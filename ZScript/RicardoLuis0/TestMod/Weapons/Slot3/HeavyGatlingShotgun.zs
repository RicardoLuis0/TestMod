class HeavyGatlingShotgun : ModRotatingWeapon {
	bool spinning_up;
	bool waiting_spindown;
	
	const CHAN_SPINFAST = 10;
	const CHAN_SPINUP = 11;
	const CHAN_SPINDOWN = 12;
	
	int spinframe;
	
	Default{
		Tag "Heavy Gatling Shotgun";
		Weapon.SlotNumber 3;
		Weapon.SlotPriority 0.001;
		Weapon.AmmoType1 "NewShell";
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Weapon.AmmoGive1 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Heavy Gatling Shotgun!";
		
		ModWeaponBase.PickupHandleNoMagazine true;
		
		
		ModRotatingWeapon.minTics 2;
		ModRotatingWeapon.maxTics 8;
		ModRotatingWeapon.rotSpeedMax 75;
		ModRotatingWeapon.rotSpeedRate 1;
	}
	
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
	}
	
	int spin_tics;
	override void ReadyTick(){
		double loopPitch = 1.0 + (((double(rotSpeed) / rotSpeedMax) ** 2) / 4);
		owner.A_SoundPitch(CHAN_SPINFAST,loopPitch);
		//console.printf("spin_tics = "..spin_tics.." rotSpeed = "..rotSpeed.." loopPitch = "..loopPitch);
		if(spinning_up) {
			spin_tics ++;
			if(spin_tics == 24 || rotSpeed > (rotSpeedMax / 4)) {
				owner.A_StartSound("weapons/gatlingspin",CHAN_SPINFAST,CHANF_LOOPING);
			}
		} else {
			spin_tics = 0;
		}
		
	}
	
	action State TrySpin(bool allowFire = false,bool spinDown = true){
		if(player.cmd.buttons & (BT_ALTATTACK|BT_ATTACK) || (invoker.spin_tics > 0 && invoker.spin_tics < 18)){
			invoker.waiting_spindown = false;
			if(allowFire) {
				SpinUp();
				if(!invoker.spinning_up && invoker.rotSpeed < (invoker.rotSpeedMax / 4)) {
					A_StopSound(CHAN_SPINFAST);
					A_StopSound(CHAN_SPINDOWN);
					A_StartSound("weapons/gatlingwindup",CHAN_SPINUP,CHANF_NOSTOP);
				}
				invoker.spinning_up = true;
				if(player.cmd.buttons & BT_ATTACK && invoker.ammo1.amount > 0) {
					return IfSpeedGtEq(invoker.rotSpeedMax/2,"RealFire");
				} else {
					player.refire = 0;
					return null;
				}
			}
			return SpinUp();
		} else if(spinDown) {
			if((invoker.spinning_up || invoker.waiting_spindown) && invoker.rotSpeed < (invoker.rotSpeedMax / 4)) {
				invoker.waiting_spindown = false;
				A_StopSound(CHAN_SPINFAST);
				A_StopSound(CHAN_SPINUP);
				A_StartSound("weapons/gatlingwinddown",CHAN_SPINDOWN,CHANF_NOSTOP);
			} else if(invoker.spinning_up) {
				invoker.waiting_spindown = true;
			}
			invoker.spinning_up = false;
			return SpinDown("Ready");
		} else {
			UpdateTics();
			return null;
		}
	}
	
	static const StateLabel ReadyStates[] ={
		"ReadyA" , "ReadyB" , "ReadyC" , "ReadyD"
	};
	static const StateLabel SpinStates[] ={
		"SpinA" , "SpinB" , "SpinC" , "SpinD"
	};
	
	States{
	Ready:
		DGTG A 0 {
			A_StopSound(CHAN_SPINFAST);
			A_StopSound(CHAN_SPINUP);
			A_StopSound(CHAN_SPINDOWN);
			invoker.spinning_up = false;
			return ResolveState(invoker.ReadyStates[invoker.spinframe]);
		}
	ReadyA:
		DGTG A 1 W_WeaponReady;
		Wait;
	ReadyB:
		DGTG B 1 W_WeaponReady;
		Wait;
	ReadyC:
		DGTG C 1 W_WeaponReady;
		Wait;
	ReadyD:
		DGTG D 1 W_WeaponReady;
		Wait;
	Deselect:
		DGTG A 1 A_Lower;
		Loop;
	Select:
		DGTG A 1 A_Raise;
		Loop;
	Fire:
	AltFire:
		TNT1 A 0 {
			return ResolveState(invoker.SpinStates[invoker.spinframe]);
		}
		Goto Spin;
	Spin:
	SpinA:
		DGTG A 10 {
			invoker.spinframe = 0;
			return TrySpin(true);
		}
	SpinB:
		DGTG B 10 {
			invoker.spinframe = 1;
			return TrySpin();
		}
	SpinC:
		DGTG C 10 {
			invoker.spinframe = 2;
			return TrySpin();
		}
	SpinD:
		DGTG D 10 {
			invoker.spinframe = 3;
			return TrySpin();
		}
		Goto SpinA;
	Spawn:
		PKCP A -1;
		stop;
	RealFire:
		DGTF A 10 Bright {
			if(invoker.ammo1.amount==0) return ResolveState("SpinA");
			UpdateTics(PSP_WEAPON,0.5);
			A_FireShotgun();
			return ResolveState(null);
		}
		DGTF B 10 UpdateTics(PSP_WEAPON,0.5);
		Goto SpinB;
	}
	/*
	States{
		ready:
			DGTG A 1 {
				invoker.spinning=false;
				W_WeaponReady();
			}
			loop;
		select:
			DGTG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				invoker.spinning=false;
			}
		deselectloop:
			DGTG A 1 A_Lower;
			loop;
		firespin:
			TNT1 A 0 {
				invoker.spinning=true;
				if(CountInv(invoker.ammotype1)==0) return ResolveState("idlespin_clearrefire");
				return ResolveState(null);
			}
			DGTF A 1 Bright A_FireShotgun;
			DGTF B 1 Bright;
			goto idlespin2;
		idlespin_clearrefire:
			TNT1 A 0 {
				player.refire=0;
			}
		idlespin:
			TNT1 A 0 {
				invoker.spinning=true;
			}
			DGTG A 2;
		idlespin2:
			DGTG B 2;
			DGTG C 2;
			DGTG D 2;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
			goto ready;
		spin1up:
			DGTG A 4;
			DGTG B 4;
			DGTG C 3;
			DGTG D 3;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
		spin1down:
			TNT1 A 0 {
				player.refire=0;
			}
			DGTG A 3;
			DGTG B 3;
			DGTG C 4;
			DGTG D 4;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin2down");
		fire:
		altfire:
		spin2up:
			TNT1 A 0 {
				A_StartSound("weapons/gatlingspin",CHAN_7,CHANF_LOOPING,3);
				A_StartSound("weapons/gatlingwindup",CHAN_6,CHANF_DEFAULT,4);
			}
			DGTG A 7;
			DGTG B 6;
			DGTG C 5;
			DGTG D 4;
			DGTG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			TNT1 A 0 {
				player.refire=0;
			}
			DGTG A 0 A_StopSound(CHAN_7);
			DGTG A 0 A_StartSound("weapons/gatlingwinddown",CHAN_6,CHANF_DEFAULT,3);
			DGTG A 4;
			DGTG B 5;
			DGTG C 6;
			DGTG D 7;
			DGTG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			DEGT A -1;
			stop;
	}
	*/
	action State A_FireShotgun(){
		A_GunFlash();
		Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		double spread=2.5+(0.75*clamp(player.refire,0,10));
		W_FireTracer((spread,spread),4,12,drawTracer:sv_shotgun_tracers);
		player.refire++;
		A_Recoil(2.5);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-2,0),SPF_INTERPOLATE);
		A_StartSound("weapons/gatlingfire",CHAN_AUTO);
		return ResolveState(null);
	}
}