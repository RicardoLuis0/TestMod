mixin class CasingBehavior
{
	Default {
		Height 2;
		Radius 2;
		Speed 4;
		Scale 0.15;
		BounceType 'Doom';
		-NOGRAVITY
		+WINDTHRUST
		+MOVEWITHSECTOR
		+MISSILE
		-DROPOFF
		+NOTELEPORT
		+FORCEXYBILLBOARD
		+NOTDMATCH
		BounceCount 4;
		Mass 1;
	}
}

class CasingBase : Actor
{
	mixin CasingBehavior;
	
	Default
	{
		+CLIENTSIDEONLY;
		+NOBLOCKMAP;
		+GHOST;
	}
	
	States {
	Death:
		"####" "#" 1000;
		"####" "#" 0 A_DoDespawn;
		Loop;
	Fade:
		"####" "#" 1 A_FadeOut;
		Loop;
	}
	
	action State A_DoDespawn()
	{
		if(sv_no_casing_despawn)
		{
			return null;
		}
		return ResolveState("Fade");
	}
}
