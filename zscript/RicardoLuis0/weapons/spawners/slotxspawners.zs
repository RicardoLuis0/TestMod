
class Slot1Spawner:ClassRestrictedThingSpawner replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Melee1","Chaingun",1,1));
	}
}

class Slot3Spawner:ClassRestrictedThingSpawner replaces Shotgun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Shotguns","PumpShotgun",1,1));
	}
}

class Slot3Spawnerx:Slot3Spawner replaces SuperShotgun{}

class Slot4Spawner:ClassRestrictedThingSpawner replaces Chaingun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Heavy","HeavyGatlingGun",1,1));
	}
}
class Slot5Spawner:ClassRestrictedThingSpawner replaces RocketLauncher{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Explosives","MyRocketLauncher",1,4));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Explosives","GatlingRocketLauncher",1,1));
	}
}