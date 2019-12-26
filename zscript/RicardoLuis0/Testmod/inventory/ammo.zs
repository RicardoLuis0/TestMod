class LightClip : Ammo {

	Default {
		Inventory.PickupMessage "$GOTLIGHTCLIP";
		Inventory.Amount 8;
		Inventory.MaxAmount 300;
		Ammo.BackpackAmount 25;
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
		Inventory.Amount 30;
	}
}

class LightClipBox : LightClip {

	Default {
		Inventory.PickupMessage "$GOTLIGHTCLIPBOX";
		Inventory.Amount 150;
	}

	States {
	Spawn:
		4M0K A -1;
		Stop;
	}

}

class HeavyClip : Ammo {

	Default {
		Inventory.PickupMessage "$GOTHEAVYCLIP";
		Inventory.Amount 10;
		Inventory.MaxAmount 200;
		Ammo.BackpackAmount 50;
		Ammo.BackpackMaxAmount 400;
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
		Inventory.Amount 20;
	}
}

class HeavyClipBox : HeavyClip {

	Default {
		Inventory.PickupMessage "$GOTHEAVYCLIPBOX";
		Inventory.Amount 100;
	}

	States {
	Spawn:
		AMMO A -1;
		Stop;
	}

}