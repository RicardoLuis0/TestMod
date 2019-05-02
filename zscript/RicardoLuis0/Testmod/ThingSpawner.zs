class ThingSpawnerBase:Actor{
	bool spawnactor(string a_name){
		/*
		if(bDropped){
			A_DropItem(actor_name);
			return true;
		}else{
			return A_SpawnItemEx(actor_name);
		}
		*/
		class<Actor> a_class=a_name;
		if(a_class==null){
			console.printf("Invalid Actor \""..a_name.."\"");
			return false;
		}
		Actor obj=Spawn(a_class,pos,NO_REPLACE);
		if(obj){
			obj.vel=vel;
			obj.bDropped = bDropped;
			Float ammoFactor=G_SkillPropertyFloat(SKILLP_DropAmmoFactor);
			if(ammoFactor==-1)ammoFactor=0.5;
			if(obj is "Ammo"){
				Ammo a_obj=Ammo(obj);
				if (ammoFactor > 0){
					a_obj.amount=int(a_obj.amount*ammoFactor);
				}
			}else if(obj is "Weapon"){
				Weapon w_obj=Weapon(obj);
				if (ammoFactor > 0){
					w_obj.ammoGive1=int(w_obj.ammoGive1*ammoFactor);
					w_obj.ammoGive2=int(w_obj.ammoGive2*ammoFactor);
				}
			}
			return true;
		}
		return false;
	}
}

class BasicThingSpawnerElement{
	string actor_name;
	int actor_amount;
	int actor_weight;
	BasicThingSpawnerElement Init(string name="None",int amount=0,int weight=0){
		actor_name=name;
		actor_amount=amount;
		actor_weight=weight;
		return self;
	}
}

class BasicThingSpawner:ThingSpawnerBase{
	Array<BasicThingSpawnerElement> spawnlist;
	int max_weight;
	int arrayMaxWeight(){
		int total=0;
		int i;
		for(i=0;i<spawnlist.Size();i++){
			total+=spawnlist[i].actor_weight;
		}
		return total-1;
	}
	BasicThingSpawnerElement getFromWeight(int weight){
		int total=0;
		int i;
		for(i=0;i<spawnlist.Size();i++){
			total+=spawnlist[i].actor_weight;
			if(total>weight) break;
		}
		if(i>=spawnlist.Size()){
			return null;
		}
		return spawnlist[i];
	}
	override void BeginPlay(){
		super.BeginPlay();
		setDrops();
		max_weight=arrayMaxWeight();
	}
	virtual void setDrops(){}
	States{
		Spawn:
			TNT1 A 0{
				int weight=random(0,max_weight);
				BasicThingSpawnerElement toSpawn=getFromWeight(weight);
				if(toSpawn!=null){
					if(toSpawn.actor_name!="None"){
						int i;
						for(i=0;i<toSpawn.actor_amount;i++){
							spawnactor(toSpawn.actor_name);
						}
					}
				}
				Thing_Remove(0);
			}
	}
}