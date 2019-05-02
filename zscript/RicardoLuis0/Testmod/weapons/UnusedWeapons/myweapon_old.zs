
class MyWeapon:Weapon{
	const STATE_STACK_SIZE = 8;
	int state_stack_pos;
	State state_stack[STATE_STACK_SIZE];
	override void BeginPlay(){
		state_stack_pos=0;
	}
	
	action State P_Call(StateLabel go_to,StateLabel return_to){
		if(invoker.state_stack_pos>STATE_STACK_SIZE){
			A_Log("MyWeapon Procedure stack overflow on P_Call, consider increasing STATE_STACK_SIZE.");
			return ResolveState(null);
		}else{
			invoker.state_stack[invoker.state_stack_pos++]=ResolveState(return_to);
			return ResolveState(go_to);
		}
	}
	
	action State P_Return(){
		if(invoker.state_stack_pos>0){
			return invoker.state_stack[--invoker.state_stack_pos];
		}else{
			A_Log("MyWeapon P_Return trying to return with empty stack.");
			return ResolveState(null);
		}
	}
}