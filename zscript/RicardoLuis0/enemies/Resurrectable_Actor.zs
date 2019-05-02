class Resurrectable_Drop{
	Resurrectable_Drop Init(string iname,int amt=1,int prob=255,int sh=0){
		item_name=iname;
		spawnheight=sh;
		if(amt>0)amount=amt;
		else amount=1;
		if(prob>=0||prob<=255) probability=prob;
		else probability=255;
		return self;
	}
	string item_name;
	int amount;
	int probability;
	int spawnheight;
}

class Resurrectable_Actor:Actor{
	bool firstlife;
	int maxresurrect;
	Array<Resurrectable_Drop> drops;
	
	override void BeginPlay(){
		super.BeginPlay();
		firstlife=true;
		maxresurrect=-1;
		setDrops();
	}
	
	virtual void setDrops(){}
	
	override void Die(Actor source, Actor inflictor, int dmgflags){
		super.Die(source,inflictor,dmgflags);
		firstlife=false;
	}
	
	virtual void raise(bool friendly){
		if(maxresurrect>0||maxresurrect==-1){
			if(maxresurrect>0)maxresurrect--;
			if(friendly){
				bCOUNTKILL=false;
				bFRIENDLY=true;
				bTHRUACTORS=true;
			}else{
				bISMONSTER=true;
				bCOUNTKILL=true;
				bFRIENDLY=false;
				bTHRUACTORS=false;
			}
			Thing_Raise(0);
		}
	}
	
	virtual int rank(){
		return 0;
	}
	
	action void resolveDrops(){
		if(invoker.firstlife){
			for(int i=0;i<invoker.drops.Size();i++){
				Resurrectable_Drop drop=invoker.drops[i];
				if(drop.probability<255){
					if(random(0,255)>drop.probability){
						continue;
					}
				}
				for(int i2=0;i2<drop.amount;i2++){
					A_SpawnItem(drop.item_name,0,drop.spawnheight);
				}
			}
		}
	}
}