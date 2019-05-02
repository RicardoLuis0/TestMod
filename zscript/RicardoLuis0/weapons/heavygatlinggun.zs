
class HeavyGatlingGun : MyWeapon replaces ChainGun{
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 50;
		Weapon.AmmoType "Clip";
		Weapon.SlotNumber 4;
		//+WEAPON.NOAUTOFIRE
		+WEAPON.NOALERT;
	}
	States{
	Ready:
		0GTG A 1 A_WeaponReady;
		Loop;
	Deselect:
		0GTG A 1 A_Lower;
		Loop;
	Select:
		0GTG A 1 A_Raise;
		Loop;
	Fire:
		0GTG A 6;
		0GTG A 0 CheckFire(noFire: "Unspin1");
		0GTG B 5;
		0GTG A 0 CheckFire(noFire: "Unspin2");
		0GTG C 4;
		0GTG A 0 CheckFire(noFire: "Unspin3");
		0GTG D 3;
		0GTG A 0 CheckFire(noFire: "Unspin4");
		0GTG ABCD 2;
		0GTG A 0 CheckFire("Shoot","AltLoop","Spindown");
	Unspin1:
		0GTG BCD 6;
		Goto Ready;
	Unspin2:
		0GTG CD 6;
	Unspin3:
		0GTG D 5;
		0GTG ABCD 6 CheckFire("Fire","AltFire");
		Goto Ready;
	Unspin4:
		0GTG A 4;
		0GTG B 5;
		0GTG CD 6;
		Goto Ready;
	Shoot:
		0GTG A 0 A_GunFlash;
		0GTF A 1 MyFire;
		0GTF B 1;
		0GTG BCD 2;
		0GTG A 0 CheckFire(null,"AltLoop","Spindown");
		0GTG A 0 A_Refire("Shoot");
		goto Shoot;
	Spindown:
		0GTG ABCD 2;
		0GTG A 0 CheckFire("Shoot","AltLoop");
		0GTG A 3;
		0GTG A 0 CheckFire("Respin1","Respin1");
		0GTG B 4;
		0GTG A 0 CheckFire("Respin2","Respin2");
		0GTG C 5;
		0GTG A 0 CheckFire("Respin3","Respin3");
		0GTG D 6;
		0GTG A 0 CheckFire("Respin4","Respin4");
		Goto Ready;
	Respin1:
		0GTG BCD 2;
		0GTG A 0 CheckFire("Shoot","AltLoop");
		goto Spindown;
	Respin2:
		0GTG C 3;
		0GTG D 2;
		0GTG A 0 CheckFire("Shoot","AltLoop");
		goto Spindown;
	Respin3:
		0GTG D 4;
		0GTG A 3;
		goto Respin1;
	Respin4:
		0GTG A 5;
		0GTG B 4;
		0GTG C 3;
		0GTG D 2;
		0GTG A 0 CheckFire("Shoot","AltLoop");
		goto Spindown;
	Flash:
		TNT1 A 4 A_Light2;
		TNT1 A 4 A_Light1;
		TNT1 A 0 A_Light0;
		Goto LightDone;
	AltFire:
		0GTG A 6;
		0GTG B 5;
		0GTG C 4;
		0GTG D 3;
		0GTG ABCD 2;
	AltLoop:
		0GTG ABCD 2 CheckFire("Shoot",null);
		0GTG A 0 CheckFire("Shoot","AltLoop");
		Goto Spindown;
	Spawn:
		0EGT A -1;
		Stop;
	}
	action State MyFire(){
		if(CountInv("Clip")==0){
			return ResolveState("AltLoop");
		}
		A_Recoil(1);
		A_TakeInventory("Clip",1);
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_AlertMonsters();
		A_FireBullets(2,2,1,10,"BulletPuff");
		return ResolveState(null);
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