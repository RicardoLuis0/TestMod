class ShellCasing : CasingBase {
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

class PumpShotgun : ModWeaponBase {
	int pellets;
	int dmg;
	bool firecasing;
	
	Default{
		Tag "Pump Shotgun";
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "PumpLoaded";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 8;
		Weapon.SlotPriority 0.25;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Pump Shotgun!";
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
			0SGG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
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
			0SGG A 0 {
				if(CountInv(invoker.AmmoType1)==0) return ResolveState("Reload");
				return P_Call("Pump");
			}
			0SGG A 5 A_Refire;
			goto ready;
		flash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		reload:
			0SGG A 0 A_ReloadStart;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
		reloadloop:
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 A_ReloadMid;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 0 A_StartSound("weapons/sshotl",CHAN_AUTO);
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,77,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 0 A_ReloadEnd;
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			loop;
		reloadstop:
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 P_Return;
			goto ready;
		firecheck:
			0SGG A 0 CheckFire("fire");
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

	action State A_FirePump(){
		if(CountInv("PumpLoaded")==0){
			if(CountInv("Shell")==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		A_AlertMonsters();
		invoker.firecasing=true;
		A_Recoil(2.0);
		W_FireBullets(1.5,1.5,invoker.pellets,invoker.dmg);
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

	action State A_ReloadStart(){
		InitInterruptReload();
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return ResolveState("ready");
		}
		if(CountInv("PumpLoaded")>0){
			return CheckFire("fire");
		}
		return ResolveState(null);
	}

	action State A_ReloadMid(){
		if(player.PendingWeapon!=WP_NOCHANGE){
			return P_CallJmp("reloadstop","ready");
		}
		if(CountInv("PumpLoaded")>=9||CountInv("Shell")==0){
			return P_CallJmp("reloadstop","ready");
		}
		if(CountInv("PumpLoaded")>0){
			return InterruptReload();
		}
		return ResolveState(null);
	}

	action State A_ReloadEnd(){
		A_TakeInventory("Shell",1);
		A_GiveInventory("PumpLoaded",1);
		if(CountInv("PumpLoaded")==1) return P_CallJmp("reloadstop",P_CallSLJmp("pump","reload"));
		return InterruptReload();
	}
	
	bool do_interrupt;
	
	action void InitInterruptReload(){
		invoker.do_interrupt=false;
	}
	
	action void PollInterruptReload(){
		if(iCheckFire()>0){
			invoker.do_interrupt=true;
		}
	}
	
	action state InterruptReload(){
		if(invoker.do_interrupt||iCheckFire()>0){
			return P_CallJmp("reloadstop","firecheck");
		}
		return ResolveState(null);
	}
	
}