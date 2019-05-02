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
		PISG B 6 A_ThrowGrenade("C4_World",20,8,4);
		PISG C 4;
		PISG B 5 A_ReFire;
		Goto Ready;
	AltFire:
		PISG A 1{
			let Tracker=My_Globals.get();
			if(Tracker){
				int TID=Tracker.tid_handler.getTID("C4_World");
				Console.printf("Destroy: "..TID);
				Thing_Destroy(TID);
			}
			//Thing_Destroy(TID_Handler.getTIDstatic("C4_World"));
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
	bool a;
	Default{
		Radius 8;
		Height 8;
		Speed 25;
		Damage 0;
		Projectile;
		-NOGRAVITY
		-MISSILE
		+DEHEXPLOSION
	}
	override void BeginPlay(){
		Super.BeginPlay();
		a=true;
	}
	States{
	Spawn:
		SGRN A 1 Bright A_C4_World_Set_TID;
		Loop;
	Death:
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
	action void A_C4_World_Set_TID(){
		if(invoker.a){
			int TID;
			let Tracker=My_Globals.get();
			if(Tracker){
				TID=Tracker.tid_handler.getTID("C4_World");
			}
			//TID=TID_Handler.getTIDstatic("C4_World");
			Console.printf("TID GOT: "..TID);
			Thing_ChangeTID(0,TID);
			invoker.a=false;
		}
	}
}