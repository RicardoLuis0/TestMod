class VisTracer:BulletPuff{
	Default{
		+ALWAYSPUFF
		+PUFFONACTORS
		+BLOODLESSIMPACT
		+DONTSPLASH
		+NODECAL
		-RANDOMIZE
		VSpeed 0;
	}
	States{
	Spawn:
		TNT1 A 0;
		Stop;
	}
}

class TestModPlayer : PlayerPawn{
	double fmove1temp,fmove2temp,smove1temp,smove2temp,vbobtemp;
	bool movemod;
	bool look_calc;
	Vector3 look_pos;
	Default{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;

		//+THRUSPECIES;
		//Species "ThruPlayer";

		Player.DisplayName "Pistol Start (Harder)";
		Player.CrouchSprite "PLYC";

		Player.StartItem "MyPistol";
		Player.StartItem "Clip", 51;//3 pistol clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";

		Player.WeaponSlot 1, "Fist","Chainsaw";
		Player.WeaponSlot 2, "Pistol";
		Player.WeaponSlot 3, "Shotgun","SuperShotgun";
		Player.WeaponSlot 4, "Chaingun";
		Player.WeaponSlot 5, "RocketLauncher";
		Player.WeaponSlot 6, "PlasmaRifle";
		Player.WeaponSlot 7, "BFG9000";

		Player.ColorRange 112, 127;
		Player.Colorset 0, "Green",			0x70, 0x7F,  0x72;
		Player.Colorset 1, "Gray",			0x60, 0x6F,  0x62;
		Player.Colorset 2, "Brown",			0x40, 0x4F,  0x42;
		Player.Colorset 3, "Red",			0x20, 0x2F,  0x22;
		Player.Colorset 4, "Light Gray",	0x58, 0x67,  0x5A;
		Player.Colorset 5, "Light Brown",	0x38, 0x47,  0x3A;
		Player.Colorset 6, "Light Red",		0xB0, 0xBF,  0xB2;
		Player.Colorset 7, "Light Blue",	0xC0, 0xCF,  0xC2;
	}

	int ipow(int a,int e){
		int r=1;
		for(;e>0;e--){
			r*=a;
		}
		return r;
	}

	override void BeginPlay(){
		super.BeginPlay();
		console.printf(":"..(1/2.0));
		pickup_distance=150;
	}
	override void PostBeginPlay(){
		super.PostBeginPlay();
		initInertia();
	}
	Actor inv_lasthit;
	bool inv_lastbright;
	bool inv_hold;
	double pickup_distance;
	void glow(Actor a,out bool lastbright){
		if(a is "MyInventory"){
			MyInventory(a).glowStart();
		}else if(a is "MyWeapon"){
			MyWeapon(a).glowStart();
		}else if(a is "MyHealth"){
			MyHealth(a).glowStart();
		}else if(a is "MyHealthPickup"){
			MyHealthPickup(a).glowStart();
		}else if(a is "MyArmor"){
			MyArmor(a).glowStart();
		}else{
			a.A_SetTranslation("HoverGlow");
			lastbright=a.bBright;
			a.bBright=true;
		}
	}

	void unglow(Actor a,bool lastbright){
		if(a is "MyInventory"){
			MyInventory(a).glowEnd();
		}else if(a is "MyWeapon"){
			MyWeapon(a).glowEnd();
		}else if(a is "MyHealth"){
			MyHealth(a).glowEnd();
		}else if(a is "MyHealthPickup"){
			MyHealthPickup(a).glowEnd();
		}else if(a is "MyArmor"){
			MyArmor(a).glowEnd();
		}else{
			a.A_SetTranslation("None");
			a.bBright=lastbright;
		}
	}

	override void Tick(){
		Super.Tick();
		if (!player || !player.mo || player.mo != self){
			return;
		}else{
			InertiaTick();
			look_calc=false;
			if(player.ReadyWeapon is "MyWeapon"){
				MyWeapon(player.ReadyWeapon).ReadyTick();
			}
			if(sv_use_to_pickup){
				if(sv_auto_pickup){
					bPickup=true;
				}else{
					bPickup=false;
				}
				FLineTraceData t;
				bool inv_use=GetPlayerInput(INPUT_BUTTONS)&BT_USE;
				if(LineTrace(angle,4096,pitch,TRF_THRUHITSCAN|TRF_ALLACTORS,height-12,0,0,t)){
					Actor hit=null;
					if((t.HitType==TRACE_HitActor)){
						if(t.HitActor is "Inventory"&&Distance3D(t.HitActor)<=pickup_distance){
							hit=t.HitActor;
							if(hit!=inv_lasthit){
								if(inv_lasthit){
									unglow(inv_lasthit,inv_lastbright);
								}
								inv_lasthit=hit;
								glow(hit,inv_lastbright);
							}
							if(inv_use&&!inv_hold){
								//Inventory(hit).CallTryPickup(self);
								if(hit is "MyInventory"&&MyInventory(hit).notouch){
									MyInventory(hit).SuperTouch(self);
								}else{
									Inventory(hit).Touch(self);
								}
							}
						}
					}
					if(inv_lasthit&&!hit){
						unglow(inv_lasthit,inv_lastbright);
						inv_lasthit=null;
					}
				}
				inv_hold=(inv_use)?!sv_hold_to_pickup:false;
			}else{
				bPickup=true;
				if(inv_lasthit){
					unglow(inv_lasthit,inv_lastbright);
					inv_lasthit=null;
				}
			}
		}
	}

	BulletPuff LineAttack_Straight(String puff,int dmg,bool trueheight=false){
		if(trueheight){
			return BulletPuff(LineAttack(angle,4096,pitch,dmg,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT|LAF_OVERRIDEZ,offsetz:player.viewz-pos.z));
		}else{
			return BulletPuff(LineAttack(angle,4096,pitch,dmg,"None",puff,LAF_NORANDOMPUFFZ|LAF_NOINTERACT));
		}
	}

	Vector3 getLookAtPos(String puff="VisTracer"){//puff recommended to be derived from vistracer
		if(look_calc){
			return look_pos;
		}
		BulletPuff p=LineAttack_Straight(puff,0);
		if(p){
			Vector3 ret=p.pos;
			p.destroy();
			look_calc=true;
			look_pos=ret;
			return look_pos;
		}
		return pos;
	}

	void player_UpdateCVars(){
		weaponinertia_UpdateCVars();
	}

	States{
	Spawn:
		PLAY A -1;
		Loop;
	See:
		PLAY ABCD 4;
		Loop;
	Missile:
		PLAY E 12;
		Goto Spawn;
	Melee:
		PLAY F 6 BRIGHT;
		Goto Missile;
	Pain:
		PLAY G 4;
		PLAY G 4 A_Pain;
		Goto Spawn;
	Death:
		PLAY H 0 A_PlayerSkinCheck("AltSkinDeath");
	Death1:
		PLAY H 10;
		PLAY I 10 A_PlayerScream;
		PLAY J 10 A_NoBlocking;
		PLAY KLM 10;
		PLAY N -1;
		Stop;
	XDeath:
		PLAY O 0 A_PlayerSkinCheck("AltSkinXDeath");
	XDeath1:
		PLAY O 5;
		PLAY P 5 A_XScream;
		PLAY Q 5 A_NoBlocking;
		PLAY RSTUV 5;
		PLAY W -1;
		Stop;
	AltSkinDeath:
		PLAY H 6;
		PLAY I 6 A_PlayerScream;
		PLAY JK 6;
		PLAY L 6 A_NoBlocking;
		PLAY MNO 6;
		PLAY P -1;
		Stop;
	AltSkinXDeath:
		PLAY Q 5 A_PlayerScream;
		PLAY R 0 A_NoBlocking;
		PLAY R 5 A_SkullPop;
		PLAY STUVWX 5;
		PLAY Y -1;
		Stop;
	}
}