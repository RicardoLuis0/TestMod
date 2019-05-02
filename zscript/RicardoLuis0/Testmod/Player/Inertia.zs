extend class TestModPlayer{
	bool weaponsway_old_movebob;
	bool weaponsway_invert_x_look;
	bool weaponsway_invert_y_look;
	bool weaponsway_move_forward_back_bidirectional;
	double weaponsway_movescale_x;
	double weaponsway_movescale_y;
	double weaponsway_scale;
	double weaponsway_y_offset;
	double weaponsway_min_y;
	Array<double> weaponsway_prevAP_angle;
	Array<double> weaponsway_prevAP_pitch;
	Array<double> weaponsway_prevMV_x;
	Array<double> weaponsway_prevMV_y;
	Vector2 weaponsway_prevbob;
	Vector2 weaponsway_nextbob;
	Vector2 weaponsway_prevmove;
	Vector2 weaponsway_nextmove;
	int weaponsway_prevtic;
	void update_Cvars(){
		
	}
	vector2 weaponsway_prevAP_average(){
		double acc_angle;
		double acc_pitch;
		int i;
		for(i=0;i<weaponsway_prevAP_angle.size();i++){
			acc_angle+=weaponsway_prevAP_angle[i];
		}
		for(i=0;i<weaponsway_prevAP_pitch.size();i++){
			acc_pitch+=weaponsway_prevAP_pitch[i];
		}
		acc_angle/=weaponsway_prevAP_angle.size();
		acc_pitch/=weaponsway_prevAP_pitch.size();
		return (acc_angle,acc_pitch);
	}

	vector2 weaponsway_prevMV_average(){
		double acc_x;
		double acc_y;
		int i;
		for(i=0;i<weaponsway_prevMV_x.size();i++){
			acc_x+=weaponsway_prevMV_x[i];
		}
		for(i=0;i<weaponsway_prevMV_y.size();i++){
			acc_y+=weaponsway_prevMV_y[i];
		}
		acc_x/=weaponsway_prevMV_x.size();
		acc_y/=weaponsway_prevMV_y.size();
		return (acc_x,acc_y);
	}

	void weaponsway_prevAP_add(vector2 add){
		weaponsway_prevAP_angle.pop();
		weaponsway_prevAP_pitch.pop();
		weaponsway_prevAP_angle.insert(0,add.x);
		weaponsway_prevAP_pitch.insert(0,add.y);
	}

	void weaponsway_prevMV_add(vector2 add){
		weaponsway_prevMV_x.pop();
		weaponsway_prevMV_y.pop();
		weaponsway_prevMV_x.insert(0,add.x);
		weaponsway_prevMV_y.insert(0,add.y);
	}

	void initSway(){
		weaponsway_old_movebob=false;
		weaponsway_invert_x_look=false;
		weaponsway_invert_y_look=false;
		weaponsway_move_forward_back_bidirectional=false;
		weaponsway_scale=0.25;
		weaponsway_movescale_x=1;
		weaponsway_movescale_y=1;
		weaponsway_y_offset=5;
		weaponsway_min_y=0;
		weaponsway_prevAP_angle.resize(5);
		weaponsway_prevAP_pitch.resize(5);
		weaponsway_prevMV_x.resize(5);
		weaponsway_prevMV_y.resize(5);
		weaponsway_prevbob=(0,0);
		weaponsway_nextbob=(0,0);
		weaponsway_prevtic=0;
	}

	vector2 vec2lerp(vector2 v1,vector2 v2,double f){
		return v1+f*(v2-v1);
	}

	override vector2 BobWeapon (double ticfrac){
		double zbob=Pos.Z-Player.ViewZ;
		bool extra_weapon_bob=CVar.findCVar("extra_weapon_bob").getBool();
		if(gametic>weaponsway_prevtic){
			weaponsway_prevbob=weaponsway_nextbob;
			weaponsway_nextbob=(weaponsway_prevAP_average()-(angle,pitch))*weaponsway_scale;
			weaponsway_prevAP_add((angle,pitch));
			weaponsway_prevtic=gametic;
			if(!weaponsway_old_movebob/*&&(extra_weapon_bob||player.WeaponState&WF_WEAPONBOBBING)*/){
				weaponsway_prevmove=weaponsway_nextmove;
				weaponsway_prevMV_add((vel.y,vel.x));
				weaponsway_nextmove=RotateVector(weaponsway_prevMV_average(),angle);
				weaponsway_nextmove.x*=weaponsway_movescale_x;
				weaponsway_nextmove.y*=weaponsway_movescale_y;
				if(!weaponsway_move_forward_back_bidirectional)weaponsway_nextmove.y=abs(weaponsway_nextmove.y);
				//sway+=vel*weaponsway_movescale;
				//sway.x+=rv.x*weaponsway_movescale_x;
				//sway.y+=abs(rv.y*weaponsway_movescale_y);
			}
		}
		vector2 sway=vec2lerp(weaponsway_prevbob,weaponsway_nextbob,ticfrac); //vec2lerp(weaponsway_prevbob,weaponsway_nextbob,ticfrac);
		if(weaponsway_invert_x_look){
			sway.x=-sway.x;
		}
		if(!weaponsway_invert_y_look){
			sway.y=-sway.y;
		}
		if(weaponsway_old_movebob){//use vanilla weapon bob
			if(extra_weapon_bob)player.WeaponState|=WF_WEAPONBOBBING;//always bob
			sway+=super.BobWeapon(ticfrac);
		}else /*if(extra_weapon_bob||player.WeaponState&WF_WEAPONBOBBING)*/{
			sway+=vec2lerp(weaponsway_prevmove,weaponsway_nextmove,ticfrac);
		}
		sway.y+=weaponsway_y_offset;
		if(sway.y<weaponsway_min_y)sway.y=weaponsway_min_y;
		return sway;
	}
}