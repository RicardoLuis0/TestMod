extend class ModWeaponBase {
	PSPrite PSP_Get(int layer=PSP_WEAPON){
		PlayerPawn p=PlayerPawn(owner);
		if(p&&p.player){
			return p.player.GetPSprite(layer);
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
	
	void SetLayerSprite(int layer,name sprite){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			int index=GetSpriteIndex(sprite);
			psp.sprite = index;
		}
	}

	void SetLayerState(int layer,state newState) {
		PlayerPawn p=PlayerPawn(owner);
		if(p&&p.player){
			p.player.SetPSprite(layer,newState);
		}
	}
	
	action void W_SetLayerFrame(int layer, int frame) {
		invoker.SetLayerFrame(layer,frame);
	}
	
	action void W_SetLayerStateSL(int layer, statelabel newSL) {
		invoker.SetLayerState(layer,ResolveState(newSL));
	}
	
	action void W_SetLayerState(int layer, state newState) {
		invoker.SetLayerState(layer,newState);
	}
	
	action void W_SetLayerSprite(int layer, name sprite) {
		invoker.SetLayerSprite(layer,sprite);
	}
}