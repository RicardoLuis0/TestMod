class FastLightClipCasing : LightClipCasing {
	Default {
		Speed 4;
	}
}

class SMGLoaded : Ammo{
	Default {
		Inventory.MaxAmount 31;
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
		
		ModWeaponBase.PickupHandleMagazine true;
		
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
				if(invoker.ammo1.amount==0){
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
		FullAmmo:
			RIFG A 1;
			Goto Ready;
		Reload:
			TNT1 A 0 A_PreReloadGun;
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
			TNT1 A 0 A_ReloadAmmoMagazineDefaults;
			RIFR NOPQRST 1;
			Goto Ready;
	}
	action void A_FireGun(){
		A_AlertMonsters();
		A_StartSound("weapons/pistol_fire",CHAN_AUTO,CHANF_DEFAULT,0.35);
		Actor c=A_FireProjectile("FastLightClipCasing",random[TestModWeapon](-80, -100),false,2,6-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		
		W_FireTracerSpreadXY(4,0.25,8,0.25,0.75,drawTracer:sv_light_bullet_tracers);
		A_Recoil(0.25);
	}
	action State A_PreReloadGun(){
		if(invoker.ammo1.amount == invoker.ammo1.maxamount || invoker.ammo2.amount == 0){
			return ResolveState("Ready");
		}
		return ResolveState(null);
	}
}
