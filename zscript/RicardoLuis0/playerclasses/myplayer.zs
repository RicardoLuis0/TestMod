class VisTracer:BulletPuff{
	Default{
		+ALWAYSPUFF
		+PUFFONACTORS
	}
	override void BeginPlay(){
		super.BeginPlay();
		console.printf("VisTracer Spawn");
	}
	/*
	States{
	Spawn:
		TNT1 A 0;
	Melee:
		TNT1 A 0;
		Stop;
	}*/
}

class BVector{
	bool valid;
	//int x,y,z;
	Vector3 v;
	virtual BVector Init(Vector3 nv,bool nb=true){
		v=nv;
		valid=nb;
		return self;
	}
}

class MyPlayer : PlayerPawn{
	int ipow(int a,int e){
		int r=1;
		for(;e>0;e--){
			r*=a;
		}
		return r;
	}

	Array<string> allowed_spawn_classes;
	override void BeginPlay(){
		super.BeginPlay();
		initClasses();
	}

	Vector3 getLookAtPos(){
		Vistracer p=Vistracer(LineAttack(angle,4096,pitch,0,"None","VisTracer"));
		if(p){
			Vector3 ret=p.pos;
			p.destroy();
			return ret;
		}
		console.printf("Cast Fail");
		return pos;
	}

	virtual void initClasses(){
		allowed_spawn_classes.Push("All");
	}

	virtual int getClassCount(){
		return allowed_spawn_classes.Size();
	}

	virtual string getClassAtIndex(int index){
		return allowed_spawn_classes[index];
	}

	virtual bool allowMana(){
		return true;
	}

	virtual void pGiveInventory(String str,int amt){
		A_GiveInventory(str,amt);
	}

	virtual void pTakeInventory(String str,int amt){
		A_TakeInventory(str,amt);
	}

	virtual void pSetInventory(String str,int amt){
		A_SetInventory(str,amt);
	}

	virtual int pCountInv(String str){
		return CountInv(str);
	}

	virtual int pFindUniqueTid(){
		return FindUniqueTid();
	}

	Default{
		Speed 1;
		Health 100;
		Radius 16;
		Height 56;
		Mass 100;
		PainChance 255;
		Player.DisplayName "...";
		Player.CrouchSprite "PLYC";
		
		Player.StartItem "MPistol";
		Player.StartItem "Pistol";
		Player.StartItem "Fist";
		Player.StartItem "ManaRegenHandler";
		Player.StartItem "ManaCapacity",100;
		Player.StartItem "ManaRegenAmt",1;
		Player.StartItem "Clip", 90;
		//Player.StartItem "AKAMMO",31;
		
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
		// Doom Legacy additions
		Player.Colorset 4, "Light Gray",	0x58, 0x67,  0x5A;
		Player.Colorset 5, "Light Brown",	0x38, 0x47,  0x3A;
		Player.Colorset 6, "Light Red",		0xB0, 0xBF,  0xB2;
		Player.Colorset 7, "Light Blue",	0xC0, 0xCF,  0xC2;
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