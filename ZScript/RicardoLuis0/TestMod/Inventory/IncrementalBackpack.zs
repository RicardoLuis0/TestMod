class IncrementalBackpack : Backpack replaces Backpack {
	override bool HandlePickup(Inventory i){
		if(!(i is "BackpackItem")){
			return super.HandlePickup(i);
		}
		//partially copied from BackpackItem::HandlePickup
		for(Inventory iitem=Owner.inv;iitem;iitem=iitem.inv){
			Ammo iammo=Ammo(iitem);
			if(iammo&&iammo.getParentAmmo()==iammo.getClass()){
				if(sv_incremental_backpack&&iammo.default.maxAmount!=iammo.default.backpackMaxAmount){
					int bamount=iammo.default.backpackMaxAmount-iammo.default.maxAmount;
					int max=iammo.default.maxAmount+(bamount*sv_incremental_backpack_max_multiplier);
					if(iammo.maxAmount<max){
						iammo.maxAmount+=bamount;
					}
				}
				if (iammo.amount<iammo.maxAmount||sv_unlimited_pickup){
					int amount=iammo.default.backpackAmount;
					if (!bIgnoreSkill) {
						amount=int(amount*G_SkillPropertyFloat(SKILLP_AmmoFactor));
					}
					iammo.amount += amount;
					if(iammo.amount>iammo.MaxAmount&&!sv_unlimited_pickup){
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