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
			
			double line_hit_normal = diff > 0 ? line_angle - 90 : line_angle + 90;
			
			console.printf("hitLine, puff angle = "..angle.." line_angle = "..line_angle.." angle diff = "..diff.." line_hit_normal = "..line_hit_normal);
			
			A_SpawnParticle("FF0000",SPF_RELVEL|SPF_FULLBRIGHT,350,
				angle:line_hit_normal,
				velx:1
			);
			
		}
		
	}
	
}