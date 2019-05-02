class ManaBall : Actor{
	States{
	Spawn:
		PLSS AB 6 Bright;
		Loop;
	Death:
		PLSE ABCDE 4 Bright;
		TNT1 A 0 A_Explode(5,64,0,0,16);
		Stop;
	}
}
class ManaBall_Regular : ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 5;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt0:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 1;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt1:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 5;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt2:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 10;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt3:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 15;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt4:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 20;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class ManaBall_Alt5:ManaBall{
	Default{
		Radius 13;
		Height 8;
		Speed 40;
		Damage 35;
		Projectile;
		+RANDOMIZE
		+ZDOOMTRANS
		RenderStyle "Add";
		Alpha 0.75;
		DeathSound "weapons/plasmax";
	}
}
class MPistol : MyWeapon{
	int charge;
	const maxcharge=25;
	const firedivide=5;
	Default{
		Weapon.SlotNumber 2;
		Weapon.AmmoType "Mana";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 0;
		Inventory.Pickupmessage "You've got the Mana Pistol";
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
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
		PLPI B 6 A_Fire_MPistol;
		PLPI C 2 A_ReFire;
		PLPI B 2;
		Goto Ready;
	AltFire://holdfire
		PLPI A 2;
		PLPI A 0 A_StartCharge;
	AltLoop:
		PLPI A 2;
		PLPI A 0 A_Charge;
	AltRelease:
		PLPI A 4;
		PLPI B 6 A_AltFire;
		PLPI C 2;
		PLPI B 2;
		Goto Ready;
 	Spawn:
		PLSP A -1;
		Stop;
	}
	action void A_Fire_MPistol(){
		A_AlertMonsters();
		A_TakeInventory("Mana",5);
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_FireProjectile("ManaBall_Regular");
	}
	action void A_StartCharge(){
		invoker.charge=0;
	}
	action State A_Charge(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ALTATTACK==BT_ALTATTACK){
			if(CountInv("Mana")>0&&invoker.charge<invoker.maxcharge){
				A_TakeInventory("Mana",1);
				invoker.charge++;
			}
			return ResolveState("AltLoop");
		}else{
			return ResolveState("AltRelease");
		}
	}
	action void A_AltFire(){
		int firenum=(invoker.charge/invoker.firedivide);
		string tofire="ManaBall_Alt"..firenum;
		A_Log(tofire);
		A_AlertMonsters();
		A_Recoil(1.0*firenum);
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		A_FireProjectile(tofire);
		invoker.charge=0;
	}
}