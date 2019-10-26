class VisTracer:BulletPuff{
	Default{
		+ALWAYSPUFF;
		+PUFFONACTORS;
		+BLOODLESSIMPACT;
		+DONTSPLASH;
		+NODECAL;
		-ALLOWPARTICLES;
		-RANDOMIZE;
		VSpeed 0;
	}
	States{
	Spawn:
		TNT1 A 0;
		Stop;
	}
}

extend class TestModPlayer {
	bool look_calc;
	Vector3 look_pos;
	
	void do_look_calc(Actor p){
		if(p){
			Vector3 ret=p.pos;
			look_calc=true;
			look_pos=ret;
		}
		look_calc=true;
	}
	
	BulletPuff LineAttack_Straight(String puff="VisTracer"){
		BulletPuff p=BulletPuff(LineAttack(angle,4096,pitch,0,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT));
		if(!look_calc){
			do_look_calc(p);
		}
		return p;
	}

	Vector3 getLookAtPos(String puff="VisTracer"){//puff recommended to be derived from vistracer
		if(!look_calc){
			BulletPuff p=LineAttack_Straight(puff);
			do_look_calc(p);
			p.destroy();
		}
		return look_pos;
	}

	void LookPosInit(){
		look_calc=false;
	}

	void LookPosTick(){
		look_calc=false;
	}

}