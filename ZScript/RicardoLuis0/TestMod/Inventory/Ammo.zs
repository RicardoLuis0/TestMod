mixin class IncrementalPickup {
	override bool CanPickup(Actor toucher) {
		if(toucher == null) return false;
		Inventory tItem;
		Class<Inventory> findClass=GetClass();
		
		while(findClass is "Ammo"){//find root ammo
			Class<Inventory> pcls=(Class<Inventory>)(findClass.getParentClass());
			if(pcls!="Ammo"){
				findClass=pcls;
			}else{
				break;
			}
		}
		
		if((tItem = Toucher.FindInventory(findClass))) {
			if(tItem.amount < tItem.maxamount) {
				if((tItem.amount + amount) > tItem.maxamount) {
					let p = toucher.player;
					if(p){
						toucher = p.mo;
					}
					
					bool localView = toucher.CheckLocalView();
					
					let givenAmount = tItem.maxamount - tItem.amount;
					amount -= tItem.maxamount - tItem.amount;
					tItem.amount = tItem.maxamount;
					
					if(!bQuiet){
						Inventory.PrintPickupMessage(localView,Stringtable.Localize(PickupMsg).." ("..givenAmount..")");
						if(p) {
							PlayPickupSound(toucher);
							if(!bNoScreenFlash && p.playerstate != PST_DEAD) {
								p.bonuscount = BONUSADD;
							}
						} else {
							PlayPickupSound(toucher);
						}
					}
				} else {
					return super.CanPickup(toucher);
				}
			}
			return false;
		}
		return super.CanPickup(toucher);
	}
}

mixin class MyModAmmo {
	override String PickupMessage(){
		return Stringtable.Localize(PickupMsg).." ("..amount..")";
	}
}

class LightClip : Ammo {
	mixin MyModAmmo;
	mixin IncrementalPickup;
	
	Default {
		Inventory.PickupMessage "$GOTLIGHTCLIP";
		Inventory.Amount 8;
		Inventory.MaxAmount 300;
		Ammo.BackpackAmount 15;
		Ammo.BackpackMaxAmount 600;
		Inventory.Icon "MBLKA0";
		Tag "$AMMO_CLIP";
	}

	States {
	Spawn:
		MBLK A -1;
		Stop;
	}

}

class FreshLightClip : LightClip {
	Default {
		Inventory.PickupMessage "$GOTFULLLIGHTCLIP";
		Inventory.Amount 15;
	}
}

class LightClipBox : LightClip {

	Default {
		Inventory.PickupMessage "$GOTLIGHTCLIPBOX";
		Inventory.Amount 45;
	}

	States {
	Spawn:
		4M0K A -1;
		Stop;
	}

}

class HeavyClip : Ammo {
	mixin MyModAmmo;
	mixin IncrementalPickup;
	
	Default {
		Inventory.PickupMessage "$GOTHEAVYCLIP";
		Inventory.Amount 10;
		Inventory.MaxAmount 180;
		Ammo.BackpackAmount 20;
		Ammo.BackpackMaxAmount 360;
		Inventory.Icon "CLIPA0";
		Tag "$AMMO_CLIP";
	}

	States {
	Spawn:
		CLIP A -1;
		Stop;
	}

}

class FreshHeavyClip : HeavyClip {
	Default {
		Inventory.PickupMessage "$GOTFULLHEAVYCLIP";
		Inventory.Amount 20;
	}
}

class HeavyClipBox : HeavyClip {

	Default {
		Inventory.PickupMessage "$GOTHEAVYCLIPBOX";
		Inventory.Amount 80;
	}

	States {
	Spawn:
		AMMO A -1;
		Stop;
	}

}

class NewShell : Ammo replaces Shell {
	mixin MyModAmmo;
	mixin IncrementalPickup;
	
	Default {
		Inventory.PickupMessage "$GOTSHELLS";
		Inventory.Amount 4;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 4;
		Ammo.BackpackMaxAmount 100;
		Inventory.Icon "SHELA0";
		Tag "$AMMO_SHELLS";
	}
	States {
	Spawn:
		SHEL A -1;
		Stop;
	}
}

class NewShellBox : NewShell replaces ShellBox {
	Default {
		Inventory.PickupMessage "$GOTSHELLBOX";
		Inventory.Amount 20;
	}
	States {
	Spawn:
		SBOX A -1;
		Stop;
	}
}

class NewCell : Ammo replaces Cell {
	mixin MyModAmmo;
	mixin IncrementalPickup;
	
	Default {
		Inventory.PickupMessage "$GOTCELL";
		Inventory.Amount 20;
		Inventory.MaxAmount 300;
		Ammo.BackpackAmount 20;
		Ammo.BackpackMaxAmount 600;
		Inventory.Icon "CELLA0";
		Tag "$AMMO_CELLS";
	}
	
	States {
	Spawn:
		CELL A -1;
		Stop;
	}
}

class NewCellPack : NewCell replaces CellPack {
	Default {
		Inventory.PickupMessage "$GOTCELLBOX";
		Inventory.Amount 100;
	}
	States {
	Spawn:
		CELP A -1;
		Stop;
	}
}

class NewRocketAmmo : Ammo replaces RocketAmmo {
	mixin MyModAmmo;
	mixin IncrementalPickup;
	
	Default {
		Inventory.PickupMessage "$GOTROCKET";
		Inventory.Amount 1;
		Inventory.MaxAmount 50;
		Ammo.BackpackAmount 1;
		Ammo.BackpackMaxAmount 100;
		Inventory.Icon "ROCKA0";
		Tag "$AMMO_ROCKETS";
	}
	States {
	Spawn:
		ROCK A -1;
		Stop;
	}
}

class NewRocketBox : NewRocketAmmo replaces RocketBox {
	Default {
		Inventory.PickupMessage "$GOTROCKBOX";
		Inventory.Amount 5;
	}
	States {
	Spawn:
		BROK A -1;
		Stop;
	}
}