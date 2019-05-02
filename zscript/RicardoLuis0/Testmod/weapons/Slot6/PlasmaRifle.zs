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
	name cur_sprite;
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
		cur_sprite="PHNA";
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
		SetLayerFrame(2,overheatamt);
		SetLayerSprite(2,cur_sprite);
	}
	
	action void A_SetOSprite(name newspr){
		invoker.cur_sprite=newspr;
	}

	States{
	Ready:
		DPGG A 0 {
			W_SetLayerSprite(2,"PHNA");
		}
	ReadyLoop:
		DPGG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Deselect:
		DPGG A 1 A_Lower();
		Loop;
	Select:
		DPGG A 0 {
			A_Overlay(2,"WeaponOverlay");
			invoker.init=true;
		}
		DPGG A 1 A_Raise();
		Wait;
	Fire:
		DPGG A 1{
			A_FireGun();
			W_SetLayerSprite(2,"PHNA");
		}
		DPGG B 1 W_SetLayerSprite(2,"PHNB");
		DPGG A 1 W_SetLayerSprite(2,"PHNA");
		DPGG A 3 A_MyRefire();
		DPGG C 10 W_SetLayerSprite(2,"PHNC");
		DPGG A 3 W_SetLayerSprite(2,"PHNA");
		DPGG A 0 A_FireEnd();
		Goto Ready;
	Reload:
		DPGG A 1 W_SetLayerSprite(2,"PHNA");
	ReloadStart:
		DPGG C 6 W_SetLayerSprite(2,"PHNC");
		DPGG C 0 {
			invoker.reloading=true;
		}
	HeatReload:
		DPGG D 4{
			W_SetLayerSprite(2,"PHNA");
			return A_ReloadEnd();
		}
		Loop;
	HeatReloadStop:
		DPGG C 6 W_SetLayerSprite(2,"PHNC");
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
		DPGG A 3 W_SetLayerSprite(2,"PHNA");
		DPGG C 6 W_SetLayerSprite(2,"PHNC");
		DPGG C 0{
			invoker.reloading=true;
		}
	OverheatLoop:
		DPGG D 4 {
			W_SetLayerSprite(2,"PHND");
			return A_OverheatEnd();
		}
		Loop;
	OverheatStop:
		DPGG C 6 W_SetLayerSprite(2,"PHNC");
		DPGG A 3 W_SetLayerSprite(2,"PHNA");
		goto Ready;
	WeaponOverlay:
		PHNA A -1;
		PHNB A -1;
		PHNC A -1;
		PHND A -1;
		PHOA A -1;
		PHOB A -1;
		PHOC A -1;
		PHOD A -1;
		Stop;
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
		A_FireProjectile("PlasmaBall",0,1,0,0);
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
			return ResolveState("HeatReloadStop");
		}
		return ResolveState(null);
	}
	action State A_OverheatEnd(){
		if(!invoker.overheat){
			invoker.reloading=false;
			return ResolveState("OverHeatStop");
		}
		return ResolveState(null);
	}
}