extend class ModWeaponBase {
	
	static int TracerCalcDamage(int dmg){
		switch(sv_random_damage_mode){
		default:
		case 0://doom type random
			return dmg * Random[cabullet](1,3);
		case 1://full random
			return int(dmg * fRandom[cabullet](1,3));
		case 2://no random
			return dmg * 2;
		}
	}
	
	//THIS ALWAYS IGNORES AUTOAIM
	action void W_FireTracer(Vector2 spread, int dmg, int count = 1, class<ModBulletPuffBase> puff = "ModBulletPuffBase", int flags = FBF_USEAMMO, double range = PLAYERMISSILERANGE, bool drawTracer = true){
		if(!player) return;
		
		let attack_zoff = (player.mo.attackZOffset * player.crouchfactor);
		
		let attack_height = (player.mo.height / 2) + attack_zoff;
		
		FTranslatedLineTarget t;
		
		int laflags = (flags & FBF_NORANDOMPUFFZ)? LAF_NORANDOMPUFFZ : 0;
		
		if(flags & FBF_NORANDOMPUFFZ) {
			laflags |= LAF_NORANDOMPUFFZ;
		}
		
		if(drawTracer){
			laflags |= LAF_NOIMPACTDECAL;
		}
		
		if((flags & FBF_USEAMMO) && player.ReadyWeapon &&  stateinfo != null && stateinfo.mStateType == STATE_Psprite) {
			if(!player.ReadyWeapon.DepleteAmmo(player.ReadyWeapon.bAltFire, true)) return;	// out of ammo
		}
		
		if(count <= 0) count = 1;
		
		if(!(flags & FBF_NOFLASH)) player.mo.PlayAttacking2();
			
		Vector2 aim;
		
		if(flags & FBF_EXPLICITANGLE) {
			aim = (angle,pitch) + spread;
		}
		
		for(int i = 0; i < count; i++) {
			int newdmg = dmg;
			if(!(flags & FBF_NORANDOM)) {
				newdmg = TracerCalcDamage(dmg);
			}
			
			if(!(flags & FBF_EXPLICITANGLE)) {
				aim = (angle,pitch) + (fRandom[cabullet](-1.0,1.0) * spread.x , fRandom[cabullet](-1.0,1.0) * spread.y);
			}
			
			ModBulletPuffBase puff = ModBulletPuffBase(LineAttack(aim.x,range,aim.y,newdmg,GetDefaultByType(puff).default.DamageType,puff,laflags,t));
			
			if(drawTracer) {
				A_RailAttack(0,0,false,"","FFFF7F",RGF_SILENT|RGF_NOPIERCING|RGF_EXPLICITANGLE|RGF_FULLBRIGHT,0,"VisTracer",aim.x - angle,aim.y - pitch,range,1,0.25,0);
			}
			
			Line line = null;
			
			FLineTraceData l;
			bool ok = LineTrace(aim.x,range,aim.y,offsetz:attack_height,data:l);
			if(ok){
				line = l.hitLine;
			}
			
			if(puff) {
				puff.doPuffFX(aim.x,line,t.lineTarget);
			}
		}
	}
	
	action void W_FireTracerSpreadXY(int dmg,double min,double max,double refire_rate=1.0,double refire_max=0.25,double refire_start=0.0,int count = 1,class<ModBulletPuffBase> puff = "ModBulletPuffBase",int flags = FBF_USEAMMO,double range = PLAYERMISSILERANGE){
		Vector2 spread;
		for(int i=0;i<count;i++){
			[spread.x,spread.y]=W_CalcSpreadXY(min,max,refire_rate,refire_max,refire_start);
			W_FireTracer(spread,dmg,1,puff,flags|FBF_EXPLICITANGLE);
			flags &= ~FBF_USEAMMO;
		}
	}
}