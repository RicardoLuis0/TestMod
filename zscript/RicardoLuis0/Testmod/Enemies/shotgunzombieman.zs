

class ShotgunZombieManSpawner : RandomSpawner replaces ShotgunGuy {
	Default {
		DropItem "ShotgunZombieMan";
		DropItem "ShotgunZombieMan";
		DropItem "ShotgunZombieMan";
		DropItem "ShotgunZombieMan";
		DropItem "ShotgunZombieMan";
		DropItem "ShotgunZombieMan";
		DropItem "SSGZombieMan";
	}
}

Class ShotgunZombieMan : ShotgunGuy {
}

Class SSGZombieMan : Actor {
	Default {
		Health 80;
		Radius 20;
		Height 56;
		YScale 0.9;
		Speed 5;
		PainChance 225;
		Translation "112:127=16:47";
		SEESOUND "SSGUNER/sight";
		ATTACKSOUND "SSGUNER/SSG";
		PAINSOUND "grunt/pain";
		DEATHSOUND "SSGUNER/death";
		ACTIVESOUND "SSGUNER/idle";
		OBITUARY "%o was blown open by a SSG Zombie!";
		DropItem "SSG";
		DropItem "Shell";
		Decal "Bulletchip";
		MONSTER;
		+FloorClip
	}
	
	States {
	Spawn:
		GPOS A 10 A_Look();
		Loop;
	See:
		GPOS AABBCCDD 4 A_Chase();
		Loop;
	Missile:
		GPOS E 15 A_FaceTarget();
		GPOS F 8 BRIGHT A_CustomBulletAttack(11.2, 7.1, 15, 2, "Bulletpuff");
		GPOS E 8;
		Goto See;
	Pain:
		GPOS G 3;
		GPOS G 3 A_Pain();
		Goto See;
	Death:
		GPOS H 7;
		GPOS I 7 A_Scream();
		GPOS J 7 A_NoBlocking();
		GPOS KLM 7;
		GPOS N -1;
		Stop;
	XDeath:
		GPOS O 5;
		GPOS P 5 A_XScream();
		GPOS Q 5 A_NoBlocking();
		GPOS RS 5;
		GPOS T -1;
		Stop;
	Raise:
		GPOS NMLKJIH 5;
		Goto See;
	}
}
