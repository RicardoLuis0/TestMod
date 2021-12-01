class FastLightClipCasing : LightClipCasing {
	Default {
		Speed 4;
	}
}

class SMGLoaded : Ammo{
	Default{
		Inventory.MaxAmount 46;
		+Inventory.IgnoreSkill;
		Inventory.Icon "RIFLA0";
	}
}

class SMG : ModWeaponBase {
	Default {
		Tag "SMG";
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 1;
		Weapon.AmmoType1 "SMGLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 20;
		Obituary "%o was shot down by %k's SMG.";
		Inventory.Pickupmessage "You got the SMG!";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.AMMO_OPTIONAL;
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=20;
	}
	States {
		Spawn:
			RIFL A -1;
			Stop;
		Ready:
			RIFG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		Deselect:
			RIFG A 1 A_Lower;
			Loop;
		Select:
			RIFG A 1 A_Raise;
			Loop;
		Fire:
			TNT1 A 0 {
				if(CountInv(invoker.AmmoType1)==0){
					return ResolveState("Reload");
				}else{
					return ResolveState(null);
				}
			}
			RIFF A 1 BRIGHT A_FireGun;
			RIFF A 1 BRIGHT A_WeaponOffset(0,36,WOF_INTERPOLATE);
			RIFF B 1 A_WeaponOffset(0,34,WOF_INTERPOLATE);
			RIFG A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			RIFG A 1 A_Refire;
			Goto Ready;
		NoAmmo:
			RIFG A 1 A_StartSound("weapons/empty",CHAN_AUTO);
			Goto Ready;
		Reload:
			TNT1 A 0 {
				player.refire=0;
				if(CountInv(invoker.AmmoType1)==46){
					return ResolveState("NoAmmo");
				}else if(CountInv(invoker.AmmoType2)==0){
					return ResolveState("NoAmmo");
				}else{
					return ResolveState(null);
				}
			}
			RIFG A 1 A_WeaponOffset(-5,45,WOF_INTERPOLATE);
			RIFG A 3 A_WeaponOffset(-8,70,WOF_INTERPOLATE);
			TNT1 A 0 A_StartSound("weapons/click01",CHAN_AUTO);
			RIFG A 5 A_WeaponOffset(-5,70,WOF_INTERPOLATE);
			RIFG A 3 A_WeaponOffset(0,70,WOF_INTERPOLATE);
			RIFR A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			RIFR BCDEF 1;
			RIFR GGGGGGGG 1;
			RIFR HIKL 1;
			TNT1 A 0 A_StartSound("weapons/rifle_reload",CHAN_AUTO);
			RIFR MMM 1;
			TNT1 A 0 A_ReloadAmmo(45,46);
			RIFR NOPQRST 1;
			Goto Ready;
	}
	action void A_FireGun(){
		A_AlertMonsters();
		A_StartSound("weapons/pistol_fire",CHAN_AUTO);
		Actor c=A_FireProjectile("FastLightClipCasing",random(-80, -100),false,2,6-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random(15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		W_FireBulletsSpreadXY(0.25,8,1,4,refire_rate:0.25,refire_max:0.75);
		A_Recoil(0.25);
	}
}