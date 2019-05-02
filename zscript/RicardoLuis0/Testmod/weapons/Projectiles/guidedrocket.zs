class GuidedRocket:Rocket{
	bool alive;
	double rotspeed;
	double follow_limit;

	static const String colors[]={
		"#FF8000",
		"#FF8000",
		"#FF8000",
		"#FF8000",
		"#FFFF00",
		"#FFFF00",
		"#FFFF00",
		"#FF4000",
		"#FF4000",
		"#FF2000",
		"#FF1000"
	};

	static const String colors_smoke[]={
		"#808080",
		"#404040",
		"#404040"
	};

	action void A_ExplosionParticle(int particles,double strength,double size,double yaw_max=360,double pitch_max=360,double pitch_offset=0,double yaw_offset=0){
		for(int i=0;i<particles;i++){
			double r_yaw=yaw_offset+frandom(0,yaw_max);
			double r_pitch=pitch_offset+frandom(0,pitch_max);
			vector3 vel=invoker.angleToVec3(r_yaw,r_pitch,strength*frandom(0.75,1.5));
			A_SpawnParticle(invoker.colors[random(0,invoker.colors.Size()-1)],SPF_FULLBRIGHT,random(5,15),size*frandom(0.75,1.5),0,0,0,0,vel.x,vel.y,vel.z);
		}
	}

	action void A_ExplosionParticleFast(String color,int particles,double strength,double size,double yaw_max=360,double pitch_max=360,double pitch_offset=0,double yaw_offset=0){
		for(int i=0;i<particles;i++){
			double r_yaw=yaw_offset+frandom(0,yaw_max);
			double r_pitch=pitch_offset+frandom(0,pitch_max);
			vector3 vel=invoker.angleToVec3(r_yaw,r_pitch,strength);
			A_SpawnParticle(color,SPF_FULLBRIGHT,20,size,0,0,0,0,vel.x,vel.y,vel.z);
		}
	}

	action void A_SmokeParticle(int particles,double strength,double size,double yaw_max=360,double pitch_max=360,double pitch_offset=0,double yaw_offset=0){
		for(int i=0;i<particles;i++){
			double r_yaw=yaw_offset+frandom(0,yaw_max);
			double r_pitch=pitch_offset+frandom(0,pitch_max);
			vector3 vel=invoker.angleToVec3(r_yaw,r_pitch,strength*frandom(0.75,1.5));
			A_SpawnParticle(invoker.colors_smoke[random(0,invoker.colors_smoke.Size()-1)],SPF_FULLBRIGHT,random(5,15),size*frandom(0.75,1.5),0,0,0,0,vel.x,vel.y,vel.z,0,0,0.5);
		}
	}
	void recalculateVelocity(int speed){
		A_ChangeVelocity(cos(angle)*cos(pitch)*speed,sin(angle)*cos(pitch)*speed,sin(pitch)*speed,CVF_REPLACE);
	}
	/*
	default{
		-ROCKETTRAIL
		-GRENADETRAIL
	}
	*/
	override void BeginPlay(){
		super.BeginPlay();
		alive=true;
		rotspeed=5;
		CVar follow_limit_cv=CVar.FindCVar("guided_rocket_max_follow_angle");
		follow_limit=follow_limit_cv.GetFloat();
	}

	override void Tick(){
		super.Tick();
		if(alive){
			MyPlayer p=MyPlayer(GetPointer(AAPTR_TARGET));
			if(p){
				if(p.player!=null&&p.player.ReadyWeapon.getClass()=="GuidedRocketLauncher"&&GuidedRocketLauncher(p.player.ReadyWeapon).laserenabled){
					Vector3 lpos=p.getLookAtPos();
					double dx=lpos.x-pos.x;
					double dy=lpos.y-pos.y;
					double dz=lpos.z-pos.z;
					double targetangle=atan2(dy,dx);
					double targetpitch=-(atan2(sqrt(dy*dy+dx*dx),dz)-90);
					double adiff=DeltaAngle(angle,targetangle);
					double pdiff=DeltaAngle(pitch,targetpitch);
					if(abs(adiff)<=follow_limit&&abs(pdiff)<=follow_limit){
						if(abs(adiff)>rotspeed){
							angle+=(adiff>0)?rotspeed:-rotspeed;
						}else{
							angle+=adiff;
						}
						if(abs(pdiff)>rotspeed){
							pitch+=(pdiff>0)?rotspeed:-rotspeed;
						}else{
							pitch+=pdiff;
						}
						recalculateVelocity(20);
					}
				}
			}
		}
	}
	Default{
		Decal "Scorch";
	}
	States{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		TNT1 A 0{
			alive=false;
			A_Explode();
			A_ExplosionParticleFast("#FF4000",50,1,15);
			A_ExplosionParticleFast("#FFFF00",100,2,10);
			A_ExplosionParticleFast("#FF8000",350,5,5);
			/*
			A_ExplosionParticle(50,1,15);
			A_ExplosionParticle(100,2,10);
			A_ExplosionParticle(350,5,5);
			*/
			
		}
		/*
		MISL B 1 Bright A_ParticleExplode(10,2,10);
		MISL BB 1 Bright A_ParticleExplode(100,5,5);
		MISL B 1 Bright A_ParticleExplode(10,2,10);
		MISL BBBB 1 Bright A_ParticleExplode(100,5,5);
		*/
		MISL B 8 Bright;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	/*
	BrainExplode:
		MISL BC 10 Bright;
		MISL D 10 A_BrainExplode;
		Stop;
	*/
	}
}
