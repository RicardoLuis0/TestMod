class MCrossBow:Weapon replaces PlasmaRifle{
	Default{
		Weapon.AmmoType "Mana";
		Weapon.AmmoUse 0;
		Weapon.AmmoGive 0;
		Weapon.SlotNumber 6;
		Inventory.Pickupmessage "You've got the Mana Crossbow";
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
	}
	States{
	Spawn:
		WBOW A -1;
		Stop;
	Deselect:
		BOWF E 1 Bright A_Lower;
		Loop;
	Select:
		BOWF E 1 Bright A_Raise;
		Loop;
	Ready:
		BOWF E 1 A_WeaponReady;
		//BOWG AAABBBCCCDDDBBB 1 Bright A_WeaponReady;
    	Loop;
	Fire:
		BOWF E 0 A_CheckAmmo(5);
		BOWF E 2 A_PlaySound("weapons/cryobowreload");
		BOWF E 2 Offset(0,31);
		BOWF F 2 Offset(0,32);
		BOWF F 2 Offset(0,30);
		BOWF G 2 Offset(0,31);
		BOWF HI 1 Offset(0,32){
			int input=GetPlayerInput(INPUT_BUTTONS);
			if(input&BT_ATTACK==0){
				return ResolveState("FireStop");
			}
			return ResolveState(null);
		}
		BOWG CD 2 Bright Offset(0,32);
		BOWF A 2 Bright A_FireWeak;
		BOWF BCD 2 Bright;
		BOWF E 8 A_ReFire;
		Goto Ready;
	AltFire:
		BOWF E 0 A_CheckAmmo(25);
		BOWF E 4 A_PlaySound("weapons/cryobowreload");
		BOWF E 4 Offset(0,31);
		BOWF F 4 Offset(0,32);
		BOWF F 4 Offset(0,30);
		BOWF G 4 Offset(0,31);
		BOWF HI 2 Offset(0,32){
			int input=GetPlayerInput(INPUT_BUTTONS);
			if(input&BT_ALTATTACK==0){
				return ResolveState("FireStop");
			}
			return ResolveState(null);
		}
		BOWG CD 2 Bright Offset(0,32);
		BOWF A 2 Bright A_FireStrong;
		BOWF BCD 2 Bright;
		BOWF E 8 A_ReFire;
		Goto Ready;
	FireStop:
		//BOWF IH 1 Offset(0,32);
		BOWF G 2 Offset(0,31);
		BOWF F 2 Offset(0,30);
		BOWF F 2 Offset(0,32);
		BOWF E 2 Offset(0,31);
		Goto Ready;
	Flash:
		TNT1 A 2 Bright A_Light1;
		TNT1 A 2 Bright A_Light2;
		TNT1 A 1 Bright A_Light1;
		Goto LightDone;
	}
	action State A_CheckAmmo(int min){
		if(CountInv("Mana")<min){
			return ResolveState("Ready");
		}
		return ResolveState(null);
	}
	action void A_FireWeak(){
		A_GunFlash();
		A_TakeInventory("Mana",5);
		A_Recoil(2.0);
		A_PlaySound("weapons/cryobowshot");
		A_PlaySound("weapons/cryobowfire", CHAN_WEAPON);
		A_FireCustomMissile("ManaCrossbowShotWeak",0,1);
	}
	action void A_FireStrong(){
		A_GunFlash();
		A_TakeInventory("Mana",25);
		A_Recoil(8.0);
		A_PlaySound("weapons/cryobowshot");
		A_PlaySound("weapons/cryobowfire", CHAN_WEAPON);
		A_FireCustomMissile("ManaCrossbowShotStrong",0,1);
	}
}
/*
class CryoShot : FastProjectile{
	Default{
		Radius 4;
		Height 8;
		Speed 100;
		Damage 6;
		Projectile;
		RenderStyle "Add";
		Alpha 0.9;
		+EXTREMEDEATH;
		+RIPPER;
		DeathSound "weapons/cryobowhit";
		MissileType "CryoTrail";
		MissileHeight 8;
		Decal "PlasmaScorchLower";
	}
	States{
	Spawn:
		BSHT A 0 Bright;
		BSHT A 0 Bright A_PlaySound("weapons/cryobowflyby", CHAN_BODY, 1.0, 1);
		BSHT A 1 Bright;
		Loop;
	}
}
class CryoTrail:actor{
	Default{
		+NOINTERACTION;
		Radius 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.5;
	}
	States{
	Spawn:
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}
*/
class ManaCrossbowShotWeak:FastProjectile{
	Default{
		Radius 4;
		Height 8;
		Speed 50;
		Damage 1;
		Projectile;
		RenderStyle "Add";
		Alpha 0.7;
		+RIPPER;
		DeathSound "weapons/cryobowhit";
		MissileType "ManaTrailWeak";
		MissileHeight 8;
		Decal "PlasmaScorchLower";
	}
	States{
	Spawn:
		BSHT A 0 Bright ThrustThingZ(0,1,1,1);
		BSHT A 0 Bright A_PlaySound("weapons/cryobowflyby", CHAN_BODY, 1.0, 1);
		BSHT A 1 Bright;
		Loop;
	Death:
		stop;
	}
}
class ManaCrossbowShotStrong:FastProjectile{
	Default{
		Radius 4;
		Height 8;
		Speed 100;
		Damage 8;
		Projectile;
		RenderStyle "Add";
		Alpha 0.9;
		+EXTREMEDEATH;
		+RIPPER;
		DeathSound "weapons/cryobowhit";
		MissileType "ManaTrailStrong";
		MissileHeight 8;
		Decal "PlasmaScorchLower";
	}
	States{
	Spawn:
		BSHT A 0 Bright A_PlaySound("weapons/cryobowflyby", CHAN_BODY, 1.0, 1);
		BSHT A 1 Bright;
		Loop;
	Death:
		stop;
	}
}
class ManaTrailWeak:actor{
	Default{
		+NOINTERACTION;
		Radius 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.5;
	}
	States{
	Spawn:
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}
class ManaTrailStrong:actor{
	Default{
		+NOINTERACTION;
		Radius 16;
		Scale 4;
		Height 8;
		Renderstyle "Add";
		Alpha 0.5;
	}
	States{
	Spawn:
		BSHT AABBCDEFG 1 Bright;
		Stop;
	}
}