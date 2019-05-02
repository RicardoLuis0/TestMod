class StimpackSpawner:BasicThingSpawner replaces Stimpack{//80% chance for 5 health, 20% chace for 10 health
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("TinyHealthVial",1,4));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SmallHealthVial",1,1));
	}
}

class MedikitSpawner:BasicThingSpawner replaces Medikit{//80% chance for 10 health, 16% chance for 25 health, 4% chance for 50 health
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SmallHealthVial",1,20));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("MediumHealthVial",1,4));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LargeHealthVial",1,1));
	}
}

class HealthBonusSpawner:BasicThingSpawner replaces HealthBonus {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("SmallBonusVial",1,4));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LargeBonusVial",1,1));
	}
}

class TinyHealthVial : MyHealthPickup{
	Default{
		Health 5;
		Inventory.PickupMessage "Picked up a Tiny Health Vial.";
		Inventory.PickupSound "misc/i_pkup";
		Inventory.Icon "IHP1B0";
		Inventory.MaxAmount 10;
		HealthPickup.AutoUse 0;
	}

	States{
		Spawn:
			IHP1 A -1;
			Stop;
	}
}

class SmallHealthVial : MyHealthPickup{
	Default{
		Health 10;
		Inventory.PickupMessage "Picked up a Small Health Vial.";
		Inventory.PickupSound "misc/i_pkup";
		Inventory.Icon "IHP2B0";
		Inventory.MaxAmount 5;
		HealthPickup.AutoUse 0;
	}

	States{
		Spawn:
			IHP2 A -1;
			Stop;
	}
}

class MediumHealthVial : MyHealthPickup{
	Default{
		Health 25;
		Inventory.PickupMessage "Picked up a Medium Health Vial.";
		Inventory.PickupSound "misc/i_pkup";
		Inventory.Icon "IHP3B0";
		Inventory.MaxAmount 2;
		HealthPickup.AutoUse 0;
	}

	States{
		Spawn:
			IHP3 A -1;
			Stop;
	}
}

class LargeHealthVial : MyHealthPickup{
	Default{
		Health 50;
		Inventory.PickupMessage "Picked up a Large Health Vial.";
		Inventory.PickupSound "misc/i_pkup";
		Inventory.Icon "IHP4B0";
		Inventory.MaxAmount 1;
		HealthPickup.AutoUse 0;
	}

	States{
		Spawn:
			IHP4 A -1;
			Stop;
	}
}

class SmallBonusVial : MyHealth {
	Default{
		+COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		Inventory.Amount 1;
		Inventory.MaxAmount 200;
		Inventory.PickupMessage "Picked up a Small Health Bonus.";
	}
	States{
		Spawn:
			BHP1 A -1;
			Stop;
	}
}

class LargeBonusVial : MyHealth {
	Default{
		+COUNTITEM;
		+INVENTORY.ALWAYSPICKUP;
		Inventory.Amount 5;
		Inventory.MaxAmount 200;
		Inventory.PickupMessage "Picked up a Large Health Bonus.";
	}
	States{
		Spawn:
			BHP2 A -1;
			Stop;
	}
}