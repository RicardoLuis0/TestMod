class GuidedRocketLauncher:MyWeapon{
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 2;
		Weapon.AmmoType "RocketAmmo";
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "Got Laser Guided Rocket Launcher";
	}
	States{
	Ready:
		HSML A 1 A_WeaponReady();
		Loop;
	Select:
		HSML A 1 A_Raise;
		Loop;
	Deselect:
		HSML A 1 A_Lower;
		Loop;
	Fire:
		HSML B 0 {
			if(CountInv("RocketAmmo")==0){
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		HSML B 0 Bright A_GunFlash;
		HSML B 3 Bright MyFire;
		HSML C 3;
		HSML D 3;
		HSML A 20;
		HSML A 0 A_Refire;
		Goto Ready;
	Flash:
		TNT1 A 2 A_Light1;
		TNT1 A 2 A_Light2;
		TNT1 A 0 A_Light0;
		Goto LightDone;
	Spawn:
		HSGN A -1;
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