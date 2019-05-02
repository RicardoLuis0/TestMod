class BFGCharge : Ammo {
	Default {
		Inventory.MaxAmount 200;
	}
}

class BFG : MyWeapon {
	override void ReadyTick(){
		if(!(InStateSequence(CurState,ResolveState("Raise"))||InStateSequence(CurState,ResolveState("Lower")))){
			//only charge if not raising or lowering the weapon
		}
	}
}