class AssaultRifleLoadedAmmo : Ammo {
	Default{
		Inventory.MaxAmount 21;
		//Inventory.Icon "Clip";
	}
}

class AssaultRifle : MyWeapon {
	bool ready;
	Default{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "AssaultRifleLoadedAmmo";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Assault Rifle";
	}
	States{
		ready:
			CHGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		select:
			CHGG A 0 OnSelect(true,35);
			CHGG A 1 A_Raise;
			loop;
		deselect:
			CHGG A 0 OnDeselect;
			CHGG A 1 A_Lower;
			loop;
		fire:
			CHGG A 0 A_FireGun;
			CHGF A 1 BRIGHT A_Light1;
			CHGG A 2 Offset(0,35);
			CHGG A 2;
			CHGG A 1 A_ReFire;
			goto ready;
		reload:
			CHGG A 0 A_PreReloadGun;
			
			CHGR ABCDEF 1;
			
			CHGR G 4 A_PlaySound("ARCLICK");
			CHGR HIJK 2;
			CHGR L 2 A_PlaySound("ARRELOAD");
			CHGR L 0 A_ReloadGun;
			CHGR MNOPQRS 1;
			CHGG A 0 A_PostReloadGun;
			goto ready;
		bolt:
			CGCK A 2;
			CGCK B 2;
			CGCK C 5;
			CGCK D 20 A_PlaySound("ARBOLT");
			CGCK C 10;
			CGCK B 5;
			CGCK A 0{
				invoker.ready=true;
			}
			
			CHGG A 0 P_Return;
			goto ready;
		noammo:
			CHGG A 3 A_PlaySound("weapons/sshoto");
			goto ready;
		spawn:
			MGUN A -1;
			stop;
	}
	override void BeginPlay(){
		Super.BeginPlay();
		ready=true;
	}
	const spread_max=10;
	const spread_x=5;
	const spread_y=5;
	const spread_scale=2;
	float getSpreadX(int refire){
		if(refire<=0){
			return 0;
		}else{
			int ftimes=(spread_max+1)-min(refire,spread_max);
			if(ftimes>spread_scale){
				ftimes/=spread_scale;
			}else{
				ftimes=1;
			}
			A_Log("ft:"..ftimes);
			A_Log("sx:"..spread_x/ftimes);
			return spread_x/ftimes;
		}
	}
	float getSpreadY(int refire){
		if(refire<=0){
			return 0;
		}else{
			int ftimes=(spread_max+1)-min(refire,spread_max);
			ftimes*=spread_scale;
			return spread_y/ftimes;
		}
	}
	action State A_FireGun(){
		if(CountInv("AssaultRifleLoadedAmmo")==0){
			if(CountInv("Clip")==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		if(!invoker.ready){
			return P_Call("bolt","ready");
		}
		A_AlertMonsters();
		//A_FireBullets(10,4,1,7,"BulletPuff");
		A_Log("player.refire="..player.refire);
		A_FireBullets(invoker.getSpreadX(player.refire),invoker.getSpreadY(player.refire),1,8,"BulletPuff");
		A_PlaySound("weapons/gatlingfire");
		A_SetPitch(pitch+(random(-10,0)/5));
		A_SetAngle(angle+(random(-20,15)/10));
		return ResolveState(null);
	}
	action State A_PreReloadGun(){
		if(CountInv("AssaultRifleLoadedAmmo")==21||CountInv("Clip")==0){
			return ResolveState("ready");
		}
		return ResolveState(null);
	}
	action void A_ReloadGun(){
		A_ClearReFire();
		int cur = CountInv("AssaultRifleLoadedAmmo");
		int reserve = CountInv("Clip");
		if(cur==0){
			invoker.ready=false;
			if(reserve>20){
				A_SetInventory("AssaultRifleLoadedAmmo",20);
				A_SetInventory("Clip",reserve-20);
			}else{
				A_SetInventory("AssaultRifleLoadedAmmo",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}
		}else{
			int reloadamt=21-cur;
			if(reserve>reloadamt){
				A_SetInventory("Clip",reserve-reloadamt);
				A_SetInventory("AssaultRifleLoadedAmmo",21);
			}else{
				A_SetInventory("AssaultRifleLoadedAmmo",cur+reserve);
				A_SetInventory("Clip",0);
			}
		}
	}
	action State A_PostReloadGun(){
		if(!invoker.ready){
			return P_Call("bolt","ready");
		}
		return ResolveState("ready");
	}
}