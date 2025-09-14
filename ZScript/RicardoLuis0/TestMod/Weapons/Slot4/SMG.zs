class FastLightClipCasing : LightClipCasing {
	Default {
		Speed 4;
	}
}

class SMGLoaded : Ammo{
	Default {
		Inventory.MaxAmount 30;
		+Inventory.IgnoreSkill;
		Inventory.Icon "RIFLA0";
	}
}

class SMG : ModWeaponBase
{
	Default
	{
		Tag "SMG";
		Weapon.SlotNumber 4;
		Weapon.SlotPriority 1;
		Weapon.AmmoType1 "SMGLoaded";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 0;
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 20;
		Obituary "%o was shot down by %k's SMG.";
		Inventory.Pickupmessage "You got the SMG!";
		+WEAPON.NOAUTOAIM;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
		+WEAPON.AMMO_OPTIONAL;
		
		ModWeaponBase.PickupHandleMagazine true;
		
	}
	
	bool mag;
	bool bolt;
	
	override void BeginPlay()
	{
		super.BeginPlay();
		crosshair=20;
		mag = true;
		bolt = true;
	}
	
	SpriteID changeLetter(String letter)
	{
		String letter2 = (bolt && mag) ? "F" : (!bolt && mag) ? "G" : (bolt && !mag) ? "H" : "I";
		
		SpriteID spr = GetSpriteIndex("RI"..letter2..letter);
		return spr;
	}
	
	action void A_FixUpSprite(string letter)
	{
		player.GetPSprite(stateinfo.mPSPIndex).sprite = invoker.changeLetter(letter);
	}
	
	States {
		Spawn:
			RIFL A -1;
			Stop;
		Ready:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			Wait;
		Deselect:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_Lower();
			Wait;
		Select:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_Raise();
			Wait;
			/*
		AltFire:
			// state debug code
			"####" A 1
			{
				if(invoker.bolt && invoker.mag)
				{
					invoker.bolt = false;
				}
				else if(!invoker.bolt && invoker.mag)
				{
					invoker.bolt = true;
					invoker.mag = false;
				}
				else if(invoker.bolt && !invoker.mag)
				{
					invoker.bolt = false;
				}
				else if(!invoker.bolt && !invoker.mag)
				{
					invoker.bolt = true;
					invoker.mag = true;
				}
				console.printf("bolt = "..(invoker.bolt?"true":"false").." mag = "..(invoker.mag?"true":"false"));
			}
			Goto Ready;
			*/
		FireCheck:
			"####" A 0 CheckFire("Fire");
			Goto Ready;
		FireLoop:
			"####" A 0 {
				if(invoker.ammo1.amount==0)
				{
					if(sv_automatic_reload)
					{
						return ResolveState("FireDoneReload");
					}
					else
					{
						return ResolveState("FireDone");
					}
				}
				else
				{
					return ResolveState(null);
				}
			}
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto FireShared;
		Fire:
			 RIFF  A 0 A_FixUpSprite("F");
			"####" A 0
			{
				if(invoker.ammo1.amount == 0 && invoker.ammo2.amount > 0 && sv_automatic_reload)
				{
					return ResolveState("Reload");
				}
				else if(invoker.ammo1.amount==0)
				{
					return ResolveState("NoAmmo");
				}
				else
				{
					if(invoker.bolt)
					{
						return ResolveState(null);
					}
					else
					{
						return P_CallJmp("ChargeWithMag", "FireCheck");
					}
					/*
					//TODO charge bolt anim
					invoker.bolt = true;
					return ResolveState(null);
					*/
				}
			}
		FireShared:
			"####" A 1;
			"####" B 1 BRIGHT 
			{
				A_FireGun();
				A_WeaponOffset(0,36,WOF_INTERPOLATE);
			}
			//"####" B 1 BRIGHT A_WeaponOffset(0,34,WOF_INTERPOLATE);
			"####" A 0 A_Refire("FireLoop");
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1;
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		FireDoneReload:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Reload;
		FireDone:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		NoAmmo:
			 RIFG  A 0 
			{
				if(invoker.bolt)
				{
					A_StartSound("weapons/click01",CHAN_AUTO);
					A_StartSound("weapons/click02",CHAN_AUTO);
				}
				invoker.bolt = false;
				A_FixUpSprite("G");
			}
			"####" A 1 A_StartSound("weapons/sshoto",CHAN_AUTO);
			Goto Ready;
		FullAmmo:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1;
			Goto Ready;
		Reload:
			 RIFG  A 0 A_PreReloadGun;
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_WeaponOffset(-5,45,WOF_INTERPOLATE);
			"####" A 3 A_WeaponOffset(-8,70,WOF_INTERPOLATE);
			"####" A 0 A_StartSound("weapons/click01",CHAN_AUTO);
			"####" A 5 A_WeaponOffset(-5,70,WOF_INTERPOLATE);
			"####" A 3 A_WeaponOffset(0,70,WOF_INTERPOLATE);
		DoReload:
			 RIFR  A 0 {
				invoker.mag = true;
			 }
			 RIFR  A 0 A_FixUpSprite("R");
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			"####" BCDEF 1;
			"####" GGGGGGGG 1;
			"####" HIKL 1;
			"####" A 0 A_StartSound("weapons/rifle_reload",CHAN_AUTO);
			"####" MMM 1;
			"####" A 0 A_ReloadAmmoMagazineDefaults;
			"####" NOP 1;
			"####" A 0
			{
				if(!invoker.bolt && sv_automatic_bolt)
				{
					return P_CallJmp("ChargeMid", "ready");
				}
				return ResolveState(null);
			}
			"####" QRST 1;
			Goto Ready;
		Charge:
			 RIFR  A 0 A_FixUpSprite("R");
			"####" ABCDE 1;
			Goto ChargeMid;
		ChargeWithMag:
			 RIFR  A 0 A_FixUpSprite("R");
			"####" TSRQP 1;
			Goto ChargeMid;
		ChargeMid:
			 RIFC  A 0 A_FixUpSprite("C");
			"####" ABCD 2;
			 RIFC  A 0
			 {
				invoker.bolt = true;
				A_StartSound("weapons/rifle_bolt",CHAN_AUTO);
				A_FixUpSprite("C");
			 }
			"####" E 4;
			"####" F 2;
			"####" F 8 A_WeaponOffset(4,36,WOF_INTERPOLATE);
			"####" F 4;
			"####" F 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			"####" G 2;
			"####" A 0
			{
				if(!invoker.mag)
				{
					return ResolveState("ChargeNoMag");
				}
				return ResolveState(null);
			}
			 RIFR  A 0 A_FixUpSprite("R");
			"####" PQRST 1;
			 RIFC  A 0 P_Return;
		ChargeNoMag:
			 RIFR  A 0 A_FixUpSprite("R");
			"####" EDCBA 1;
		 RIFC  A 0 P_Return;
			//TODO
		Unload:
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 1 A_WeaponOffset(-5,45,WOF_INTERPOLATE);
			"####" A 3 A_WeaponOffset(-8,70,WOF_INTERPOLATE);
			"####" A 0 A_StartSound("weapons/click01",CHAN_AUTO);
			"####" A 0 { invoker.mag = false; }
			 RIFG  A 0 A_FixUpSprite("G");
			"####" A 0
			{
				if(invoker.ammo1.amount <= 0)
				{
					//invoker.TossActor('EmptySMGClip');
				}
				else
				{
					invoker.UnloadAmmo();
				}
			}
			"####" A 5 A_WeaponOffset(-5,70,WOF_INTERPOLATE);
			"####" A 3 A_WeaponOffset(0,70,WOF_INTERPOLATE);
			"####" A 0 P_Return();
		UnloadDone:
			"####" A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			Goto Ready;
		NoMag:
			RIFC ABCDEFG 0;
			RIGC ABCDEFG 0;
			RIHC ABCDEFG 0;
			RIIC ABCDEFG 0;
			
			RIGG A 0;
			RIGR ABCDEFGHIKLMNOPQRST 0;
			RIGF AB 0;
		NoBolt:
			RIHG A 0;
			RIHR ABCDEFGHIKLMNOPQRST 0;
			RIHF AB 0;
		NoMagNoBolt:
			RIIG A 0;
			RIIR ABCDEFGHIKLMNOPQRST 0;
			RIIF AB 0;
	}
	action void A_FireGun(){
		A_AlertMonsters();
		A_StartSound("weapons/pistol_fire",CHAN_AUTO,CHANF_DEFAULT,0.35);
		Actor c=W_FireProjectile("FastLightClipCasing",random[TestModWeapon](-80, -100),false,2,6-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		
		W_FireTracerSpreadXY(4,0.25,8,0.25,0.75,drawTracer:sv_light_bullet_tracers);
		A_Recoil(0.25);
	}
	
	action State A_PreReloadGun()
	{
		if(invoker.ammo1.amount == invoker.ammo1.maxamount || invoker.ammo2.amount == 0){
			return ResolveState("Ready");
		}
		if(!invoker.mag)
		{
			return ResolveState("DoReload");
		}
		return ResolveState(null);
	}
	
	override bool OnCycleKeyPressed()
	{
		//console.printf("cyclekey");
		if(!bolt && mag)
		{
			P_RemoteCallJmp(PSP_WEAPON, "ChargeWithMag", "Ready");
		}
		else if(!bolt && !mag)
		{
			P_RemoteCallJmp(PSP_WEAPON, "Charge", "Ready");
		}
		return true;
	}
	
	
	override bool OnUnloadKeyPressed()
	{
		if(mag)
		{
			P_RemoteCallJmp(PSP_WEAPON, "Unload", "UnloadDone");
			return true;
		}
		else
		{
			return false;
		}
	}
}
