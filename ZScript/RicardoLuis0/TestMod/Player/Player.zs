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

	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		InertiaInit();
		LookPosInit();
		
		do_railgun_light_fx = CVar.GetCVar("cl_do_railgun_light_fx",player);
		simplified_railgun_light_fx = CVar.GetCVar("cl_simplified_railgun_light_fx",player);
	}

	override void Tick()
	{
		Super.Tick();
		if (!player || !player.mo || player.mo != self)
		{
			return;
		}
		InertiaTick();
		LookPosTick();
		if(player.ReadyWeapon is "ModWeaponBase"){
			ModWeaponBase(player.ReadyWeapon).ReadyTick();
		}
	}

	override Vector2 BobWeapon(double ticfrac)
	{
		return WeaponInertiaBobWeapon(ticfrac);
	}
}