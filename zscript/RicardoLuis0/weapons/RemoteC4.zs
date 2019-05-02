class C4_Weap:Weapon{
	Default{
		Weapon.SlotNumber 5;
		+WEAPON.NOALERT;
	}
	States{
	Ready:
		PISG A 1 A_WeaponReady;
		Loop;
	Deselect:
		PISG A 1 A_Lower;
		Loop;
	Select:
		PISG A 1 A_Raise;
		Loop;
	Fire:
		PISG A 4;
		PISG A 0 {
			int input=GetPlayerInput(INPUT_BUTTONS);
			if(input&BT_CROUCH){
				return ResolveState("ThrowSlow");
			}
			return ResolveState(null);
		}
		PISG B 6 A_ThrowGrenade("C4_World",8,20,4);
		Goto ThrowEnd;
	ThrowSlow:
		PISG B 6 A_ThrowGrenade("C4_World",8,8,4);
	ThrowEnd:
		PISG C 4;
		PISG B 5 A_ReFire;
		Goto Ready;
	AltFire:
		PISG A 1{
			ThinkerIterator it = ThinkerIterator.Create("C4_World");
			for(C4_World p=C4_World(it.Next());p!=null;p=C4_World(it.Next())){
				p.destroyself();
			}
		}
		Goto Ready;
	Flash:
		PISF A 7 Bright A_Light1;
		Goto LightDone;
		PISF A 7 Bright A_Light1;
		Goto LightDone;
 	Spawn:
		PIST A -1;
		Stop;
	}
}

class C4_World:Actor{
	bool exploded;
	Default{
		Radius 8;
		Height 8;
		Speed 0;
		Damage 0;
		Projectile;
		-NOGRAVITY
		-NOLIFTDROP
		//-SOLID
		//+NOEXPLODEFLOOR
		+DEHEXPLOSION
		//+BOUNCEONACTORS
		BounceType "Doom";
	}
	override void BeginPlay(){
		Super.BeginPlay();
		exploded=false;
	}
	States{
	Spawn:
		SGRN A 1;
		Loop;
	Death:
		TNT1 A 0{
			A_ChangeVelocity(0,0,0,CVF_REPLACE);
		}
	DeathLoop:
		SGRN A 1;
		Loop;
	Explode:
		TNT1 A 0 {
			bNOGRAVITY=true;
			A_ChangeVelocity(0,0,0,CVF_REPLACE);
			exploded=true;
		}
		MISL B 8 Bright A_Explode;
		MISL C 6 Bright;
		MISL D 4 Bright;
		Stop;
	/*
	Grenade:
		MISL A 1000 A_Die;
		Wait;
	Detonate:
		MISL B 4 A_Scream;
		MISL C 6 A_Detonate;
		MISL D 10;
		Stop;
	Mushroom:
		MISL B 8 A_Mushroom;
		Goto Death+1;
	*/
	}
	virtual void destroyself(){
		if(!exploded) SetState(ResolveState("Explode"));
	}
}