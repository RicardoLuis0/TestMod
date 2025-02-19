class RailgunCharge : Ammo {
	Default {
		Inventory.MaxAmount 50;
	}
}

class RailgunTrail : Actor {
	Default {
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
	/*
	static const Color lightColors[] = {
		"C7C7FF", //  0%
		"C3BDFF", //  5%
		"C0B3FF", // 10%
		"BCA9FF", // 15%
		"B99FFF", // 20%
		"B595FF", // 25%
		"B18BFF", // 30%
		"AE81FF", // 35%
		"AA77FF", // 40%
		"A76DFF", // 45%
		"A363FF", // 50%
		"9F5AFF", // 55%
		"9C50FF", // 60%
		"9846FF", // 65%
		"953CFF", // 70%
		"9132FF", // 75%
		"8D28FF", // 80%
		"8A1EFF", // 85%
		"8614FF", // 90%
		"830AFF", // 95%
		"7F00FF"  // 100%
	}
	*/
	
	static const Color lightColors[] = {
		"060607", //   0%
		"060507", //   5%
		"060507", //  10%
		"050507", //  15%
		"050407", //  20%
		"050407", //  25%
		"050407", //  30%
		"050407", //  35%
		"050307", //  40%
		"050307", //  45%
		"050307", //  50%
		"040207", //  55%
		"040207", //  60%
		"040207", //  65%
		"040107", //  70%
		"040107", //  75%
		"040107", //  80%
		"040007", //  85%
		"040007", //  90%
		"040007", //  95%
		"030007"  // 100%
	};
	
	static const Color lightColorsBig[] = {
		"030303", //   0%
		"030203", //   5%
		"030203", //  10%
		"020203", //  15%
		"020203", //  20%
		"020203", //  25%
		"020203", //  30%
		"020203", //  35%
		"020103", //  40%
		"020103", //  45%
		"020103", //  50%
		"020103", //  55%
		"020103", //  60%
		"020103", //  65%
		"020003", //  70%
		"020003", //  75%
		"020003", //  80%
		"020003", //  85%
		"020003", //  90%
		"020003", //  95%
		"010003"  // 100%
	};
	
	int trns;
	int intens;
	int base_intens;
	int intens_dec;
	Name lightName;
	Color lightColor;
	
	bool do_light;
	
	override void PostBeginPlay() {
		super.PostBeginPlay();
		if(target) {
			int dist = int(Level.Vec3Diff(pos, target.pos).length() / 10);
			trns = Abs((dist % 41) - 20);
			bool simple = TestModPlayer(target).simplified_railgun_light_fx.getBool();
			if(simple)
			{	//software mode
				do_light = TestModPlayer(target).do_railgun_light_fx.getBool() && ((trns % 7) == 0);
				base_intens = 500;
			}
			else
			{
				do_light = TestModPlayer(target).do_railgun_light_fx.getBool();
				base_intens = 200;
			}
			A_SetTranslation("RailgunTrailTrns"..trns);
			if(do_light)
			{
				if((trns % 2) == 1 || simple)
				{
					intens = base_intens / 4;
					intens_dec = intens / 10;
					lightName = "glow";
					
					if(simple)
					{
						lightColor = lightColorsBig[trns] * 7;
					}
					else
					{
						lightColor = lightColors[trns];
					}
				} else {
					intens = base_intens;
					intens_dec = intens / 10;
					lightName = "bigGlow";
					lightColor = lightColorsBig[trns];
				}
				A_AttachLight(lightName,DynamicLight.PointLight,lightColor,intens,intens,DynamicLight.LF_ATTENUATE | DynamicLight.LF_NOSHADOWMAP);
			}
		}
	}
	
	States{
	Spawn:
		BSHT A 0 NODELAY A_JumpIf(!do_light, "NoLight");
		BSHT A 10 Bright;
		BSHT AABBCDEFG 1 Bright
		{
			invoker.intens -= intens_dec;
			A_AttachLight(lightName,DynamicLight.PointLight,lightColor,intens,intens,DynamicLight.LF_ATTENUATE | DynamicLight.LF_NOSHADOWMAP);
		}
		Stop;
	NoLight:
		BSHT A 10 Bright;
		BSHT AB 2 Bright;
		BSHT CDEFG 1 Bright;
		Stop;
	}
}

class Railgun : ModWeaponBase {

	Default {
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

	override void BeginPlay() {
		super.BeginPlay();
		crosshair = 43;
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
			A_Overlay(2, "FireBodyGlowOverlay");
			A_OverlayFlags(2,PSPF_FORCEALPHA, true);
			invoker.SetLayerAlpha(2, 0);
			
			A_Overlay(3, "FireAnimOverlay");
			A_OverlayFlags(3,PSPF_FORCEALPHA, true);
			invoker.SetLayerAlpha(3, 0);
			
			A_Overlay(4, "FireGlowOverlay");
			A_OverlayFlags(4, PSPF_FORCEALPHA, true);
			A_OverlayFlags(4, PSPF_RENDERSTYLE, true);
			A_OverlayRenderstyle(4, STYLE_Add);
			invoker.SetLayerAlpha(4, 0);
			
			invoker.overlay_alpha_down = false;
			invoker.overlay_alpha = 0.0;
		}
		RGUN A 15;
		TNT1 A 0 CheckFireNoAlt(null, "SkipFire");
		RGUN A 4 {
			A_SetBlend("cc33ff", 1, 5);
			A_RailAttack(
				1500,
				flags: RGF_FULLBRIGHT,
				pufftype: "",
				spawnclass: "RailgunTrail"
			);
			A_AlertMonsters();
			A_SetPitch(pitch+random[TestModWeapon](-10, 0));
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
		TNT1 A 0 CheckFireNoAlt(null, "FireAnimOverlaySkipFire");
		RGUN C 4 BRIGHT;
	FireAnimOverlaySkipFire:
		RGUN B 25 BRIGHT;
		Stop;
		
	FireGlowOverlay:
		RGUN D 15 BRIGHT;
		TNT1 A 0 CheckFireNoAlt(null, "FireGlowOverlaySkipFire");
		RGUN E 4 BRIGHT;
	FireGlowOverlaySkipFire:
		RGUN D 25 BRIGHT;
		Stop;
	
	FireBodyGlowOverlay:
		RGUN A 15 BRIGHT;
		TNT1 A 0 CheckFireNoAlt(null, "FireGlowOverlaySkipFire");
		RGUN A 4 BRIGHT;
	FireBodyGlowOverlaySkipFire:
		RGUN A 25 BRIGHT;
	Spawn:
		DEPG A -1;
		Loop;
	}
	
	bool overlay_alpha_down;
	double overlay_alpha;
	
	override void ReadyTick() {
		double rate_up = 1.0 / 15;
		double rate_down = 1.0 / 25;
		overlay_alpha = clamp(
						overlay_alpha_down ? 
							overlay_alpha - rate_down
						  : overlay_alpha + rate_up,
						0.0, 1.0);
		SetLayerAlpha(2, clamp(overlay_alpha ** 2, 0.0, 0.5));
		SetLayerAlpha(3, overlay_alpha);
		SetLayerAlpha(4, overlay_alpha);
		if(
			(gametic % 2 == 0 )
		  && PSP_GetState(1) == ResolveState("Ready")
		  && ammo2.amount > 0
		  && ammo1.amount < ammo1.maxamount
		){
			ammo1.amount++;
			ammo2.amount--;
		}
	}
}