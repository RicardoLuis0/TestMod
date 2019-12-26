/*
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
*/
class OldBFG : BFG9000 {
	default {
		Weapon.SlotNumber 8;
		Weapon.AmmoUse 1;
	}
	states {
		Fire:
			BFGG A 10 A_BFGSound;
			BFGG BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB 1 A_FireOldBFG;
			BFGG B 0 A_Light0;
			BFGG B 20 A_ReFire;
			Goto Super::Ready;
	}
}