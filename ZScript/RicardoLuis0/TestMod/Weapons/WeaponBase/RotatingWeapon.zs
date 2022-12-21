class ModRotatingWeapon : ModWeaponBase {
	int rotSpeed;
	
	int rotSpeedMax;
	int rotSpeedRate;
	
	Property rotSpeedMax : rotSpeedMax;
	Property rotSpeedRate : rotSpeedRate;
	
	int minTics;
	int maxTics;
	
	Property minTics : minTics;
	Property maxTics : maxTics;
	
	
	Default {
		ModRotatingWeapon.minTics 1;
		ModRotatingWeapon.maxTics 6;
		ModRotatingWeapon.rotSpeedMax 50;
		ModRotatingWeapon.rotSpeedRate 1;
	}
	
	// MAIN
	// call spinup and spindown on the main layers, and updatespeed on overlays
	
	action void UpdateTics(int layer = PSP_WEAPON) {
		player.FindPSprite(layer).tics = int((1.0 - sqrt(sqrt(invoker.rotSpeed / double(invoker.rotSpeedMax)))) * (invoker.maxTics - invoker.minTics)) + invoker.minTics;
	}
	
	action State SpinUp(StateLabel ifFullSpeed = null, StateLabel ifElse = null) {
		player.WeaponState |= WF_DISABLESWITCH;
		player.WeaponState &= ~WF_REFIRESWITCHOK;
		
		invoker.rotSpeed += invoker.rotSpeedRate;
		if(invoker.rotSpeed > invoker.rotSpeedMax) invoker.rotSpeed = invoker.rotSpeedMax;
		UpdateTics();
		return ResolveState((invoker.rotSpeed == invoker.rotSpeedMax) ? ifFullSpeed : ifElse);
	}
	
	action State SpinDown(StateLabel ifStopped = null, StateLabel ifElse = null) {
		invoker.rotSpeed -= invoker.rotSpeedRate;
		if(invoker.rotSpeed < 0) invoker.rotSpeed = 0;
		UpdateTics();
		return ResolveState((invoker.rotSpeed == 0) ? ifStopped : ifElse);
	}
	
	//HELPERS
	
	action State IfSpeedGt(int speedMin,StateLabel ifTrue, StateLabel ifFalse = null)
	{
		if(invoker.rotSpeed > speedMin) return ResolveState(ifTrue);
		return ResolveState(ifFalse);
	}
	
	action State IfSpeedGtEq(int speedMin,StateLabel ifTrue, StateLabel ifFalse = null)
	{
		if(invoker.rotSpeed >= speedMin) return ResolveState(ifTrue);
		return ResolveState(ifFalse);
	}
	
	action State IfSpeedLt(int speedMax,StateLabel ifTrue, StateLabel ifFalse = null)
	{
		if(invoker.rotSpeed < speedMax) return ResolveState(ifTrue);
		return ResolveState(ifFalse);
	}
	
	action State IfSpeedLtEq(int speedMax,StateLabel ifTrue, StateLabel ifFalse = null)
	{
		if(invoker.rotSpeed <= speedMax) return ResolveState(ifTrue);
		return ResolveState(ifFalse);
	}
	
	action State IfSpeedEq(int speedEq,StateLabel ifTrue, StateLabel ifFalse = null)
	{
		if(invoker.rotSpeed == speedEq) return ResolveState(ifTrue);
		return ResolveState(ifFalse);
	}
}