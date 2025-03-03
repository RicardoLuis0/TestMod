class ArmorShard : ArmorBonus
{
	mixin MPMultiPickup;

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
	
	override bool TryPickup(in out Actor toucher)
	{
		BasicArmor armor=BasicArmor(toucher.FindInventory("ArmorBase"));
		if(armor){
			if(sv_armorshard_requires_armor&&armor.amount<=0){
				return false;
			}
			if(sv_armorshard_full_refill&&armor.amount>0){
				maxSaveAmount=armor.ActualSaveAmount;
			}
		}
		else if(!armor && sv_armorshard_requires_armor)
		{
			return false;
		}
		
		return super.TryPickup(toucher);
	}

	States {
	Spawn:
		ARSD ABCDCB 6;
		Loop;
	}

}