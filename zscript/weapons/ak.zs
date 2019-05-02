class AKAMMO : Ammo {
	Default{
		Inventory.MaxAmount 31;
		Inventory.Icon "AK4IA0";
	}
}

class AK : Weapon {
	Default{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "AKAMMO";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 30;
		+Weapon.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the AK47";
	}
	States{
		ready:
			AK47 A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		select:
			AK47 A 1 A_Raise;
			loop;
		deselect:
			AK47 A 1 A_Lower;
			loop;
		fire:
			AK47 A 0 A_FireAK;
			AK4F A 1 BRIGHT A_Light1;
			AK4F B 1 BRIGHT A_Light2;
			AK47 B 1;
			AK47 B 2 A_ReFire;
			goto ready;
		reload:
			AK47 A 0 A_ReloadAK;
			AK47 A 5;
			AK47 A 10 A_PlaySound("weapons/sshoto");
			AK47 A 1;
			goto ready;
		noammo:
			AK47 A 3 A_PlaySound("weapons/sshoto");
			goto ready;
		spawn:
			AK4I A -1;
			stop;
	}

	action State A_FireAK(){
		if(CountInv("AKAMMO")==0){
			if(CountInv("Clip")==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		A_FireBullets(10,4,1,7,"BulletPuff");
		A_PlaySound("AKFIRE");
		A_SetPitch(pitch+(random(-10,0)/5));
		A_SetAngle(angle+(random(-20,20)/10));
		return ResolveState(null);
	}
	
	action State A_ReloadAK(){
		if(CountInv("AKAMMO")==31||CountInv("Clip")==0){
			return ResolveState("ready");
		}
		int cur = CountInv("AKAMMO");
		int reserve = CountInv("Clip");
		if(cur==0){
			if(reserve>30){
				A_SetInventory("AKAMMO",30);
				A_SetInventory("Clip",reserve-30);
			}else{
				A_SetInventory("AKAMMO",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}
		}else{
			int reloadamt=31-cur;
			if(reserve>reloadamt){
				A_SetInventory("Clip",reserve-reloadamt);
				A_SetInventory("AKAMMO",31);
			}else{
				A_SetInventory("AKAMMO",cur+reserve);
				A_SetInventory("Clip",0);
			}
		}
		return ResolveState(null);
	}
}