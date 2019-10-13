class PistolZombieManClipDrop : BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("None",1,4,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",1,2,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",2,1,ALLOW_REPLACE));
	}
}

class RifleZombieManClipDrop : BasicThingSpawner{
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",1,4,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",2,2,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",4,1,ALLOW_REPLACE));
	}
}

class ZombieManSpawner : RandomSpawner replaces ZombieMan {
	Default {
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "RifleZombieMan";
		DropItem "RifleZombieMan";
	}
}

class PistolZombieMan : ZombieMan{
	Default{
		DropItem "PistolZombieManClipDrop";
		DropItem "MyPistol";
	}
}

class RifleZombieMan : ZombieMan{
	Default{
		DropItem "RifleZombieManClipDrop";
		DropItem "AssaultRifle";
		Health 40;
	}
	States {
	Spawn:
		RFTR AB 10 A_Look;
		Loop;
	See:
		RFTR AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		RFTR E 10 A_FaceTarget;
		RFTR F 5 Bright A_PosAttack;
		RFTR E 5 A_CPosRefire;
		Goto Missile+1;
	Pain:
		RFTR G 3;
		RFTR G 3 A_Pain;
		Goto See;
	Death: 
		RFTR H 5;
		RFTR I 5 A_Scream;
		RFTR J 5 A_Fall;
		RFTR K 5;
		RFTR L -1;
		Stop;
	XDeath:
		RFTR M 5;
		RFTR N 5 A_XScream;
		RFTR N 5;
		RFTR P 5 A_Fall;
		RFTR QRST 5;
		RFTR U -1;
		Stop;
	Raise:
		RFTR KJ 5;
		RFTR IH 5;
		Goto See;
	}
}
