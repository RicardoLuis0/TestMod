class Resurrector:Weapon{
	Default{
		Weapon.SlotNumber 1;
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
		PISG B 6 A_Resurrect(200,false);
		PISG C 4;
		PISG B 5 A_ReFire;
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
	action void A_Resurrect(int radius,bool ignore_sight){
		ThinkerIterator it = ThinkerIterator.Create("Actor");
		//Credit to Zombie#1795 from ZDoom discord for this awesome workaround
		for(Actor mo; mo = Actor(it.Next());){
			if(!mo.bCorpse || !mo.bIsMonster || mo.bFriendly) continue;
			if ((player.mo.Distance2D(mo)<radius)&&(ignore_sight||player.mo.CheckSight(mo))){
				let temp  = mo.master;
				mo.master = mo;
				mo.A_RaiseMaster();
				mo.bFriendly = true;
				mo.Species="ThruPlayer";
				mo.bTHRUSPECIES = true;
				mo.master = temp;
			}
		}
	}
}