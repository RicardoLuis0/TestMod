class ModBulletPuffBase:BulletPuff {
	
	Default {
		-ALLOWPARTICLES;
		+PUFFGETSOWNER;
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		//console.printf("ModBulletPuffBase::PostBeginPlay");
	}
	
	void DoPuffFX(Line hitLine){
		//console.printf("ModBulletPuffBase::DoPuffFX");
		if(hitLine){
			console.printf("hitLine");
		}
	}
	
}