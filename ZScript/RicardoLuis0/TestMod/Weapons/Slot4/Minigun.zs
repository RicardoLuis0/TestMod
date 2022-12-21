class Minigun : ModRotatingWeapon {
	bool tammo;
	bool spinning_up;
	
	bool fireframe;
	
	const CHAN_SPINFAST = 10;
	
	const CHAN_SPINUP = 11;
	const CHAN_SPINDOWN = 12;

	Default{
		Tag "Minigun";
		Weapon.AmmoType1 "LightClip";
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		
		Weapon.AmmoGive1 20;
		
		Inventory.PickupMessage "You've got the Minigun!";
		Weapon.SlotPriority 0;
		Weapon.SlotNumber 4;
		
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		
		ModWeaponBase.PickupHandleNoMagazine true;
	}
	
	int spin_tics;
	override void ReadyTick(){
		if(spinning_up) {
			spin_tics ++;
			if(spin_tics == 24) {
				owner.A_StartSound("weapons/minigunspin",CHAN_SPINFAST,CHANF_LOOPING,0.2);
			}
		} else {
			spin_tics = 0;
		}
		
	}
	
	action State TrySpin(bool allowFire = false,bool spinDown = true){
		if(player.cmd.buttons & (BT_ALTATTACK|BT_ATTACK) || (invoker.spin_tics > 0 && invoker.spin_tics < 18)){
			if(allowFire) {
				SpinUp();
				if(!invoker.spinning_up) {
					A_StopSound(CHAN_SPINFAST);
					A_StopSound(CHAN_SPINDOWN);
					A_StartSound("weapons/minigunwindup",CHAN_SPINUP,CHANF_NOSTOP,0.25);
				}
				invoker.spinning_up = true;
				if(player.cmd.buttons & BT_ATTACK) {
					return IfSpeedGtEq(25,"RealFire");
				} else {
					player.refire = 0;
					return null;
				}
			}
			return SpinUp();
		} else if(spinDown) {
			if(invoker.spinning_up) {
				A_StopSound(CHAN_SPINFAST);
				A_StopSound(CHAN_SPINUP);
				A_StartSound("weapons/minigunwinddown",CHAN_SPINDOWN,CHANF_NOSTOP,0.25);
			}
			invoker.spinning_up = false;
			return SpinDown("Ready");
		} else {
			UpdateTics();
			return null;
		}
	}
	
	States{
	Ready:
		PKCG A 1 {
			invoker.spinning_up = false;
			W_WeaponReady();
		}
		Loop;
	Deselect:
		PKCG A 1 A_Lower;
		Loop;
	Select:
		PKCG A 1 A_Raise;
		Loop;
	Fire:
	AltFire:
		Goto Spin;
	Spin:
		TNT1 A 0 IfSpeedEq(50,"SpinFast");
		PKCG A 10 TrySpin(true);
		PKCG B 10 TrySpin;
		PKCG C 10 TrySpin;
		PKCG D 10 TrySpin;
		Loop;
	SpinFast:
		PKCG A 10 {
			A_StopSound(CHAN_SPINUP);
			A_StopSound(CHAN_SPINDOWN);
			A_StartSound("weapons/minigunspin",CHAN_SPINFAST,CHANF_LOOPING,0.2);
			W_SetLayerFrame(PSP_WEAPON,random[minigunFireFrame](0,1));
			return TrySpin(true);
		}
		PKCG C 10 {
			W_SetLayerFrame(PSP_WEAPON,random[minigunFireFrame](2,3));
			return TrySpin(true);
		}
		Goto Spin;
	Spawn:
		PKCP A -1;
		stop;
	RealFire:
		TNT1 A 0 IfSpeedEq(50,"RealFireFast");
		PKCF A 10 Bright {
			if(invoker.ammo1.amount==0)return ResolveState("Spin");
			W_SetLayerFrame(PSP_WEAPON,invoker.fireframe);
			invoker.fireframe = !invoker.fireframe;
			
			TrySpin(false,false);
			A_FireGun();
			return ResolveState(null);
		}
		PKCG B 10 TrySpin;
		PKCG C 10 TrySpin;
	AbortFireFast:
		PKCG D 10 {
			W_SetLayerFrame(PSP_WEAPON,random[minigunFireFrame](0,1));
			TrySpin();
		}
		Goto Spin;
	RealFireFast:
		PKCF A 10 Bright {
			A_StopSound(CHAN_SPINUP);
			A_StopSound(CHAN_SPINDOWN);
			A_StartSound("weapons/minigunspin",CHAN_SPINFAST,CHANF_LOOPING,0.2);
			if(invoker.ammo1.amount==0)return ResolveState("SpinFast");
			TrySpin(false,false);
			A_FireGun();
			return ResolveState(null);
		}
		PKCG C 10 {
			W_SetLayerFrame(PSP_WEAPON,random[minigunFireFrame](1,3));
			TrySpin();
			return IfSpeedEq(50,null,"AbortFireFast");
		}
		PKCF B 10 Bright {
			TrySpin(false,false);
			A_FireGun();
		}
		PKCG C 10 {
			W_SetLayerFrame(PSP_WEAPON,random[minigunFireFrame](1,3));
			TrySpin();
		}
		Goto Spin;
	}
	action State A_FireGun() {
		Actor c=A_FireProjectile("LightClipCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		A_GunFlash();
		
		W_FireTracerSpreadXY(4,3,16,0.0625,0.5,flags:((player.refire%2)==0)?FBF_USEAMMO:0,drawTracer:sv_light_bullet_tracers);
		
		player.refire++;
		
		invoker.tammo=!invoker.tammo;
		A_Recoil(1);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-1,0),SPF_INTERPOLATE);
		A_StartSound("weapons/minigun_fire_01",CHAN_AUTO);
		return ResolveState(null);
	}
}