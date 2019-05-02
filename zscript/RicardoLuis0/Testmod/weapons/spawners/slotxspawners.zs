/*
class Slot1Spawner:ClassRestrictedThingSpawner replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Melee","MyChainsaw",1,1));
	}
}
*/

class Slot2Spawner:ClassRestrictedThingSpawner replaces Pistol{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Pistols","MyPistol",1,1));
	}
}

class Slot3Spawner:ClassRestrictedThingSpawner replaces Shotgun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Shotguns","PumpShotgun",1,1));
	}
}

class Slot3SpawnerX1:Slot3Spawner replaces SuperShotgun{}

class Slot4Spawner:ClassRestrictedThingSpawner replaces Chaingun{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Assault","AssaultRifle",1,1));
	}
}

class Slot5Spawner:ClassRestrictedThingSpawner replaces RocketLauncher{
	override void setDrops(){
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Explosives","GuidedRocketLauncher",1,1));
		spawnlist.Push(new("ClassRestrictedThingSpawnerElement").Init("Explosives","GatlingRocketLauncher",1,1));
	}
}