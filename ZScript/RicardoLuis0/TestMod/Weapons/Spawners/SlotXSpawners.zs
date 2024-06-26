/*
class Slot1Spawner:BasicThingSpawnerElement replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(BasicThingSpawnerElement.Create("MyChainsaw",1,1));
	}
}
*/

class AssaultRifleSpawnerElement : MultiThingSpawnerElement
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("AssaultRifle", 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("HeavyClip", 3, allow_dropped: false));
	}
	
	AssaultRifleSpawnerElement Init(int amount = 1,int weight = 1, bool allow_dropped = true)
	{
		Super.init(amount, weight, allow_dropped);
		return self;
	}
	
	static AssaultRifleSpawnerElement Create(int amount = 1,int weight = 1, bool allow_dropped = true)
	{
		return new("AssaultRifleSpawnerElement").Init(amount, weight, allow_dropped);
	}
}

class GatlingRocketLauncherSpawnerElement : MultiThingSpawnerElement
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("GatlingRocketLauncher", 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("RocketBox", 2, allow_dropped: false));
	}
	
	GatlingRocketLauncherSpawnerElement Init(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		Super.init(amount, weight, allow_dropped);
		return self;
	}
	
	static GatlingRocketLauncherSpawnerElement Create(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		return new("GatlingRocketLauncherSpawnerElement").Init(amount, weight, allow_dropped);
	}
}

class GuidedRocketLauncherSpawnerElement : MultiThingSpawnerElement
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("GuidedRocketLauncher", 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("RocketBox", 1, allow_dropped: false));
	}
	
	GuidedRocketLauncherSpawnerElement Init(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		Super.init(amount, weight, allow_dropped);
		return self;
	}
	
	static GuidedRocketLauncherSpawnerElement Create(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		return new("GuidedRocketLauncherSpawnerElement").Init(amount, weight, allow_dropped);
	}
}

class SmartGunSpawnerElement : MultiThingSpawnerElement
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("Smartgun", 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("HeavyClipBox", 1, allow_dropped: false));
	}
	
	SmartGunSpawnerElement Init(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		Super.init(amount, weight, allow_dropped);
		return self;
	}
	
	static SmartGunSpawnerElement Create(int amount = 1, int weight = 1, bool allow_dropped = true)
	{
		return new("SmartGunSpawnerElement").Init(amount, weight, allow_dropped);
	}
}

class Slot2Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("NewPistol", 1, 1));
	}
}

class Slot3Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("AutoShotgun", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("PumpShotgun", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("SSG", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("HeavyGatlingShotgun", 1, 1));
	}
}

class Slot4Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("SMG", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("AssaultRifle", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("Minigun", 1, 1));
	}
}

class Slot5Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(GuidedRocketLauncherSpawnerElement.Create(1, 1));
		spawnlist.Push(GatlingRocketLauncherSpawnerElement.Create(1, 1));
	}
}

class Slot6Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("MyPlasmaRifle", 1, 1));
	}
}

class Slot7Spawner : ThingSpawner
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("BFG", 1, 1));
	}
}

class PistolSpawner : ThingSpawner replaces Pistol
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("NewPistol", 1, 1));
	}
}

class ShotgunSpawner : ThingSpawner replaces Shotgun
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("PumpShotgun", 1, deathmatch ? 1 : 8));
		if(!bDropped)
		{
			spawnlist.Push(BasicThingSpawnerElement.Create("AutoShotgun", 1, 1));
			spawnlist.Push(BasicThingSpawnerElement.Create("HeavyGatlingShotgun", 1, 1));
			if(deathmatch)
			{
				spawnlist.Push(AssaultRifleSpawnerElement.Create(1, 1));
			}
		}
	}
}

class SuperShotgunSpawner : ThingSpawner replaces SuperShotgun
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("SSG", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("AutoShotgun", 1, 1));
	}
}

class ChaingunSpawner : ThingSpawner replaces Chaingun
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("Minigun", 1, 20));
		if(!bDropped)
		{
			spawnlist.Push(BasicThingSpawnerElement.Create("HeavyGatlingShotgun", 1, 4));
			spawnlist.Push(BasicThingSpawnerElement.Create("SmartGun", 1, 1));
			if(deathmatch)
			{
				spawnlist.Push(AssaultRifleSpawnerElement.Create(1, 20));
			}
		}
	}
}

class RocketLauncherSpawner : ThingSpawner replaces RocketLauncher
{
	override void setDrops()
	{
		spawnlist.Push(GuidedRocketLauncherSpawnerElement.Create(1, 2));
		spawnlist.Push(GatlingRocketLauncherSpawnerElement.Create(1, 1));
	}
}

class PlasmaRifleSpawner : ThingSpawner replaces PlasmaRifle
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("MyPlasmaRifle", 1, 1));
	}
}

class BFGSpawner : ThingSpawner replaces BFG9000
{
	override void setDrops()
	{
		spawnlist.Push(BasicThingSpawnerElement.Create("BFG", 1, 1));
		spawnlist.Push(BasicThingSpawnerElement.Create("Railgun", 1, 1));
		spawnlist.Push(SmartGunSpawnerElement.Create(1, 1));
	}
}