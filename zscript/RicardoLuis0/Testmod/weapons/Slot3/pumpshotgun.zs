class PumpLoaded : Ammo{
	Default{
		Inventory.MaxAmount 9;
		+INVENTORY.IGNORESKILL;
	}
}

class PumpShotgun : MyWeapon {
	bool first;
	int firemode;//0=pump,1=auto
	int pellets;
	int dmg;
	Default{
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "PumpLoaded";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 8;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Pump Shotgun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=23;
		first=true;
		pellets=12;
		dmg=5;
		firemode=0;
	}
	States{
		ready:
			TNT1 A 0{
				if(invoker.first){
					invoker.first=false;
					if(CountInv("PumpLoaded")!=9){
						return P_Call("Pump","Ready");
					}
				}
				return ResolveState(null);
			}
			0SGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			TNT1 A 0 A_UpdateBob();
		SelectLoop:
			0SGG A 1 A_Raise;
			loop;
		deselect:
			0SGG A 1 A_Lower;
			loop;
		fire:
			0SGG A 0 {
				switch(invoker.firemode){
					case 0:
						return ResolveState("pumpfire");
					case 1:
						return ResolveState("autofire");
					default:
						return ResolveState(null);
				}
			}
			Goto Ready;
		pumpfire:
			0SGG A 0 A_FirePump();
			0SGG A 0 A_Bob();
			0SGF A 2 Bright A_GunFlash;
			0SGG A 0 A_Bob();
			0SGF B 2 Bright;
			0SGG A 0 A_Bob();
			0SGF C 2 Bright;
			0SGG A 0 A_Bob();
			0SGF D 1;
			0SGG A 0 A_Bob();
			0SGF E 1;
			0SGG A 0 A_PlaySound("weapons/shotgun_pump",CHAN_AUTO);
			0SGG BCD 3;
			0SGG E 4;
			0SGG DCB 3;
			0SGG A 0 A_Bob();
			0SGG A 5;
			0SGG A 5 A_Refire;
			0SGG A 0 {
				if(CountInv("PumpLoaded")==0) return ResolveState("Reload");
				return ResolveState(null);
			}
			goto ready;
		autofire:
			0SGG A 0 A_CheckAmmo(true);
		autofireloop:
			0SGF A 0 A_FirePumpQuick();
			0SGG A 0 A_Bob();
			0SGF A 1 Bright A_GunFlash;
			0SGG A 0 A_Bob();
			0SGF B 1 Bright;
			0SGG A 0 A_Bob();
			0SGF C 1 Bright;
			0SGG A 0 A_Bob();
			0SGF D 1;
			0SGG A 0 A_Bob();
			0SGF E 1;
			0SGG A 0 A_Bob();
			0SGF C 2 A_ReFire;
			0SGG A 0 A_Bob();
			0SGF DE 2;
			goto ready;
		altfire:
			0SGG A 0 A_Bob();
			0SGG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
			0SGG A 0{
				A_PlaySound("weapons/click02");
				if(invoker.firemode==0){
					A_Print("Auto Fire");
					invoker.firemode=1;
					//invoker.crosshair=35;
				}else if(invoker.firemode==1){
					A_Print("Pump Fire");
					invoker.firemode=0;
					//invoker.crosshair=43;
				}
			}
			0SGG A 0 A_Bob();
			0SGG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		flash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		autoflash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		reload:
			0SGG A 0 A_ReloadStart;
			goto reloadm;
		reloadm:
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			goto reloadloop;
		reloadloop:
			0SGG A 0 A_ReloadMid;
			0SGG A 0 A_Bob();
			0SGG A 4 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 0 A_PlaySound("weapons/sshotl",CHAN_AUTO);
			0SGG A 0 A_Bob();
			0SGG A 4 A_WeaponOffset(28,77,WOF_INTERPOLATE);
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 0 A_ReloadEnd;
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			loop;
		reloadstop:
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 0 A_Bob();
			0SGG A 2 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 P_Return;
			goto ready;
		pump:
			0SGG A 0 A_Bob();
			0SGG A 5;
			0SGG A 0 A_PlaySound("weapons/shotgun_pump",CHAN_AUTO);
			0SGG BCD 3;
			0SGG E 4;
			0SGG DCB 3;
			0SGG A 5;
			0SGG A 0 P_Return;
			goto ready;
		noammo:
			0SGG A 0 A_Bob();
			0SGG A 3 A_PlaySound("weapons/sshoto");
			goto ready;
		spawn:
			0ESG A -1;
			stop;
	}
	action State A_CheckAmmo(bool doreload){
		if(CountInv("PumpLoaded")==0){
			if(CountInv("Shell")==0||doreload==false){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		return ResolveState(null);
	}
	action State A_FirePump(){
		if(CountInv("PumpLoaded")==0){
			if(CountInv("Shell")==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		A_AlertMonsters();
		A_TakeInventory("PumpLoaded",1);
		A_Recoil(2.0);
		A_FireBullets (3,3,invoker.pellets,invoker.dmg,"BulletPuff");
		A_PlaySound ("weapons/shotgun_fire",CHAN_AUTO);
		return ResolveState(null);
	}
	
	action State A_FirePumpQuick(){
		if(CountInv("PumpLoaded")==0){
			return ResolveState("noammo");
		}
		A_AlertMonsters();
		A_TakeInventory("PumpLoaded",1);
		A_Recoil(2.0);
		A_SetPitch(pitch+(random(-15,0)/5),SPF_INTERPOLATE);
		A_SetAngle(angle+(random(-30,30)/10),SPF_INTERPOLATE);
		A_FireBullets (5,5,invoker.pellets,invoker.dmg,"BulletPuff");
		A_PlaySound ("weapons/shotgun_fire",CHAN_AUTO);
		return ResolveState(null);
	}
	action State A_ReloadStart(){
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return ResolveState("ready");
		}
		if(CountInv("PumpLoaded")>0){
			return CheckFire("fire","afl");
		}
		return ResolveState(null);
	}
	action State A_ReloadMid(){
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return P_Call("reloadstop","ready");
		}
		if(CountInv("PumpLoaded")>0){
			return CheckFire("fire","afl");
		}
		return ResolveState(null);
	}
	action State A_ReloadEnd(){
		A_TakeInventory("Shell",1);
		A_GiveInventory("PumpLoaded",1);
		if(CountInv("PumpLoaded")==1) return P_Call("reloadstop",P_CallSL("pump","reload"));
		return ResolveState(null);
	}
}