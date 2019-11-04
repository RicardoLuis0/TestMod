class SMGAmmo : Ammo{
	Default{
		Inventory.MaxAmount 46;
		+Inventory.IgnoreSkill;
	}
}

class SMG : MyWeapon {
	Default {
		Weapon.SlotNumber 2;
		Weapon.SlotPriority 1;
		Weapon.AmmoType1 "SMGAmmo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 40;
		Obituary "%o was shot down by %k's SMG.";
		Inventory.PickupSound "CLIPIN";
		Inventory.Pickupmessage "You got the SMG!";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.AMMO_OPTIONAL;
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=43;
	}
	bool tick;
	States {
		Spawn:
			RIFL A -1;
			Stop;
		Ready:
			RIFG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			Loop;
		Deselect:
			RIFG A 1 A_Lower;
			Loop;
		Select:
			RIFG A 1 A_Raise;
			Loop;
		Fire:
			TNT1 A 0 {
				if(CountInv("SMGAmmo")==0){
					return ResolveState("Reload");
				}else{
					return ResolveState(null);
				}
			}
			TNT1 A 0 {
				if(invoker.tick){
					A_PlaySound("weapons/pistol_fire",CHAN_5);
					invoker.tick=false;
				}else{
					A_PlaySound("weapons/pistol_fire",CHAN_6);
					invoker.tick=true;
				}
			}
			RIFF A 1 BRIGHT {
				A_AlertMonsters();
				if(player.refire==0){
					player.refire=1;//refire 1 to enable spread
					W_FireBullets(2,2,1,4,"BulletPuff");
					player.refire=0;
				}else{
					int add=min(player.refire/4,5);
					W_FireBullets(3+add,3+add,1,4,"BulletPuff");
				}
			}
			RIFF A 1 BRIGHT A_WeaponOffset(0,36,WOF_INTERPOLATE);
			RIFF B 1 A_WeaponOffset(0,34,WOF_INTERPOLATE);
			RIFG A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			RIFG A 1 A_Refire;
			Goto Ready;
		NoAmmo:
			RIFG A 1 A_PlaySound("weapons/empty");
			Goto Ready;
		Reload:
			TNT1 A 0 {
				if(CountInv("SMGAmmo")==46){
					return ResolveState("NoAmmo");
				}else if(CountInv("LightClip")==0){
					return ResolveState("NoAmmo");
				}else{
					return ResolveState(null);
				}
			}
			RIFG A 1 A_WeaponOffset(-5,45,WOF_INTERPOLATE);
			RIFG A 3 A_WeaponOffset(-8,70,WOF_INTERPOLATE);
			TNT1 A 0 A_PlaySound("weapons/click01");
			RIFG A 5 A_WeaponOffset(-5,70,WOF_INTERPOLATE);
			RIFG A 3 A_WeaponOffset(0,70,WOF_INTERPOLATE);
			RIFR A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			RIFR BCDEF 1;
			RIFR GGGGGGGG 1;
			RIFR HIKL 1;
			TNT1 A 0 A_PlaySound("weapons/rifle_reload");
			RIFR MMM 1;
			RIFR NOPQRST 1;
			TNT1 A 0 {
				int curammo=CountInv("SMGAmmo");
				int reload_amount;
				if(curammo==0){
					reload_amount=min(CountInv("LightClip"),45);
				}else{
					reload_amount=min(CountInv("LightClip"),46-curammo);
				}
				A_TakeInventory("LightClip",reload_amount);
				A_SetInventory("SMGAmmo",reload_amount+curammo);
			}
			Goto Ready;
	}
}
