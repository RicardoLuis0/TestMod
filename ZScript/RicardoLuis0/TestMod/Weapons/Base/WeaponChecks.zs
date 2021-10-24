extend class ModWeaponBase {
	
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

	action int iCheckFire(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			return 2;
		}else if(input&BT_ALTATTACK){
			return 1;
		}
		return 0;
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
}