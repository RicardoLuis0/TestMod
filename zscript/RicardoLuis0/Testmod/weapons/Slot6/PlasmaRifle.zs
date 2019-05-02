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
		Weapon.AmmoUse2 10;
		Weapon.AmmoGive1 40;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Plasma Rifle!";
	}

	override void BeginPlay(){
		super.BeginPlay();
		firemode=0;
		firemodemax=1;
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

	void updateFire(){
		switch(firemode){
		case 0://automatic fire
			heatdownoverheat=20;
			heatup=10;
			fireState=ResolveState("AutoFire");
			ammouse1=1;
			break;
		case 1://plasma launcher
			heatup=heatmax;
			heatdownoverheat=10;
			fireState=ResolveState("LauncherFire");
			ammouse1=10;
			break;
		default:
			firemode=0;
			return updateFire();
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

	States{
	NoAmmo:
		DPGG A 0 {
			A_Bob();
			invoker.init=false;
			W_SetLayerFrame(LAYER,0);
		}
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
			A_Overlay(LAYER,"WeaponOverlay");
			invoker.init=true;
		}
		DPGG A 1 A_Raise();
		Wait;
	AltFire:
		DPGG A 0 A_Bob();
		DPGG A 4 A_WeaponOffset(5,40,WOF_INTERPOLATE);
		DPGG A 0{
			A_PlaySound("DSCLICKY");
			if(invoker.firemode<invoker.firemodemax){
				invoker.firemode++;
			}else{
				invoker.firemode=0;
			}
			invoker.updateFire();
		}
		DPGG A 0 A_Bob();
		DPGG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		Goto Ready;
	Fire:
		DPGG A 0 {
			return invoker.fireState;
		}
		Goto Ready;
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
	LauncherFireStop:
		DPGG A 0 A_Bob();
		DPGF C 5 Bright;
		Goto Ready;
	LauncherFire:
		DPGG A 0 A_Bob();
		DPGG A 0{
			if(invoker.heat!=0){
				return ResolveState("Reload");
			}else if(CountInv("Cell")<invoker.altuse){
				return ResolveState("NoAmmo");
			}
			return ResolveState(null);
		}
		DPGF AC 5 Bright A_Bob();
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		DPGF AC 5 Bright A_Bob();
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		DPGF AC 5 Bright A_Bob();
		DPGF C 0 {
			return CheckFire(null,"Ready");
		}
		DPGF B 0 W_SetLayerSprite(LAYER,"PHNB");
	LauncherFireLoop1:
		DPGF BD 3 Bright A_Bob();
		DPGF D 0 {
			return CheckFire("LauncherFireLoop1","LauncherFireStop",null);
		}
		DPGF C 0 {
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
	Flash1:
		DPGF A 1 Bright A_Light(2);
		DPGF B 1 Bright A_Light(1);
		Goto LightDone;
	Flash2:
		DPGF C 1 Bright A_Light(2);
		DPGF D 1 Bright A_Light(1);
		Goto LightDone;
	Spawn:
		DEPG A -1;
		Loop;
	OverheatStart:
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
		A_FireProjectile("PlasmaBall",0,true);
		if(random(0,1)) {
			A_GunFlash("Flash1");
		} else {
			A_GunFlash("Flash2");
		}
		return ResolveState(null);
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