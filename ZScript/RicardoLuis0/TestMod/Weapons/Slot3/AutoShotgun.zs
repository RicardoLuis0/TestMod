class AutoShotgunLoaded : Ammo{
	Default{
		Inventory.MaxAmount 13;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "DEASA0";
	}
}

class AutoShotgun : ModWeaponBase {
	int pellets;
	int dmg;
	bool firecasing;
	
	Default{
		Tag "Auto Shotgun";
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "AutoShotgunLoaded";
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 12;
		Weapon.SlotPriority 0.75;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Auto Shotgun!";
		
		ModWeaponBase.PickupHandleMagazine true;
	}
	
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=23;
		pellets=12;
		dmg=4;
		firecasing=false;
	}
	
	States{
		ready:
			DASG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			DASG A 1 A_Raise;
			loop;
		deselect:
			DASG A 1 A_Lower;
			loop;
		fire:
			DASG A 0 A_FireAuto();
			DASF B 3 Bright A_GunFlash;
			DASF C 2 Bright;
			//DASF D 1;
			DASF E 2;
			DASF E 2 A_Refire;
			TNT1 A 0 {
				player.refire=0;
			}
			goto ready;
		flash:
			TNT1 A 3 Bright A_Light1;
			TNT1 A 2 Bright A_Light2;
			goto lightdone;
		reload:
			TNT1 A 0 {
				if(invoker.ammo1.amount==13||invoker.ammo2.amount==0){
					return ResolveState("Ready");
				}
				return ResolveState(null);
			}
			DASG B 6;
			DASG C 2;
			DASG D 4;
			TNT1 A 0 A_StartSound("weapons/click01",CHAN_AUTO);
			DASG EF 2;
			DASG G 6;
			DASG H 2;
			DASG IJ 2;
			TNT1 A 0 A_StartSound("weapons/rifle_reload",CHAN_AUTO);
			DASG K 5 A_ReloadAmmoMagazineDefaults;
			DASG L 4;
			DASG M 4;
			goto ready;
		noammo:
			DASG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			goto ready;
		spawn:
			DEAS A -1;
			stop;
	}

	action State A_FireAuto(){
		if(invoker.ammo1.amount==0){
			if(invoker.ammo2.amount==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		A_AlertMonsters();
		Actor c=W_FireProjectile("ShellCasing",random[TestModWeapon](-30, -50),false,2,2-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		A_Recoil(2.0);
		double spread=(player.refire>0)?6.5:5;
		W_FireTracer((spread,spread),invoker.dmg,invoker.pellets,drawTracer:sv_shotgun_tracers);
		A_SetPitch(pitch+frandom[TestModWeapon](-5,-2.5),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom[TestModWeapon](-2,2),SPF_INTERPOLATE);
		A_StartSound("weapons/shotgun_fire",CHAN_AUTO,CHANF_DEFAULT,0.5);
		return ResolveState(null);
	}
}