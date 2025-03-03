class ThingSpawnerElement abstract
{
	int actor_weight;
	bool actor_allow_dropped;
	ThingSpawnerElement Init(int weight, bool allow_dropped)
	{
		actor_weight = weight;
		actor_allow_dropped = allow_dropped;
		return self;
	}
	
	play virtual bool DoSpawn(Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		return false;
	}
	
	virtual bool IsEmpty()
	{
		return false;
	}
}

class ThingSpawner : Actor abstract
{
	static bool SpawnActor(class<Actor> a_class, int replace, Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		if(!a_class)
		{
			console.printf("\c[red] Unexpected Null 'a_class' in ThingSpawner::spawnactor");
			return false;
		}
		
		Actor obj = Spawn(a_class, pos, replace);
		
		if(obj)
		{
			obj.vel = vel;
			obj.bDropped = bDropped;
			
			float ammoFactor = G_SkillPropertyFloat(bDropped? SKILLP_DropAmmoFactor : SKILLP_AmmoFactor);
			
			if(ammoFactor < 0)
			{
				ammoFactor = 0.5;
			}
			
			if(obj is "Ammo")
			{
				Ammo a_obj = Ammo(obj);
				a_obj.amount = int(a_obj.amount * ammoFactor);
			}
			else if(obj is "Weapon")
			{
				Weapon w_obj = Weapon(obj);
				w_obj.ammoGive1 = int(w_obj.ammoGive1 * ammoFactor);
				w_obj.ammoGive2 = int(w_obj.ammoGive2 * ammoFactor);
			}
			
			spawned.Push(obj);
			
			return true;
		}
		
		return false;
	}

	Array<ThingSpawnerElement> spawnlist;
	int max_weight;

	int ArrayMaxWeight()
	{
		int total = 0;
		
		for(int i = 0; i < spawnlist.Size(); i++)
		{
			if(!bDropped || spawnlist[i].actor_allow_dropped)
			{
				total += spawnlist[i].actor_weight;
			}
		}
		
		return total;
	}

	ThingSpawnerElement GetFromWeight(int weight)
	{
		int total = 0;
		
		for(int i = 0; i < spawnlist.Size(); i++)
		{
			if(!bDropped || spawnlist[i].actor_allow_dropped)
			{
				total += spawnlist[i].actor_weight;
				if(total >= weight)
				{
					return spawnlist[i];
				}
			}
		}
		
		return null;
	}
	
	abstract void SetDrops();

	bool DoSpawn(Array<Actor> spawned)
	{
		int weight = random[ThingSpawnerWeight](0, max_weight);
		
		ThingSpawnerElement toSpawn = GetFromWeight(weight);

		if(!toSpawn) return false;

		if(toSpawn.IsEmpty()) return true;
		
		return toSpawn.DoSpawn(pos, vel, bDropped, spawned);
	}

	bool initialized;
	
	override void PostBeginPlay()
	{
		super.PostBeginPlay();
		
		if(!initialized)
		{
			SetDrops();
			max_weight = ArrayMaxWeight();
			initialized = true;
		}
		
		if(sv_per_player_rolls)
		{
			for(int i = 0; i < MAXPLAYERS; i++)
			{
				if(playeringame[i])
				{
					SpawnForPlayer(players[i]);
				}
			}
		}
		else
		{
			Array<Actor> spawned;
			
			if(!DoSpawn(spawned))
			{
				console.printf("\c[Red] Error Spawning Drops for "..GetClassName());
			}
			
			Destroy();
		}
		
	}
	
	void SpawnForPlayer(PlayerInfo player)
	{
		if(!initialized)
		{
			ThrowAbortException("SpawnForPlayer called too early in ThingSpawner");
		}
		Array<Actor> spawned;
		
		if(!DoSpawn(spawned))
		{
			console.printf("\c[Red] Error Spawning Drops for "..GetClassName());
			return;
		}
		
		foreach(item : spawned)
		{
			TestModUtil.SetPlayerRestrict(item, player);
		}
	}
}

class EmptyThingSpawnerElement : ThingSpawnerElement final
{
	EmptyThingSpawnerElement Init(int weight = 1,bool allow_dropped = true)
	{
		super.Init(weight,allow_dropped);
		return self;
	}
	
	override bool IsEmpty()
	{
		return true;
	}
	
	override bool DoSpawn(Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		return true;
	}
}

class BasicThingSpawnerElement : ThingSpawnerElement final
{
	class<Actor> actor_class;
	int actor_amount;
	int actor_replace;
	
	BasicThingSpawnerElement Init(class<Actor> a_class, int amount = 1,int weight = 1, int replace = ALLOW_REPLACE, bool allow_dropped = true)
	{
		super.Init(weight, allow_dropped);
		actor_class = a_class;
		actor_amount = amount;
		actor_replace = replace;
		return self;
	}
	
	static BasicThingSpawnerElement Create(class<Actor> a_class, int amount = 1, int weight = 1, int replace = ALLOW_REPLACE, bool allow_dropped = true){
		return new("BasicThingSpawnerElement").Init(a_class, amount, weight, replace, allow_dropped);
	}
	
	override bool DoSpawn(Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		if(actor_amount == 1)
		{
			return ThingSpawner.SpawnActor(actor_class, actor_replace, pos, vel, bDropped, spawned);
		}
		else
		{
			for(int i = 0; i < actor_amount; i++)
			{
				Vector3 spawn_vel = vel + (frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](1,2));
				if(!ThingSpawner.SpawnActor(actor_class, actor_replace, pos, spawn_vel, bDropped, spawned)) return false;
			}
			return true;
		}
	}
}

class MultiThingSpawnerElement : ThingSpawnerElement abstract
{
	Array<ThingSpawnerElement> spawnlist;
	int actor_amount;

	abstract void SetDrops();//weight ignored
	
	MultiThingSpawnerElement Init(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		Super.Init(weight,allow_dropped);
		actor_amount=amount;
		SetDrops();
		return self;
	}
	
	int CountList(bool bDropped)
	{
		int total = 0;
		
		for(int i = 0; i < spawnlist.Size(); i++)
		{
			if(!bDropped || spawnlist[i].actor_allow_dropped)
			{
				total++;
			}
		}
		return total;
	}
	
	play bool DoSpawnList(Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		int count = CountList(bDropped);
		
		if(count == 0)
		{
			return true;
		}
		else if(count == 1)
		{
			for(int i = 0; i < spawnlist.Size(); i++)
			{
				if(!bDropped || spawnlist[i].actor_allow_dropped)
				{
					return spawnlist[i].DoSpawn(pos, vel, bDropped, spawned);
				}
			}
			return false;
		}
		else
		{
			for(int i = 0; i < spawnlist.Size(); i++)
			{
				if(!bDropped || spawnlist[i].actor_allow_dropped)
				{
					Vector3 spawn_vel = vel + (frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](1,2));
					if(!spawnlist[i].DoSpawn(pos, spawn_vel, bDropped, spawned))return false;
				}
			}
			return true;
		}
	}
	
	override bool DoSpawn(Vector3 pos, Vector3 vel, bool bDropped, Array<Actor> spawned)
	{
		if(actor_amount == 1)
		{
			return DoSpawnList(pos, vel, bDropped, spawned);
		}
		else
		{
			for(int i = 0; i < actor_amount; i++)
			{
				Vector3 spawn_vel = vel + (frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](-1,1), frandom[ThingSpawnerVel](1,2));
				if(!DoSpawnList(pos, spawn_vel, bDropped, spawned))return false;
			}
			return true;
		}
	}
	
}

