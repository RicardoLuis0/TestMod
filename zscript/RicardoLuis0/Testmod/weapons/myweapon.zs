class MyWeapon:Weapon{
	Default{
		Decal "BulletChip";
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
								statelabel noammo/* ammo is zero */,
								statelabel magazinefull/* magazine is already full */,
								statelabel partialreload/*magazine is not zero, not enough ammo for full reload*/,
								statelabel emptypartialreload/*magazine is zero, not enough ammo for full reload*/,
								statelabel emptyreload /* magazine is zero, enough ammo for full reload */,
								statelabel fullreload /* magazine is not zero, enough ammo for full reload */)
	{
		int ammo=CountInv(ammotype);
		if(ammo==0) return ResolveState(noammo);
		int magazine=CountInv(magazinetype);
		if(magazine==magazinecapacity) return ResolveState(magazinefull);
		int toreload=magazinecapacity-magazine;
		if(toreload>ammo) return ResolveState((magazine==0)?emptypartialreload:partialreload);
		return ResolveState((magazine==0)?emptyreload:fullreload);
	}
	action state CheckAmmo(string ammotype,string magazinetype,int magazinecapacity,
								statelabel noammo/* ammo is zero */,
								statelabel magazinefull/* magazine is already full */)
	{
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
	action void OnSelect(bool UseCrosshair,int id=0){
		if(UseCrosshair){
			invoker.crosshair=id;
		}else{
			invoker.crosshair=0;
		}
	}
	action void OnDeselect(){
	}
	virtual void ReadyTick(){
	}
}