class Minigun:MyWeapon{
	int dmg;
	Default{
		Weapon.SlotNumber 4;
		Weapon.AmmoType1 "Clip";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Weapon.AmmoGive1 50;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You've got the Minigun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
		dmg=10;
	}
	States{
		ready:
			PKCG A 1 A_WeaponReady();
			loop;
		select:
			TNT1 A 0 {
				MyPlayer cast=MyPlayer(invoker.owner);
				if(cast){
					cast.ChangeMove(1,false);
				}
			}
		selectloop:
			PKCG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				MyPlayer cast=MyPlayer(invoker.owner);
				if(cast){
					cast.RevertMove();
				}
			}
		deselectloop:
			PKCG A 1 A_Lower;
			loop;
		fire:
			goto spin2up;
		firespin:
			PKCG A 0 A_Jump(128,"firespin2");
			PKCG A 0 A_Bob;
			PKCF A 1 Bright A_FireGun;
			goto idlespin2;
		firespin2:
			PKCG A 0 A_Bob;
			PKCF B 1 Bright A_FireGun;
			goto idlespin2;
		altfire:
			goto spin2up;
		idlespin:
			PKCG A 0 A_Bob;
			PKCG A 1;
		idlespin2:
			PKCG A 0 A_Bob;
			PKCG B 1;
			PKCG A 0 A_Bob;
			PKCG C 1;
			PKCG A 0 A_Bob;
			PKCG D 1;
			PKCG A 0 CheckFire("firespin","idlespin","spin1down");
			goto ready;
		spin1up:
			PKCG A 0 A_Bob;
			PKCG A 3;
			PKCG A 0 A_Bob;
			PKCG B 3;
			PKCG A 0 A_Bob;
			PKCG C 2;
			PKCG A 0 A_Bob;
			PKCG D 2;
			PKCG A 0 CheckFire("firespin","idlespin","spin1down");
		spin1down:
			PKCG A 0 A_Bob;
			PKCG A 2;
			PKCG A 0 A_Bob;
			PKCG B 2;
			PKCG A 0 A_Bob;
			PKCG C 3;
			PKCG A 0 A_Bob;
			PKCG D 3;
			PKCG A 0 CheckFire("firespin","idlespin","spin2down");
		spin2up:
			PKCG A 0 A_Bob;
			PKCG A 5;
			PKCG A 0 A_Bob;
			PKCG B 5;
			PKCG A 0 A_Bob;
			PKCG C 4;
			PKCG A 0 A_Bob;
			PKCG D 4;
			PKCG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			PKCG A 0 A_Bob;
			PKCG A 4;
			PKCG A 0 A_Bob;
			PKCG B 4;
			PKCG A 0 A_Bob;
			PKCG C 5;
			PKCG A 0 A_Bob;
			PKCG D 5;
			PKCG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			DEGT A -1;
			stop;
	}
	action State A_FireGun(){
		if(CountInv("Clip")==0){
			return ResolveState("noammo");
		}
		A_GunFlash();
		int refire=player.refire;
		if(refire<=0)player.refire=1;
		A_FireBullets(2,1,1,invoker.dmg,"BulletPuff");
		player.refire=refire;
		A_Recoil(1.5);
		A_AlertMonsters();
		A_SetPitch(pitch+(random(-10,0)/5),SPF_INTERPOLATE);
		A_PlaySound("weapons/gatlingfire");
		return ResolveState(null);
	}
}