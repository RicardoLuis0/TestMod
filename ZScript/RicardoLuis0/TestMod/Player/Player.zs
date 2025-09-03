class TestModPlayer : DoomPlayer
{
	bool grenade_key_pressed;
	bool melee_key_pressed;
	bool unload_key_pressed;

	void ClearActionKeys()
	{
		grenade_key_pressed=false;
		melee_key_pressed=false;
		unload_key_pressed=false;
	}
	
	bool invuse_key_down;
	
	mixin WeaponInertia;
	mixin LookPos;
	
	Default
	{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;
		
		Player.DisplayName "TestMod Player";
		
		Player.CrouchSprite "PLYC";
        
		Player.StartItem "Fist";
	}
	
	CVar do_railgun_light_fx;
	CVar simplified_railgun_light_fx;
	
	bool inited;

	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		
		if(inited) return;
		
		InertiaInit();
		UseToPickupInit();
		LookPosInit();
		
		do_railgun_light_fx = CVar.GetCVar("cl_do_railgun_light_fx",player);
		simplified_railgun_light_fx = CVar.GetCVar("cl_simplified_railgun_light_fx",player);
		
		inited = true;
	}

	override void Tick()
	{
		Super.Tick();
		if (!player || !player.mo || player.mo != self)
		{
			return;
		}
		if(!inited) PostBeginPlay();
		
		InertiaTick();
		if(!(player.cheats & CF_PREDICTING)) UseToPickupTick();
		if(!(player.cheats & CF_PREDICTING)) LookPosTick(); //TODO switch lookpos to not use puffs
		
		if(player.ReadyWeapon is "ModWeaponBase")
		{
			if(!(player.cheats & CF_PREDICTING)) ModWeaponBase(player.ReadyWeapon).ReadyTick();
			else ModWeaponBase(player.ReadyWeapon).PredictedReadyTick();
		}
	}

	override Vector2 BobWeapon(double ticfrac)
	{
		return WeaponInertiaBobWeapon(ticfrac);
	}
}