class ArmorShard : MyArmorBonus {

	Default {
		Inventory.Pickupmessage "Picked up an Armor Shard.";
		Inventory.Icon "ARSDA0";
		Inventory.PickupSound "pickup/armorshard";
		Armor.SavePercent 33.335;
		Armor.Saveamount 5;
		Armor.MaxSaveAmount 200;
		-INVENTORY.ALWAYSPICKUP;
	}

	States {
	Spawn:
		ARSD ABCDCB 6;
		Loop;
	}

}