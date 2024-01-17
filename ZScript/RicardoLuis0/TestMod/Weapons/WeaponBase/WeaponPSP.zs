class WeaponOffsetInterpolData
{
	int duration;
	int currentTick;
	Vector2 start;
	Vector2 diff;
}

extend class ModWeaponBase
{
	PSPrite PSP_Get(int layer=PSP_WEAPON){
		if(owner.player){
			return owner.player.GetPSprite(layer);
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

	void SetLayerTics(int layer, int tics) {
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			psp.tics = tics;
		}
	}
	
	void SetLayerSprite(int layer,name sprite){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			int index=GetSpriteIndex(sprite);
			psp.sprite = index;
		}
	}
	
	void SetLayerAlpha(int layer,double alpha){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			psp.alpha = alpha;
		}
	}
	
	void SetLayerSpriteIndex(int layer,int sprite_index){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			psp.sprite = sprite_index;
		}
	}
	
	int GetLayerSprite(int layer){
		PSprite psp = PSP_Get(layer);
		if(psp && psp.CurState) {
			return psp.sprite;
		}else{
			return -1;
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
	
	action void W_SetLayerTics(int layer, int tics) {
		invoker.SetLayerTics(layer,tics);
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
	
	
	Map<int, WeaponOffsetInterpolData> layerInterpol;
	
	void SetLayerInterpolation(int index, Vector2 start, Vector2 end, int duration)
	{
		let data = new('WeaponOffsetInterpolData');
		data.start = start;
		data.diff = end - start;
		data.currentTick = 0;
		data.duration = duration - 1;
		layerInterpol.insert(index, data);
		
		PSprite psp;
		if(owner.player)
		{
			psp = owner.player.FindPSprite(index);
			if(psp)
			{
				psp.x = start.x;
				psp.y = start.y;
			}
		}
	}
	
	bool _DoInterpolateLayer(int index, WeaponOffsetInterpolData data)
	{
		PSprite psp;
		if(owner.player)
		{
			psp = owner.player.FindPSprite(index);
			if(psp)
			{
				double ratio = double(data.currentTick) / double(data.duration);
				
				psp.x = data.start.x + (data.diff.x * ratio);
				psp.y = data.start.y + (data.diff.y * ratio);
			}
		}
		data.currentTick++;
		return data.currentTick >= data.duration;
	}
	
	override void DoEffect()
	{
		if(self == owner.player.ReadyWeapon)
		{
			MapIterator<int, WeaponOffsetInterpolData> it;
			Array<int> toRemove;
			
			it.init(layerInterpol);
			
			while(it.next())
			{
				if(_DoInterpolateLayer(it.getKey(), it.getValue()))
				{
					toRemove.push(it.getKey());
				}
			}
			
			foreach(key : toRemove)
			{
				layerInterpol.remove(key);
			}
		}
	}
	
	
	
	
}