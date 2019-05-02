class LaserDot:VisTracer{
	states{
	Spawn:
		RDOT A 2 BRIGHT;
		Stop;
	}
}
class GuidedRocketLauncher:MyWeapon{
	bool laserenabled;
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 5;
		Weapon.AmmoType "RocketAmmo";
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "Got Laser Guided Rocket Launcher";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=48;
		laserenabled=true;
	}
	override void ReadyTick(){
		if(laserenabled){
			MyPlayer(owner).P_LineAttack("LaserDot",0);
		}
	}
	States{
	Ready:
		DRLG A 1 A_WeaponReady();
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
		DRLF BCDE 3;
		DRLG BC 5;
		DRLG A 0 A_Refire;
		Goto Ready;
	AltFire:
		DRLG A 3 A_WeaponOffset(5,40,WOF_INTERPOLATE);
		DRLG A 0{
			A_PlaySound("DSCLICKY");
			invoker.laserenabled=!invoker.laserenabled;
		}
		DRLG A 3 A_WeaponOffset(0,32,WOF_INTERPOLATE);
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