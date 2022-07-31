class Minigun : HeavyGatlingShotgun {
	bool tammo;

	Default{
		Tag "Minigun";
		Weapon.AmmoType1 "LightClip";
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Inventory.PickupMessage "You've got the Minigun!";
		Weapon.SlotPriority 0;
		Weapon.SlotNumber 4;
		
		ModWeaponBase.PickupHandleNoMagazine true;
	}
	States{
		ready:
			PKCG A 1 {
				invoker.spinning=false;
				player.refire=0;
				W_WeaponReady();
			}
			loop;
		select:
			PKCG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				invoker.spinning=false;
			}
		deselectloop:
			PKCG A 1 A_Lower;
			loop;
		firespin:
			TNT1 A 0 {
				invoker.spinning=true;
				A_StopSound(CHAN_6);
				A_StartSound("weapons/minigunspin",CHAN_7,CHANF_LOOPING,0.2);
				if(CountInv(invoker.ammotype1)==0)return ResolveState("idlespin_clearrefire");
				return ResolveState(null);
			}
			PKCG A 0 A_Jump(128,"firespin2");
			PKCF A 1 Bright A_FireGun;
			goto idlespin2fire;
		firespin2:
			PKCF B 1 Bright A_FireGun;
			goto idlespin2fire;
		idlespin_clearrefire:
			TNT1 A 0 {
				player.refire=0;
			}
		idlespin:
			TNT1 A 0 {
				invoker.spinning=true;
				A_StopSound(CHAN_6);
				A_StartSound("weapons/minigunspin",CHAN_7,CHANF_LOOPING,0.2);
			}
			PKCG A 1;
		idlespin2:
			PKCG C 1;
			PKCG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
			goto ready;
		idlespin2fire:
			PKCG C 1 Bright;
			PKCG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
			goto ready;
		spin1up:
			TNT1 A 0 A_StartSound("weapons/minigunwindup",CHAN_6,CHANF_NOSTOP,0.2);
			PKCG A 2;
			PKCG B 2;
			PKCG C 1;
			PKCG D 1;
			PKCG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
		spin1down:
			TNT1 A 0 {
				player.refire=0;
			}
			TNT1 A 0 A_StopSound(CHAN_7);
			TNT1 A 0 A_StartSound("weapons/minigunwinddown",CHAN_6,CHANF_DEFAULT,0.25);
			PKCG A 1;
			PKCG B 1;
			PKCG C 2;
			PKCG D 2;
			PKCG A 0 CheckFire("firespin","idlespin_clearrefire","spin2down");
		altfire:
		fire:
		spin2up:
			TNT1 A 0 A_StartSound("weapons/minigunwindup",CHAN_6,CHANF_DEFAULT,0.2);
			PKCG A 6;
			PKCG B 5;
			PKCG C 4;
			PKCG D 3;
			PKCG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			TNT1 A 0 {
				player.refire=0;
			}
			TNT1 A 0 A_StopSound(CHAN_7);
			TNT1 A 0 A_StartSound("weapons/minigunwinddown",CHAN_6,CHANF_NOSTOP,0.25);
			PKCG A 3;
			PKCG B 4;
			PKCG C 5;
			PKCG D 6;
			PKCG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			PKCP A -1;
			stop;
	}
	action State A_FireGun(){
		if(CountInv(invoker.ammotype1)==0){
			return ResolveState("idlespin_clearrefire");
		}
		Actor c=A_FireProjectile("LightClipCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		A_GunFlash();
		W_FireBulletsSpreadXY(3,16,1,4,flags:((player.refire%2)==0)?FBF_USEAMMO:0,refire_rate:0.0625,refire_max:0.5);
		player.refire++;
		
		invoker.tammo=!invoker.tammo;
		A_Recoil(1);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-1,0),SPF_INTERPOLATE);
		A_StartSound("weapons/minigun_fire_01",CHAN_AUTO);
		return ResolveState(null);
	}
}