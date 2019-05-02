class MyEnemy:Actor{

	Vector3 LastKnownPos;
	int lastsee;

	int maxresurrect;
	
	override void BeginPlay(){
		super.BeginPlay();
		maxresurrect=-1;
	}
	
	virtual void doRaise(bool friendly=false){
		if(maxresurrect>0||maxresurrect==-1){
			if(maxresurrect>0)maxresurrect--;
			if(friendly){
				bFRIENDLY=true;
			}else{
				bFRIENDLY=false;
			}
			Thing_Raise(0);
		}
	}

	action State A_StealthLook(){
		return ResolveState(null);
	}

	action State A_StealthChase(){
		return ResolveState(null);
	}

	action State A_StealthSearch(){
		return ResolveState(null);
	}
}