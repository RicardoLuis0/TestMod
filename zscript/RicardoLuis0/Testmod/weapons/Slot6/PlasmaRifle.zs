class MyPlasmaRifle : MyWeapon {
	const LAYER = 9999;
	int heat;
	int heatmax;
	int heatup;
	int heatdown;
	int heatdownreload;
	bool firing;
	bool overheat;
	bool reloading;
	bool init;
	int altloop;
	int altuse;
	Default{
		Weapon.SlotNumber 6;
		Weapon.AmmoType1 "Cell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 40;
		+WEAPON.NOALERT;
		Inventory.PickupMessage "You've got the Plasma Rifle!";
	}

	override void BeginPlay(){
		super.BeginPlay();
		crosshair=20;
		heat=0;
		heatmax=500;
		heatup=10;
		heatdownreload=20;
		heatdown=1;
		altuse=10;
		firing=false;
		overheat=false;
		reloading=false;
		init=false;
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
		heat-=reloading?heatdownreload:heatdown;
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
	Fire:
		DPGG A 1{
			W_SetLayerSprite(LAYER,"PHNA");
			return A_FireGun();
		}
		DPGG B 1 W_SetLayerSprite(LAYER,"PHNB");
		DPGG A 1 W_SetLayerSprite(LAYER,"PHNA");
		DPGG A 3 A_MyRefire();
		DPGG A 0 A_FireEnd();
		Goto Ready;
	AltStop:
		DPGF AC 5 Bright;
		Goto Ready;
	AltFire:
		DPGG A 0{
			if(invoker.heat!=0){
				return ResolveState("Reload");
			}else if(CountInv("Cell")<invoker.altuse){
				return ResolveState("Ready");
			}
			return ResolveState(null);
		}
		DPGF AC 5 Bright;
		DPGF C 0 {
			return CheckAFire(null,"Ready");
		}
		DPGF AC 5 Bright;
		DPGF C 0 {
			return CheckAFire(null,"Ready");
		}
		DPGF AC 5 Bright;
		DPGF C 0 {
			return CheckAFire(null,"Ready");
		}
		DPGF B 0 W_SetLayerSprite(LAYER,"PHOB");
	AltLoop1:
		DPGF BD 3 Bright;
		DPGF D 0 {
			return CheckFire("AltStop","AltLoop1",null);
		}
		DPGF C 0 {
			A_SetBlend("LightSlateBlue",1,5);
			invoker.firing=true;
			A_AlertMonsters();
			TakeInventory("Cell",invoker.altuse);
			A_FireProjectile("SuperPlasmaBall",0,false);
			A_SetPitch(pitch+random(-10,0));
			A_Recoil(10);
			A_Overheat();
			W_SetLayerSprite(LAYER,"PHOC");
		}
		DPGG C 5 A_WeaponOffset(0,52,WOF_INTERPOLATE);
		DPGG C 0 {
			A_SetBlend("AliceBlue",.5,10);
			invoker.altloop=20;
		}
	AltLoop2:
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
	}

	action State A_FireGun(){
		if(invoker.overheat){
			invoker.firing=false;
			return ResolveState("OverheatStart");
		}else if(CountInv("Cell")==0){
			invoker.firing=false;
			return ResolveState("Ready");
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
	action State A_MyRefire(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			player.refire++;
			return ResolveState("Fire");
		}else{
			player.refire=0;
			return ResolveState(null);
		}
	}
	action State A_FireEnd(){
		invoker.firing=false;
		if(invoker.overheat){
			return ResolveState("OverheatStart");
		}else{
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