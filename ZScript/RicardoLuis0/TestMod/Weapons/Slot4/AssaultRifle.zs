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

class HeavyClipCasingAmmo : HeavyClip
{
	mixin CasingBehavior;
	
	Default {
		Scale 0.10;
		Inventory.Amount 1;
	}
	
	States {
	Death:
		"####" "#" 100;
		Loop;
	Spawn:
		CAS4 C 0;
		CAS4 AB 3;
	Bounce:
	Stay:
		CAS4 C 1 {
			A_SetScale(0.15);
		}
		Loop;
	}
}


class AssaultRifleLoaded : Ammo
{
	Default
	{
		Inventory.MaxAmount 21;
		+Inventory.IgnoreSkill;
		Inventory.Icon "MGUNA0";
	}
}

class PiercingPuff : ModBulletPuffBase
{
	Default {
		DamageType "Piercing";
	}
}

class AssaultRifle : ModWeaponBase
{
	int firemode;//0=single,1=auto
	bool hasmagazine;
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
		ModWeaponBase.HasChamber true;
	}
	
	override void BeginPlay(){
		super.BeginPlay();
		firemode=1;
		crosshair=20;
		magazineWeaponChamberLoaded=true;
	}
	
	override void ReadyTick()
	{
		if(ammo1.amount == 21)
		{
			magazineWeaponChamberLoaded = true;
		}
		if(ammo1.amount > magazineWeaponChamberLoaded)
		{
			hasmagazine = true;
		}
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
		fireloop:
			ASRG A 1 A_WeaponOffset(0,37, WOF_INTERPOLATE);
			ASRG A 1 A_WeaponOffset(0,32, WOF_INTERPOLATE);
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
			ASRG A 0 A_ReFire("fireloop");
			ASRG A 1 A_WeaponOffset(0,37, WOF_INTERPOLATE);
			ASRG A 1 A_WeaponOffset(0,32, WOF_INTERPOLATE);
			goto ready;
		firesingle:
			ASRG A 0 A_FireGun(true);
			ASRF A 1 BRIGHT;
			ASRF A 1 BRIGHT A_WeaponOffset(0,35);
			ASRG A 1 A_WeaponOffset(0,37, WOF_INTERPOLATE);
			ASRG A 1 A_WeaponOffset(0,32, WOF_INTERPOLATE);
			goto ready;
		unloadreload:
			ASRR ABC 3;
			ASRR T 4;
			ASRR L 12;
			ASRR K 2 {
				A_StartSound("weapons/click01",CHAN_AUTO);
			}
			ASRR JIH 2;
			ASRR G 6
			{
				if(sv_drop_magazine_reload && invoker.ammo1.amount > invoker.magazineWeaponChamberLoaded)
				{
					invoker.UnloadAmmo(false);
				}
				else
				{
					invoker.DropActor('EmptyHeavyClip');
				}
			}
			goto reloadmid;
		reload:
			ASRG A 0 A_PreReloadGun;
			ASRG A 0
			{
				if(invoker.hasmagazine)
				{
					return ResolveState("unloadreload");
				}
				invoker.hasmagazine = true;
				return ResolveState(null);
			}
			
			ASRR ABCDEFG 1;
			goto reloadmid;
		reloadmid:
			ASRR HIJK 2;
			ASRR L 2 A_StartSound("weapons/rifle_reload",CHAN_AUTO);
			ASRR L 0 A_ReloadGun;
			ASRR MNOPQ 1;
			ASRR Q 0 A_PostReloadGun;
			ASRR RS 1;
			goto ready;
		bolt:
			ASRK A 1;
		bolt2:
			ASRK B 2;
			ASRK C 5;
			ASRK D 20
			{
				A_StartSound("weapons/rifle_bolt",CHAN_AUTO);
				
				if(ChamberLoaded())
				{
					A_UnloadChamber();
					if(invoker.ammo1.amount > 0)
					{
						invoker.ammo1.amount--;
						A_FireCasing("HeavyClipCasingAmmo");
					}
				}
			}
			ASRK C 10;
			ASRK B 5;
			ASRK A 0
			{
				if(invoker.ammo1.amount > 0)
				{
					A_LoadChamber();
				}
			}
			
			ASRG A 0 P_Return;
			Goto Ready;
		noammo:
			ASRG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			Goto Ready;
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
		unload:
			ASRR ABC 3;
			ASRR T 4;
			ASRR L 12;
			ASRR K 2 {
				A_StartSound("weapons/click01",CHAN_AUTO);
			}
			ASRR JIH 2;
			ASRR G 2
			{
				if(invoker.ammo1.amount <= 0)
				{
					invoker.TossActor('EmptyHeavyClip');
				}
				else
				{
					invoker.UnloadAmmo();
				}
				invoker.hasmagazine = false;
			}
			ASRR UVQRS 3;
			ASRG A 0 P_Return;
			Goto Ready;
			
	}
	
	action State A_FireGun(bool precise=false){
		if(invoker.ammo1.amount==0)
		{
			if(invoker.ammo2.amount == 0 || !sv_automatic_reload)
			{
				return ResolveState("noammo");
			}
			else
			{
				return ResolveState("reload");
			}
		}
		
		if(!ChamberLoaded())
		{
			return P_CallJmp("bolt2","ready");
		}
		
		A_GunFlash();
		A_FireCasing("HeavyClipCasing");
		
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
		A_CheckChamber();
		return ResolveState(null);
	}
	
	action void A_FireCasing(class<Actor> casingActor)
	{
		Actor c=W_FireProjectile(casingActor,random[TestModWeapon](-80, -100),false,2,4-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
	}
	
	action State A_PreReloadGun()
	{
		if(invoker.ammo1.amount == invoker.ammo1.maxamount || invoker.ammo2.amount == 0) {
			return ResolveState("Ready");
		}
		if(invoker.ammo1.amount >= (invoker.ammo1.maxamount - 1) && !ChamberLoaded())
		{
			return P_CallJmp("bolt2","ready");
		}
		
		return ResolveState(null);
	}
	
	action void A_ReloadGun()
	{
		A_ClearReFire();
		A_ReloadAmmoMagazineDefaults();
	}
	
	action State A_PostReloadGun()
	{
		if(!ChamberLoaded() && (sv_automatic_bolt || (player.cmd.buttons & BT_RELOAD))){
			return P_CallJmp("bolt","ready");
		}
		return ResolveState(null);
	}
	
	override bool OnCycleKeyPressed()
	{
		P_RemoteCallJmp(PSP_WEAPON, "bolt2","ready");
		return true;
	}
	
	override bool OnUnloadKeyPressed()
	{
		if(ChamberLoaded() && ammo1.amount==1)
		{
			P_RemoteCallJmp(PSP_WEAPON, "bolt2","ready");
			return true;
		}
		else if(ammo1.amount > 0 || hasmagazine)
		{
			P_RemoteCallJmp(PSP_WEAPON, "unload","ready");
			return true;
		}
		else
		{
			return 0;
		}
	}
}