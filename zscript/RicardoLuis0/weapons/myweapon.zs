class MyWeapon:Weapon{
	Default{
		Decal "BulletChip";
	}
	Array<State> call_stack;

	action State P_Call(StateLabel go_to,StateLabel return_to){
		invoker.call_stack.push(ResolveState(return_to));
		return ResolveState(go_to);
	}
	
	action State P_Return(){
		int size=invoker.call_stack.size();
		if(size>0){
			state returnval=invoker.call_stack[size-1];
			invoker.call_stack.Pop();
			return returnval;
		}else{
			A_Log("MyWeapon P_Return trying to return with empty stack.");
			return ResolveState(null);
		}
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
}