class GuidedRocket:Rocket{
	bool alive;
	double rotspeed;
	double follow_limit;

	double mod(double a,int n){
		return a-(floor(a/n)*n);
	}

	double anglediff(double a1,double a2){
		//thanks to https://stackoverflow.com/a/7869457
		return mod((a2-a1)+180,360)-180;
	}

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
		class<Object> weaponclass="GuidedRocketLauncher";
		super.Tick();
		if(alive){
			MyPlayer p=MyPlayer(GetPointer(AAPTR_TARGET));
			if(p){
				if(p.player!=null&&p.player.ReadyWeapon.getClass()==weaponclass){
					Vector3 lpos=p.getLookAtPos();
					double dx=lpos.x-pos.x;
					double dy=lpos.y-pos.y;
					double dz=lpos.z-pos.z;
					double targetangle=atan2(dy,dx);
					double targetpitch=-(atan2(sqrt(dx*dx+dy*dy),dz)-90);
					//angle=targetangle;
					//pitch=targetpitch;
					double adiff=anglediff(angle,targetangle);
					double pdiff=anglediff(pitch,targetpitch);
					//console.printf("angle:%f,targetangle:%f,pitch:%f,targetpitch:%f,adiff: %f,pdiff: %f",angle,targetangle,pitch,targetpitch,adiff,pdiff);
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
		}
		MISL B 8 Bright A_Explode;
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
