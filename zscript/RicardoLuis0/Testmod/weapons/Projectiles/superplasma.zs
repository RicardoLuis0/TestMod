class superplasmaball:Actor{
	Default{
		Radius 13;
		Height 8;
		Speed 25;
		Damage 150;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/bfgx";
		Obituary "$OB_MPPLASMARIFLE";
	}
	States
	{
	Spawn:
		PES1 AB 4 Bright;
		Loop;
	Death:
		PED1 A 0 A_Explode(250,250,XF_HURTSOURCE,true,25);
		PED1 AB 8 Bright;
		PED1 C 8 Bright;
		PED1 DEF 8 Bright;
		Stop;
	}
}