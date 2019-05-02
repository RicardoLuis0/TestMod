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

	action State P_Call(StateLabel go_to,StateLabel return_to){
		invoker.call_stack.push(ResolveState(return_to));
		return ResolveState(go_to);
	}

	action StateLabel P_CallSL(StateLabel go_to,StateLabel return_to){
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

	void SetLayerFrame(int layer, int frame) {
		if(owner==null) return;
		PlayerPawn pp=PlayerPawn(owner);
		if(pp==null) return;
		PlayerInfo pi=pp.player;
		if(pi) {
			PSprite psp = pi.GetPSprite(layer);
			if(psp && psp.CurState) {
				psp.frame = frame;
			}
		}
	}

	void SetLayerState(int layer, state new) {
		if(owner==null) return;
		PlayerPawn pp=PlayerPawn(owner);
		if(pp==null) return;
		PlayerInfo pi=pp.player;
		if(pi) {
			PSprite psp = pi.GetPSprite(layer);
			if(psp){
				psp.setState(new,true);
			}
		}
	}

	void SetLayerSprite(int layer,name sprite){
		if(owner==null) return;
		PlayerPawn pp=PlayerPawn(owner);
		if(pp==null) return;
		PlayerInfo pi=pp.player;
		if(pi) {
			PSprite psp = pi.GetPSprite(layer);
			if(psp && psp.CurState) {
				int index=GetSpriteIndex(sprite);
				psp.sprite = index;
			}
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
	action void A_Bob(){
		if(invoker.extra_weapon_bob)A_WeaponReady(WRF_NOFIRE|WRF_NOSWITCH);
	}
	action void A_UpdateBob(){
		invoker.extra_weapon_bob=CVar.FindCVar("extra_weapon_bob").GetInt();
	}
}