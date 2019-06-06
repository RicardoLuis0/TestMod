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
		Weapon.SlotPriority 1;
		Weapon.AmmoType1 "AssaultRifleLoadedAmmo";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Assault Rifle!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
		loaded=true;
		firemode=1;
		dmg=10;
	}
	States{
		ready:
			ASRG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			ASRG A 1 A_Raise;
			loop;
		deselect:
			ASRG A 1 A_Lower;
			loop;
		fire:
			ASRG A 0 {
				if(invoker.firemode==0){
					return ResolveState("fireburst");
				}
				return ResolveState(null);
			}
			ASRG A 0 A_FireGun;
			ASRF A 1 BRIGHT;
			ASRG A 2 A_WeaponOffset(0,35,WOF_INTERPOLATE );
			ASRG A 2;
			ASRG A 1 A_ReFire;
			goto ready;
		fireburst:
			ASRG A 0 A_FireGun;
			ASRF A 1 BRIGHT;
			ASRG A 1 A_WeaponOffset(0,35,WOF_INTERPOLATE);
			ASRG A 0 A_FireGun;
			ASRF A 1 BRIGHT;
			ASRG A 1 A_WeaponOffset(0,38,WOF_INTERPOLATE);
			ASRG A 0 A_FireGun;
			ASRF A 1 BRIGHT;
			ASRG A 1 A_WeaponOffset(0,41,WOF_INTERPOLATE);
			ASRG A 2 A_WeaponOffset(0,38,WOF_INTERPOLATE);
			ASRG A 2 A_WeaponOffset(0,35,WOF_INTERPOLATE);
			ASRG A 2 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			goto ready;
		flash:
			TNT1 A 1 A_Light1;
			goto lightdone;
		reload:
			ASRG A 0 A_PreReloadGun;
			
			ASRR ABCDEF 1;
			
			ASRR G 4 A_PlaySound("weapons/click01");
			ASRR HIJK 2;
			ASRR L 2 A_PlaySound("weapons/rifle_reload");
			ASRR L 0 A_ReloadGun;
			ASRR MNOPQRS 1;
			ASRG A 0 A_PostReloadGun;
			goto ready;
		bolt:
			ASRK A 2;
			ASRK B 2;
			ASRK C 5;
			ASRK D 20 A_PlaySound("weapons/rifle_bolt");
			ASRK C 10;
			ASRK B 5;
			ASRK A 0{
				invoker.loaded=true;
			}
			
			ASRG A 0 P_Return;
			goto ready;
		noammo:
			ASRG A 3 A_PlaySound("weapons/sshoto");
			goto ready;
		spawn:
			MGUN A -1;
			stop;
		altfire:
			ASRG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
			ASRG A 0{
				A_PlaySound("weapons/click02");
				if(invoker.firemode==0){
					A_Print("Full Auto");
					invoker.firemode=1;
					//invoker.crosshair=35;
				}else if(invoker.firemode==1){
					A_Print("Burst");
					invoker.firemode=0;
					//invoker.crosshair=43;
				}
			}
			ASRG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		altloop:
			ASRG A 1;
			ASRG A 0 A_ReFire("altloop");
			Goto Ready;
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
			return P_Call2("bolt","ready");
		}
		A_GunFlash();
		int refire=player.refire;
		if(refire<=0)player.refire=1;
		W_FireBullets(invoker.getSpreadX(refire,player.vel.length()),invoker.getSpreadY(refire,player.vel.length()),1,invoker.dmg,"BulletPuff");
		player.refire=refire;
		A_Recoil(0.5);
		A_AlertMonsters();
		A_PlaySound("weapons/ar_fire");
		A_SetPitch(pitch+frandom(-2,0),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom(-2,1.5),SPF_INTERPOLATE);
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
			return P_Call2("bolt","ready");
		}
		return ResolveState("ready");
	}
}