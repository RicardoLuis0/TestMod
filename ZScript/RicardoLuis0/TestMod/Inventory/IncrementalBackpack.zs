class IncrementalBackpack : Backpack replaces Backpack {
	
	//modified from BackpackItem::CreateCopy
	override Inventory CreateCopy(Actor other)
	{
		// Find every unique type of ammoitem. Give it to the player if
		// he doesn't have it already, and double its maximum capacity.
		uint end = AllActorClasses.Size();
		for (uint i = 0; i < end; ++i)
		{
			let ammotype = (class<Ammo>)(AllActorClasses[i]);

			if (ammotype && GetDefaultByType(ammotype).GetParentAmmo() == ammotype)
			{
				let ammoitem = Ammo(other.FindInventory(ammotype));
				int amount = GetDefaultByType(ammotype).BackpackAmount;
				// extra ammo in baby mode and nightmare mode
				if (!bIgnoreSkill)
				{
					amount = int(amount * (G_SkillPropertyFloat(SKILLP_AmmoFactor) * sv_ammofactor));
				}
				if (amount < 0) amount = 0;
				if (ammoitem == NULL)
				{ // The player did not have the ammoitem. Add it.
					ammoitem = Ammo(Spawn(ammotype));
					ammoitem.Amount = bDepleted ? 0 : amount;
					if (ammoitem.BackpackMaxAmount > ammoitem.MaxAmount)
					{
						ammoitem.MaxAmount = ammoitem.BackpackMaxAmount;
					}
					if (ammoitem.Amount > ammoitem.MaxAmount)
					{
						ammoitem.Amount = ammoitem.MaxAmount;
					}
					ammoitem.AttachToOwner (other);
				}
				else
				{ // The player had the ammoitem. Give some more.
					if(ammoitem.default.BackpackMaxAmount > ammoitem.default.MaxAmount)
					{
						ammoitem.MaxAmount += (ammoitem.default.BackpackMaxAmount - ammoitem.default.MaxAmount);
					}
					
					if (!bDepleted && ammoitem.Amount < ammoitem.MaxAmount)
					{
						ammoitem.Amount += amount;
						if (ammoitem.Amount > ammoitem.MaxAmount)
						{
							ammoitem.Amount = ammoitem.MaxAmount;
						}
					}
				}
			}
		}
		return Super.CreateCopy (other);
	}
	
	
	
	override bool HandlePickup(Inventory i)
	{
		if(!(i is "BackpackItem"))
		{
			return super.HandlePickup(i);
		}
		
		if(!(i is "IncrementalBackpack"))
		{
			ThrowAbortException("Unexpected backpack type found in inventory");
		}
		
		bool incrementMax = false;
		
		if(sv_incremental_backpack && IncrementalBackpack(i).amount < sv_incremental_backpack_max_multiplier)
		{
			incrementMax = true;
			i.amount++;
		}
		
		//partially copied from BackpackItem::HandlePickup
		for(Inventory iitem = Owner.inv; iitem; iitem = iitem.inv)
		{
			Ammo iammo = Ammo(iitem);
			if(iammo && iammo.getParentAmmo() == iammo.getClass())
			{
				if(incrementMax && iammo.default.backpackMaxAmount > iammo.default.maxAmount)
				{
					iammo.maxAmount += iammo.default.backpackMaxAmount - iammo.default.maxAmount;
				}
				if (iammo.amount < iammo.maxAmount || sv_unlimited_pickup)
				{
					int amount = iammo.default.backpackAmount;
					if (!bIgnoreSkill)
					{
						amount = int(amount * G_SkillPropertyFloat(SKILLP_AmmoFactor));
					}
					iammo.amount += amount;
					if(iammo.amount > iammo.MaxAmount && !sv_unlimited_pickup)
					{
						iammo.amount=iammo.maxAmount;
					}
				}
			}
		}
		i.bPickupGood=true;
		return true;
	}
	//TODO
}