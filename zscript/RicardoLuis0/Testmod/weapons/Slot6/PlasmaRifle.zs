class MyPlasmaRifle : MyWeapon {
	const LAYER = 9999;
	int heat;
	int heatmax;
	int heatup;
	int heatdown;
	int heatdownreload;
	int heatdownoverheat;
	bool firing;
	bool overheat;
	bool reloading;
	bool init;
	int altloop;
	int altuse;
	int firemode;
	int firemodemax;
	State fireState;

	Default{
		Weapon.SlotNumber 6;
		Weapon.AmmoType1 "Cell";
		Weapon.AmmoType2 "Cell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 75;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Plasma Rifle!";
		Decal "PlasmaScorchLower";
	}

	States{
	NoAmmo:
		DPGG A 0 {
			invoker.init=false;
			W_SetLayerFrame(LAYER,0);
		}
		TNT1 A 0 A_Bob();
		DPGG A 10 W_SetLayerSprite(LAYER,"PNAAA");
		DPGG A 0 {
			invoker.init=true;
		}
	Ready:
		DPGG A 0 {
			W_SetLayerSprite(LAYER,"PHNA");
		}
	ReadyLoop:
		DPGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		DPGG A 1 A_Lower();
		Loop;
	Select:
		DPGG A 0 {
			A_UpdateBob();
			A_Overlay(LAYER,"WeaponOverlay");
			invoker.init=true;
		}
	SelectLoop:
		DPGG A 1 A_Raise();
		Wait;
	AltFire:
		DPGG A 0 {
			if(!CVar.FindCVar("plasmagun_extrafire").getInt()){
				if(invoker.firemode!=0){
					invoker.firemode=0;
					updateFire(false);
				}
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		DPGG A 0 A_Bob();
		DPGG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
		DPGG A 0{
			A_PlaySound("weapons/click02");
			if(invoker.firemode<invoker.firemodemax){
				invoker.firemode++;
			}else{
				invoker.firemode=0;
			}
			updateFire();
		}
		DPGG A 0 A_Bob();
		DPGG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
	ResetFire:
		TNT1 A 0 {
			invoker.firemode=0;
			updateFire(false);
		}
	Fire:
		DPGG A 0 {
			if(invoker.firemode!=0&&!CVar.FindCVar("plasmagun_extrafire").getInt())return ResolveState("ResetFire");
			return invoker.fireState;
		}
		Goto Ready;
	ShotgunFire:
		DPGG A 0 A_Bob();
		DPGG A 2 A_FirePShotgun();
		DPGG B 0 A_Bob();
		DPGG B 3 W_SetLayerSprite(LAYER,"PHNB");
		DPGG A 0 A_Bob();
		DPGG A 6 W_SetLayerSprite(LAYER,"PHNA");
		DPGG A 3 A_Refire("ShotgunFire");
		DPGG A 0 A_FireEnd();
		Goto Ready;
	SFlash1:
		DPGF A 2 Bright A_Light(2);
		DPGF B 3 Bright A_Light(1);
		Goto LightDone;
	SFlash2:
		DPGF C 2 Bright A_Light(2);
		DPGF D 3 Bright A_Light(1);
		Goto LightDone;
	AutoFire:
		DPGG A 0 A_Bob();
		DPGG A 1 A_FireGun();
		DPGG B 0 A_Bob();
		DPGG B 1 W_SetLayerSprite(LAYER,"PHNB");
		DPGG A 0 A_Bob();
		DPGG A 1 W_SetLayerSprite(LAYER,"PHNA");
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
		DPGG A 0 A_Bob();
		DPGF C 5 Bright;
		Goto Ready;
	LauncherFire:
		DPGG A 0{
			if(invoker.heat!=0){
				return ResolveState("Reload");
			}else if(CountInv("Cell")<invoker.altuse){
				return ResolveState("NoAmmo");
			}
			return ResolveState(null);
		}
		TNT1 A 0 A_Bob();
		DPGF A 5 Bright;
		TNT1 A 0 A_Bob();
		DPGF C 5 Bright;
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		TNT1 A 0 A_Bob();
		DPGF A 5 Bright;
		TNT1 A 0 A_Bob();
		DPGF C 5 Bright;
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		TNT1 A 0 A_Bob();
		DPGF A 5 Bright;
		TNT1 A 0 A_Bob();
		DPGF C 5 Bright;
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		DPGF B 0 W_SetLayerSprite(LAYER,"PHNB");
	LauncherFireLoop1:
		TNT1 A 0 A_Bob();
		DPGF B 3 Bright;
		TNT1 A 0 A_Bob();
		DPGF D 3 Bright;
		DPGF D 0 {
			return CheckFire("LauncherFireLoop1","LauncherFireStop",null);
		}
		DPGF C 0 A_FirePLauncher;
		DPGG C 0 A_Bob();
		DPGG C 5 A_WeaponOffset(0,52,WOF_INTERPOLATE);
		DPGG C 0 {
			A_SetBlend("AliceBlue",.5,10);
			invoker.altloop=20;
		}
	LauncherFireLoop2:
		DPGG C 0 A_Bob();
		DPGG C 1 {
			A_WeaponOffset(0,32+invoker.altloop,WOF_INTERPOLATE);
			if(invoker.altloop==0){
				invoker.firing=false;
				return ResolveState("OverheatUp");
			}else{
				if(invoker.altloop==9){
					A_PlaySound("weapons/overheat",CHAN_AUTO);
				}
				invoker.altloop--;
			}
			return ResolveState(null);
		}
		Loop;
	RailFire:
		DPGF C 0 A_FirePRail;
		DPGG C 0 A_Bob();
		DPGG C 5 A_WeaponOffset(0,52,WOF_INTERPOLATE);
		DPGG C 0 {
			A_SetBlend("AliceBlue",.5,10);
			invoker.altloop=20;
		}
		//A_RailAttack
	RailFireLoop:
		DPGG C 0 A_Bob();
		DPGG C 1 {
			A_WeaponOffset(0,32+invoker.altloop,WOF_INTERPOLATE);
			if(invoker.altloop==0){
				invoker.firing=false;
				return ResolveState("OverheatUp");
			}else{
				if(invoker.altloop==9){
					A_PlaySound("weapons/overheat",CHAN_AUTO);
				}
				invoker.altloop--;
			}
			return ResolveState(null);
		}
		Loop;
	Reload:
		DPGG A 0{
			if(invoker.heat==0){
				return ResolveState("Ready");
			}else{
				return ResolveState(null);
			}
		}
		DPGG C 6 W_SetLayerSprite(LAYER,"PHNC");
		DPGG C 0 {
			invoker.reloading=true;
		}
	ReloadLoop:
		DPGG D 4{
			W_SetLayerSprite(LAYER,"PHND");
			return A_ReloadEnd();
		}
		Loop;
	ReloadStop:
		DPGG C 6 W_SetLayerSprite(LAYER,"PHNC");
		Goto Ready;
	Spawn:
		DEPG A -1;
		Loop;
	OverheatStart:
		DPGG A 0 A_PlaySound("weapons/overheat",CHAN_AUTO);
		DPGG A 0 A_Bob();
		DPGG A 3 W_SetLayerSprite(LAYER,"PHOA");
		DPGG C 6 W_SetLayerSprite(LAYER,"PHOC");
	OverheatUp:
		DPGG C 0{
			invoker.reloading=true;
		}
	OverheatLoop:
		DPGG D 4 {
			W_SetLayerSprite(LAYER,"PHOD");
			return A_OverheatEnd();
		}
		Loop;
	OverheatStop:
		DPGG C 6 W_SetLayerSprite(LAYER,"PHOC");
		DPGG A 0 A_Bob();
		DPGG A 3 W_SetLayerSprite(LAYER,"PHOA");
		goto Ready;
	WeaponOverlay:
		PHNA A -1 Bright;
		Stop;
		PHNB A 1 Bright;
		PHNC A 1 Bright;
		PHND A 1 Bright;
		PHOA A 1 Bright;
		PHOB A 1 Bright;
		PHOC A 1 Bright;
		PHOD A 1 Bright;
		PNAA A 1 Bright;
	}

	override void BeginPlay(){
		super.BeginPlay();
		firemode=0;
		firemodemax=3;
		fireState=ResolveState("AutoFire");
		crosshair=20;
		heat=0;
		heatmax=500;
		heatup=10;
		heatdownreload=20;
		heatdownoverheat=20;
		heatdown=1;
		altuse=10;
		firing=false;
		overheat=false;
		reloading=false;
		init=false;
	}

	action void updateFire(bool showmessage=true){
		switch(invoker.firemode){
		default:
			invoker.firemode=0;
		case 0://automatic mode
			if(showmessage)A_Print("Automatic Mode");
			invoker.heatdownoverheat=20;
			invoker.heatup=10;
			invoker.fireState=ResolveState("AutoFire");
			invoker.ammouse1=1;
			break;
		case 1://shotgun mode
			if(showmessage)A_Print("Shotgun Mode");
			invoker.heatdownoverheat=20;
			invoker.heatup=50;
			invoker.fireState=ResolveState("ShotgunFire");
			invoker.ammouse1=5;
			break;
		case 2://launcher mode
			if(showmessage)A_Print("Launcher Mode");
			invoker.heatup=invoker.heatmax;
			invoker.heatdownoverheat=10;
			invoker.fireState=ResolveState("LauncherFire");
			invoker.ammouse1=15;
			break;
		case 3://railgun mode
			if(showmessage)A_Print("Railgun Mode");
			invoker.heatup=invoker.heatmax;
			invoker.heatdownoverheat=30;
			invoker.fireState=ResolveState("RailFire");
			invoker.ammouse1=20;
		}
	}

	override void ReadyTick(){
		if(!firing&&heat>0)HeatMinus();
		if(init)HeatOverlay();
	}

	action void A_Overheat(){
		invoker.overheat=true;
		invoker.heat=invoker.heatmax;
	}

	void HeatPlus(){
		heat+=heatup;
		if(heat>=heatmax){
			heat=heatmax;
			overheat=true;
		}
	}

	void HeatMinus(){
		heat-=reloading?(overheat?heatdownoverheat:heatdownreload):heatdown;
		if(heat<=0){
			heat=0;
			overheat=false;
		}
	}

	void HeatOverlay(){
		int overheatamt=7-int(ceil((double(heat)/heatmax)*7));
		SetLayerFrame(LAYER,overheatamt);
	}

	action State A_FireGun(){
		if(invoker.overheat){
			invoker.firing=false;
			return ResolveState("OverheatStart");
		}else if(CountInv("Cell")==0){
			invoker.firing=false;
			return ResolveState("NoAmmo");
		}
		invoker.firing=true;
		invoker.HeatPlus();
		A_AlertMonsters();
		A_FireProjectile("PlasmaShot01",frandom(-1,1),pitch:frandom(-1,1));
		A_Recoil(1);
		if(random(0,1)) {
			A_GunFlash("Flash1");
		} else {
			A_GunFlash("Flash2");
		}
		return ResolveState(null);
	}

	action State A_FirePShotgun(){
		if(invoker.overheat){
			invoker.firing=false;
			return ResolveState("OverheatStart");
		}else if(CountInv("Cell")<5){
			invoker.firing=false;
			return ResolveState("NoAmmo");
		}
		invoker.firing=true;
		invoker.HeatPlus();
		A_AlertMonsters();
		A_FireProjectile("PlasmaShot01",frandom(-3,3),true,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_FireProjectile("PlasmaShot01Silent",frandom(-3,3),false,pitch:frandom(-3,3));
		A_Recoil(5);
		if(random(0,1)) {
			A_GunFlash("Flash1");
		} else {
			A_GunFlash("Flash2");
		}
		return ResolveState(null);
	}

	action void A_FirePLauncher(){
		A_SetBlend("LightSlateBlue",1,5);
		invoker.firing=true;
		A_AlertMonsters();
		//TakeInventory("Cell",invoker.altuse);
		A_FireProjectile("SuperPlasmaBall",0);
		A_SetPitch(pitch+random(-10,0));
		A_Recoil(10);
		A_Overheat();
		W_SetLayerSprite(LAYER,"PHOC");
	}

	action void A_FirePRail(){
		A_SetBlend("LightSlateBlue",1,5);
		invoker.firing=true;
		A_AlertMonsters();
		A_RailAttack(100,0,true,"Cyan","Blue",RGF_FULLBRIGHT,0,"",0,0,0,0,1,0,"PlasmaRailTrail");
		A_SetPitch(pitch+random(-10,0));
		A_Recoil(10);
		A_Overheat();
		W_SetLayerSprite(LAYER,"PHOC");
	}

	action State A_FireEnd(){
		invoker.firing=false;
		if(invoker.overheat){
			return ResolveState("OverheatStart");
		}else{
			if(CVar.GetCVar("plasma_rifle_classic_mode",player).getInt()!=0){
				return ResolveState("Reload");
			}
			return ResolveState("Ready");
		}
	}

	action State A_ReloadEnd(){
		if(invoker.heat==0){
			invoker.reloading=false;
			return ResolveState("ReloadStop");
		}
		return ResolveState(null);
	}

	action State A_OverheatEnd(){
		if(!invoker.overheat){
			invoker.reloading=false;
			return ResolveState("OverheatStop");
		}
		return ResolveState(null);
	}

}