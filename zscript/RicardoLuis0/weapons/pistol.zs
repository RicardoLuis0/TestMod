class MyPistolClip : Ammo{
	Default{
		Inventory.MaxAmount 13;
		+Inventory.IgnoreSkill;
	}
}
class MyPistol : Weapon replaces pistol{
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
		0PIG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		0PIG A 1 A_Lower;
		Loop;
	Select:
		0PIG A 1 A_Raise;
		Loop;
	Fire:
		0PIF A 0 {
			if(CountInv("MyPistolClip")==0){
				if(CountInv("Clip")==0){
					return ResolveState("Ready");
				}else{
					return ResolveState("Reload");
				}
			}
			return ResolveState(null);
		}
		0PIF A 2 Fire;
		0PIF B 4;
		0PIF C 4;
		0PIG A 4 A_ReFire;
		Goto Ready;
 	Spawn:
		PLSP A -1;
		Stop;
	Reload:
		0PIG A 0 {
			if(CountInv("Clip")==0||CountInv("MyPistolClip")==13){
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		0PIG A 5 Offset(0,40);
		0PIG A 5 Offset(0,50);
		0PIG A 5 Offset(0,60);
		0PIG A 5 Offset(0,70);
		0PIG A 5 Offset(0,60);
		0PIG A 5 Offset(0,50);
		0PIG A 5 Offset(0,40);
		0PIG A 5 {
			if(CountInv("MyPistolClip")==0){
				if(CountInv("Clip")>=12){
					A_TakeInventory("Clip",12);
					A_SetInventory("MyPistolClip",12);
				}else{
					A_SetInventory("MyPistolClip",CountInv("Clip"));
					A_SetInventory("Clip",0);
				}
			}else{
				if(CountInv("Clip")>=(13-CountInv("MyPistolClip"))){
					A_TakeInventory("Clip",13-CountInv("MyPistolClip"));
					A_SetInventory("MyPistolClip",13);
				}else{
					A_GiveInventory("MyPistolClip",CountInv("Clip"));
					A_SetInventory("Clip",0);
				}
			}
		}
	}
	action void fire(){
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_FireBullets(4,4,1,5,"BulletPuff");
		A_TakeInventory("MyPistolClip",1);
	}
}