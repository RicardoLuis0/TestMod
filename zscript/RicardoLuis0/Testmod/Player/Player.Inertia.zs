extend class TestModPlayer{
	bool weaponinertia_look_impulse;
	bool weaponinertia_move_impulse;
	bool weaponinertia_old_movebob;
	bool weaponinertia_invert_x_look;
	bool weaponinertia_invert_y_look;
	bool weaponinertia_move_forward_back_bidirectional;
	double weaponinertia_movescale_x;
	double weaponinertia_movescale_y;
	double weaponinertia_scale;
	double weaponinertia_y_offset;
	double weaponinertia_min_y;
	double weaponinertia_zbob_amount;
	Array<double> weaponinertia_prevAP_angle;
	Array<double> weaponinertia_prevAP_pitch;
	Array<double> weaponinertia_prevMV_x;
	Array<double> weaponinertia_prevMV_y;
	Vector2 weaponinertia_prevbob;
	Vector2 weaponinertia_nextbob;
	Vector2 weaponinertia_prevmove;
	Vector2 weaponinertia_nextmove;
	int weaponinertia_prevtic;

	vector2 weaponinertia_prevAP_average(){
		double acc_angle;
		double acc_pitch;
		int i;
		for(i=0;i<weaponinertia_prevAP_angle.size();i++){
			acc_angle+=weaponinertia_prevAP_angle[i];
		}
		for(i=0;i<weaponinertia_prevAP_pitch.size();i++){
			acc_pitch+=weaponinertia_prevAP_pitch[i];
		}
		acc_angle/=weaponinertia_prevAP_angle.size();
		acc_pitch/=weaponinertia_prevAP_pitch.size();
		return (acc_angle,acc_pitch);
	}

	vector2 weaponinertia_prevMV_average(){
		double acc_x;
		double acc_y;
		int i;
		for(i=0;i<weaponinertia_prevMV_x.size();i++){
			acc_x+=weaponinertia_prevMV_x[i];
		}
		for(i=0;i<weaponinertia_prevMV_y.size();i++){
			acc_y+=weaponinertia_prevMV_y[i];
		}
		acc_x/=weaponinertia_prevMV_x.size();
		acc_y/=weaponinertia_prevMV_y.size();
		return (acc_x,acc_y);
	}

	void weaponinertia_prevAP_add(vector2 add){
		weaponinertia_prevAP_angle.pop();
		weaponinertia_prevAP_pitch.pop();
		weaponinertia_prevAP_angle.insert(0,add.x);
		weaponinertia_prevAP_pitch.insert(0,add.y);
	}

	void weaponinertia_prevMV_add(vector2 add){
		weaponinertia_prevMV_x.pop();
		weaponinertia_prevMV_y.pop();
		weaponinertia_prevMV_x.insert(0,add.x);
		weaponinertia_prevMV_y.insert(0,add.y);
	}

	void initInertia(){
		weaponinertia_prevAP_angle.resize(5);
		weaponinertia_prevAP_pitch.resize(5);
		weaponinertia_prevMV_x.resize(5);
		weaponinertia_prevMV_y.resize(5);
		weaponinertia_prevbob=(0,0);
		weaponinertia_nextbob=(0,0);
		weaponinertia_prevtic=-1;
		weaponinertia_UpdateCVars();
	}

	vector2 vec2lerp(vector2 v1,vector2 v2,double f){
		return v1+f*(v2-v1);
	}

	override vector2 BobWeapon (double ticfrac){
		double zbob=Player.ViewZ-ViewHeight-Pos.Z;
		bool extra_weapon_bob=CVar.GetCVar("cl_extra_weapon_bob",player).getBool();
		if(gametic>weaponinertia_prevtic){
			weaponinertia_prevbob=weaponinertia_nextbob;
			weaponinertia_nextbob=(weaponinertia_prevAP_average()-(angle,pitch))*weaponinertia_scale;
			weaponinertia_prevAP_add((angle,pitch));
			weaponinertia_prevtic=gametic;
			if(weaponinertia_move_impulse){
				weaponinertia_prevmove=weaponinertia_nextmove;
				weaponinertia_prevMV_add((vel.y,vel.x));
				weaponinertia_nextmove=RotateVector(weaponinertia_prevMV_average(),angle);
				weaponinertia_nextmove.x*=weaponinertia_movescale_x;
				weaponinertia_nextmove.y*=weaponinertia_movescale_y;
				if(!weaponinertia_move_forward_back_bidirectional)weaponinertia_nextmove.y=abs(weaponinertia_nextmove.y);
			}
		}
		vector2 sway=vec2lerp(weaponinertia_prevbob,weaponinertia_nextbob,ticfrac); //vec2lerp(weaponinertia_prevbob,weaponinertia_nextbob,ticfrac);
		sway.y+=weaponinertia_y_offset;
		if(weaponinertia_invert_x_look){
			sway.x=-sway.x;
		}
		if(!weaponinertia_invert_y_look){
			sway.y=-sway.y;
		}
		if(weaponinertia_move_impulse){
			sway.y+=zbob*weaponinertia_zbob_amount;
			sway+=vec2lerp(weaponinertia_prevmove,weaponinertia_nextmove,ticfrac);
		}
		if(weaponinertia_old_movebob){
			if(extra_weapon_bob)player.WeaponState|=WF_WEAPONBOBBING;
			sway+=super.BobWeapon(ticfrac);
		}
		if(sway.y<weaponinertia_min_y)sway.y=weaponinertia_min_y;
		return sway;
	}
	void weaponinertia_UpdateCVars(){
		weaponinertia_move_impulse=CVar.GetCVar("cl_weaponinertia_move_impulse",player).getBool();
		weaponinertia_old_movebob=CVar.GetCVar("cl_weaponinertia_old_movebob",player).getBool();
		weaponinertia_invert_x_look=CVar.GetCVar("cl_weaponinertia_invert_x_look",player).getBool();
		weaponinertia_invert_y_look=CVar.GetCVar("cl_weaponinertia_invert_y_look",player).getBool();
		weaponinertia_move_forward_back_bidirectional=CVar.GetCVar("cl_weaponinertia_move_forward_back_bidirectional",player).getBool();
		weaponinertia_scale=CVar.GetCVar("cl_weaponinertia_scale",player).getFloat();
		weaponinertia_movescale_x=CVar.GetCVar("cl_weaponinertia_movescale_x",player).getFloat();
		weaponinertia_movescale_y=CVar.GetCVar("cl_weaponinertia_movescale_y",player).getFloat();
		weaponinertia_y_offset=CVar.GetCVar("cl_weaponinertia_y_offset",player).getFloat();
		weaponinertia_min_y=CVar.GetCVar("cl_weaponinertia_min_y",player).getFloat();
		weaponinertia_zbob_amount=CVar.GetCVar("cl_weaponinertia_zbob_amount",player).getFloat();
	}
}