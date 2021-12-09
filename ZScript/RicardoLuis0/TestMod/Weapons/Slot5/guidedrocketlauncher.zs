class LaserDot:Actor{
	Default{
		+NOINTERACTION;
	}
	states{
	Spawn:
		RDOT A 2 BRIGHT;
		Stop;
	}
}

class GuidedRocketLauncher : ModWeaponBase {
	bool laserenabled;
	Default{
		Tag "Laser-Guided Rocket Launcher";
		Weapon.SlotNumber 5;
		Weapon.SlotPriority 0;
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 5;
		Weapon.AmmoType "RocketAmmo";
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Laser-Guided Rocket Launcher!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		laserenabled=true;
	}
	double clamp(double min,double val,double max){
		return max(min,min(val,max));
	}
	override void ReadyTick(){
		super.ReadyTick();
		if(laserenabled){
			crosshair=0;
			if(owner is "TestModPlayer"){
				TestModPlayer p=TestModPlayer(owner);
				let a=p.LineAttack_Straight();
				double dist=level.Vec3Diff((p.pos.x,p.pos.y,p.player.ViewZ),a.pos).length();
				a.A_SpawnParticle("#FF0000",SPF_FULLBRIGHT,2,clamp(5,dist/50,50));
				a.destroy();
			}
		}else{
			crosshair=48;
		}
	}
	States{
		Ready:
			DRLG A 1 W_WeaponReady;
			Loop;
		Select:
			DRLG A 1 A_Raise;
			Loop;
		Deselect:
			DRLG A 1 A_Lower;
			Loop;
		Fire:
			DRLF A 0 {
				if(CountInv("RocketAmmo")==0){
					return ResolveState("Ready");
				}
				return ResolveState(null);
			}
			DRLF A 0 Bright A_GunFlash;
			DRLF A 3 Bright MyFire;
			DRLF B 2;
			DRLF C 2;
			DRLF D 2;
			DRLF E 2;
			DRLG B 4;
			DRLG C 6;
			DRLG A 0 A_Refire;
			Goto Ready;
		AltFire:
			DRLG A 3 A_WeaponOffset(5,40,WOF_INTERPOLATE);
			DRLG A 0{
				A_StartSound("DSCLICKY",CHAN_AUTO);
				A_Print(invoker.laserenabled?"Laser Guide Off":"Laser Guide On");
				invoker.laserenabled=!invoker.laserenabled;
			}
			DRLG A 3 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		altloop:
			DRLG A 1;
			DRLG A 0 A_ReFire("altloop");
			Goto Ready;
		Flash:
			TNT1 A 2 A_Light1;
			TNT1 A 2 A_Light2;
			TNT1 A 0 A_Light0;
			Goto LightDone;
		Spawn:
			DERL A -1;
			Stop;
	}
	action void MyFire(){
		A_Recoil(8);
		A_TakeInventory("RocketAmmo",1);
		A_GunFlash();
		A_AlertMonsters();
		A_FireProjectile("GuidedRocket");
	}
}