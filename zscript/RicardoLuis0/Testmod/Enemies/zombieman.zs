class NewZombieManDrop1 : MD_Spawner{
	override void setDrops(){
		if(CVar.FindCVar("zombiemen_drop_rifle").GetInt())droplist.Push(new("MD_Component").Init("AssaultRifle",1,1));
		droplist.Push(new("MD_Component").Init("Clip",1,4));
	}
}

class NewZombieMan : ZombieMan replaces ZombieMan{
	Default{
		DropItem "NewZombieManDrop1";
	}
}