class ClipSpawner : BasicThingSpawner replaces Clip {

	override void setDrops(){
		console.printf("ClipSpawner");
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",1,2));
	}

}

class ClipBoxSpawner : BasicThingSpawner replaces ClipBox {

	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClipBox",1,1));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClipBox",1,2));
	}

}