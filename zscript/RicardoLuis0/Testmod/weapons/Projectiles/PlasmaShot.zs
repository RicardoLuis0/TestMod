class PlasmaShot01:FastProjectile{
	Default{
		Radius 4;
		Height 8;
		Speed 50;
		Damage 5;
		Projectile;
		RenderStyle "Add";
		Alpha 0.7;
		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		MissileType "PlasmaShot01Trail";
		MissileHeight 8;
		Decal "PlasmaScorchLower";
	}
	States{
	Spawn:
		BSHT A 0 Bright A_PlaySound("weapons/plasmaflyby", CHAN_BODY, 1.0, 1);
		BSHT A 1 Bright;
		Loop;
	Death:
		TNT1 A 1;
		Stop;
	}
}
class PlasmaShot01Silent:PlasmaShot01{
	Default{
		SeeSound "";
	}
}
class PlasmaShot01Trail:actor{
	Default{
		+NOINTERACTION;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+NOTELEPORT;
		Radius 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.5;
	}
	States{
	Spawn:
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}

class PlasmaRailTrail:actor{
	Default{
		+NOINTERACTION;
		+NOBLOCKMAP;
		+NOGRAVITY;
		+NOTELEPORT;
		Radius 4;
		Scale 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.1;
	}
	States{
	Spawn:
		BSHT A 10 Bright;
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}