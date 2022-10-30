class RailgunCharge : Ammo {
	Default {
		Inventory.MaxAmount 50;
	}
}

class RailgunTrail : Actor {
	Default{
		+NOINTERACTION;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+NOTELEPORT;
		Radius 4;
		Scale 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.025;
		+FORCEXYBILLBOARD;
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		if(target){
			int dist=int(Level.Vec3Diff(pos,target.pos).length()/10);
			int trns=abs((dist%41)-20);
			A_SetTranslation("RailgunTrailTrns"..trns);
		}
	}
	States{
	Spawn:
		BSHT A 10 Bright;
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}

class Railgun : ModWeaponBase {

	Default{
		Tag "Railgun";
		Weapon.SlotNumber 7;
		Weapon.AmmoType1 "RailgunCharge";
		Weapon.AmmoType2 "NewCell";
		Weapon.AmmoUse1 50;
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
			A_Overlay(2,"FireBodyGlowOverlay");
			A_OverlayFlags(2,PSPF_FORCEALPHA,true);
			invoker.SetLayerAlpha(2,0);
			A_Overlay(3,"FireAnimOverlay");
			A_OverlayFlags(3,PSPF_FORCEALPHA,true);
			invoker.SetLayerAlpha(3,0);
			A_Overlay(4,"FireGlowOverlay");
			A_OverlayFlags(4,PSPF_FORCEALPHA,true);
			A_OverlayFlags(4,PSPF_RENDERSTYLE,true);
			A_OverlayRenderstyle(4,STYLE_Add);
			invoker.SetLayerAlpha(4,0);
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
					spawnclass: "RailgunTrail"
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
		
	FireGlowOverlay:
		RGUN D 15 BRIGHT;
		TNT1 A 0 CheckFireNoAlt(null,"FireGlowOverlaySkipFire");
		RGUN E 4 BRIGHT;
	FireGlowOverlaySkipFire:
		RGUN D 25 BRIGHT;
		Stop;
	
	FireBodyGlowOverlay:
		RGUN A 15 BRIGHT;
		TNT1 A 0 CheckFireNoAlt(null,"FireGlowOverlaySkipFire");
		RGUN A 4 BRIGHT;
	FireBodyGlowOverlaySkipFire:
		RGUN A 25 BRIGHT;
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
		SetLayerAlpha(2,clamp(overlay_alpha**2,0.0,0.5));
		SetLayerAlpha(3,overlay_alpha);
		SetLayerAlpha(4,overlay_alpha);
		if( (gametic % 2 == 0 ) && PSP_GetState(1) == ResolveState("Ready") && ammo2.amount > 0 && ammo1.amount < ammo1.maxamount){
			ammo1.amount++;
			ammo2.amount--;
		}
	}
}