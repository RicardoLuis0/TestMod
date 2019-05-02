class myMarine:myPlayer{
	override void initClasses(){
		allowed_spawn_classes.Push("Melee1");
		allowed_spawn_classes.Push("Shotguns");
		allowed_spawn_classes.Push("Rifles");
		allowed_spawn_classes.Push("Heavy");
		allowed_spawn_classes.Push("Explosives");
	}
	override bool allowMana(){
		return false;
	}
	Default{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;
		Player.DisplayName "...";
		Player.CrouchSprite "PLYC";
		
		Player.StartItem "Pistol";
		//Player.StartItem "AK";
		Player.StartItem "Fist";
		/*
		Player.StartItem "ManaRegenHandler";
		Player.StartItem "ManaCapacity",100;
		Player.StartItem "ManaRegenAmt",1;
		*/
		Player.StartItem "Clip", 90;
		//Player.StartItem "AKAMMO",31;
		
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
		// Doom Legacy additions
		Player.Colorset 4, "Light Gray",	0x58, 0x67,  0x5A;
		Player.Colorset 5, "Light Brown",	0x38, 0x47,  0x3A;
		Player.Colorset 6, "Light Red",		0xB0, 0xBF,  0xB2;
		Player.Colorset 7, "Light Blue",	0xC0, 0xCF,  0xC2;
	}
}