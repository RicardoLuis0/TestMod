class MyEnemy:Actor{
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
}