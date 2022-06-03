class HeavyGatlingShotgun : ModWeaponBase {
	bool spinning;
	Default{
		Tag "Heavy Gatling Shotgun";
		Weapon.SlotNumber 3;
		Weapon.SlotPriority 0.001;
		Weapon.AmmoType1 "Shell";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 1;
		Weapon.AmmoGive1 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Heavy Gatling Shotgun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=35;
	}
	override void Tick(){
		super.Tick();
	}
	override void ReadyTick(){
		if(spinning){
			Owner.player.WeaponState |= WF_DISABLESWITCH;
			Owner.player.WeaponState &= ~WF_REFIRESWITCHOK;
		}
	}
	States{
		ready:
			DGTG A 1 {
				invoker.spinning=false;
				W_WeaponReady();
			}
			loop;
		select:
			DGTG A 1 A_Raise;
			loop;
		deselect:
			TNT1 A 0 {
				invoker.spinning=false;
			}
		deselectloop:
			DGTG A 1 A_Lower;
			loop;
		firespin:
			TNT1 A 0 {
				invoker.spinning=true;
				if(CountInv(invoker.ammotype1)==0) return ResolveState("idlespin_clearrefire");
				return ResolveState(null);
			}
			DGTF A 1 Bright A_FireShotgun;
			DGTF B 1 Bright;
			goto idlespin2;
		idlespin_clearrefire:
			TNT1 A 0 {
				player.refire=0;
			}
		idlespin:
			TNT1 A 0 {
				invoker.spinning=true;
			}
			DGTG A 2;
		idlespin2:
			DGTG B 2;
			DGTG C 2;
			DGTG D 2;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
			goto ready;
		spin1up:
			DGTG A 4;
			DGTG B 4;
			DGTG C 3;
			DGTG D 3;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin1down");
		spin1down:
			TNT1 A 0 {
				player.refire=0;
			}
			DGTG A 3;
			DGTG B 3;
			DGTG C 4;
			DGTG D 4;
			DGTG A 0 CheckFire("firespin","idlespin_clearrefire","spin2down");
		fire:
		altfire:
		spin2up:
			TNT1 A 0 {
				A_StartSound("weapons/gatlingspin",CHAN_7,CHANF_LOOPING,3);
				A_StartSound("weapons/gatlingwindup",CHAN_6,CHANF_DEFAULT,4);
			}
			DGTG A 7;
			DGTG B 6;
			DGTG C 5;
			DGTG D 4;
			DGTG A 0 CheckFire("spin1up","spin1up","spin2down");
		spin2down:
			TNT1 A 0 {
				player.refire=0;
			}
			DGTG A 0 A_StopSound(CHAN_7);
			DGTG A 0 A_StartSound("weapons/gatlingwinddown",CHAN_6,CHANF_DEFAULT,3);
			DGTG A 4;
			DGTG B 5;
			DGTG C 6;
			DGTG D 7;
			DGTG A 0 CheckFire("spin2up","spin2up","ready");
		spawn:
			DEGT A -1;
			stop;
	}
	action State A_FireShotgun(){
		if(CountInv(invoker.ammotype1)==0){
			return ResolveState("idlespin_clearrefire");
		}
		A_GunFlash();
		Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		double spread=2.5+(0.75*clamp(player.refire,0,10));
		W_FireBullets(spread,spread,12,4);
		player.refire++;
		A_Recoil(2.5);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-2,0),SPF_INTERPOLATE);
		A_StartSound("weapons/gatlingfire",CHAN_AUTO);
		return ResolveState(null);
	}
}