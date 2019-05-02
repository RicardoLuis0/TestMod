class MyRocket:Rocket replaces Rocket{
	action void A_RocketExplode(){
		A_Explode();
		
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
