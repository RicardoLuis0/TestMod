class PortableMedKit : Inventory {
	
	mixin PartialPickup;
	mixin MPMultiPickup;
	
	int max_heal;
	Property MaxHeal:max_heal;
	bool allow_use;
	
	Default {
		PortableMedKit.MaxHeal 100;
		Inventory.Amount 25;
		Inventory.MaxAmount 50;
		Inventory.InterHubAmount 50;
		Inventory.Icon "RMPKA0";
		+Inventory.InvBar;
		+Inventory.KeepDepleted;
		+Inventory.IgnoreSkill;
		+Inventory.IsHealth;
		+Inventory.PersistentPower;
		Inventory.Pickupmessage "Got a portable Medkit.";
	}
	
	override void DoEffect()
	{
		if(owner is "TestModPlayer")
		{
			let pp=TestModPlayer(owner);
			if(pp.InvSel==self&&pp.invuse_key_down){
				allow_use=true;
				pp.UseInventory(self);
				allow_use=false;
			}
		}
	}
	
	override bool Use(bool pickup){
		if(!allow_use)return false;
		return owner.GiveBody(1,max_heal);
	}
	States {
		Spawn:
			RMPK A -1;
			Stop;
	}
	
}

class TestModMedikit : Medikit
{
	mixin MPMultiPickup;
}

class MedkitSpawner : ThingSpawner replaces Medikit {
	override void setDrops(){
		spawnlist.Push(BasicThingSpawnerElement.Create("TestModMedikit",1,4,0));
		spawnlist.Push(BasicThingSpawnerElement.Create("PortableMedKit",1,1));
	}
}