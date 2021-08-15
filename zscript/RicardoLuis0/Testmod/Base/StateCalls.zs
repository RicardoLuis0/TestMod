mixin class StateCalls {
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

	action State P_CallJmp(StateLabel go_to,StateLabel return_to){
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

	action StateLabel P_CallSLJmp(StateLabel go_to,StateLabel return_to){
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
}