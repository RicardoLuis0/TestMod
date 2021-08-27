class TestModPlayer : PlayerPawn {
	
	bool grenade_key_down;
	bool melee_key_down;
	
	mixin WeaponInertia;
	mixin LookPos;
	
	Default{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;
		
		Player.DisplayName "TestMod Player";
		
		Player.CrouchSprite "PLYC";

		Player.StartItem "NewPistol";
		Player.StartItem "LightClip", 50;
		Player.StartItem "PistolLoaded", 18;
		Player.StartItem "SMGLoaded", 46;
		Player.StartItem "AssaultRifleLoaded", 21;
		Player.StartItem "AutoShotgunLoaded", 13;
		Player.StartItem "PumpLoaded", 9;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";

		Player.WeaponSlot 1, "Fist","Chainsaw";
		Player.WeaponSlot 2, "Pistol";
		Player.WeaponSlot 3, "Shotgun","SuperShotgun";
		Player.WeaponSlot 4, "Chaingun";
		Player.WeaponSlot 5, "RocketLauncher";
		Player.WeaponSlot 6, "PlasmaRifle";
		Player.WeaponSlot 7, "BFG9000";

		Player.ColorRange 112, 127;
		Player.Colorset 0, "Green",			0x70, 0x7F,  0x72;
		Player.Colorset 1, "Gray",			0x60, 0x6F,  0x62;
		Player.Colorset 2, "Brown",			0x40, 0x4F,  0x42;
		Player.Colorset 3, "Red",			0x20, 0x2F,  0x22;
		Player.Colorset 4, "Light Gray",	0x58, 0x67,  0x5A;
		Player.Colorset 5, "Light Brown",	0x38, 0x47,  0x3A;
		Player.Colorset 6, "Light Red",		0xB0, 0xBF,  0xB2;
		Player.Colorset 7, "Light Blue",	0xC0, 0xCF,  0xC2;
	}

	override void PostBeginPlay(){
		super.PostBeginPlay();
		InertiaInit();
		LookPosInit();
	}

	override void Tick(){
		Super.Tick();
		if (!player || !player.mo || player.mo != self){
			return;
		}else{
			InertiaTick();
			LookPosTick();
			if(player.ReadyWeapon is "ModWeaponBase"){
				ModWeaponBase(player.ReadyWeapon).ReadyTick();
			}
		}
	}

	override Vector2 BobWeapon(double ticfrac){
		return WeaponInertiaBobWeapon(ticfrac);
	}

	void player_UpdateCVars(){
		weaponinertia_UpdateCVars();
	}

	States{
	Spawn:
		PLAY A -1;
		Loop;
	See:
		PLAY ABCD 4;
		Loop;
	Missile:
		PLAY E 12;
		Goto Spawn;
	Melee:
		PLAY F 6 BRIGHT;
		Goto Missile;
	Pain:
		PLAY G 4;
		PLAY G 4 A_Pain;
		Goto Spawn;
	Death:
		PLAY H 0 A_PlayerSkinCheck("AltSkinDeath");
	Death1:
		PLAY H 10;
		PLAY I 10 A_PlayerScream;
		PLAY J 10 A_NoBlocking;
		PLAY KLM 10;
		PLAY N -1;
		Stop;
	XDeath:
		PLAY O 0 A_PlayerSkinCheck("AltSkinXDeath");
	XDeath1:
		PLAY O 5;
		PLAY P 5 A_XScream;
		PLAY Q 5 A_NoBlocking;
		PLAY RSTUV 5;
		PLAY W -1;
		Stop;
	AltSkinDeath:
		PLAY H 6;
		PLAY I 6 A_PlayerScream;
		PLAY JK 6;
		PLAY L 6 A_NoBlocking;
		PLAY MNO 6;
		PLAY P -1;
		Stop;
	AltSkinXDeath:
		PLAY Q 5 A_PlayerScream;
		PLAY R 0 A_NoBlocking;
		PLAY R 5 A_SkullPop;
		PLAY STUVWX 5;
		PLAY Y -1;
		Stop;
	}
}