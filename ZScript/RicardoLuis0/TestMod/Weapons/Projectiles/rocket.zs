class MyRocket : Rocket {
	virtual void RocketExplode(){
		A_SetRenderStyle(0.75,STYLE_Add);
		A_Explode(ExplosionDamage,ExplosionRadius,flags:sv_rocket_selfdamage?XF_HURTSOURCE:0);
		float mod=0.5;
		int count1=int(5*mod);
		int count2=int(10*mod);
		float stren_mod=2;
		//color1
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1,15,15);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1.25,14.2,15);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*1.75,13.25,16);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2,12.5,17);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2.25,11.65,18);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*2.75,10.8,19);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count1,stren_mod*3,10,20);

		//color2
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*1,15,15);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*1.5,13.75,16);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*2,12.5,17);//--
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*2.5,11.75,18);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count1,stren_mod*3,10,20);

		//color3
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count1,stren_mod*1,15,15);
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count1,stren_mod*2,12.5,17);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count1,stren_mod*3,10,20);

		//color2
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count1,stren_mod*1,15,15);
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count1,stren_mod*2,12.5,17);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count1,stren_mod*3,10,20);

		//color1
		ModWeaponBase.DoParticleExplosion(self,"#FF1000",count1,stren_mod*2,12.5,17);//--

		//ModWeaponBase.DoParticleExplosion(self,"#FF8000",350,5,5);

		//color1
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4,10,25);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4.25,9.2,26);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*4.75,8.25,27);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5,7.5,27);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5.25,6.65,28);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*5.75,5.8,29);
		ModWeaponBase.DoParticleExplosion(self,"#FF8000",count2,stren_mod*6,5,30);

		//color2
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*4,10,25);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5.5,8.75,26);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5,7.5,27);//--
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*5.5,6.25,28);
		ModWeaponBase.DoParticleExplosion(self,"#FFFF00",count2,stren_mod*6,5,30);

		//color3
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count2,stren_mod*6,10,25);
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count2,stren_mod*5,7.5,27);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF4000",count2,stren_mod*6,5,30);

		//color4
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count2,stren_mod*6,10,25);
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count2,stren_mod*5,7.5,27);//--
		ModWeaponBase.DoParticleExplosion(self,"#FF2000",count2,stren_mod*4,5,30);

		//color5
		ModWeaponBase.DoParticleExplosion(self,"#FF1000",count2,stren_mod*5,7.5,27);//--
	}
	Default{
		Decal "Scorch";
		-DEHEXPLOSION;
		+FORCEXYBILLBOARD;
	}
	States {
	Spawn:
		MISL A 1 Bright;
		Loop;
	Death:
		MISL B 8 Bright RocketExplode();
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	}
}
class FastRocket:MyRocket {
	Default {
		Scale 0.75;
		Speed 50;
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

class SteerRocket:MyRocket {

	void recalculateVelocity(int speed){
		A_ChangeVelocity(cos(angle)*cos(pitch)*speed,sin(angle)*cos(pitch)*speed,sin(pitch)*speed,CVF_REPLACE);
	}

	void Steer(Vector3 tpos,double maxangle,double rotspeed){//should be called in "Tick" or comparable function; maxangle=max angle to steer,else keep straight; rotspeed=rotation speed
		double dx=tpos.x-pos.x;
		double dy=tpos.y-pos.y;
		double dz=tpos.z-pos.z;
		double targetangle=atan2(dy,dx);
		double targetpitch=-(atan2(sqrt(dy*dy+dx*dx),dz)-90);
		double adiff=DeltaAngle(angle,targetangle);
		double pdiff=DeltaAngle(pitch,targetpitch);
		if(abs(adiff)<=maxangle&&abs(pdiff)<=maxangle){
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

class GuidedRocket:SteerRocket{
	bool alive;
	double rotspeed;

	override void RocketExplode(){
		alive=false;
		super.RocketExplode();
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
					bool ok;
					Vector3 lookPos;
					[lookPos,ok]=p.getLookAtPos();
					if(ok){
						Steer(lookPos,sv_guided_rocket_max_follow_angle,rotspeed);
					}
				}
			}
		}
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
