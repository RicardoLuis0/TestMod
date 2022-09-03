class PistolZombieManClipDrop : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("EmptyThingSpawnerElement").Init(8));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",1,2,ALLOW_REPLACE));
	}
}

class SMGZombieManClipDrop : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("EmptyThingSpawnerElement").Init(16));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("LightClip",1,8,ALLOW_REPLACE));
	}
}

class RifleZombieManClipDrop : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("EmptyThingSpawnerElement").Init(7));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("HeavyClip",1,1,ALLOW_REPLACE));
	}
}

class ZombieManArmorDrop : ThingSpawner {
	override void setDrops(){
		spawnlist.Push(new("BasicThingSpawnerElement").Init("ArmorShard",1,7,ALLOW_REPLACE));
		spawnlist.Push(new("BasicThingSpawnerElement").Init("ArmorShard",2,1,ALLOW_REPLACE));
	}
}

class ZombieManSpawner : RandomSpawner replaces ZombieMan {
	Default {
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "PistolZombieMan";
		DropItem "SMGZombieMan";
		DropItem "SMGZombieMan";
		DropItem "ArmoredRifleZombieMan";
	}
}

class TracerZombieMan : ZombieMan {
	mixin TracerEnemy;
}

class SMGZombieMan : TracerZombieMan {
	Default {
		Health 40;
		Speed 8;
		PainChance 150;
		DropItem "SMG";
		DropItem "SMGZombieManClipDrop";
		AttackSound "";
		Tag "$FN_SMGZOMBIE";
	}
	States {
	Spawn:
		MGPO AB 10 A_Look;
		Loop;
	SeeStun:
		MGPO A 16;
	See:
		MGPO AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		MGPO E 8 A_FaceTarget;
	MissileLoop:
		MGPO E 0 A_FaceTarget;
		MGPO F 2 BRIGHT  {
			A_StartSound("weapons/pistol_fire",CHAN_WEAPON,CHANF_OVERLAP,0.35);
			
			E_CustomTracerAttack((12,0),random(1,5),flags:CBAF_NORANDOM,drawTracer:sv_light_bullet_tracers);
		}
		MGPO E 2 A_MonsterRefire(192,"SeeStun");
		Loop;
	Pain:
		MGPO G 3;
		MGPO G 3 A_Pain;
		Goto See;
	Death:
		MGPO H 5;
		MGPO I 5 A_Scream;
		MGPO J 5 A_NoBlocking;
		MGPO K 5;
		MGPO L -1;
		Stop;
	XDeath:
		MGPO M 5;
		MGPO N 5 A_XScream;
		MGPO O 5 A_NoBlocking;
		MGPO PQRST 5;
		MGPO U -1;
		Stop;
	Raise:
		MGPO K 5;
		MGPO JIH 5;
		Goto See;
	}
}
class PistolZombieMan : TracerZombieMan {
	Default{
		DropItem "PistolZombieManClipDrop";
		DropItem "NewPistol";
		AttackSound "";
	}
	States{
	Spawn:
		PPSS AB 10 A_Look;
		Loop;
	See:
		PPSS AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		PPSS E 10 A_FaceTarget;
		PPSS F 8 {
			A_StartSound("weapons/pistol_fire",CHAN_WEAPON,CHANF_OVERLAP,0.25);
			
			E_CustomTracerAttack((22.5,0),random(1,5)*3,flags:CBAF_NORANDOM,drawTracer:sv_light_bullet_tracers);
		}
		PPSS E 8;
		Goto See;
	Pain:
		PPSS G 3;
		PPSS G 3 A_Pain;
		Goto See;
	Death:
		PPSS H 5;
		POSS I 5 A_Scream;
		POSS J 5 A_NoBlocking;
		POSS K 5;
		POSS L -1;
		Stop;
	XDeath:
		POSS M 5;
		POSS N 5 A_XScream;
		POSS O 5 A_NoBlocking;
		POSS PQRST 5;
		POSS U -1;
		Stop;
	Raise:
		POSS K 5;
		POSS JIH 5;
		Goto See;
	}
}

class ArmoredRifleZombieMan : TracerZombieMan {
	Default{
		DropItem "RifleZombieManClipDrop";
		DropItem "AssaultRifle";
		DropItem "ZombieManArmorDrop";
		AttackSound "";
		Health 60;//has more health
		PainChance 64;//less stun
		Tag "$FN_RIFLEZOMBIE";
	}

	action void A_RPosAttack1(){//attack 1 for possessed riflemen, more accurate
		A_StartSound("weapons/ar_fire",CHAN_WEAPON,CHANF_OVERLAP,0.5);
		
		E_CustomTracerAttack((15,0),random(1,3) * 3,flags:CBAF_NORANDOM,drawTracer:sv_heavy_bullet_tracers);
	}

	action void A_RPosAttack2(){//attack 2 for possessed riflemen, less accurate
		A_StartSound("weapons/ar_fire",CHAN_WEAPON,CHANF_OVERLAP,0.5);
		
		E_CustomTracerAttack((30,0),random(1,3) * 3,flags:CBAF_NORANDOM,drawTracer:sv_heavy_bullet_tracers);
	}
	
	override int DamageMobj(Actor inflictor, Actor source, int damage, Name mod, int flags, double angle){
		if((mod!="Piercing")&&(damage>0)){//if not armor piercing and not healing, apply damage resistance of 5
			if(damage>5){
				damage-=5;
			}else{
				damage=0;
			}
		}
		return Super.DamageMobj(inflictor,source,damage,mod,flags,angle);
	}
	
	States {
	Spawn:
		RFTR AB 10 A_Look;
		Loop;
	SeeStun:
		RFTR A 16;
	See:
		RFTR AABBCCDD 4 A_Chase;
		Loop;
	Missile:
		TNT1 A 0 A_Jump(16,"FireSingle");//6.25% chance of firing once
		TNT1 A 0 A_Jump(64,"FireMany");//25% chance of firing many times
		Goto FireBurst;
	FireSingle:
		RFTR E 10 A_FaceTarget;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 3;
		Goto See;
	FireBurst:
		RFTR E 10 A_FaceTarget;//fire 3 shots, pause for a while
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack1;
		RFTR E 5;
		Goto See;
	FireMany:
		RFTR E 10 A_FaceTarget;
	FireManyLoop:
		RFTR E 0 A_FaceTarget;
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 1;
		RFTR F 3 Bright A_RPosAttack2;
		RFTR E 3;
		RFTR E 0 A_MonsterRefire(128,"SeeStun");//50% chance for each shot to continue firing while out of sight
		RFTR E 3 A_Jump(32,"SeeStun");//12.5% chance to stop firing
		Loop;
	Pain:
		RFTR G 3;
		RFTR G 3 A_Pain;
		Goto SeeStun;
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
