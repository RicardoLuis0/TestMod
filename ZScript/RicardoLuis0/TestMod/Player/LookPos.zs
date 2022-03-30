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

mixin class LookPos {
	
	BulletPuff LineAttack_Straight(String puff="VisTracer",int flags=LAF_NORANDOMPUFFZ|LAF_NOINTERACT){
		return BulletPuff(LineAttack(angle,4096,pitch,0,"None",puff,flags));
	}
	
    bool lookPosCacheOk;
    Vector3 lookPosCache;
    
	bool getLookAtPos(out Vector3 lookPos,String puff="VisTracer"){//puff recommended to be derived from vistracer
		if(!lookPosCacheOk){
			BulletPuff p=BulletPuff(LineAttack(angle,4096,pitch,0,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT));
            if(p){
                lookPosCache=p.pos;
                lookPosCacheOk=true;
                p.destroy();
            }
		}
        if(lookPosCacheOk){
            lookPos=lookPosCache;
            return true;
        }else{
            return false;//could not get look position
        }
	}

	void LookPosInit(){
		lookPosCacheOk=false;
	}

	void LookPosTick(){
		lookPosCacheOk=false;
	}

}