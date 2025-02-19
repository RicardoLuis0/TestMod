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

mixin class WeaponInertia {
	//config
	CVar weaponinertia_move_impulse;
	CVar weaponinertia_old_movebob;
	CVar weaponinertia_invert_x_look;
	CVar weaponinertia_invert_y_look;
	CVar weaponinertia_move_forward_back_bidirectional;
	
	CVar weaponinertia_scale;
	CVar weaponinertia_movescale_x;
	CVar weaponinertia_movescale_y;
	CVar weaponinertia_y_offset;
	CVar weaponinertia_min_y;
	CVar weaponinertia_zbob_scale;
	CVar weaponinertia_oldbob_scale_x;
	CVar weaponinertia_oldbob_scale_y;
	
	int weaponinertia_max_memory_old;
	CVar weaponinertia_max_memory;
	
	double weaponinertia_zbob;
	//data
	Vector2 weaponinertia_prevbob;
	Vector2 weaponinertia_nextbob;
	Vector2 weaponinertia_prevmove;
	Vector2 weaponinertia_nextmove;
	Array<InertiaInterpolationData> weaponinertia_memory;

	const LOOKSCALE = 0.1;
	const MOVESCALE_Y = 0.5;
	void InertiaTick(){
		if(weaponinertia_max_memory_old != weaponinertia_max_memory.getInt())
		{
			weaponinertia_ClearInertia();
		}
		
		weaponinertia_zbob = player.bob * sin(Level.maptime / (20 * TICRATE / 35.) * 360.) * (waterlevel > 1 ? 0.25f : 0.5f);//from PlayerPawn::CalcHeight
		UserCmd cmd=player.cmd;
		Vector2 temp=weaponinertia_nextbob;
		weaponinertia_nextbob=(-(cmd.yaw/16),(cmd.pitch/16));
		weaponinertia_nextbob*=LOOKSCALE;
		weaponinertia_nextbob*=weaponinertia_scale.getFloat();
		weaponinertia_prevbob=temp;
		temp=weaponinertia_nextmove;
		Vector2 mvec=RotateVector((vel.y,vel.x),angle);
		weaponinertia_nextmove.x=mvec.x*weaponinertia_movescale_x.getFloat();//x
		weaponinertia_nextmove.y=mvec.y*weaponinertia_movescale_y.getFloat();//y
		weaponinertia_nextmove.y+=vel.z*weaponinertia_movescale_y.getFloat();//z
		weaponinertia_nextmove.y*=MOVESCALE_Y;
		weaponinertia_prevmove=temp;
		InertiaInterpolationData avg=weaponinertia_memory_average();
		weaponinertia_memory_add(InertiaInterpolationData.make(weaponinertia_nextbob,weaponinertia_nextmove));
		weaponinertia_nextbob+=avg.bob;
		if(!weaponinertia_move_forward_back_bidirectional.getBool()){
			weaponinertia_nextmove.y=abs(weaponinertia_nextmove.y);
		}
		weaponinertia_nextmove+=avg.move;
	}

	void InertiaInit()
	{
		weaponinertia_move_impulse=CVar.GetCVar("cl_weaponinertia_move_impulse",player);
		weaponinertia_old_movebob=CVar.GetCVar("cl_weaponinertia_old_movebob",player);
		weaponinertia_invert_x_look=CVar.GetCVar("cl_weaponinertia_invert_x_look",player);
		weaponinertia_invert_y_look=CVar.GetCVar("cl_weaponinertia_invert_y_look",player);
		weaponinertia_move_forward_back_bidirectional=CVar.GetCVar("cl_weaponinertia_move_forward_back_bidirectional",player);
		
		weaponinertia_scale=CVar.GetCVar("cl_weaponinertia_scale",player);
		weaponinertia_movescale_x=CVar.GetCVar("cl_weaponinertia_movescale_x",player);
		weaponinertia_movescale_y=CVar.GetCVar("cl_weaponinertia_movescale_y",player);
		weaponinertia_y_offset=CVar.GetCVar("cl_weaponinertia_y_offset",player);
		weaponinertia_min_y=CVar.GetCVar("cl_weaponinertia_min_y",player);
		weaponinertia_zbob_scale=CVar.GetCVar("cl_weaponinertia_zbob_scale",player);
		weaponinertia_oldbob_scale_x=CVar.GetCVar("cl_weaponinertia_oldbob_scale_x",player);
		weaponinertia_oldbob_scale_y=CVar.GetCVar("cl_weaponinertia_oldbob_scale_y",player);
		weaponinertia_max_memory=CVar.GetCVar("cl_weaponinertia_max_memory",player);
		
		weaponinertia_max_memory_old = weaponinertia_max_memory.getInt();
		
		weaponinertia_ClearInertia();
	}

	InertiaInterpolationData weaponinertia_memory_average(){
		InertiaInterpolationData acc=InertiaInterpolationData.make((0,0),(0,0));
		if(weaponinertia_move_forward_back_bidirectional.getBool()){
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
		while(weaponinertia_memory.size()>weaponinertia_max_memory.getInt()){
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
		weaponinertia_max_memory_old = weaponinertia_max_memory.getInt();
	}

	Vector2 vec2lerp(Vector2 v1,Vector2 v2,double f){
		return v1+f*(v2-v1);
	}

	Vector2 getAnglePitch(){
		return (DeltaAngle(angle,0),DeltaAngle(pitch,0));
	}

	Vector2 WeaponInertiaBobWeapon(double ticfrac){
		Vector2 sway=vec2lerp(weaponinertia_prevbob,weaponinertia_nextbob,ticfrac);
		sway.y-=weaponinertia_y_offset.getFloat();
		if(weaponinertia_invert_x_look.getBool()){
			sway.x=-sway.x;
		}
		if(!weaponinertia_invert_y_look.getBool()){
			sway.y=-sway.y;
		}
		if(weaponinertia_move_impulse.getBool()){
			sway.y+=weaponinertia_zbob*weaponinertia_zbob_scale.getFloat();
			sway+=vec2lerp(weaponinertia_prevmove,weaponinertia_nextmove,ticfrac);
		}
		if(weaponinertia_old_movebob.getBool()){
			Vector2 oldbob=super.BobWeapon(ticfrac);
			sway+=(oldbob.x*weaponinertia_oldbob_scale_x.getFloat(),oldbob.y*weaponinertia_oldbob_scale_y.getFloat());
		}
		if(sway.y<weaponinertia_min_y.getFloat())sway.y=weaponinertia_min_y.getFloat();
		return sway;
	}
	
	
	Vector2, Vector2 InertiaBobAim(){
		return (-weaponinertia_prevbob)/2, weaponinertia_prevmove;
	}
}


