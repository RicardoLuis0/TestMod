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

	States {
	Spawn:
		ARSD ABCDCB 6;
		Loop;
	}

}