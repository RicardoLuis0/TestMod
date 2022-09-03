class ModBulletPuffBase:BulletPuff {
	
	Default {
		-ALLOWPARTICLES;
		+PUFFGETSOWNER;
	}
	
	override void PostBeginPlay(){
		super.PostBeginPlay();
		//console.printf("ModBulletPuffBase::PostBeginPlay");
	}
	
	void DoPuffFX(double firing_angle,Line hitLine,Actor hitActor){
		//console.printf("ModBulletPuffBase::DoPuffFX");
		
		//double inv_angle = angle;
		
		if(hitLine){
			double line_angle = atan2(hitLine.delta.y,hitLine.delta.x);
			double diff=DeltaAngle(angle,line_angle);
			
			double line_hit_normal = diff > 0 ? line_angle - 90 : line_angle + 90;
			
			//inv_angle = angle + (DeltaAngle(angle,line_hit_normal) * 2);
			
			/*
			A_SpawnParticle("FF0000",SPF_RELVEL|SPF_FULLBRIGHT,350,
				angle:inv_angle,
				velx:1
			);
			*/
			
			angle = line_hit_normal;
			
		} else if(!hitLine && target){
			//inv_angle = angle + DeltaAngle(angle,target.angle) * 2;
		}
		
		if(hitLine || hitActor){
		
			int num_particles = random[puff_fx](2,4);
			for(int i=0;i<num_particles;i++){
				A_SpawnParticle("FFFF00",SPF_RELATIVE|SPF_FULLBRIGHT,350,
					angle:frandom[puff_fx](-10,10),
					velx:frandom[puff_fx](3,5),
					velz:frandom[puff_fx](3,5),
					accelz:-1
				);
			}
			
		}
		/*
		angle = inv_angle;
		
		num_particles = random[puff_fx](5,8);
		for(int i=0;i<num_particles;i++){
			A_SpawnParticle("FFFF00",SPF_RELATIVE|SPF_FULLBRIGHT,350,
				angle:frandom[puff_fx](-10,10),
				velx:frandom[puff_fx](5,8),
				velz:frandom[puff_fx](3,5),
				accelz:-1
			);
		}
		*/
		
	}
	
}