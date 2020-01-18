class GatlingRocketLauncher : MyWeapon{
	Default{
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 10;
		Weapon.AmmoType1 "RocketAmmo";
		Weapon.AmmoType2 "RocketAmmo";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You've got the Gatling Rocket Launcher!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=46;
	}
	States{
		Ready:
			REPG A 1 A_WeaponReady;
			Loop;
		Select:
			REPG A 1 A_Raise;
			loop;
		Deselect:
			REPG A 1 A_Lower;
			loop;
		AltFire:
		Fire:
			TNT1 A 0 A_PlaySound("weapons/gatlingrocketwindup",CHAN_6);
			REPG A 12;
			REPG A 0 CheckFire(noFire: "Unspin1");
			REPG B 10;
			REPG A 0 CheckFire(noFire: "Unspin2");
			REPG C 8;
			REPG A 0 CheckFire(noFire: "Unspin3");
			REPG D 6;
			REPG A 0 CheckFire(noFire: "Unspin4");
			REPG A 4;
			REPG B 4;
			REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
			REPG C 4;
			REPG D 4;
			REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
			Goto Ready;
		Unspin1:
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG B 12;
			REPG C 12;
			REPG D 12;
			Goto Ready;
		Unspin2:
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG C 12;
			REPG D 12;
			Goto Ready;
		Unspin3:
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG D 10;
			REPG A 12 CheckFire("Fire","AltFire");
			REPG B 12;
			REPG C 12;
			REPG D 12;
			Goto Ready;
		Unspin4:
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG A 8;
			REPG B 10;
			REPG C 12;
			REPG D 12;
			Goto Ready;
		Shoot1:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP);
			}
			REPG A 0 {
				if(CountInv("RocketAmmo")==0){
					return ResolveState("AltLoop1");
				}
				return ResolveState(null);
			}
			REPG A 0 A_WeaponOffset(0,40);
			REPG E 4 MyFire();
			REPG F 4 {
				A_WeaponOffset(0,32,WOF_INTERPOLATE);
				MyFire2();
			}
			REPG A 0 CheckFire(null,"AltLoop2","Spindown2");
			REPG A 0 A_ReFire("Shoot2");
			Goto Shoot2;
		Shoot2:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG A 0 {
				if(CountInv("RocketAmmo")==0){
					return ResolveState("AltLoop2");
				}
				return ResolveState(null);
			}
			REPG A 0 A_WeaponOffset(0,40);
			REPG G 4 MyFire();
			REPG H 4 {
				A_WeaponOffset(0,32,WOF_INTERPOLATE);
				MyFire2();
			}
			REPG A 0 CheckFire(null,"AltLoop1","Spindown1");
			REPG A 0 A_ReFire("Shoot1");
			Goto Shoot1;
		Spindown1:
			REPG A 0 CheckFire("Shoot2","AltLoop2");
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG A 4;
			REPG B 4;
		Spindown2:
			TNT1 A 0 {
				A_StopSound(CHAN_7);
				A_PlaySound("weapons/gatlingrocketwinddown",CHAN_6|CHAN_NOSTOP);
			}
			REPG C 4;
			REPG D 4;
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
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG B 4;
			REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
			goto Spindown2;
		Respin2:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG C 6;
			REPG D 4;
			REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
			goto Spindown1;
		Respin3:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG D 8;
			REPG A 6;
			goto Respin1;
		Respin4:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
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
			/*
		AltFire:
			REPG A 12;
			REPG B 10;
			REPG C 8;
			REPG D 6;
			REPG A 4;
			REPG B 4;
			REPG C 4;
			REPG D 4;
			*/
		AltLoop1:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG A 4;
			REPG B 4;
			REPG A 0 CheckFire("Shoot2","AltLoop2","Spindown2");
		AltLoop2:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/gatlingrocketspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.6);
			}
			REPG C 4;
			REPG D 4;
			REPG A 0 CheckFire("Shoot1","AltLoop1","Spindown1");
		Spawn:
			REPG I -1;
			Stop;
	}
	action void MyFire(){
		A_TakeInventory("RocketAmmo",1);
		MyFire2();
	}
	action void MyFire2(){
		A_Recoil(2);
		A_GunFlash();
		A_AlertMonsters();
		A_FireProjectile("FastRocket",frandom(-4,4),pitch:frandom(-2,2));
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