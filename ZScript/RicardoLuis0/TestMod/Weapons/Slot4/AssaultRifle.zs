class HeavyClipCasing : CasingBase {
	Default {
		Scale 0.10;
	}
	States {
	Spawn:
		CAS3 AB 3;
	Bounce:
	Stay:
		CAS3 C 1 {
			A_SetScale(0.15);
		}
		Loop;
	}
}

class AssaultRifleLoaded : Ammo {
	Default{
		Inventory.MaxAmount 21;
		+Inventory.IgnoreSkill;
		Inventory.Icon "MGUNA0";
	}
}

class PiercingPuff : ModBulletPuffBase {
	Default {
		DamageType "Piercing";
	}
}

class AssaultRifle : ModWeaponBase {
	bool loaded;
	int firemode;//0=single,1=auto
	Default{
		Tag "Assault Rifle";
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 0.75;
		Weapon.AmmoType1 "AssaultRifleLoaded";
		Weapon.AmmoType2 "HeavyClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive2 20;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Assault Rifle!";
		
		ModWeaponBase.PickupHandleMagazine true;
	}
	override void BeginPlay(){
		super.BeginPlay();
		firemode=1;
		crosshair=20;
		loaded=true;
	}
	States{
		ready:
			ASRG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			ASRG A 1 A_Raise;
			loop;
		deselect:
			ASRG A 1 A_Lower;
			loop;
		fire:
			ASRG A 0 {
				if(invoker.firemode==0){
					return ResolveState("firesingle");
				}
				return ResolveState(null);
			}
			ASRG A 0 A_FireGun;
			ASRF A 1 BRIGHT;
			ASRF A 1 BRIGHT A_WeaponOffset(0,35);
			ASRG A 1 A_WeaponOffset(0,37, WOF_INTERPOLATE);
			ASRG A 1 A_WeaponOffset(0,32, WOF_INTERPOLATE);
			ASRG A 1 A_ReFire;
			goto ready;
		firesingle:
			ASRG A 0 A_FireGun(true);
			ASRF A 1 BRIGHT;
			ASRF A 1 BRIGHT A_WeaponOffset(0,35);
			ASRG A 1 A_WeaponOffset(0,37, WOF_INTERPOLATE);
			ASRG A 1 A_WeaponOffset(0,32, WOF_INTERPOLATE);
			goto ready;
		flash:
			TNT1 A 1 A_Light1;
			goto lightdone;
		reload:
			ASRG A 0 A_PreReloadGun;
			
			ASRR ABCDEF 1;
			
			ASRR G 4 A_StartSound("weapons/click01",CHAN_AUTO);
			ASRR HIJK 2;
			ASRR L 2 A_StartSound("weapons/rifle_reload",CHAN_AUTO);
			ASRR L 0 A_ReloadGun;
			ASRR MNOPQRS 1;
			ASRG A 0 A_PostReloadGun;
			goto ready;
		bolt:
			ASRK A 2;
			ASRK B 2;
			ASRK C 5;
			ASRK D 20 A_StartSound("weapons/rifle_bolt",CHAN_AUTO);
			ASRK C 10;
			ASRK B 5;
			ASRK A 0{
				invoker.loaded=true;
			}
			
			ASRG A 0 P_Return;
			goto ready;
		noammo:
			ASRG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			goto ready;
		spawn:
			MGUN A -1;
			stop;
		altfire:
			ASRG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
			ASRG A 0{
				A_StartSound("weapons/click02",CHAN_AUTO);
				if(invoker.firemode==0){
					A_Print("Full Auto");
					invoker.firemode=1;
					invoker.crosshair=20;
				}else if(invoker.firemode==1){
					A_Print("Single Shot");
					invoker.firemode=0;
					invoker.crosshair=43;
				}
			}
			ASRG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		altloop:
			ASRG A 1;
			ASRG A 0 A_ReFire("altloop");
			Goto Ready;
	}
	
	action State A_FireGun(bool precise=false){
		if(invoker.ammo1.amount==0){
			if(invoker.ammo2.amount==0){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		if(!invoker.loaded){
			return P_CallJmp("bolt","ready");
		}
		A_GunFlash();
		Actor c=W_FireProjectile("HeavyClipCasing",random[TestModWeapon](-80, -100),false,2,4-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		double sx,sy;
		if(precise){
			[sx,sy]=W_CalcSpreadXY(0,5,0.0);
		}else{
			[sx,sy]=W_CalcSpreadXY(0,15);
		}
		
		W_FireTracer((sx,sy),12,puff:"PiercingPuff",flags:FBF_USEAMMO|FBF_EXPLICITANGLE,drawTracer:sv_heavy_bullet_tracers);
		A_Recoil(0.5);
		A_AlertMonsters();
		A_StartSound("weapons/ar_fire",CHAN_AUTO);
		A_SetPitch(pitch+frandom[TestModWeapon](-2,0),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom[TestModWeapon](-2,1.5),SPF_INTERPOLATE);
		return ResolveState(null);
	}
	action State A_PreReloadGun(){
		if(invoker.ammo1.amount == invoker.ammo1.maxamount || invoker.ammo2.amount == 0) {
			return ResolveState("Ready");
		}
		return ResolveState(null);
	}
	
	action void A_ReloadGun(){
		A_ClearReFire();
		invoker.loaded=invoker.ammo1.amount > 0;
		A_ReloadAmmoMagazineDefaults();
	}
	
	action State A_PostReloadGun(){
		if(!invoker.loaded){
			return P_CallJmp("bolt","ready");
		}
		return ResolveState("ready");
	}
}