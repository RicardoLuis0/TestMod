class TestModHandler : StaticEventHandler {
	
	static ui void resetSingleCVar(string cvar_name){
		CVar.FindCVar(cvar_name).ResetToDefault();
	}
	
	static ui void resetInertiaCVars()
	{
		static const string inertiaCVars [] = {
			"cl_weaponinertia_move_impulse",
			"cl_weaponinertia_old_movebob",
			"cl_weaponinertia_invert_x_look",
			"cl_weaponinertia_invert_y_look",
			"cl_weaponinertia_move_forward_back_bidirectional",
			"cl_weaponinertia_scale",
			"cl_weaponinertia_movescale_x",
			"cl_weaponinertia_movescale_y",
			"cl_weaponinertia_y_offset",
			"cl_weaponinertia_min_y",
			"cl_weaponinertia_zbob_scale",
			"cl_weaponinertia_oldbob_scale_x",
			"cl_weaponinertia_oldbob_scale_y",
			"cl_weaponinertia_max_memory"
		};
		
		int n=inertiaCVars.size();
		
		for(int i=0;i<n;i++)
		{
			resetSingleCVar(inertiaCVars[i]);
		}
	}
	
	static ui void resetModCVars()
	{
		static const string modCVars [] = {
			"sv_guided_rocket_max_follow_angle",
			"sv_ssg_zombie_drop_ssg",
			"sv_plasmagun_extrafire",
			"sv_random_damage_mode",
			"sv_no_casing_despawn",
			"sv_rocket_selfdamage",
			"sv_incremental_backpack",
			"sv_incremental_backpack_max_multiplier",
			"sv_armorshard_full_refill",
			"sv_armorshard_requires_armor",
			"sv_player_start_pistol",
			"sv_player_start_smg",
			"sv_player_start_rifle",
			"sv_player_start_shotgun",
			"sv_player_start_extra_ammo",
			"sv_player_start_green_armor",
			"sv_player_start_portmed",
			"sv_magazine_weapon_ammo_auto_pickup",
			"sv_keep_empty_weapon_items",
			"cl_ssg_autoreload"
		};
		
		int n=modCVars.size();
		
		for(int i=0;i<n;i++)
		{
			resetSingleCVar(modCVars[i]);
		}
	}
	
	override void PlayerEntered(PlayerEvent e)
	{
		if(e.IsReturn || Level.MapTime < 1) return;
		foreach(ThingSpawner spawner : ThinkerIterator.Create("ThingSpawner"))
		{
			spawner.SpawnForPlayer(players[e.playernumber]);
		}
	}
	
	override void PlayerDisconnected(PlayerEvent e)
	{
		PlayerInfo p = players[e.playernumber];
		
		Array<Actor> toDestroy;
		
		foreach(Inventory item : ThinkerIterator.Create("Inventory"))
		{
			if(!item.owner && TestModUtil.GetPlayerRestrict(item) == p)
			{
				toDestroy.Push(item);
			}
		}
		
		foreach(item : toDestroy)
		{
			item.Destroy();
		}
	}
	
	override void InterfaceProcess(ConsoleEvent e)
	{
		if(e.name == "weaponinertia_ResetCVars")
		{
			resetInertiaCVars();
			
			console.printf("inertia cvars reset");
		}
		else if(e.name == "testMod_ResetCVars")
		{
			resetModCVars();
			
			console.printf("mod cvars reset");
		}
	}
	
	override void OnRegister(){
		OnRegisterCustomHUDDrawer();
		OnRegisterKeyHandler();
	}
	
	override void NetworkProcess(ConsoleEvent e){
		ProcessKeyNetEvent(e);
		ProcessTimeFreezeNetEvent(e);
	}
}