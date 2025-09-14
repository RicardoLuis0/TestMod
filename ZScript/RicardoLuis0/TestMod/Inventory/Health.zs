class HealthInjector : Health replaces HealthBonus
{
	Default
	{
		+COUNTITEM
		+INVENTORY.ALWAYSPICKUP
		Inventory.Amount 5;
		Inventory.MaxAmount 200;
		Inventory.PickupMessage "$GOTHEALTHINJECTOR";
		Tag "$TAG_HEALTHINJECTOR";
		Scale 0.75;
	}
	
	States
	{
	Spawn:
		BON1 ABCD 6;
		BON1 E 3;
		Loop;
	}
}