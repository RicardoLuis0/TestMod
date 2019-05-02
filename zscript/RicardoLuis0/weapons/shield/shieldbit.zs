class ShieldBit : Actor{
	int ticks_since_damage;
	int ticks_till_regen;
	int regen_cooldown;
	int regen_amount;
	int max_health;
	override void BeginPlay(){
		super.BeginPlay();
		//A_SetRenderStyle(1,STYLE_AddStencil);
		//SetShade(0x00FF00);
		//internal variables
		max_health=255;
		ticks_since_damage=0;
		ticks_till_regen=5;
		regen_cooldown=20;
		regen_amount=1;
		//flags/properties
		health=max_health;
		//other
		retint();
	}
	Default{
		+SHOOTABLE
		+NOGRAVITY
		+NOTELEPORT
		+DONTRIP
		+DONTTHRUST
		+NOBLOODDECALS
		//+WALLSPRITE
		BloodType "None";
	}
	override void Tick(){
		super.Tick();
		ticks_since_damage++;
		if(ticks_since_damage>regen_cooldown){
			if(health<max_health){
				if(health+regen_amount<max_health){
					health+=regen_amount;
				}else{
					health=max_health;
				}
				retint();
			}
		}
	}
	override int DamageMobj(Actor inflictor,Actor source,int damage,Name mod,int flags,double angle){
		int ret=super.DamageMobj(inflictor,source,damage,mod,flags,angle);
		ticks_since_damage=0;
		ShieldBitHit(Spawn("ShieldBitHit",inflictor.pos)).SetColor((double(health)/max_health)*255);
		retint();
		return ret;
	}
	void retint(){
		int damagefactor=(double(health)/max_health)*255;
		A_SetTranslation("SHIELDBIT_TRANS_"..damagefactor);
	}
	States{
		Spawn:
			HEXA A 1 Bright;
			Loop;
		Die:
			TNT1 A 0;
			Stop;
	}
}
class ShieldBitHit:Actor{
	Default{
		Radius 1;
		Height 1;
		Scale 0.5;
		Renderstyle "Add";
		+NOGRAVITY
		+NOTELEPORT
		+NOINTERACTION
	}
	/*
	override void BeginPlay(){
		super.BeginPlay();
		ShieldBit p=ShieldBit(target);
		if(p){
			int damagefactor=(double(p.health)/p.max_health)*255;
			A_SetTranslation("SHIELDBIT_TRANS_"..damagefactor);
		}else{
			console.printf("Cast Fail");
		}
	}
	*/
	void SetColor(int index){
		A_SetTranslation("SHIELDBIT_TRANS_"..index);
	}
	States{
	Spawn:
		FHIT A 0 bright;
		FHIT A 1 bright A_Stop;
		FHIT A 0 bright A_PlaySound ("ForceBarrier/Hit");
		FHIT BCDEFGH 1 bright;
		Stop;
	}
}