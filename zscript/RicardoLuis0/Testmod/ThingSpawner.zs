/*

Basic Spawner ignores allowed classes, "None" item is no drops.

Class Restricted Spawner only spawn items/enemies that are allowed by the classes of the ingame players, "None" class is allowed to all, "Else" class is only allowed when no other allowed classes are present in the game

*/

class ThingSpawnerBase:Actor{
	Actor spawnactor(string act_name){
		Actor actor_object=Spawn(act_name);
		actor_object.SetOrigin(pos,false);
		return actor_object;
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
							Actor a = spawnactor(toSpawn.actor_name);
							a.bDropped=bDropped;
							//A_SpawnItemEx(toSpawn.actor_name);
						}
					}
				}
				Thing_Remove(0);
			}
	}
}

class ClassRestrictedThingSpawnerElement{
	string actor_class_required;
	string actor_name;
	int actor_amount;
	int actor_weight;
	ClassRestrictedThingSpawnerElement Init(string class_required="None",string name="None",int amount=0,int weight=0){
		actor_class_required=class_required;
		actor_name=name;
		actor_amount=amount;
		actor_weight=weight;
		return self;
	}
}

class ClassRestrictedThingSpawner:ThingSpawnerBase{
	Array<ClassRestrictedThingSpawnerElement> spawnlist;
	ClassRestrictedThingSpawnerElement getRandom(){
		bool non_none=false;
		Array<ClassRestrictedThingSpawnerElement> allowed_drops;
		int i;
		for(i=0;i<spawnlist.Size();i++){
			if(spawnlist[i].actor_class_required=="None"){
				allowed_drops.Push(spawnlist[i]);
			}else{
				ThinkerIterator it = ThinkerIterator.Create("MyPlayer");
				MyPlayer p=null;
				for(p=MyPlayer(it.Next());p!=null;p=MyPlayer(it.Next())){
					int class_count=p.allowed_spawn_classes.Size();
					int i2;
					for(i2=0;i2<class_count;i2++){
						if(p.allowed_spawn_classes[i2]==spawnlist[i].actor_class_required||p.allowed_spawn_classes[i2]=="All"){
							non_none=true;
							allowed_drops.Push(spawnlist[i]);
							break;
						}
					}
				}
			}
		}
		if(non_none==false){
			for(i=0;i<spawnlist.Size();i++){
				if(spawnlist[i].actor_class_required=="Else"){
					allowed_drops.Push(spawnlist[i]);
				}
			}
		}
		if(allowed_drops.Size()==0) return null;
		int total=0;
		for(i=0;i<allowed_drops.Size();i++){
			total+=allowed_drops[i].actor_weight;
		}
		int weight=random(0,total-1);
		total=0;
		for(i=0;i<allowed_drops.Size();i++){
			total+=allowed_drops[i].actor_weight;
			if(total>weight) break;
		}
		if(i>=allowed_drops.Size()){
			return null;
		}
		return allowed_drops[i];
	}
	override void BeginPlay(){
		super.BeginPlay();
		setDrops();
	}
	virtual void setDrops(){}
	States{
		Spawn:
			TNT1 A 0{
				ClassRestrictedThingSpawnerElement toSpawn=getRandom();
				if(toSpawn!=null){
					if(toSpawn.actor_name!="None"){
						int i;
						for(i=0;i<toSpawn.actor_amount;i++){
							Actor a = spawnactor(toSpawn.actor_name);
							a.bDropped=bDropped;
							//A_SpawnItemEx(toSpawn.actor_name);
						}
					}
				}
				Thing_Remove(0);
			}
	}
}
