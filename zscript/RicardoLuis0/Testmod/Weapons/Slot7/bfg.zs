class BFG : ModWeaponBase {
	const LAYER_LIGHT_1_TIMER = 10001;
	const LAYER_LIGHT_2_TIMER = 10000;
	const LAYER_LIGHT_1 = 9999;
	const LAYER_LIGHT_2 = 9998;
	const LAYER_DISPLAY = 9997;
	
	bool init;
	bool large;
	bool light1;
	bool light2;
	int ammo_display;

	Default {
		Tag "BFG";
		Weapon.SlotNumber 7;
		Weapon.AmmoType1 "Cell";
		Weapon.AmmoUse1 40;
		Weapon.AmmoGive1 120;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
	}
	
	override void ReadyTick(){
		int new_count=0;
		let iammo=owner.FindInventory(ammotype1);
		if(iammo&&iammo.amount>=ammouse1){
			new_count=ceil(iammo.amount/double(iammo.maxAmount)*5);
		}
		if(init&&new_count!=ammo_display){
			ammo_display=new_count;
			SetLayerFrame(LAYER_DISPLAY,ammo_display+(large?8:0));
		}
	}
	
	States {
	Spawn:
		BFGP A -1;
		Stop;
	Ready:
		BFGS A 1 W_WeaponReady(WRF_ALLOWRELOAD);
		wait;
	Deselect:
		BFGS A 1 A_Lower();
		wait;
	DeadLowered:
		BFGS A -1 A_ClearOverlays(LAYER_DISPLAY,LAYER_LIGHT_1);
		stop;
	Select:
		BFGS A 0 {
			A_Overlay(LAYER_LIGHT_1_TIMER,"Light1TimerStart");
			A_Overlay(LAYER_LIGHT_2_TIMER,"Light2Timer");
			A_Overlay(LAYER_LIGHT_1,"Light1Overlay");
			A_Overlay(LAYER_LIGHT_2,"Light2Overlay");
			A_Overlay(LAYER_DISPLAY,"DisplayOverlay");
			A_Small();
			A_Light1Off();
			A_Light2Off();
			invoker.ammo_display=0;
			invoker.init=true;
		}
		BFGS A 1 A_Raise();
		wait;
	Light1TimerStart:
		TNT1 A 2;
	Light1Timer:
		TNT1 A 0 {
			if(invoker.ammo_display==0){
				return ResolveState("Light1TimerCritical");
			}else if(invoker.ammo_display>1){
				return ResolveState("Light1TimerOff");
			}else{
				return ResolveState("Light1TimerOn");
			}
		}
	Light1TimerCritical:
		TNT1 A 8 {
			A_Light1On();
			A_StartSound("weapons/bfg/beep",CHAN_AUTO,CHANF_LOCAL,0.30,ATTN_NONE,1.0);
		}
		TNT1 A 4 A_Light1Off;
		TNT1 A 8 {
			A_Light1On();
			A_StartSound("weapons/bfg/beep",CHAN_AUTO,CHANF_LOCAL,0.30,ATTN_NONE,1.0);
		}
		TNT1 A 15 A_Light1Off;
		goto Light1TimerOff;
	Light1TimerOn:
		TNT1 A 8 {
			A_Light1On();
			A_StartSound("weapons/bfg/beep",CHAN_AUTO,CHANF_LOCAL,0.30,ATTN_NONE,1.0);
		}
		TNT1 A 15 A_Light1Off;
	Light1TimerOff:
		TNT1 A 1 A_Light1Off;
		goto Light1Timer;
	Light2Timer:
		TNT1 A 0 {
			if(invoker.ammo_display==0){
				return ResolveState("Light2TimerOff");
			}else{
				return ResolveState(null);
			}
		}
		TNT1 A 1 A_Light2On;
		goto Light2Timer;
	Light2TimerOff:
		TNT1 A 1 A_Light2Off;
		goto Light2Timer;
	Light1Overlay:
		BFGO G -1;
		loop;
	Light2Overlay:
		BFGO H -1;
		stop;
	DisplayOverlay:
		BFGO A -1;
		stop;
	Fire:
		TNT1 A 0 {
			if(CountInv(invoker.ammotype1)<invoker.ammouse1){
				return ResolveState("ready");
			}else{
				return ResolveState(null);
			}
		}
		TNT1 A 0 A_GunFlash;
	FireCharge:
		BFGS A 8 BRIGHT ;
		TNT1 A 0 CheckFire(null,"FireUncharge","FireUncharge");
	FireLoop:
		BFGS AAAAAA 4 BRIGHT CheckFire(null,"FireUncharge","FireFire");
		TNT1 A 0 CheckFire("FireLoop");
	FireFire:
		TNT1 A 0 A_StartSound("weapons/bfg/fire",CHAN_AUTO);
		BFGS A 3 BRIGHT;
		TNT1 A 0 {
			A_WeaponOffset(0,52,WOF_INTERPOLATE);
			A_BFGFire();
		}
		BFGL A 12 BRIGHT A_Large;
		BFGL A 1 A_WeaponOffset(0,48,WOF_INTERPOLATE);
		BFGL A 1 A_WeaponOffset(0,44,WOF_INTERPOLATE);
		BFGL A 1 A_WeaponOffset(0,40,WOF_INTERPOLATE);
		BFGL A 1 A_WeaponOffset(0,36,WOF_INTERPOLATE);
		BFGL A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		TNT1 A 0 A_Small;
		goto ready;
	FireUncharge:
		BFGS A 8 BRIGHT;
		TNT1 A 0 CheckFire("FireCharge");
		goto ready;
	Flash:
		BFGC ABCD 2 BRIGHT;
		TNT1 A 0 CheckFire(null,"FlashUncharge","FlashUncharge");
	FlashLoop:
		BFGR ABCDEF 4 BRIGHT CheckFire(null,"FlashUncharge","FlashFire");
		TNT1 A 0 CheckFire("FlashLoop");
	FlashFire:
		BFGR A 2 BRIGHT;
		BFGR B 1 BRIGHT;
		BFGF AB 4 BRIGHT;
		stop;
		BFGO ABCDEFGHIJKLMNOP 0;
	FlashUncharge:
		BFGC DCBA 2 BRIGHT;
		TNT1 A 0 CheckFire("Flash");
		stop;
	}
	action void A_Large(){
		invoker.large=true;
		if(invoker.light1){
			W_SetLayerFrame(LAYER_LIGHT_1,14);
		}
		if(invoker.light2){
			W_SetLayerFrame(LAYER_LIGHT_2,15);
		}
		W_SetLayerFrame(LAYER_DISPLAY,invoker.ammo_display+8);
	}
	
	action void A_Small(){
		invoker.large=false;
		if(invoker.light1){
			W_SetLayerFrame(LAYER_LIGHT_1,6);
		}
		if(invoker.light2){
			W_SetLayerFrame(LAYER_LIGHT_2,7);
		}
		W_SetLayerFrame(LAYER_DISPLAY,invoker.ammo_display);
	}
	
	action void A_Light1On(){
		invoker.light1=true;
		W_SetLayerSprite(LAYER_LIGHT_1,"BFGO");
		W_SetLayerFrame(LAYER_LIGHT_1,invoker.large?14:6);
	}
	
	action void A_Light1Off(){
		invoker.light1=false;
		//A_Overlay(LAYER_LIGHT_1,"Light1Overlay");
		W_SetLayerSprite(LAYER_LIGHT_1,"TNT1");
	}
	
	action void A_Light2On(){
		invoker.light2=true;
		W_SetLayerSprite(LAYER_LIGHT_2,"BFGO");
		W_SetLayerFrame(LAYER_LIGHT_2,invoker.large?15:7);
	}
	
	action void A_Light2Off(){
		invoker.light2=false;
		//A_Overlay(LAYER_LIGHT_2,"Light2Overlay");
		W_SetLayerSprite(LAYER_LIGHT_2,"TNT1");
	}
	
	action void A_BFGFire(){
		A_SetBlend("GreenYellow",.75,10);
		A_FireBFG();
		A_Recoil(10);
		A_AlertMonsters();
		A_SetPitch(pitch+frandom(-10,-5));
	}
}
