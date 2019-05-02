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

class MD_Spawner:WeaponGiver{
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
	Actor spawnactor(string act_name){
		Actor actor_object=Spawn(act_name);
		actor_object.SetOrigin(pos,false);
		return actor_object;
	}
	bool DoSpawn(){
		MD_DropItem di = Get();
		if (di==NULL) return false;
		if(di.pname=="None")return true;
		Class<Actor> actor_class=di.pname;
		if(actor_class==NULL) return false;
		Actor actor_object=spawnactor(di.pname);
		if(actor_object==NULL)return false;
		if(actor_object is "weapon"){
			Weapon weap=Weapon(actor_object);
			if(weap==null)return false;
			weap.bAlwaysPickup = false;
			weap.bDropped = bDropped;
			if (AmmoFactor > 0){
				weap.AmmoGive1 = int(weap.AmmoGive1 * AmmoFactor);
				weap.AmmoGive2 = int(weap.AmmoGive2 * AmmoFactor);
			}
		}else if(actor_object is "ammo"){
			Ammo ammoitem=Ammo(actor_object);
			if(ammoitem==null)return false;
			if (AmmoFactor > 0){
				ammoitem.Amount=int(ammoitem.Amount * AmmoFactor);
			}
		}
		return true;
	}
}