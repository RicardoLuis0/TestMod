class SMGAmmo : Ammo{
	Default{
		Inventory.MaxAmount 46;
		+Inventory.IgnoreSkill;
	}
}

class SMG : MyWeapon {
	Default {
		Weapon.SlotNumber 2;
		Weapon.AmmoType1 "SMGAmmo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 20;
		Obituary "%o was shot down by %k's SMG.";
		Inventory.PickupSound "CLIPIN";
		Inventory.Pickupmessage "You got the SMG!";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
	}
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
			TNT1 A 0 A_PlaySound("weapons/pistol");
			RIFF A 1 BRIGHT A_AlertMonsters;
			RIFF B 1 BRIGHT W_FireBullets(2,2,-1,10,"BulletPuff");
			TNT1 A 0 A_SetPitch(-1.3 + pitch);
			TNT1 A 0 A_SetPitch(+0.4 + pitch);
			RIFG AA 1 A_SetPitch(+0.4 + pitch);
			RIFG A 1 A_Refire;
			RIFG A 7;
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
			RIFR ABCDEF 1;
			RIFR GGGGGGGG 1;
			RIFR HIKL 1;
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
