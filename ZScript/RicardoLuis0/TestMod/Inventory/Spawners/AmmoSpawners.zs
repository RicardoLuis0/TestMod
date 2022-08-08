class ClipSpawner : ThingSpawner replaces Clip {

	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("FreshLightClip",1,3));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("FreshHeavyClip",1,1));
	}

}

class ClipBoxSpawner : ThingSpawner replaces ClipBox {

	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClipBox",1,6));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClipBox",1,1));
	}

}