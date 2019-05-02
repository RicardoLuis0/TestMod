class SpawnerBase:Actor{
	Actor spawnactor(string act_name){
		Actor actor_object=Spawn(act_name);
		actor_object.SetOrigin(pos,false);
		return actor_object;
	}
}