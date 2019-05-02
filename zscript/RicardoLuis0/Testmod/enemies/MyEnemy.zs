class MyEnemy_Drop_Item{
	MyEnemy_Drop_Item Init(string iname,int amt=1,int sh=0){
		item_name=iname;
		spawnheight=sh;
		if(amt>0)amount=amt;
		else amount=1;
		return self;
	}
	string item_name;
	int amount;
	int spawnheight;
}

class MyEnemy_Drop{
	int probability;
	virtual MyEnemy_Drop_Item Get(){
		return new("MyEnemy_Drop_Item").Init("Null",0,0);
	}
}

class MyEnemy_Drop_Single : MyEnemy_Drop{
	string item_name;
	int amount;
	int spawnheight;
	MyEnemy_Drop Init(string iname,int amt=1,int prob=255,int sh=0){
		item_name=iname;
		spawnheight=sh;
		if(amt>0)amount=amt;
		else amount=1;
		if(prob>=0||prob<=255) probability=prob;
		else probability=255;
		return self;
	}
	override MyEnemy_Drop_Item Get(){
		return new("MyEnemy_Drop_Item").Init(item_name,amount,spawnheight);
	}
}

class MyEnemy_Drop_Multi_Component : MyEnemy_Drop{
	string item_name;
	int amount;
	int spawnheight;
	int weight;
	MyEnemy_Drop_Multi_Component Init(string iname,int amt=1,int wt=1,int sh=0){
		item_name=iname;
		spawnheight=sh;
		if(amt>0)amount=amt;
		else amount=1;
		if(wt>=0) weight=wt;
		else weight=1;
		return self;
	}
	override MyEnemy_Drop_Item Get(){
		return new("MyEnemy_Drop_Item").Init(item_name,amount,spawnheight);
	}
}

class MyEnemy_Drop_Multi : MyEnemy_Drop{
	Array<MyEnemy_Drop_Multi_Component> droplist;
	MyEnemy_Drop_Multi Init(int prob=255){
		if(prob>=0||prob<=255) probability=prob;
		else probability=255;
		return self;
	}
	void Push(MyEnemy_Drop_Multi_Component comp){
		console.printf("push "..comp.item_name);
		droplist.Push(comp);
	}
	MyEnemy_Drop_Multi_Component getFromWeight(int wt){
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
	override MyEnemy_Drop_Item Get(){
		console.printf("Multi");
		if(droplist.Size()==0) return null;
		int sum=0;
		for(int i=0;i<droplist.Size();i++){
			sum+=droplist[i].weight;
		}
		int randnum=random(0,sum<=0?0:sum-1);
		MyEnemy_Drop_Multi_Component comp=getFromWeight(randnum);
		console.printf(comp.item_name);
		return comp==null?null:comp.Get();
	}
	MyEnemy_Drop Reduce(){
		MyEnemy_Drop_Item temp=Get();
		return new("MyEnemy_Drop_Single").Init(temp.item_name,temp.amount,probability,temp.spawnheight);
	}
}

class MyEnemy:Actor{
	bool firstlife;
	int maxresurrect;
	Array<MyEnemy_Drop> drops;
	
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
				int probability=invoker.drops[i].probability;
				if(probability<255){
					if(random(0,255)>probability){
						continue;
					}
				}
				MyEnemy_Drop_Item drop=invoker.drops[i].Get();
				if(drop!=null){
					for(int i2=0;i2<drop.amount;i2++){
						A_SpawnItem(drop.item_name,0,drop.spawnheight);
					}
				}
			}
		}
	}
}