class AssaultRifleLoadedAmmo : Ammo {
	Default{
		Inventory.MaxAmount 21;
		+Inventory.IgnoreSkill;
	}
}

class AssaultRifle : MyWeapon {
	bool loaded;
	int firemode;//0=single,1=auto
	int dmg;
	Default{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "AssaultRifleLoadedAmmo";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Assault Rifle";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
		loaded=true;
		firemode=1;
		dmg=8;
	}
	States{
		ready:
			CHGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		select:
			CHGG A 1 A_Raise;
			loop;
		deselect:
			CHGG A 1 A_Lower;
			loop;
		fire:
			CHGG A 0 A_Bob();
			CHGG A 0 A_FireGun;
			CHGF A 1 BRIGHT A_Light1;
			CHGG A 2 Offset(0,35) A_Bob();
			CHGG A 2 A_Bob();
			CHGG A 0{
				if(invoker.firemode==0){
					return ResolveState("ready");
				}
				return ResolveState(null);
			}
			CHGG A 0 A_Bob();
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
			CGCK A 2 A_Bob();
			CGCK B 2 A_Bob();
			CGCK C 5 A_Bob();
			CGCK D 0 A_Bob();
			CGCK D 20 A_PlaySound("ARBOLT");
			CGCK C 10 A_Bob();
			CGCK B 5 A_Bob();
			CGCK A 0{
				invoker.loaded=true;
			}
			
			CHGG A 0 P_Return;
			goto ready;
		noammo:
			CHGG A 3 A_PlaySound("weapons/sshoto");
			goto ready;
		spawn:
			MGUN A -1;
			stop;
		altfire:
			CHGG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
			CHGG A 0{
				A_PlaySound("DSCLICKY");
				if(invoker.firemode==0){
					A_Print("Full Auto");
					invoker.firemode=1;
					invoker.crosshair=35;
				}else if(invoker.firemode==1){
					A_Print("Semi-Automatic");
					invoker.firemode=0;
					invoker.crosshair=43;
				}
			}
			CHGG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
	}
	const spread_max=10;
	const spread_x=5;
	const spread_y=5;
	const velspread_x=5;
	const velspread_y=5;
	const spread_scale=2;
	float getSpreadX(int refire,double vel_len){
		double velspread=max(log10(vel_len)*velspread_x,0);
		if(refire<=0){
			return velspread;
		}else{
			double ftimes=(spread_max+1)-min(refire,spread_max);
			if(ftimes>spread_scale){
				ftimes/=spread_scale;
			}else{
				ftimes=1;
			}
			return int((spread_x/ftimes)+velspread);
		}
	}
	float getSpreadY(int refire,double vel_len){
		double velspread=max(log10(vel_len)*velspread_y,0);
		if(refire<=0){
			return velspread;
		}else{
			double ftimes=(spread_max+1)-min(refire,spread_max);
			if(ftimes>spread_scale){
				ftimes/=spread_scale;
			}else{
				ftimes=1;
			}
			return int((spread_y/ftimes)+velspread);
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
		if(!invoker.loaded){
			return P_Call("bolt","ready");
		}
		int refire=player.refire;
		if(refire<=0)player.refire=1;
		A_AlertMonsters();
		A_FireBullets(invoker.getSpreadX(refire,player.vel.length()),invoker.getSpreadY(refire,player.vel.length()),1,invoker.dmg,"BulletPuff");
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
			invoker.loaded=false;
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
		if(!invoker.loaded){
			return P_Call("bolt","ready");
		}
		return ResolveState("ready");
	}
}