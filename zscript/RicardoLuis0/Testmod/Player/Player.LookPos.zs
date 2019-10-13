extend class TestModPlayer {
	bool look_calc;
	Vector3 look_pos;

	BulletPuff LineAttack_Straight(String puff,int dmg,bool trueheight=false){
		if(trueheight){
			return BulletPuff(LineAttack(angle,4096,pitch,dmg,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT|LAF_OVERRIDEZ,offsetz:player.viewz-pos.z));
		}else{
			return BulletPuff(LineAttack(angle,4096,pitch,dmg,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT));
		}
	}

	Vector3 getLookAtPos(String puff="VisTracer"){//puff recommended to be derived from vistracer
		if(look_calc){
			return look_pos;
		}
		BulletPuff p=LineAttack_Straight(puff,0);
		if(p){
			Vector3 ret=p.pos;
			p.destroy();
			look_calc=true;
			look_pos=ret;
			return look_pos;
		}
		return pos;
	}

	void LookPosInit(){
		look_calc=false;
	}

	void LookPosTick(){
		look_calc=false;
	}

}