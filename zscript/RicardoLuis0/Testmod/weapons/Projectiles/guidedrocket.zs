class MyRocket:Rocket{
	virtual void RocketExplode(){
		A_SetRenderStyle(0.75,STYLE_Add);
		A_Explode();
		float mod=0.5;//particle_density_modifier.getFloat();
		int count1=int(5*mod);
		int count2=int(10*mod);
		float stren_mod=2;
		//color1
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1,15,15);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1.25,14.2,15);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1.75,13.25,16);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2,12.5,17);//--
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2.25,11.65,18);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2.75,10.8,19);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count1,stren_mod*3,10,20);

		//color2
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*1,15,15);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*1.5,13.75,16);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*2,12.5,17);//--
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*2.5,11.75,18);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*3,10,20);

		//color3
		MyWeapon.DoParticleExplosion(self,"#FF4000",count1,stren_mod*1,15,15);
		MyWeapon.DoParticleExplosion(self,"#FF4000",count1,stren_mod*2,12.5,17);//--
		MyWeapon.DoParticleExplosion(self,"#FF4000",count1,stren_mod*3,10,20);

		//color2
		MyWeapon.DoParticleExplosion(self,"#FF2000",count1,stren_mod*1,15,15);
		MyWeapon.DoParticleExplosion(self,"#FF2000",count1,stren_mod*2,12.5,17);//--
		MyWeapon.DoParticleExplosion(self,"#FF2000",count1,stren_mod*3,10,20);

		//color1
		MyWeapon.DoParticleExplosion(self,"#FF1000",count1,stren_mod*2,12.5,17);//--

		//MyWeapon.DoParticleExplosion(self,"#FF8000",350,5,5);

		//color1
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4,10,25);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4.25,9.2,26);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4.75,8.25,27);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5,7.5,27);//--
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5.25,6.65,28);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5.75,5.8,29);
		MyWeapon.DoParticleExplosion(self,"#FF8000",count2,stren_mod*6,5,30);

		//color2
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*4,10,25);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5.5,8.75,26);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5,7.5,27);//--
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5.5,6.25,28);
		MyWeapon.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*6,5,30);

		//color3
		MyWeapon.DoParticleExplosion(self,"#FF4000",count2,stren_mod*6,10,25);
		MyWeapon.DoParticleExplosion(self,"#FF4000",count2,stren_mod*5,7.5,27);//--
		MyWeapon.DoParticleExplosion(self,"#FF4000",count2,stren_mod*6,5,30);

		//color4
		MyWeapon.DoParticleExplosion(self,"#FF2000",count2,stren_mod*6,10,25);
		MyWeapon.DoParticleExplosion(self,"#FF2000",count2,stren_mod*5,7.5,27);//--
		MyWeapon.DoParticleExplosion(self,"#FF2000",count2,stren_mod*4,5,30);

		//color5
		MyWeapon.DoParticleExplosion(self,"#FF1000",count2,stren_mod*5,7.5,27);//--
	}

	Default{
		Decal "Scorch";
		-DEHEXPLOSION;
	}
	States{
	Spawn:
		RCKT A 1 Bright;
		Loop;
	Death:
		RCKT B 4 Bright RocketExplode();
		RCKT CD 3 Bright;
		RCKT EF 2 Bright A_FadeOut(0.25);
		Stop;
	}
}
class GuidedRocket:MyRocket{
	bool alive;
	double rotspeed;
	double follow_limit;

	override void RocketExplode(){
		alive=false;
		super.RocketExplode();
	}

	void recalculateVelocity(int speed){
		A_ChangeVelocity(cos(angle)*cos(pitch)*speed,sin(angle)*cos(pitch)*speed,sin(pitch)*speed,CVF_REPLACE);
	}

	override void BeginPlay(){
		super.BeginPlay();
		alive=true;
		rotspeed=5;
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
					if(abs(adiff)<=sv_guided_rocket_max_follow_angle&&abs(pdiff)<=sv_guided_rocket_max_follow_angle){
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
		RCKT A 1 Bright;
		Loop;
	Death:
		RCKT B 4 Bright RocketExplode();
		RCKT CD 3 Bright;
		RCKT EF 2 Bright A_FadeOut(0.25);
		Stop;
	}
}
