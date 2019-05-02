class MyPistolClip : Ammo{
	Default{
		Inventory.MaxAmount 13;
		+Inventory.IgnoreSkill;
	}
}

class MyPistol : MyWeapon{
	Default{
		Weapon.SlotNumber 2;
		Weapon.AmmoType1 "MyPistolClip";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 0;
		Weapon.AmmoGive2 12;
		Inventory.Pickupmessage "You've got the Pistol";
		+WEAPON.AMMO_OPTIONAL;
	}
	States{
	Ready:
		PISG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Select:
		PISG A 0 OnSelect(true,43);
		PISG A 1 A_Raise;
		Loop;
	Deselect:
		PISG A 0 OnDeselect;
		PISG A 1 A_Lower;
		Loop;
	Fire:
		PISG A 0 {
			if(CountInv("MyPistolClip")==0){
				if(CountInv("Clip")==0){
					return ResolveState("Ready");
				}else{
					return ResolveState("Reload");
				}
			}
			return ResolveState(null);
		}
		PISG B 6 Fire;
		PISG C 4;
		PISG B 5 A_ReFire;
		Goto Ready;
	Flash:
		PISF A 7 Bright A_Light1;
		Goto LightDone;
		PISF A 7 Bright A_Light1;
		Goto LightDone;
 	Spawn:
		PLSP A -1;
		Stop;
	Reload:
		PISG A 0 {
			if(CountInv("Clip")==0||CountInv("MyPistolClip")==13){
				return ResolveState("Ready");
			}else if(CountInv("MyPistolClip")==0){
				return ResolveState("ReloadEmpty");
			}
			return ResolveState(null);
		}
		PKR2 ABCDEFGHIJKL 3;
		PKPR PQ 3;
		PISG A 0 {
			if(CountInv("Clip")>=(13-CountInv("MyPistolClip"))){
				A_TakeInventory("Clip",13-CountInv("MyPistolClip"));
				A_SetInventory("MyPistolClip",13);
			}else{
				A_GiveInventory("MyPistolClip",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}
		}
		Goto Ready;
	ReloadEmpty:
		PKPR ABCDEFGHIJKLMNOPQ 3;
		PISG A 0 {
			if(CountInv("Clip")>=12){
				A_TakeInventory("Clip",12);
				A_SetInventory("MyPistolClip",12);
			}else{
				A_SetInventory("MyPistolClip",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}
		}
		Goto Ready;
	}
	action void fire(){
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_FireBullets(4,4,1,5,"BulletPuff");
		A_TakeInventory("MyPistolClip",1);
		A_GunFlash();
	}
}