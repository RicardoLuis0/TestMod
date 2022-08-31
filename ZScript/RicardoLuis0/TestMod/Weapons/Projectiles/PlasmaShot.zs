class PlasmaShot01 : FastProjectile {
	Default{
		Radius 4;
		Height 8;
		Speed 50;
		Damage 8;
		Projectile;
		RenderStyle "Add";
		Alpha 0.7;
		SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
		MissileType "PlasmaShot01Trail";
		MissileHeight 8;
		Decal "PlasmaScorchLower";
		+FORCEXYBILLBOARD;
	}
	States{
	Spawn:
		BSHT A 0 NoDelay Bright A_StartSound("weapons/plasmaflyby",CHAN_BODY,CHANF_LOOPING,1.0);
		BSHT A 1 Bright;
		Loop;
	Missile:
	Death:
		TNT1 A 0;
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
		+FORCEXYBILLBOARD;
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