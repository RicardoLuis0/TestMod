class ThingSpawnerElement abstract {
	int actor_weight;
	bool actor_allow_dropped;
	ThingSpawnerElement Init(int weight,bool allow_dropped){
		actor_weight=weight;
		actor_allow_dropped=allow_dropped;
		return self;
	}
	play virtual bool doSpawn(Vector3 pos,Vector3 vel,bool bDropped){
		return false;
	}
	virtual bool isEmpty(){
		return false;
	}
}

class ThingSpawner : Actor abstract {
	static bool spawnactor(class<Actor> a_class,int replace,Vector3 pos,Vector3 vel,bool bDropped){
		if(a_class==null){
			console.printf("\c[red] Unexpected Null 'a_class' in ThingSpawner::spawnactor");
			return false;
		}
		Actor obj=Spawn(a_class,pos,replace);
		if(obj){
			obj.vel=vel;
			obj.bDropped = bDropped;
			Float ammoFactor;
			if(bDropped){
				ammoFactor=G_SkillPropertyFloat(SKILLP_DropAmmoFactor);
				if(ammoFactor==-1)ammoFactor=0.5;
			}else{
				ammoFactor=G_SkillPropertyFloat(SKILLP_AmmoFactor);
				if(ammoFactor==-1)ammoFactor=1;
			}
			if(obj is "Ammo"){
				Ammo a_obj=Ammo(obj);
				a_obj.amount=int(a_obj.amount*ammoFactor);
			}else if(obj is "Weapon"){
				Weapon w_obj=Weapon(obj);
				w_obj.ammoGive1=int(w_obj.ammoGive1*ammoFactor);
				w_obj.ammoGive2=int(w_obj.ammoGive2*ammoFactor);
			}
			return true;
		}
		return false;
	}

	Array<ThingSpawnerElement> spawnlist;
	int max_weight;

	int arrayMaxWeight(){
		int total=0;
		for(int i=0;i<spawnlist.Size();i++){
			if(!bDropped||spawnlist[i].actor_allow_dropped){
				total+=spawnlist[i].actor_weight;
			}
		}
		return total;
	}

	ThingSpawnerElement getFromWeight(int weight){
		int total=0;
		for(int i=0;i<spawnlist.Size();i++){
			if(!bDropped||spawnlist[i].actor_allow_dropped){
				total+=spawnlist[i].actor_weight;
				if(total>=weight){
					return spawnlist[i];
				}
			}
		}
		return null;
	}

	override void BeginPlay(){
		super.BeginPlay();
		setDrops();
		max_weight=arrayMaxWeight();
	}

	abstract void setDrops();

	bool DoSpawn(){
		int weight=random(0,max_weight);
		ThingSpawnerElement toSpawn=getFromWeight(weight);

		if(toSpawn==null) return false;

		if(toSpawn.isEmpty()) return true;
		
		return toSpawn.doSpawn(pos,vel,bDropped);
	}

	override void PostBeginPlay(){
		super.PostBeginPlay();
		//setDrops();
		if(!DoSpawn()) console.printf("\c[Red] Error Spawning Drops");
		Destroy();
	}
}

class EmptyThingSpawnerElement : ThingSpawnerElement {
	EmptyThingSpawnerElement Init(int weight=1,bool allow_dropped=true){
		super.Init(weight,allow_dropped);
		return self;
	}
	override bool isEmpty() {
		return true;
	}
	override bool doSpawn(Vector3 pos,Vector3 vel,bool bDropped){
		return true;
	}
}

class BasicThingSpawnerElement : ThingSpawnerElement {
	class<Actor> actor_class;
	int actor_amount;
	int actor_replace;
	
	BasicThingSpawnerElement Init(class<Actor> a_class,int amount=1,int weight=1,int replace=ALLOW_REPLACE,bool allow_dropped=true){
		super.Init(weight,allow_dropped);
		actor_class=a_class;
		actor_amount=amount;
		actor_replace=replace;
		return self;
	}
	
	static BasicThingSpawnerElement Create(class<Actor> a_class,int amount=1,int weight=1,int replace=ALLOW_REPLACE,bool allow_dropped=true){
		return new("BasicThingSpawnerElement").Init(a_class,amount,weight,replace,allow_dropped);
	}
	
	override bool doSpawn(Vector3 pos,Vector3 vel,bool bDropped){
		if(actor_amount==1){
			return ThingSpawner.spawnactor(actor_class,actor_replace,pos,vel,bDropped);
		}else{
			for(int i=0;i<actor_amount;i++){
				Vector3 spawn_vel=vel+(frandom(-1,1),frandom(-1,1),frandom(1,2));
				if(!ThingSpawner.spawnactor(actor_class,actor_replace,pos,spawn_vel,bDropped))return false;
			}
			return true;
		}
	}
}

class MultiThingSpawnerElement : ThingSpawnerElement abstract {
	Array<ThingSpawnerElement> spawnlist;
	int actor_amount;

	abstract void setDrops();//weight ignored
	
	MultiThingSpawnerElement Init(int amount=1,int weight=1,bool allow_dropped=true){
		Super.init(weight,allow_dropped);
		actor_amount=amount;
		setDrops();
		return self;
	}
	
	int countList(bool bDropped){
		int total=0;
		for(int i=0;i<spawnlist.Size();i++){
			if(!bDropped||spawnlist[i].actor_allow_dropped){
				total++;
			}
		}
		return total;
	}
	
	play bool doSpawnList(Vector3 pos,Vector3 vel,bool bDropped){
		int count=countList(bDropped);
		if(count==1){
			for(int i=0;i<spawnlist.Size();i++){
				if(!bDropped||spawnlist[i].actor_allow_dropped){
					return spawnlist[i].doSpawn(pos,vel,bDropped);
				}
			}
			return false;
		}else{
			for(int i=0;i<spawnlist.Size();i++){
				if(!bDropped||spawnlist[i].actor_allow_dropped){
					Vector3 spawn_vel=vel+(frandom(-1,1),frandom(-1,1),frandom(1,2));
					if(!spawnlist[i].doSpawn(pos,spawn_vel,bDropped))return false;
				}
			}
			return true;
		}
	}
	
	override bool doSpawn(Vector3 pos,Vector3 vel,bool bDropped){
		if(actor_amount==1){
			return doSpawnList(pos,vel,bDropped);
		}else{
			for(int i=0;i<actor_amount;i++){
				Vector3 spawn_vel=vel+(frandom(-1,1),frandom(-1,1),frandom(1,2));
				if(!doSpawnList(pos,spawn_vel,bDropped))return false;
			}
			return true;
		}
	}
	
}

