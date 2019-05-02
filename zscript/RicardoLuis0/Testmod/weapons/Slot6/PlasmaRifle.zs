class MyPlasmaRifle : MyWeapon {
	int heat;
	int heatmax;
	int heatup;
	int heatdown;
	int heatdownreload;
	bool firing;
	bool overheat;
	bool reloading;
	bool init;
	int spriteindex_prev;
	int overheat_prev;
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
		crosshair=35;
		heat=0;
		heatmax=1000;
		heatup=20;
		heatdown=1;
		heatdownreload=20;
		firing=false;
		overheat=false;
		overheat_prev=false;
		spriteindex_prev=0;
		reloading=false;
		init=false;
	}

	override void ReadyTick(){
		if(!firing&&heat>0)HeatMinus();
		if(init)HeatOverlay();
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
		SetLayerFrame(9999,overheatamt);
	}

	States{
	Ready:
		DPGG A 0 {
			A_Overlay(9999,"OverlayReady");
		}
	ReadyLoop:
		DPGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		DPGG A 1 A_Lower();
		Loop;
	Select:
		DPGG A 0 {
			A_Overlay(9999,"OverlayReady");
			invoker.init=true;
		}
		DPGG A 1 A_Raise();
		Wait;
	Fire:
		DPGG A 1 A_FireGun();
		DPGG BA 1;
		DPGG A 3 A_ReFire();
		DPGG A 0 A_FireEnd();
		Goto Ready;
	Reload:
		DPGG A 1 {
			A_Overlay(9999,"OverlayReload");
			invoker.reloading=true;
			return ResolveState("ReloadStart");
		}
	ReloadStart:
		DPGG C 6;
	HeatReload:
		DPGG D 4 A_ReloadEnd();
		Loop;
	HeatReloadStop:
		DPGG C 6;
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
		DPGG A 3;
		DPGG C 6;
		DPGG C 0{
			invoker.reloading=true;		
		}
	OverheatLoop:
		DPGG D 4 A_OverheatEnd();
		Loop;
	OverheatStop:
		DPGG C 6;
		DPGG A 3;
		goto Ready;
	OverlayReady:
		PHNA A 1;
		Loop;
	OverlayFire:
		PHNA A 1;
		PHNB A 1;
		PHNA A 4;
		Goto OverlayReady;
	OverlayReload:
		PHNC A 6;
	OverlayReloadLoop:
		PHND A 4;
		Loop;
	OverlayReloadStop:
		PHNC A 6;
		Goto OverlayReady;
	OverlayOverheat:
		PHOA A 3;
		PHOC A 6;
	OverlayOverheatLoop:
		PHOD A 4;
		Loop;
	OverlayOverheatStop:
		PHOC A 6;
		PHOA A 3;
		goto OverlayReady;
	}

	action State A_FireGun(){
		if(invoker.overheat){
			invoker.firing=false;
			A_Overlay(9999,"OverlayOverheat");
			return ResolveState("OverheatStart");
		}else if(CountInv("Cell")==0){
			invoker.firing=false;
			return ResolveState("Ready");
		}
		invoker.firing=true;
		invoker.HeatPlus();
		A_AlertMonsters();
		A_FireProjectile("PlasmaBall",0,1,0,0);
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
			A_Overlay(9999,"OverlayOverheat");
			return ResolveState("OverheatStart");
		}else{
			return ResolveState("Ready");
		}
	}
	action State A_ReloadEnd(){
		if(invoker.heat==0){
			invoker.reloading=false;
			A_Overlay(9999,"OverlayReloadStop");
			return ResolveState("HeatReloadStop");
		}
		return ResolveState(null);
	}
	action State A_OverheatEnd(){
		if(!invoker.overheat){
			invoker.reloading=false;
			A_Overlay(9999,"OverlayOverheatStop");
			return ResolveState("OverHeatStop");
		}
		return ResolveState(null);
	}
}