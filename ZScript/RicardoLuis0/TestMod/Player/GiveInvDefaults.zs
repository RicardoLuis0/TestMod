extend class TestModPlayer
{
	private void GiveDefaultInventoryItem(class<Inventory> type,int amount=0)
	{	//this logic was extracted from PlayerPawn::GiveDefaultInventory
		Inventory item=FindInventory(type);
		if(item)
		{
			if(!(item is "Weapon") && !(item is "BasicArmorPickup"))
			{
				item.amount=clamp(item.Amount+(amount>0?amount:item.default.amount),0,item.maxAmount);
			}
			return;
		}
		
		item = Inventory(Spawn(type));
		
		if(amount > 0 && !(item is "Weapon") && !(item is "BasicArmorPickup"))
		{
			item.amount=clamp(amount,0,item.maxAmount);
		}
		
		
		Weapon weap = Weapon(item);
		if(weap)
		{
			weap.ammoGive1=0;
			weap.ammoGive2=0;
		}
		bool res;
		Actor check;
		[res,check]=item.CallTryPickup(self);
		if(!res)
		{
			item.destroy();
			return;
		}
		else if(check!=self)
		{
			ThrowAbortException("Cannot give morph item '%s' when starting a game!",Name(type));
		}
		if(weap&&weap.CheckAmmo(Weapon.eitherFire,false))
		{
			player.readyWeapon=weap;
			player.pendingWeapon=weap;
		}
		
		if(amount > 0 && item is "BasicArmorPickup")
		{
			//BasicArmorPickup(item).saveamount = amount;
			BasicArmor(FindInventory("ArmorBase")).amount = amount;
		}
	}
	
	override void GiveDefaultInventory()
	{
		super.GiveDefaultInventory();
		if(G_SkillPropertyInt(SKILLP_ACSReturn) == 5)
		{
			A_SetHealth(25);
			GiveDefaultInventoryItem("NewPistol");
			GiveInventory("PistolLoaded",999);
			GiveDefaultInventoryItem("LightClip",17);
			GiveDefaultInventoryItem("GreenArmor", 15);
		}
		else
		{
			if(sv_player_start_pistol)
			{
				GiveDefaultInventoryItem("NewPistol");
				GiveInventory("PistolLoaded",999);
				if(!sv_player_start_smg)
					GiveDefaultInventoryItem("LightClip",sv_player_start_extra_ammo?80:50);
			}
			if(sv_player_start_shotgun)
			{
				GiveDefaultInventoryItem("PumpShotgun");
				GiveInventory("PumpLoaded",999);
				GiveDefaultInventoryItem("NewShell",sv_player_start_extra_ammo?24:16);
			}
			if(sv_player_start_smg)
			{
				GiveDefaultInventoryItem("SMG");
				GiveDefaultInventoryItem("LightClip",sv_player_start_extra_ammo?120:90);
				GiveInventory("SMGLoaded",999);
			}
			if(sv_player_start_rifle)
			{
				GiveDefaultInventoryItem("AssaultRifle");
				GiveDefaultInventoryItem("HeavyClip",sv_player_start_extra_ammo?60:40);
				GiveInventory("AssaultRifleLoaded",999);
			}
			
			if(sv_player_start_armor_amount > 0)
			{
				if(sv_player_start_armor == 1)
				{
					GiveDefaultInventoryItem("GreenArmor", sv_player_start_armor_amount);
				}
				else if(sv_player_start_armor == 2)
				{
					GiveDefaultInventoryItem("BlueArmor", sv_player_start_armor_amount);
				}
			}
			
			if(sv_player_start_portmed)
			{
				GiveDefaultInventoryItem("PortableMedKit",sv_player_start_extra_ammo?50:25);
			}
		}
	}
}