class MD_DropItem{
	string pname;
	int amount;
	MD_DropItem Init(string iname,int amt=1){
		pname=iname;
		if(amt>0)amount=amt;
		else amount=1;
		return self;
	}
}

class MD_Component{
	string pname;
	int amount;
	int weight;
	MD_Component Init(string iname,int amt=1,int wt=1){
		pname=iname;
		if(amt>0)amount=amt;
		else amount=1;
		if(wt>=0) weight=wt;
		else weight=1;
		return self;
	}
	MD_DropItem Get(){
		return new("MD_DropItem").Init(pname,amount);
	}
}

class MD_Spawner:ThingSpawnerBase{
	Array<MD_Component> droplist;

	virtual void setDrops(){}//override and push to droplist from here in child classes

	override void PostBeginPlay(){
		super.PostBeginPlay();
		setDrops();
		if(!DoSpawn()) console.printf("\c[Red] Error Spawning Drop");
		Destroy();
	}

	MD_Component getFromWeight(int wt){
		int total=0;
		int i;
		for(i=0;i<droplist.Size();i++){
			total+=droplist[i].weight;
			if(total>wt) break;
		}
		if(i>=droplist.Size()){
			return null;
		}
		return droplist[i];
	}

	MD_DropItem Get(){
		if(droplist.Size()==0) return null;
		int sum=0;
		for(int i=0;i<droplist.Size();i++){
			sum+=droplist[i].weight;
		}
		int randnum=random(0,sum<=0?0:sum-1);
		MD_Component comp=getFromWeight(randnum);
		return comp==null?null:comp.Get();
	}
	bool DoSpawn(){
		MD_DropItem di = Get();
		if (di==NULL) return false;
		if(di.pname=="None")return true;
		Class<Actor> actor_class=di.pname;
		if(actor_class==NULL) return false;
		return spawnactor(di.pname);
	}
}