/*
class Slot1Spawner:BasicThingSpawnerElement replaces Chainsaw{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyChainsaw",1,1));
	}
}
*/

class Slot2Spawner : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPistol",1,1));
	}
}

class Slot3Spawner : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("PumpShotgun",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class Slot4Spawner : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SMG",1,6));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("AssaultRifle",1,3));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("Minigun",1,2));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyGatlingGun",1,1));
	}
}

class GatlingRocketLauncherSpawnerElement : MultiThingSpawnerElement {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GatlingRocketLauncher",1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("RocketBox",2,allow_dropped:false));
	}
}

class GuidedRocketLauncherSpawnerElement : MultiThingSpawnerElement {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("GuidedRocketLauncher",1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("RocketBox",1,allow_dropped:false));
	}
}

class Slot5Spawner : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("GuidedRocketLauncherSpawnerElement").Init(1,1));
		spawnlist.Push(new("GatlingRocketLauncherSpawnerElement").Init(1,1));
	}
}

class Slot6Spawner : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPlasmaRifle",1,1));
	}
}

class PistolSpawner:Slot2Spawner replaces Pistol{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPistol",1,1));
	}
}

class ShotgunSpawner : ThingSpawner replaces Shotgun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("PumpShotgun",1,3));
		if(sv_ssg_from_shotgun)spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class SuperShotgunSpawner : ThingSpawner replaces SuperShotgun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
	}
}

class ChaingunSpawner : ThingSpawner replaces Chaingun{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("Minigun",1,3));
	}
}

class RocketLauncherSpawner : ThingSpawner replaces RocketLauncher{
	override void setDrops(){
		spawnlist.Push(new("GuidedRocketLauncherSpawnerElement").Init(1,2));
		spawnlist.Push(new("GatlingRocketLauncherSpawnerElement").Init(1,1));
	}
}

class PlasmaRifleSpawner : ThingSpawner replaces PlasmaRifle{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MyPlasmaRifle",1,1));
	}
}