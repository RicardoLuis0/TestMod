class MyPlasmaRifle : ModWeaponBase
{
	const PSP_DISPLAY = 9999;
	int heat;
	int heatmax;
	int heatmaxmax;
	int heatextra;
	int heatup;
	int heatdown;
	int heatdownreload;
	int heatdownoverheat;
	
	bool firing;
	bool overheat;
	bool reloading;
	bool init;
	bool noammo;
	
	int altloop;
	int firemode;
	int firemodemax;
	
	State fireState;

	Default
	{
		Tag "Plasma Rifle";
		Weapon.SlotNumber 6;
		Weapon.AmmoType1 "NewCell";
		Weapon.AmmoType2 "NewCell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 75;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Plasma Rifle!";
		Decal "PlasmaScorchLower";
		
		ModWeaponBase.PickupHandleNoMagazine true;
	}

	States
	{
	NoAmmo:
		DPGG A 10;
	Ready:
		TNT1 A 0 W_SetLayerSprite(PSP_DISPLAY,(invoker.firemode == 0 && invoker.heat > invoker.heatmax) ? "PHEA" : "PHNA");
		DPGG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		DPGG A 1 A_Lower();
		Loop;
	DeadLowered:
		DPGG A 0 A_ClearOverlays(PSP_DISPLAY,PSP_DISPLAY);
		Stop;
	Select:
		DPGG A 0
		{
			A_Overlay(PSP_DISPLAY,"WeaponOverlay");
			invoker.init=true;
			invoker.noammo=false;
		}
	SelectLoop:
		DPGG A 1 A_Raise();
		Wait;
	AltFire:
		DPGG A 0
		{
			if(!sv_plasmagun_extrafire)
			{
				if(invoker.firemode!=0)
				{
					invoker.firemode=0;
					updateFire(false);
				}
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		DPGG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
		DPGG A 0
		{
			A_StartSound("weapons/click02",CHAN_AUTO);
			if(invoker.firemode<invoker.firemodemax)
			{
				invoker.firemode++;
			}
			else
			{
				invoker.firemode=0;
			}
			updateFire();
		}
		DPGG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
	altloop:
		DPGG A 1;
		DPGG A 0 A_ReFire("altloop");
		Goto Ready;
	ResetFire:
		TNT1 A 0
		{
			invoker.firemode=0;
			updateFire(false);
		}
	Fire:
		DPGG A 0
		{
			if(CountInv("NewCell")<invoker.ammouse1){
				return ResolveState("NoAmmo");
			}else if(invoker.firemode!=0&&!sv_plasmagun_extrafire)return ResolveState("ResetFire");
			return invoker.fireState;
		}
		Goto Ready;
	AutoFire:
		DPGG A 1 A_FireGun();
		DPGG B 1 W_SetLayerSprite(PSP_DISPLAY,invoker.heat > invoker.heatmax ? "PHEB" : "PHNB");
		DPGG A 1 W_SetLayerSprite(PSP_DISPLAY,invoker.heat > invoker.heatmax ? "PHEA" : "PHNA");
		DPGG A 1 A_SetTics(CalcAutoFireTics());
		DPGG A 3 A_Refire("AutoFire");
		DPGG A 0 A_FireEnd();
		Goto Ready;
	Flash1:
		DPGF A 1 Bright A_Light(2);
		DPGF B 1 Bright A_Light(1);
		Goto LightDone;
	Flash2:
		DPGF C 1 Bright A_Light(2);
		DPGF D 1 Bright A_Light(1);
		Goto LightDone;
	LauncherFireStop:
		DPGF C 5 Bright;
		Goto Ready;
	LauncherFire:
		DPGG A 0
		{
			if(invoker.heat!=0)
			{
				return ResolveState("Reload");
			}
			return ResolveState(null);
		}
		DPGF A 3 Bright;
		DPGF C 3 Bright;
		DPGF A 3 Bright;
		DPGF C 3 Bright;
		DPGF A 3 Bright;
		DPGF C 3 Bright;
		DPGF C 0
		{
			return CheckFire(null,"LauncherFireStop","LauncherFireStop");
		}
		DPGF B 0 W_SetLayerSprite(PSP_DISPLAY,"PHNB");
	LauncherFireLoop1:
		DPGF B 3 Bright;
		DPGF D 3 Bright;
		DPGF D 0 {
			return CheckFire("LauncherFireLoop1","LauncherFireStop",null);
		}
		DPGF C 0 A_FirePLauncher;
		DPGG C 5 A_WeaponOffset(0,52,WOF_INTERPOLATE);
		DPGG C 0
		{
			A_SetBlend("AliceBlue",.5,10);
			invoker.altloop=20;
		}
	LauncherFireLoop2:
		DPGG C 1
		{
			A_WeaponOffset(0,32+invoker.altloop,WOF_INTERPOLATE);
			if(invoker.altloop==0)
			{
				invoker.firing=false;
				return ResolveState("OverheatUp");
			}
			else
			{
				if(invoker.altloop==9)
				{
					A_StartSound("weapons/overheat",CHAN_AUTO);
				}
				invoker.altloop--;
			}
			return ResolveState(null);
		}
		Loop;
	Reload:
		DPGG A 0
		{
			if(invoker.heat==0) return ResolveState("Ready");
			
			if(invoker.heat > invoker.heatmax)
			{
				invoker.heat = invoker.heatmax;
			}
			
			return ResolveState(null);
		}
		DPGG C 6 W_SetLayerSprite(PSP_DISPLAY,"PHNC");
		DPGG C 0
		{
			invoker.reloading = true;
		}
	ReloadLoop:
		DPGG D 4{
			W_SetLayerSprite(PSP_DISPLAY,"PHND");
			return A_ReloadEnd();
		}
		Loop;
	ReloadStop:
		DPGG C 6 W_SetLayerSprite(PSP_DISPLAY,"PHNC");
		DPGG A 0 W_SetLayerSprite(PSP_DISPLAY,"PHNAA");
		Goto Ready;
	Spawn:
		DEPG A -1;
		Loop;
	OverheatStart:
		DPGG A 0 A_StartSound("weapons/overheat",CHAN_AUTO);
		DPGG A 3 W_SetLayerSprite(PSP_DISPLAY,"PHOA");
		DPGG C 6 W_SetLayerSprite(PSP_DISPLAY,"PHOC");
	OverheatUp:
		DPGG C 0
		{
			invoker.reloading=true;
		}
	OverheatLoop:
		DPGG D 4
		{
			W_SetLayerSprite(PSP_DISPLAY,"PHOD");
			return A_OverheatEnd();
		}
		Loop;
	OverheatStop:
		DPGG C 6 W_SetLayerSprite(PSP_DISPLAY,"PHOC");
		DPGG A 5 W_SetLayerSprite(PSP_DISPLAY,"PHOA");
		DPGG A 0 W_SetLayerSprite(PSP_DISPLAY,"PHNAA");
		goto Ready;
	WeaponOverlay:
		PHNA A -1 Bright;
		Stop;
		PHNB A 1 Bright;
		PHNC A 1 Bright;
		PHND A 1 Bright;
		
		PHEA A 1 Bright;
		PHEB A 1 Bright;
		
		PHOA A 1 Bright;
		PHOB A 1 Bright;
		PHOC A 1 Bright;
		PHOD A 1 Bright;
		PNAA A 1 Bright;
	}

	override void BeginPlay()
	{
		super.BeginPlay();
		firemode = 0;
		firemodemax = 1;
		heat = 0;
		heatdown = 5;
		heatmax = 400;
		heatextra = 200;
		updateFire(false);
		firing = false;
		overheat = false;
		reloading = false;
		init = false;
		noammo = false;
	}
	
	action void updateFire(bool showmessage = true)
	{
		switch(invoker.firemode)
		{
		default:
			invoker.firemode=0;
		case 0://automatic mode
			if(showmessage) A_Print("Automatic Mode");
			invoker.heatdownoverheat = 8;
			invoker.heatdownreload = 30;
			invoker.heatup = 10;
			invoker.heatmaxmax = invoker.heatmax + invoker.heatextra;
			invoker.fireState = ResolveState("AutoFire");
			invoker.ammouse1 = 1;
			invoker.crosshair = 20;
			break;
		case 1://launcher mode
			if(showmessage) A_Print("Launcher Mode");
			invoker.heatup = invoker.heatmax;
			invoker.heatmaxmax = invoker.heatmax;
			invoker.heatdownoverheat = 10;
			invoker.heatdownreload = 30;
			invoker.fireState = ResolveState("LauncherFire");
			invoker.ammouse1 = 15;
			invoker.crosshair = 21;
			break;
		}
	}

	override void ReadyTick()
	{
		if(init && owner.health > 0)
		{
			if(!firing && heat > 0) HeatMinus();
			HeatOverlay();
		}
	}

	action void A_Overheat()
	{
		invoker.overheat = true;
		invoker.heat = invoker.heatmax;
	}

	void HeatPlus()
	{
		heat += heatup;
		if(heat >= heatmaxmax)
		{
			heat = heatmax;
			overheat = true;
		}
	}

	void HeatMinus()
	{
		if(reloading || overheat)
		{
			heat -= overheat ? heatdownoverheat : heatdownreload;
		}
		else if(heat < (heatmax / 4))
		{
			heat -= max(heatdown / 4, 1);
		}
		else if(heat < (heatmax / 2))
		{
			heat -= max(heatdown / 3, 1);
		}
		else if(heat < (heatmax / 1.5))
		{
			heat -= max(heatdown / 2, 1);
		}
		else
		{
			heat -= heatdown;
		}
		if(heat <= 0)
		{
			heat = 0;
			overheat = false;
		}
	}

	void HeatOverlay()
	{
		if(owner.CountInv("NewCell") < ammouse1)
		{
			if(!noammo)
			{
				noammo = true;
			}
			if(GetLayerSprite(PSP_DISPLAY) == GetSpriteIndex("PHNAA"))
			{
				SetLayerFrame(PSP_DISPLAY, 0);
				SetLayerSprite(PSP_DISPLAY, "PNAAA");
			}
		}
		else
		{
			if(noammo)
			{
				noammo = false;
				SetLayerSprite(PSP_DISPLAY, "PHNAA");
			}
			
			if(overheat)
			{
				SetLayerFrame(PSP_DISPLAY, 7 - int(ceil(min(double(heat) / heatmax, 1) * 7)));
			}
			else if(!reloading && heat > heatmax)
			{
				SetLayerFrame(PSP_DISPLAY, 7 - int(ceil((min(double(heat - heatmax) / heatextra, 1) * 7))) );
			}
			else
			{
				SetLayerFrame(PSP_DISPLAY, heat > 0 ? 6 - int(floor((min(double(heat) / heatmax, 1) * 6) + 0.5)) : 7);
			}
		}
	}

	action State A_FireGun()
	{
		if(invoker.overheat)
		{
			invoker.firing=false;
			return ResolveState("OverheatStart");
		}
		else if(CountInv("NewCell")==0)
		{
			invoker.firing=false;
			return ResolveState("NoAmmo");
		}
		W_SetLayerSprite(PSP_DISPLAY,invoker.heat > invoker.heatmax ? "PHEA" : "PHNA");
		invoker.firing=true;
		invoker.HeatPlus();
		A_AlertMonsters();
		A_StartSound("weapons/plasma/fire",CHAN_AUTO);
		W_FireProjectile("PlasmaShot01",frandom[TestModWeapon](-1,1),pitch:frandom[TestModWeapon](-1,1));
		A_SetPitch(pitch+frandom[TestModWeapon](-1,0));
		A_Recoil(0.5);
		if(random[TestModWeapon](0,1))
		{
			A_GunFlash("Flash1");
		}
		else
		{
			A_GunFlash("Flash2");
		}
		return ResolveState(null);
	}

	action void A_FirePLauncher()
	{
		A_SetBlend("LightSlateBlue",1,5);
		invoker.firing=true;
		A_AlertMonsters();
		W_FireProjectile("SuperPlasmaBall",0);
		A_SetPitch(pitch+frandom[TestModWeapon](-10,-5));
		A_Recoil(10);
		A_Overheat();
		W_SetLayerSprite(PSP_DISPLAY,"PHOC");
	}

	action State A_FireEnd(){
		invoker.firing=false;
		if(invoker.overheat){
			return ResolveState("OverheatStart");
		}else{
			return ResolveState("Ready");
		}
	}

	action State A_ReloadEnd()
	{
		if(invoker.heat == 0)
		{
			invoker.reloading = false;
			return ResolveState("ReloadStop");
		}
		return ResolveState(null);
	}

	action State A_OverheatEnd()
	{
		if(!invoker.overheat)
		{
			invoker.reloading=false;
			return ResolveState("OverheatStop");
		}
		return ResolveState(null);
	}
	
	action int CalcAutoFireTics()
	{
		return (invoker.heat > invoker.heatmax) ? (invoker.heat > (invoker.heatmax + (invoker.heatextra / 2)) ? 0 : 1) : (int((1.0 - (invoker.heat / double(invoker.heatmax))) * 3) + 1);
	}
}