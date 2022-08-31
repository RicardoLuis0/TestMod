class RailgunCharge : Ammo {
	Default {
		Inventory.MaxAmount 25;
	}
}

class Railgun : ModWeaponBase {

	Default{
		Tag "Railgun";
		Weapon.SlotNumber 7;
		Weapon.AmmoType1 "RailgunCharge";
		Weapon.AmmoType2 "NewCell";
		Weapon.AmmoUse1 25;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 50;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		Inventory.PickupMessage "You've got the Railgun!";
		Decal "PlasmaScorchLower";
		
		//ModWeaponBase.PickupHandleNoMagazine true;
	}

	override void BeginPlay(){
		super.BeginPlay();
		crosshair=43;
	}
	
	States{
	Ready:
		RGUN A 1 W_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
		
	Deselect:
		RGUN A 1 A_Lower();
		Loop;
		
	Select:
		RGUN A 1 A_Raise();
		Loop;
		
	Fire:
		TNT1 A 0 A_JumpIfNoAmmo("Ready");
		TNT1 A 0 {
			A_Overlay(2,"FireAnimOverlay");
			A_OverlayFlags(2,PSPF_FORCEALPHA,true);
			invoker.SetLayerAlpha(2,0);
			invoker.overlay_alpha_down = false;
			invoker.overlay_alpha = 0.0;
		}
		RGUN A 15;
		TNT1 A 0 CheckFireNoAlt(null,"SkipFire");
		RGUN A 4 {
			A_SetBlend("cc33ff",1,5);
			A_RailAttack(
					1500,
					flags: RGF_FULLBRIGHT,
					pufftype: "",
					spawnclass: "PlasmaRailTrail"
			);
			A_AlertMonsters();
			A_SetPitch(pitch+random(-10,0));
			A_Recoil(15);
		}
	SkipFire:
		TNT1 A 0 {
			invoker.overlay_alpha_down = true;
		}
		RGUN A 25;
		Goto Ready;
		
	FireAnimOverlay:
		RGUN B 15 BRIGHT;
		TNT1 A 0 CheckFireNoAlt(null,"FireAnimOverlaySkipFire");
		RGUN C 4 BRIGHT;
	FireAnimOverlaySkipFire:
		RGUN B 25 BRIGHT;
		Stop;
	Spawn:
		DEPG A -1;
		Loop;
	}
	bool overlay_alpha_down;
	double overlay_alpha;
	override void ReadyTick(){
		double rate_up = 1./15;
		double rate_down = 1./25;
		overlay_alpha = clamp(overlay_alpha_down?overlay_alpha - rate_down : overlay_alpha + rate_up,0.0,1.0);
		SetLayerAlpha(2,overlay_alpha);
		if( (gametic % 2 == 0 ) && PSP_GetState(1) == ResolveState("Ready") && ammo2.amount > 0 && ammo1.amount < ammo1.maxamount){
			ammo1.amount++;
			ammo2.amount--;
		}
	}
}