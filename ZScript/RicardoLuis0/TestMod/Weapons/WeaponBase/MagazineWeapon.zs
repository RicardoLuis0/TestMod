extend class ModWeaponBase
{
	mixin MPMultiPickup;
	
	override String PickupMessage()
	{
		return Stringtable.Localize(PickupMsg).." ("..(partialPickupHasMagazine ? ammogive2 : ammogive1)..")";
	}
	
	Inventory TossItem(Class<Inventory> item,int amt){
		if(item == null) return null;
		Inventory drop=Inventory(Spawn(item,owner.pos + (0,0, 10.)));
		if(drop == null) return null;
		drop.Amount=amt;
		//drop.SetOrigin(owner.pos + (0, 0, 10.), false);
		drop.Angle=owner.Angle;
		drop.VelFromAngle(5.);
		drop.SetOrigin(owner.pos + Vel*2, false);
		drop.Vel.Z=1.;
		drop.Vel+=Vel;
		drop.bNoGravity = false;	// Don't float
		drop.ClearCounters();	// do not count for statistics again
		drop.OnDrop(self);
		return drop;
	}
	
	override void AttachToOwner(Actor other){
		if(partialPickupHasMagazine){
			other.SetInventory(ammotype1,ammogive2);
			ammogive2=0;
		}
		super.AttachToOwner(other);
	}
	
	override Inventory CreateTossable(){
		Weapon copy=Weapon(super.CreateTossable(-1));
		if(partialPickupHasMagazine){
			copy.ammogive2=ammo1.amount;
			ammo1.amount=0;
		}
		return copy;
	}
	
	bool wasGiveCheat;
	
	override void SetGiveAmount(Actor receiver, int amount, bool givecheat){
		wasGiveCheat = givecheat;
		super.SetGiveAmount(receiver,amount,givecheat);
	}
	
	
	override bool TryPickup(in out Actor toucher)
	{
		if(!Toucher) return super.TryPickup(toucher);
		
		if(!sv_partial_ammo_pickup && (!Toucher.FindInventory(GetClass()) || partialPickupNoMagazine))
		{
			return super.TryPickup(toucher);
		}
		
		if(!wasGiveCheat)
		{
			if((partialPickupHasMagazine || partialPickupNoMagazine) && Toucher.FindInventory(GetClass()))
			{
				if(partialPickupHasMagazine)
				{
					if(ammogive2 == 0) return false;
					
					let tAmmo = Ammo(Toucher.FindInventory(AmmoType2));
					
					if(sv_magazine_weapon_ammo_auto_pickup && (!tAmmo || tAmmo.amount < tAmmo.maxamount) ) {
						int giveAmount;
						
						if( (tAmmo.amount + ammogive2) > tAmmo.maxamount) {
							giveAmount = tAmmo.maxamount - tAmmo.amount;
						} else {
							if(sv_keep_empty_weapon_items) {
								giveAmount = ammogive2;
							} else {
								return super.TryPickup(toucher);
							}
						}
						
						let p=toucher.player;
						
						if(p){
							toucher=p.mo;
						}
						
						bool localView=toucher.CheckLocalView();
						
						tAmmo.amount += giveAmount;
						ammogive2 -= giveAmount;
						
						if(!bQuiet) {
							Inventory.PrintPickupMessage(localView,Stringtable.Localize(tammo.PickupMsg).." ("..giveAmount..")");
							if(p) {
								PlayPickupSound(toucher);
								if(!bNoScreenFlash && p.playerstate != PST_DEAD) {
									p.bonuscount = BONUSADD;
								}
							} else {
								PlayPickupSound(toucher);
							}
						}
					}
					return false;
				}
				else
				{
					if(ammogive1 == 0) return super.TryPickup(toucher);
					
					let tAmmo = Ammo(Toucher.FindInventory(AmmoType1));
					
					if(!tAmmo || tammo.amount < tammo.maxamount) {
						let p = toucher.player;
						if(p){
							toucher = p.mo;
						}
						
						bool localView=toucher.CheckLocalView();
						
						int giveAmount;
						
						if((tAmmo.amount + ammogive1) > tAmmo.maxamount) {
							
							giveAmount = tAmmo.maxamount - tAmmo.amount;
							
						} else {
							if(sv_keep_empty_weapon_items) {
								giveAmount = ammogive2;
							} else {
								return super.TryPickup(toucher);
							}
						}
						
						ammogive1 -= giveAmount;
						tAmmo.amount += giveAmount;
						
						if(!bQuiet) {
							Inventory.PrintPickupMessage(localView,Stringtable.Localize(tAmmo.PickupMsg).." ("..giveAmount..")");
							if(p) {
								PlayPickupSound(toucher);
								if(!bNoScreenFlash && p.playerstate != PST_DEAD) {
									p.bonuscount = BONUSADD;
								}
							} else {
								PlayPickupSound(toucher);
							}
						}
						
						return false;
					}
				}
			}
		}
		else
		{
			wasGiveCheat=false;
		}
		return super.TryPickup(toucher);
	}
	
	
	override bool TryPickupRestricted(in out Actor toucher){
		return false;
	}
	
	virtual bool UnloadAmmo(){
		if(partialPickupHasMagazine&&ammo1.amount>0){
			if(customUnloadAmmo){
				TossItem(customUnloadAmmo,ammo1.amount);
			}else{
				TossItem(ammotype2,ammo1.amount);
			}
			ammo1.amount=0;
			return true;
		}
		return false;
	}
}