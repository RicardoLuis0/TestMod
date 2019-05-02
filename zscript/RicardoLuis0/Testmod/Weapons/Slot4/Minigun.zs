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
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Minigun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
		dmg=8;
	}
	States{
		ready:
			PKCG A 1 A_WeaponReady();
			loop;
		select:
			TNT1 A 0 {
				A_UpdateBob();
				TestModPlayer cast=TestModPlayer(invoker.owner);
				if(cast){
					cast.ChangeMove(1,false);
				}
			}
		selectloop:
			PKCG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				TestModPlayer cast=TestModPlayer(invoker.owner);
				if(cast){
					cast.RevertMove();
				}
			}
		deselectloop:
			PKCG A 1 A_Lower;
			loop;
		firespin:
			TNT1 A 0 {
				A_StopSound(CHAN_6);
				A_PlaySound("weapons/minigunspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.5);
				if(CountInv("Clip")==0)return ResolveState("idlespin");
				return ResolveState(null);
			}
			PKCG A 0 A_Jump(128,"firespin2");
			PKCG A 0 A_Bob;
			PKCF A 1 Bright A_FireGun;
			goto idlespin2fire;
		firespin2:
			PKCG A 0 A_Bob;
			PKCF B 1 Bright A_FireGun;
			goto idlespin2fire;
		idlespin:
			TNT1 A 0 A_StopSound(CHAN_6);
			TNT1 A 0 A_PlaySound("weapons/minigunspin",CHAN_7|CHAN_NOSTOP|CHAN_LOOP,0.5);
			PKCG A 0 A_Bob;
			PKCG A 1;
		idlespin2:
			PKCG A 0 A_Bob;
			PKCG C 1;
			PKCG A 0 CheckFire("firespin","idlespin","spin1down");
			goto ready;
		idlespin2fire:
			PKCG A 0 A_Bob;
			PKCG C 1 Bright;
			PKCG A 0 CheckFire("firespin","idlespin","spin1down");
			goto ready;
		spin1up:
			PKCG A 0 A_Bob;
			PKCG A 2;
			PKCG A 0 A_Bob;
			PKCG B 2;
			PKCG A 0 A_Bob;
			PKCG C 1;
			PKCG A 0 A_Bob;
			PKCG D 1;
			PKCG A 0 CheckFire("firespin","idlespin","spin1down");
		spin1down:
			TNT1 A 0 A_StopSound(CHAN_7);
			TNT1 A 0 A_PlaySound("weapons/minigunwinddown",CHAN_6,0.5);
			PKCG A 0 A_Bob;
			PKCG A 1;
			PKCG A 0 A_Bob;
			PKCG B 1;
			PKCG A 0 A_Bob;
			PKCG C 2;
			PKCG A 0 A_Bob;
			PKCG D 2;
			PKCG A 0 CheckFire("firespin","idlespin","spin2down");
		altfire:
		fire:
		spin2up:
			TNT1 A 0 A_PlaySound("weapons/minigunwindup",CHAN_6,0.5);
			PKCG A 0 A_Bob;
			PKCG A 6;
			PKCG A 0 A_Bob;
			PKCG B 5;
			PKCG A 0 A_Bob;
			PKCG C 4;
			PKCG A 0 A_Bob;
			PKCG D 3;
			TNT1 A 0 A_PlaySound("weapons/minigunspin",CHAN_7|CHAN_LOOP,0.5);
			PKCG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			PKCG A 0 A_Bob;
			PKCG A 3;
			PKCG A 0 A_Bob;
			PKCG B 4;
			PKCG A 0 A_Bob;
			PKCG C 5;
			PKCG A 0 A_Bob;
			PKCG D 6;
			PKCG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			PKCP A -1;
			stop;
	}
	action State A_FireGun(){
		if(CountInv("Clip")==0){
			return ResolveState("noammo");
		}
		A_GunFlash();
		int refire=player.refire;
		if(refire<=0)player.refire=1;
		W_FireBullets(8,5,1,invoker.dmg,"BulletPuff");
		player.refire=refire;
		A_Recoil(1);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-1,0),SPF_INTERPOLATE);
		A_PlaySound("weapons/minigun_fire_01",CHAN_WEAPON);
		return ResolveState(null);
	}
}