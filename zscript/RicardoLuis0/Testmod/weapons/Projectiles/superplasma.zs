class superplasmaball : Actor {
	Default {
		Radius 13;
		Height 8;
		Speed 25;
		Damage 150;
		Projectile;
		+RANDOMIZE;
		+ZDOOMTRANS;
		+FORCEXYBILLBOARD;
		-NOGRAVITY;
		RenderStyle "Add";
		Alpha 0.75;
		Scale 0.75;
		Gravity 0.125;
		DeathSound "weapons/bfgx";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States {
	Spawn:
		PES1 AB 4 Bright;
		Loop;
	Death:
		TNT1 A 0 A_NoGravity;
		PED1 A 0 A_Explode(250,250,XF_HURTSOURCE,true,25);
		PED1 AB 8 Bright;
		PED1 C 8 Bright;
		PED1 DEF 8 Bright;
		Stop;
	}
}