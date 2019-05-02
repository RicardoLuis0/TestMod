class Resurrector:Weapon{
	Default{
		Weapon.SlotNumber 2;
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
		let pt = MyPlayer(invoker.owner);
		if(pt){
			ThinkerIterator list = ThinkerIterator.Create("MyEnemy");
			while(1){
				let a=MyEnemy(list.Next());
				if(a){
					if ((pt.Distance2D(a)<radius)&&(ignore_sight||pt.CheckSight(a))){
						a.raise(true);
					}
				}else{
					break;
				}
			}
		}
	}
}