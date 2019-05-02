class RotatingWeapon : MyWeapon {
	/*
	Variables:
		twofire:
			will have 2 states for idle and fire, alternating
		spinup_speed:
			speed of spin up
		spinup_min_tics:
			spin up from this many tics per frame
		spinup_max_tics:
			spin up to this many tics per frame
	Custom States:
		SpinUp:
			first frame must call RW_DoSpinUp
			every other frame must call RW_DoFrame
		SpinDown:
			first frame must call RW_DoSpinDown
			every other frame must call RW_DoFrame
		IdleSpin:
			first frame must call RW_DoIdleSpin
			every other frame must call RW_DoFrame
		IdleSpin:
			first frame must call RW_DoFireSpin
			every other frame must call RW_DoFrame (if not directly, inside the function they run)
		
		frames must not have empty (0-duration) frames, use custom actions or anonymous functions instead
	*/
	bool increment_spin(){
		spinup_current_tics+=spinup_speed;
		return (spinup_current_tics>spinup_max_tics);
	}
	bool decrement_spin(){
		spinup_current_tics-=spinup_speed;
		return (spinup_current_tics<spinup_min_tics);
	}
	int clamp_spin(){
		if(spinup_current_tics<spinup_min_tics){
			spinup_current_tics=spinup_min_tics;
			return spinup_min_tics;
		}
		if(spinup_current_tics>spinup_max_tics){
			spinup_current_tics=spinup_max_tics;
			return spinup_max_tics;
		}
		return int(spinup_current_tics);
	}
	float spinup_speed;
	int spinup_min_tics;
	int spinup_max_tics;
	float spinup_current_tics;
	int wp_state;
	action State RW_DoSpinUp(){
		if(invoker.increment_spin()){
			return ResolveState("IdleSpin");
		}
		RW_DoFrame();
		return ResolveState(null);
	}
	action State RW_DoSpinDown(){
		if(invoker.decrement_spin()){
			return ResolveState("Ready");
		}
		RW_DoFrame();
		return ResolveState(null);
	}
	action State RW_DoIdleSpin(bool fire2=false){
		switch(iCheckFire()){
		case 0://no button
			return ResolveState("SpinDown");
		case 1://altfire pressed
			return ResolveState(null);
		case 2://fire pressed
			return ResolveState("FireSpin");
		}
	}
	action State RW_DoFireSpin(bool fire2=false){
		switch(iCheckFire()){
		case 0://no button
			return ResolveState("SpinDown");
		case 1://altfire pressed
			return ResolveState("IdleSpin");
		case 2://fire pressed
			return ResolveState(null);
		}
	}
	action void RW_DoFrame(){
		A_SetTics(invoker.clamp_spin());
	}
}