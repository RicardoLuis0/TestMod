class TestModPlayer : DoomPlayer {
	
	bool grenade_key_pressed;
	bool melee_key_pressed;
	bool unload_key_pressed;
	
	
	void ClearActionKeys(){
		grenade_key_pressed=false;
		melee_key_pressed=false;
		unload_key_pressed=false;
	}
	
	bool invuse_key_down;
	
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
        
		Player.StartItem "Fist";
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
}