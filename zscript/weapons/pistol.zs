/*
class PistolAmmo : Ammo {
	Default{
		Inventory.MaxAmount 12;
	}
}
*/

class ManaBall : Actor
{
	Default
	{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 5;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		//SeeSound "weapons/plasmaf";
		DeathSound "weapons/plasmax";
	}
	States
	{
	Spawn:
		PLSS AB 6 Bright;
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		TNT1 A 0 A_Explode(5,64,0,0,16);
		Stop;
	}
}

class MPistol : Weapon {
	Default{
		Weapon.SlotNumber 6;
		Weapon.SelectionOrder 1900;
		Weapon.AmmoUse 5;
		Weapon.AmmoGive 20;
		Weapon.AmmoType "Mana";
		Inventory.Pickupmessage "You've got the Mana Pistol";
		+WEAPON.AMMO_OPTIONAL;
	}
	States{
	Ready:
		PLPI A 1 A_WeaponReady;
		Loop;
	Deselect:
		PLPI A 1 A_Lower;
		Loop;
	Select:
		PLPI A 1 A_Raise;
		Loop;
	Fire:
		PLPI A 4 A_JumpIfNoAmmo("Ready");
		PLPI B 6 Fire;
		PLPI C 2 A_ReFire;
		PLPI B 2;
		Goto Ready;
 	Spawn:
		PLSP A -1;
		Stop;
	}
	action void fire(){
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_FireCustomMissile("ManaBall");
	}
}