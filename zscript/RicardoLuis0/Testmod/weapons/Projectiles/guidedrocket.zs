class MyRocket:Rocket replaces Rocket{
	CVAR particle_density_modifier;
	override void BeginPlay(){
		particle_density_modifier=CVar.FindCVar("particle_density_modifier");
	}
	action void A_RocketExplode(){
		A_Explode();

		//MyWeapon.DoParticleExplosion(invoker,"#FFFF00",100,2,10);
		float mod=invoker.particle_density_modifier.getFloat();
		int count1=int(5*mod);
		int count2=int(10*mod);
		//color1
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,1,15,15);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,1.25,14.2,15);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,1.75,13.25,16);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,2,12.5,17);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,2.25,11.65,18);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,2.75,10.8,19);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count1,3,10,20);

		//color2
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count1,1,15,15);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count1,1.5,13.75,16);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count1,2,12.5,17);//--
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count1,2.5,11.75,18);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count1,3,10,20);

		//color3
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count1,1,15,15);
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count1,2,12.5,17);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count1,3,10,20);

		//color2
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count1,1,15,15);
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count1,2,12.5,17);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count1,3,10,20);

		//color1
		MyWeapon.DoParticleExplosion(invoker,"#FF1000",count1,2,12.5,17);//--

		//MyWeapon.DoParticleExplosion(invoker,"#FF8000",350,5,5);

		//color1
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,4,10,25);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,4.25,9.2,26);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,4.75,8.25,27);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,5,7.5,27);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,5.25,6.65,28);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,5.75,5.8,29);
		MyWeapon.DoParticleExplosion(invoker,"#FF8000",count2,6,5,30);

		//color2
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count2,4,10,25);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count2,5.5,8.75,26);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count2,5,7.5,27);//--
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count2,5.5,6.25,28);
		MyWeapon.DoParticleExplosion(invoker,"#FFFF00",count2,6,5,30);

		//color3
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count2,6,10,25);
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count2,5,7.5,27);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF4000",count2,6,5,30);

		//color4
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count2,6,10,25);
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count2,5,7.5,27);//--
		MyWeapon.DoParticleExplosion(invoker,"#FF2000",count2,4,5,30);

		//color5
		MyWeapon.DoParticleExplosion(invoker,"#FF1000",count2,5,7.5,27);//--
	}

	Default{
		Decal "Scorch";
	}
	States{
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		TNT1 A 0 A_RocketExplode();
		MISL B 8 Bright;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	}
}
class GuidedRocket:MyRocket{
	bool alive;
	double rotspeed;
	double follow_limit;

	void recalculateVelocity(int speed){
		A_ChangeVelocity(cos(angle)*cos(pitch)*speed,sin(angle)*cos(pitch)*speed,sin(pitch)*speed,CVF_REPLACE);
	}
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
			TestModPlayer p=TestModPlayer(target);
			if(p){
				if(p.player.ReadyWeapon.getClass()=="GuidedRocketLauncher"&&GuidedRocketLauncher(p.player.ReadyWeapon).laserenabled){
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
			A_RocketExplode();
			
		}
		MISL B 8 Bright;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	}
}
