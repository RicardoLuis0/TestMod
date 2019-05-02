class PumpLoaded : Ammo{
	Default{
		Inventory.MaxAmount 8;
		Inventory.Icon "SHOTA0";
		+INVENTORY.IGNORESKILL;
	}
}

class PumpShotgun : Weapon replaces Shotgun {
	Default{
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "PumpLoaded";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 16;
		+Weapon.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Pump Shotgun";
	}
	States{
		ready:
			0SGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		select:
			0SGG A 1 A_Raise;
			loop;
		deselect:
			0SGG A 1 A_Lower;
			loop;
		fire:
			0SGG A 0 A_FirePump();
			0SGF A 2 A_GunFlash;
			0SGF B 2;
			0SGF C 2;
			0SGF D 1;
			0SGF E 1;
			0SGG BCD 3 A_PlaySound("SHOTPUMP");
			0SGG E 4;
			0SGG DCB 3;
			0SGG A 5;
			goto ready;
		altfire:
			0SGG A 0 A_CheckAmmo(true);
		afl:
			0SGF A 0 A_FirePumpQuick();
			0SGF ABC 1 A_GunFlash;
			0SGF D 1 A_ReFire;
			0SGF E 1;
			goto ready;
		flash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		reload:
			0SGR A 4 A_ReloadStart;
			0SGR B 4 A_PlaySound ("weapons/sshotl");
			0SGR A 2 A_ReloadEnd;
			loop;
		pump:
			0SGG A 5;
			0SGG BCD 3 A_PlaySound("SHOTPUMP");
			0SGG E 4;
			0SGG DCB 3;
			0SGG A 5;
			goto reload;
		noammo:
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
		A_TakeInventory("PumpLoaded",1);
		A_Recoil(2.0);
		A_FireBullets (3,3,12,5,"BulletPuff");
		A_PlaySound ("SHOTFIRE",CHAN_WEAPON);
		return ResolveState(null);
	}
	
	action State A_FirePumpQuick(){
		if(CountInv("PumpLoaded")==0){
			return ResolveState("noammo");
		}
		A_TakeInventory("PumpLoaded",1);
		A_Recoil(2.0);
		A_SetPitch(pitch+(random(-15,0)/5));
		A_SetAngle(angle+(random(-30,30)/10));
		A_FireBullets (4,4,12,5,"BulletPuff");
		A_PlaySound ("SHOTFIRE",CHAN_WEAPON);
		return ResolveState(null);
	}
	
	action State A_ReloadStart(){
		if(CountInv("PumpLoaded")>=8||CountInv("Shell")==0){
			return ResolveState("ready");
		}
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(CountInv("PumpLoaded")>0){
			if(input&BT_ALTATTACK==BT_ALTATTACK){
				return ResolveState("afl");
			}else if(input&BT_ATTACK==BT_ATTACK){
				return ResolveState("fire");
			}
		}
		return ResolveState(null);
	}
	action State A_ReloadEnd(){
		A_TakeInventory("Shell",1);
		A_GiveInventory("PumpLoaded",1);
		if(CountInv("PumpLoaded")==1) return ResolveState("pump");
		return ResolveState(null);
	}
}