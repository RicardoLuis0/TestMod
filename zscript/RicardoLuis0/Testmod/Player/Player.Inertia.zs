class TeleportCheckerFogSrc : TeleportFog{
	override void PostBeginPlay(){
		if(target is "TestModPlayer"){
			TestModPlayer p=TestModPlayer(target);
			p.weaponinertia_is_teleporting=true;
			p.pre_teleport_xy=pos.xy;
		}
	}
}

class TeleportCheckerFogDest : TeleportDest{
	override void PostBeginPlay(){
		if(target is "TestModPlayer"){
			TestModPlayer p=TestModPlayer(target);
			p.weaponinertia_has_teleported=true;
			p.post_teleport_xy=pos.xy;
		}
	}
}

extend class TestModPlayer {
	Default{
		TeleFogSourceType "TeleportCheckerFogSrc";
		TeleFogDestType "TeleportCheckerFogDest";
	}
	
	bool weaponinertia_is_teleporting;
	bool weaponinertia_has_teleported;
	Vector2 pre_teleport_xy;
	Vector2 post_teleport_xy;
	
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
	double weaponinertia_zbob_scale;
	double weaponinertia_oldbob_scale_x;
	double weaponinertia_oldbob_scale_y;
	Array<double> weaponinertia_prevAP_angle;
	Array<double> weaponinertia_prevAP_pitch;
	Array<double> weaponinertia_prevMV_x;
	Array<double> weaponinertia_prevMV_y;
	Vector2 weaponinertia_prevbob;
	Vector2 weaponinertia_nextbob;
	Vector2 weaponinertia_prevmove;
	Vector2 weaponinertia_nextmove;
	int weaponinertia_prevtic;

	void updateTeleport(){
		int i;
		vector2 temp;
		double temp2;
		temp2=angle-weaponinertia_prevAP_angle[weaponinertia_prevAP_angle.size()-1];
		for(i=0;i<weaponinertia_prevAP_angle.size();i++){
			weaponinertia_prevAP_angle[i]+=temp2;
		}
		temp2=pitch-weaponinertia_prevAP_pitch[weaponinertia_prevAP_pitch.size()-1];
		for(i=0;i<weaponinertia_prevAP_pitch.size();i++){
			weaponinertia_prevAP_pitch[i]+=temp2;
		}
		temp=(post_teleport_xy-pre_teleport_xy);
		for(i=0;i<weaponinertia_prevMV_x.size();i++){
			weaponinertia_prevMV_x[i]+=temp.x;
		}
		for(i=0;i<weaponinertia_prevMV_y.size();i++){
			weaponinertia_prevMV_y[i]+=temp.y;
		}
		weaponinertia_has_teleported=false;
		weaponinertia_is_teleporting=false;
	}

	void initInertia(){
		weaponinertia_prevAP_angle.resize(5);
		weaponinertia_prevAP_pitch.resize(5);
		weaponinertia_prevMV_x.resize(5);
		weaponinertia_prevMV_y.resize(5);
		weaponinertia_prevbob=(0,0);
		weaponinertia_nextbob=(0,0);
		weaponinertia_prevtic=-1;
		weaponinertia_has_teleported=false;
		weaponinertia_is_teleporting=false;
		pre_teleport_xy=(0,0);
		post_teleport_xy=(0,0);
		weaponinertia_UpdateCVars();
	}

	vector2 weaponinertia_prevAP_average(){
		double avg_angle;
		double avg_pitch;
		double sum_sin;
		double sum_cos;
		int i;
		for(i=0,sum_sin=0,sum_cos=0;i<weaponinertia_prevAP_angle.size();i++){
			sum_sin+=sin(weaponinertia_prevAP_angle[i]);
			sum_cos+=cos(weaponinertia_prevAP_angle[i]);
		}
		avg_angle=atan2(sum_sin/weaponinertia_prevAP_angle.size(),sum_cos/weaponinertia_prevAP_angle.size());
		for(i=0,sum_sin=0,sum_cos=0;i<weaponinertia_prevAP_pitch.size();i++){
			sum_sin+=sin(weaponinertia_prevAP_pitch[i]);
			sum_cos+=cos(weaponinertia_prevAP_pitch[i]);
		}
		avg_pitch=atan2(sum_sin/weaponinertia_prevAP_pitch.size(),sum_cos/weaponinertia_prevAP_pitch.size());
		return (avg_angle,avg_pitch);
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

	vector2 vec2lerp(vector2 v1,vector2 v2,double f){
		return v1+f*(v2-v1);
	}

	vector2 getAnglePitch(){
		return (DeltaAngle(angle,0),DeltaAngle(pitch,0));
	}

	vector2 subRot(vector2 rot1,vector2 rot2){
		return (DeltaAngle(rot1.x,rot2.x),DeltaAngle(rot1.y,rot2.y));
	}

	vector2 getNextBob(){
		return subRot(weaponinertia_prevAP_average(),getAnglePitch())*weaponinertia_scale;
	}

	override vector2 BobWeapon(double ticfrac){
		double zbob=Player.ViewZ-ViewHeight-Pos.Z;
		if(weaponinertia_has_teleported&&weaponinertia_is_teleporting){
			updateTeleport();
		}
		if(gametic>weaponinertia_prevtic){
			weaponinertia_prevbob=weaponinertia_nextbob;
			if(!weaponinertia_has_teleported&&!weaponinertia_is_teleporting){
				weaponinertia_nextbob=getNextBob();
				weaponinertia_prevAP_add(getAnglePitch());
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
		}
		vector2 sway=vec2lerp(weaponinertia_prevbob,weaponinertia_nextbob,ticfrac);
		sway.y+=weaponinertia_y_offset;
		if(weaponinertia_invert_x_look){
			sway.x=-sway.x;
		}
		if(!weaponinertia_invert_y_look){
			sway.y=-sway.y;
		}
		if(weaponinertia_move_impulse){
			sway.y+=zbob*weaponinertia_zbob_scale;
			sway+=vec2lerp(weaponinertia_prevmove,weaponinertia_nextmove,ticfrac);
		}
		if(weaponinertia_old_movebob){
			Vector2 oldbob=super.BobWeapon(ticfrac);
			sway+=(oldbob.x*weaponinertia_oldbob_scale_x,oldbob.y*weaponinertia_oldbob_scale_y);
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
		weaponinertia_zbob_scale=CVar.GetCVar("cl_weaponinertia_zbob_scale",player).getFloat();
		weaponinertia_oldbob_scale_x=CVar.GetCVar("cl_weaponinertia_oldbob_scale_x",player).getFloat();
		weaponinertia_oldbob_scale_y=CVar.GetCVar("cl_weaponinertia_oldbob_scale_y",player).getFloat();
	}
}