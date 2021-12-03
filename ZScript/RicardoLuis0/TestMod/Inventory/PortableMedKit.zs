class PortableMedKit : Inventory {
	int max_heal;
	Property MaxHeal:max_heal;
	bool allow_use;
	
	bool should_stay;
	
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
	
	override bool ShouldStay(){
		if(should_stay){
			should_stay=false;
			return true;
		}else{
			return false;
		}
	}
	
	override bool HandlePickup(Inventory item){
		if(amount<maxamount&&(amount+item.amount)>maxamount){
			item.amount-=(maxamount-amount);
			amount=maxamount;
			item.bPickupGood=true;
			item.bDropped=false;
			PortableMedKit(item).should_stay=true;
			return true;
		}
		return super.HandlePickup(item);
	}
	
	override void DoEffect(){
		if(owner is "TestModPlayer"){
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

class MedkitSpawner : ThingSpawner replaces Medikit {
	override void setDrops(){
		spawnlist.Push(BasicThingSpawnerElement.Create("Medikit",1,4,0));
		spawnlist.Push(BasicThingSpawnerElement.Create("PortableMedKit",1,1));
	}
}