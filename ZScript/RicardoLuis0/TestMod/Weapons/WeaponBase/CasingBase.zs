class CasingBase : Actor {
	Default {
		Height 2;
		Radius 2;
		Speed 4;
		Scale 0.15;
		BounceType 'Doom';
		-NOGRAVITY
		+WINDTHRUST
		+CLIENTSIDEONLY
		+MOVEWITHSECTOR
		+MISSILE
		+NOBLOCKMAP
		-DROPOFF
		+NOTELEPORT
		+FORCEXYBILLBOARD
		+NOTDMATCH
		+GHOST
		BounceCount 4;
		Mass 1;
	}
	States {
	Death:
		"####" "#" 100;
		"####" "#" 0 A_DoDespawn;
		Loop;
	Fade:
		"####" "#" 1 A_FadeOut;
		Loop;
	}
	action State A_DoDespawn(){
			if(sv_no_casing_despawn){
				return null;
			}
			return ResolveState("Fade");
	}
	
}
