/*
class Slot1Spawner:BasicThingSpawnerElement replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyChainsaw",1,1));
	}
}
*/

class Slot2Spawner:BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPistol",1,1));
	}
}

class Slot3Spawner:BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("PumpShotgun",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class Slot4Spawner:BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("AssaultRifle",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("Minigun",1,3));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyGatlingGun",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SMG",1,1));
	}
}

class Slot5Spawner:BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GuidedRocketLauncher",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GatlingRocketLauncher",1,1));
	}
}

class Slot6Spawner:BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPlasmaRifle",1,1));
	}
}

class PistolSpawner:Slot2Spawner replaces Pistol{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPistol",1,1));
	}
}

class ShotgunSpawner:BasicThingSpawner replaces Shotgun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("PumpShotgun",1,3));
		if(sv_ssg_from_shotgun)spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class SuperShotgunSpawner:BasicThingSpawner replaces SuperShotgun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class ChaingunSpawner:BasicThingSpawner replaces Chaingun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("Minigun",1,3));
	}
}

class RocketLauncherSpawner:BasicThingSpawner replaces RocketLauncher{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GuidedRocketLauncher",1,2));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GatlingRocketLauncher",1,1));
	}
}

class PlasmaRifleSpawner:BasicThingSpawner replaces PlasmaRifle{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPlasmaRifle",1,1));
	}
}