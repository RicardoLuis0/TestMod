class SSGZombieAmmoDrop : NewShell {
	Default {
		Inventory.Amount 8;//double the value to account for drops halving ammo amount
	}
}

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

class ShotgunZombieMan : ShotgunGuy {
	mixin TracerEnemy;
	
	Default {
		DropItem "PumpShotgun";
	}
	
	States {
	Missile:
		SPOS E 10 A_FaceTarget;
		SPOS F 10 BRIGHT {
			A_StartSound("shotguy/attack",CHAN_WEAPON,CHANF_OVERLAP,1.0);
			
			E_CustomTracerAttack((22.5,0),random(1,5)*3,3,flags:CBAF_NORANDOM,drawTracer:sv_shotgun_tracers);
		}
		SPOS E 10;
		Goto See;
	}
}

class MaybeSSG : ThingSpawner {

	override void setDrops(){
		if(sv_ssg_zombie_drop_ssg){
			spawnlist.Push(new("BasicThingSpawnerElement").Init("SSG",1,1));
		}else{
			spawnlist.Push(new("BasicThingSpawnerElement").Init("SSGZombieAmmoDrop",1,1));
		}
	}

}


class SSGZombieMan : Actor {
	mixin TracerEnemy;
	
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
		DropItem "MaybeSSG";
		DropItem "SSGZombieAmmoDrop";
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
		GPOS F 8 BRIGHT {
			A_StartSound(AttackSound,CHAN_WEAPON,CHANF_OVERLAP,1.0);
			E_CustomTracerAttack((11.2, 7.1), 2, 15, drawTracer:sv_shotgun_tracers);
		}
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
