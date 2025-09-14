class LayerState
{
	Array<State> callStack;
}

mixin class StateCalls
{
	
	Map<int, LayerState> layerCallStack;
	
	private LayerState GetLayerState(int id)
	{
		LayerState ls = layerCallStack.get(id);
		if(!ls)
		{
			ls = new("LayerState");
			layerCallStack.insert(id, ls);
		}
		return ls;
	}
	
	action void P_Clear()
	{
		LayerState ls = invoker.layerCallStack.get(OverlayID());
		if(ls)
		{
			ls.callStack.clear();
		}
		else
		{
			invoker.layerCallStack.insert(OverlayID(), new("LayerState"));
		}
	}
	
	action StateLabel P_CallSL(StateLabel go_to)
	{
		int id = OverlayID();
		
		let ls = invoker.GetLayerState(id);
		State st = invoker.PSP_GetState(id);
		if(st)
		{
			ls.callStack.push(st.nextState);
			return go_to;
		}
		else
		{
			return null;
		}
	}
	
	action State P_Call(StateLabel go_to)
	{
		return ResolveState(P_CallSL(go_to));
	}

	action void P_RemoteCallJmp(int id, StateLabel go_to, StateLabel return_to)
	{
		let ls = invoker.GetLayerState(id);
		ls.callStack.push(ResolveState(return_to));
		
		if(invoker.owner.player)
		{
			invoker.owner.player.SetPSprite(id, ResolveState(go_to));
		}
	}

	action void P_RemoteCallJmpChain(int id, State go_to, StateLabel return_to)
	{
		let ls = invoker.GetLayerState(id);
		ls.callStack.push(ResolveState(return_to));
		
		if(invoker.owner.player)
		{
			invoker.owner.player.SetPSprite(id, go_to);
		}
	}

	action StateLabel P_CallJmpSL(StateLabel go_to, StateLabel return_to)
	{
		int id = OverlayID();
		
		let ls = invoker.GetLayerState(id);
		ls.callStack.push(ResolveState(return_to));
		
		return go_to;
	}

	action State P_CallJmp(StateLabel go_to, StateLabel return_to)
	{
		return ResolveState(P_CallJmpSL(go_to, return_to));
	}

	action State P_CallJmpChain(State go_to, StateLabel return_to)
	{
		int id = OverlayID();
		
		let ls = invoker.GetLayerState(id);
		ls.callStack.push(ResolveState(return_to));
		
		return go_to;
	}

	action State P_Return()
	{
		int id = OverlayID();
		
		let ls = invoker.GetLayerState(id);
		
		int size = ls.callStack.size();
		if(size > 0)
		{
			state returnval=ls.callStack[size - 1];
			ls.callStack.Pop();
			return returnval;
		}
		else
		{
			console.printf("Trying to return from empty stack");
			return null;
		}
	}
}