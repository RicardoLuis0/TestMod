class InertiaInterpolationData{
	static InertiaInterpolationData make(Vector2 bob,Vector2 move){
		InertiaInterpolationData temp= new("InertiaInterpolationData");
		temp.bob=bob;
		temp.move=move;
		return temp;
	}
	Vector2 bob;
	Vector2 move;
}

extend class TestModPlayer {
	//config
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
	int weaponinertia_max_memory;
	//data
	Vector2 weaponinertia_prevbob;
	Vector2 weaponinertia_nextbob;
	Vector2 weaponinertia_prevmove;
	Vector2 weaponinertia_nextmove;
	Array<InertiaInterpolationData> weaponinertia_memory;

	const LOOKSCALE = 0.1;
	const MOVESCALE_Y = 0.5;
	void InertiaTick(){
		UserCmd cmd=player.cmd;
		Vector2 temp=weaponinertia_nextbob;
		weaponinertia_nextbob=(-(cmd.yaw/16),(cmd.pitch/16));
		weaponinertia_nextbob*=LOOKSCALE;
		weaponinertia_nextbob*=weaponinertia_scale;
		weaponinertia_prevbob=temp;
		temp=weaponinertia_nextmove;
		Vector2 mvec=RotateVector((vel.y,vel.x),angle);
		weaponinertia_nextmove.x=mvec.x*weaponinertia_movescale_x;//x
		weaponinertia_nextmove.y=mvec.y*weaponinertia_movescale_y;//y
		weaponinertia_nextmove.y+=vel.z*weaponinertia_movescale_y;//z
		weaponinertia_nextmove.y*=MOVESCALE_Y;
		weaponinertia_prevmove=temp;
		InertiaInterpolationData avg=weaponinertia_memory_average();
		weaponinertia_memory_add(InertiaInterpolationData.make(weaponinertia_nextbob,weaponinertia_nextmove));
		weaponinertia_nextbob+=avg.bob;
		if(!weaponinertia_move_forward_back_bidirectional){
			weaponinertia_nextmove.y=abs(weaponinertia_nextmove.y);
		}
		weaponinertia_nextmove+=avg.move;
	}

	void InertiaInit(){
		weaponinertia_UpdateCVars();
	}

	InertiaInterpolationData weaponinertia_memory_average(){
		InertiaInterpolationData acc=InertiaInterpolationData.make((0,0),(0,0));
		if(weaponinertia_move_forward_back_bidirectional){
			for(int i=0;i<weaponinertia_memory.size();i++){
				acc.bob+=weaponinertia_memory[i].bob;
				acc.move+=weaponinertia_memory[i].move;
			}
		}else{
			for(int i=0;i<weaponinertia_memory.size();i++){
				acc.bob+=weaponinertia_memory[i].bob;
				acc.move.x+=weaponinertia_memory[i].move.x;
				acc.move.y+=abs(weaponinertia_memory[i].move.y);
			}
		}
		
		acc.bob/=weaponinertia_memory.size();
		acc.move/=weaponinertia_memory.size();
		return acc;
	}

	void weaponinertia_memory_add(InertiaInterpolationData data){
		while(weaponinertia_memory.size()>weaponinertia_max_memory){
			weaponinertia_memory.pop();
		}
		weaponinertia_memory.insert(0,data);
	}

	void weaponinertia_ClearInertia(){
		weaponinertia_prevbob=(0,0);
		weaponinertia_nextbob=(0,0);
		weaponinertia_prevmove=(0,0);
		weaponinertia_nextmove=(0,0);
		weaponinertia_memory.clear();
	}

	Vector2 vec2lerp(Vector2 v1,Vector2 v2,double f){
		return v1+f*(v2-v1);
	}

	Vector2 getAnglePitch(){
		return (DeltaAngle(angle,0),DeltaAngle(pitch,0));
	}

	override Vector2 BobWeapon(double ticfrac){
		double zbob=0;//Player.ViewZ-ViewHeight-Pos.Z;
		Vector2 sway=vec2lerp(weaponinertia_prevbob,weaponinertia_nextbob,ticfrac);
		sway.y-=weaponinertia_y_offset;
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
		weaponinertia_max_memory=5;
		weaponinertia_ClearInertia();
	}
}