class ClipSpawner : ThingSpawner replaces Clip {

	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("FreshLightClip",1,4));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("FreshHeavyClip",1,1));
	}

}

class ClipBoxSpawner : ThingSpawner replaces ClipBox {

	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClipBox",1,1));
		//spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClipBox",1,2));
	}

}