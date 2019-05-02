class GatlingRocketLauncher : MyWeapon{
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 10;
		Weapon.AmmoType "RocketAmmo";
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "Got Gatling Rocket Launcher";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=46;
	}
	States{
	Ready:
		REPG A 1 A_WeaponReady;
		Loop;
	Deselect:
		REPG A 1 A_Lower;
		Loop;
	Select:
		REPG A 1 A_Raise;
		Loop;
	Fire:
		REPG A 12;
		REPG A 0 CheckFire(noFire: "Unspin1");
		REPG B 10;
		REPG A 0 CheckFire(noFire: "Unspin2");
		REPG C 8;
		REPG A 0 CheckFire(noFire: "Unspin3");
		REPG D 6;
		REPG A 0 CheckFire(noFire: "Unspin4");
		REPG AB 4;
		REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
		REPG CD 4;
		REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
	Unspin1:
		REPG BCD 12;
		Goto Ready;
	Unspin2:
		REPG CD 12;
	Unspin3:
		REPG D 10;
		REPG ABCD 12 CheckFire("Fire","AltFire");
		Goto Ready;
	Unspin4:
		REPG A 8;
		REPG B 10;
		REPG CD 12;
		Goto Ready;
	Shoot1:
		REPG A 0 {
			if(CountInv("RocketAmmo")==0){
				return ResolveState("AltLoop1");
			}
			return ResolveState(null);
		}
		REPG E 4 MyFire;
		REPG F 4;
		REPG A 0 CheckFire(null,"AltLoop2","Spindown2");
		REPG A 0 A_ReFire("Shoot2");
		Goto Shoot2;
	Shoot2:
		REPG A 0 {
			if(CountInv("RocketAmmo")==0){
				return ResolveState("AltLoop2");
			}
			return ResolveState(null);
		}
		REPG G 4 MyFire;
		REPG H 4;
		REPG A 0 CheckFire(null,"AltLoop1","Spindown1");
		REPG A 0 A_ReFire("Shoot1");
		Goto Shoot1;
	Spindown1:
		REPG A 0 CheckFire("Shoot2","AltLoop2");
		REPG AB 4;
	Spindown2:
		REPG CD 4;
		REPG A 0 CheckFire("Shoot1","AltLoop1");
		REPG A 6;
		REPG A 0 CheckFire("Respin1","Respin1");
		REPG B 8;
		REPG A 0 CheckFire("Respin2","Respin2");
		REPG C 10;
		REPG A 0 CheckFire("Respin3","Respin3");
		REPG D 12;
		REPG A 0 CheckFire("Respin4","Respin4");
		Goto Ready;
	Respin1:
		REPG B 4;
		REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
		goto Spindown2;
	Respin2:
		REPG C 6;
		REPG D 4;
		REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
		goto Spindown1;
	Respin3:
		REPG D 8;
		REPG A 6;
		goto Respin1;
	Respin4:
		REPG A 10;
		REPG B 8;
		REPG C 6;
		REPG D 4;
		REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
		goto Spindown1;
	Flash:
		TNT1 A 8 A_Light2;
		TNT1 A 8 A_Light1;
		TNT1 A 0 A_Light0;
		Goto LightDone;
	AltFire:
		REPG A 12;
		REPG B 10;
		REPG C 8;
		REPG D 6;
		REPG ABCD 4;
	AltLoop1:
		REPG AB 4;
		REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
	AltLoop2:
		REPG CD 4;
		REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
	Spawn:
		REPG I -1;
		Stop;
	}
	action void MyFire(){
		A_Recoil(4);
		A_TakeInventory("RocketAmmo",1);
		A_GunFlash();
		A_AlertMonsters();
		A_FireProjectile("Rocket");
	}
}

/*
class SpiralRocket : Rocket{
	int speed;
	float dist;
	override void BeginPlay(){
		super.BeginPlay();
		speed=random(1,2);
		dist=frandom(0,1);
	}
	States{
	Spawn:
		MISL A 1 Bright A_Weave(speed,speed,dist,dist);
		Loop;
	}
}
*/