class ShellCasing : Casing {
	Default {
		Scale 0.10;
	}
	States {
	Spawn:
		CAS2 AB 3;
	Bounce:
	Stay:
		CAS2 C 1 {
			A_SetScale(0.15);
		}
		Loop;
	}
}

class PumpLoaded : Ammo{
	Default{
		Inventory.MaxAmount 9;
		+INVENTORY.IGNORESKILL;
	}
}

class PumpShotgun : MyWeapon {
	int pellets;
	int dmg;
	bool firecasing;
	
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
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Shotgun!";
	}
	
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=23;
		pellets=12;
		dmg=5;
		firecasing=false;
	}
	
	States{
		ready:
			0SGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			0SGG A 1 A_Raise;
			loop;
		deselect:
			0SGG A 1 A_Lower;
			loop;
		fire:
			0SGG A 0 A_FirePump();
			0SGF A 2 Bright A_GunFlash;
			0SGF B 2 Bright;
			0SGF C 2 Bright;
			0SGF D 1;
			0SGF E 1;
			0SGG A 0 P_Call("Pump");
			0SGG A 5 A_Refire;
			0SGG A 0 {
				if(CountInv("PumpLoaded")==0) return ResolveState("Reload");
				return ResolveState(null);
			}
			goto ready;
		altloop:
			0SGG A 1;
			0SGG A 0 A_ReFire("altloop");
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
		reloadm:
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
		reloadloop:
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 A_ReloadMid;
			0SGG A 4 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 0 A_StartSound("weapons/sshotl",CHAN_AUTO);
			0SGG A 4 A_WeaponOffset(28,77,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 0 A_ReloadEnd;
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			loop;
		reloadstop:
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 P_Return;
			goto ready;
		pump:
			0SGG A 5;
			0SGG A 0 A_StartSound("weapons/shotgun_pump",CHAN_AUTO);
			0SGG B 3;
			0SGG C 3;
			0SGG D 3 A_PumpCasing;
			0SGG E 4;
			0SGG D 3;
			0SGG C 3;
			0SGG B 3;
			0SGG A 5;
			0SGG A 0 P_Return;
			goto ready;
		noammo:
			0SGG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
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
		invoker.firecasing=true;
		A_Recoil(2.0);
		W_FireBullets(1.5,1.5,invoker.pellets,invoker.dmg,"BulletPuff");
		A_SetPitch(pitch+frandom(-5,0),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom(-2,2),SPF_INTERPOLATE);
		A_StartSound("weapons/shotgun_fire",CHAN_AUTO,CHANF_DEFAULT,0.5);
		return ResolveState(null);
	}

	action void A_PumpCasing(){
		if(invoker.firecasing){
			invoker.firecasing=false;
			Actor c=A_FireProjectile("ShellCasing",random(-30, -50),false,2,2-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random(15,30));
			if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		}
	}

	action State A_FirePumpQuick(){
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
		W_FireBullets(8,8,invoker.pellets,invoker.dmg,"BulletPuff");
		Actor c=A_FireProjectile("ShellCasing",random(-30, -50),false,2,2-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random(15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		A_SetPitch(pitch+frandom(-3,0),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom(-3,3),SPF_INTERPOLATE);
		A_StartSound("weapons/shotgun_fire",CHAN_AUTO,CHANF_DEFAULT,0.5);
		return ResolveState(null);
	}

	action State A_ReloadStart(){
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return ResolveState("ready");
		}
		if(CountInv("PumpLoaded")>0){
			return checkfire("fire");
		}
		return ResolveState(null);
	}

	action State A_ReloadMid(){
		if(player.PendingWeapon!=WP_NOCHANGE){
			player.mo.BringUpWeapon();
			return ResolveState(null);
		}
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return P_Call2("reloadstop","ready");
		}
		if(CountInv("PumpLoaded")>0){
			return checkfire("fire");
		}
		return ResolveState(null);
	}

	action State A_ReloadEnd(){
		A_TakeInventory("Shell",1);
		A_GiveInventory("PumpLoaded",1);
		if(CountInv("PumpLoaded")==1) return P_Call2("reloadstop",P_CallSL2("pump","reload"));
		return ResolveState(null);
	}
}