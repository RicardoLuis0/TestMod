extend class ModWeaponBase {
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