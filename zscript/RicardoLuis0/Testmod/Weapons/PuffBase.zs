class PuffBase:BulletPuff {
	override void PostBeginPlay(){
		console.printf(target?"Target is not Null":"Target is Null");
		console.printf(master?"Master is not Null":"Master is Null");
		console.printf(tracer?"Tracer is not Null":"Tracer is Null");
	}
}