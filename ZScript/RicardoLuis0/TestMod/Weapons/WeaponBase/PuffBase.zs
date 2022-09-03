class ModBulletPuffBase:BulletPuff {
	
	Default {
		-ALLOWPARTICLES;
		+PUFFGETSOWNER;
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		//console.printf("ModBulletPuffBase::PostBeginPlay");
	}
	
	void DoPuffFX(double firing_angle,Line hitLine){
		//console.printf("ModBulletPuffBase::DoPuffFX");
		if(hitLine){
			double line_angle = atan2(hitLine.delta.y,hitLine.delta.x);
			double diff=DeltaAngle(angle,line_angle);
			console.printf("hitLine, puff angle = "..angle.." line_angle = "..line_angle.." angle diff = "..diff);
			
			
			
			A_SpawnParticle("FF0000",SPF_RELVEL|SPF_FULLBRIGHT,350,
				angle:line_angle,
				velx:1
			);
		}
		
	}
	
}