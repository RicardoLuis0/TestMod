class ArmorShard : ArmorBonus {

	Default {
		Inventory.Pickupmessage "Picked up an Armor Shard.";
		Inventory.Icon "ARSDA0";
		Inventory.PickupSound "pickup/armorshard";
		Armor.SavePercent 33.335;
		Armor.Saveamount 5;
		Armor.MaxSaveAmount 100;
		-INVENTORY.ALWAYSPICKUP;
		-COUNTITEM;
	}
	
	override bool TryPickup(in out Actor toucher){
		if(sv_armorshard_full_refill){
			BasicArmor armor=BasicArmor(toucher.FindInventory("BasicArmor"));
			maxSaveAmount=armor.MaxAmount;
		}
		return super.TryPickup(toucher);
	}

	States {
	Spawn:
		ARSD ABCDCB 6;
		Loop;
	}

}