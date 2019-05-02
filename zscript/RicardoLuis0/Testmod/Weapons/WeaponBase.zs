class MyWeapon:Weapon{
	bool extra_weapon_bob;
	string glow;
	string noglow;
	bool lastbright;
	property glow:glow;
	property noglow:noglow;
	Default{
		Decal "BulletChip";
		MyWeapon.glow "HoverGlow";
		MyWeapon.noglow "None";
	}

	static Vector3 angleToVec3(double a_yaw,double a_pitch,double length=1){
		Vector3 o;
		o.x=cos(a_pitch)*cos(a_yaw);
		o.y=cos(a_pitch)*sin(a_yaw);
		o.z=-sin(a_pitch);
		return o*length;
	}

	static void DoParticleExplosion(actor origin,string x_color,int count,double strength,double size,int lifetime=20){
		for(int i=0;i<count;i++){
			double r_yaw=random(0,360);
			double r_pitch=random(0,360);
			vector3 vel=angleToVec3(r_yaw,r_pitch,strength);
			origin.A_SpawnParticle(x_color,SPF_FULLBRIGHT,lifetime,size,0,0,0,0,vel.x,vel.y,vel.z);
		}
	}

	action void W_FireBullets(double spread_horiz, double spread_vert, int count, int dmg, class<Actor> puff = "PuffBase", int flags = 1, double range = 0, class<Actor> missile = null, double vert_offset = 32, double horiz_offset = 0){
		if(flags&FBF_NORANDOM){
			A_FireBullets(spread_horiz,spread_vert,count,dmg,puff,flags,range,missile,vert_offset,horiz_offset);
		}else{
			switch(sv_random_damage_mode){
			default:
			case 0://doom type random
				A_FireBullets(spread_horiz,spread_vert,count,dmg,puff,flags,range,missile,vert_offset,horiz_offset);
				break;
			case 1://full random
				A_FireBullets(spread_horiz,spread_vert,count,random(dmg,dmg*3),puff,flags|FBF_NORANDOM,range,missile,vert_offset,horiz_offset);
				break;
			case 2://no random
				A_FireBullets(spread_horiz,spread_vert,count,dmg*2,puff,flags|FBF_NORANDOM,range,missile,vert_offset,horiz_offset);
				break;
			}
		}
	}
	virtual void GlowStart(){
		A_SetTranslation(glow);
		lastbright=bBright;
		bBright=true;
	}
	
	virtual void GlowEnd(){
		A_SetTranslation(noglow);
		bBright=lastbright;
	}
	
	Array<State> call_stack;

	action State P_Call(StateLabel go_to,int layer=PSP_WEAPON){
		State st=invoker.PSP_GetState(layer);
		if(st){
			invoker.call_stack.push(st.nextState);
			return ResolveState(go_to);
		}else{
			return null;
		}
	}
	
	action State P_Call2(StateLabel go_to,StateLabel return_to){
		invoker.call_stack.push(ResolveState(return_to));
		return ResolveState(go_to);
	}

	action StateLabel P_CallSL(StateLabel go_to,int layer=PSP_WEAPON){
		State st=invoker.PSP_GetState(layer);
		if(st){
			invoker.call_stack.push(st.nextState);
			return go_to;
		}else{
			return null;
		}
	}

	action StateLabel P_CallSL2(StateLabel go_to,StateLabel return_to){
		invoker.call_stack.push(ResolveState(return_to));
		return go_to;
	}

	action State P_Return(){
		int size=invoker.call_stack.size();
		if(size>0){
			state returnval=invoker.call_stack[size-1];
			invoker.call_stack.Pop();
			return returnval;
		}else{
			console.printf("Trying to return from empty stack");
			return ResolveState(null);
		}
	}

	action state CheckReload(string ammotype,string magazinetype,int magazinecapacity,
								statelabel noammo/* if ammo is zero */,
								statelabel magazinefull/* if magazine is already full */,
								statelabel partialreload/* if magazine is not zero, not enough ammo for full reload*/,
								statelabel emptypartialreload/* if magazine is zero, not enough ammo for full reload*/,
								statelabel emptyreload /* if magazine is zero, enough ammo for full reload */,
								statelabel fullreload /* if magazine is not zero, enough ammo for full reload */){
		
		int ammo=CountInv(ammotype);
		if(ammo==0) return ResolveState(noammo);
		int magazine=CountInv(magazinetype);
		if(magazine==magazinecapacity) return ResolveState(magazinefull);
		int toreload=magazinecapacity-magazine;
		if(toreload>ammo) return ResolveState((magazine==0)?emptypartialreload:partialreload);
		return ResolveState((magazine==0)?emptyreload:fullreload);
	}
	action state CheckAmmo(string ammotype,string magazinetype,int magazinecapacity,
								statelabel noammo/* if ammo is zero */,
								statelabel magazinefull/* if magazine is full */){
		
		if(CountInv(ammotype)==0) return ResolveState(noammo);
		if(CountInv(magazinetype)==magazinecapacity) return ResolveState(magazinefull);
		return ResolveState(null);
	}

	action int iCheckFire(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			return 2;
		}else if(input&BT_ALTATTACK){
			return 1;
		}
		return 0;
	}

	action state CheckFire(statelabel fire=null,statelabel altFire=null,statelabel noFire=null){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			return ResolveState(fire);
		}else if(input&BT_ALTATTACK){
			return ResolveState(altFire);
		}
		return ResolveState(noFire);
	}
	action state CheckPFire(statelabel fire=null,statelabel noFire=null){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			return ResolveState(fire);
		}
		return ResolveState(noFire);
	}
	action state CheckAFire(statelabel altFire=null,statelabel noFire=null){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ALTATTACK){
			return ResolveState(altFire);
		}
		return ResolveState(noFire);
	}

	virtual void ReadyTick() {
	}
	PSPrite PSP_Get(int layer=PSP_WEAPON){
		if(owner){
			PlayerPawn pp=PlayerPawn(owner);
			if(pp){
				PlayerInfo pi=pp.player;
				if(pi) {
					return pi.GetPSprite(layer);
				}
			}
		}
		return null;
	}

	State PSP_GetState(int layer=PSP_WEAPON){
		PSprite psp = PSP_Get(layer);
		if(psp) {
			return psp.CurState;
		}
		return null;
	}

	void SetLayerFrame(int layer, int frame) {
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			psp.frame = frame;
		}
	}

	void SetLayerState(int layer, state new) {
		PSprite psp = PSP_Get(layer);
		if(psp){
			psp.setState(new,true);
		}
	}

	void SetLayerSprite(int layer,name sprite){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			int index=GetSpriteIndex(sprite);
			psp.sprite = index;
		}
	}

	action void W_SetLayerFrame(int layer, int frame) {
		invoker.SetLayerFrame(layer,frame);
	}

	action void W_SetLayerState(int layer, statelabel new) {
		invoker.SetLayerState(layer,ResolveState(new));
	}

	action void W_SetLayerSprite(int layer, name sprite) {
		invoker.SetLayerSprite(layer,sprite);
	}
}