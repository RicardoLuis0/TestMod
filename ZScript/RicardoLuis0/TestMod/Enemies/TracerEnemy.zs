mixin class TracerEnemy {
	action void E_CustomTracerAttack(Vector2 spread, int dmg, int count = 1, class<ModBulletPuffBase> puff = "ModBulletPuffBase", double range = MISSILERANGE, int flags = 0, bool drawTracer = true) {
		int laflags = (flags & CBAF_NORANDOMPUFFZ)? LAF_NORANDOMPUFFZ : 0;
		FTranslatedLineTarget t;
		
		if(target && !(flags & CBAF_AIMFACING)) {
			A_Face(target);
		}
		
		double aim_pitch = pitch;
		if (!(flags & CBAF_NOPITCH)){
			aim_pitch = AimLineAttack (angle,MISSILERANGE);
		}
		
		for (int i = 0; i < count; i++) {
			Vector2 aim = (angle,aim_pitch);
			
			if(flags & CBAF_EXPLICITANGLE) {
				aim += spread;
			} else {
				aim += (spread.x * fRandom[cwbullet](-1.0,1.0), spread.y * fRandom[cwbullet](-1.0,1.0));
			}
			
			int realdmg = dmg;
			if(!(flags & CBAF_NORANDOM)) {
				realdmg *= random[cwbullet](1,3); // TODO use sv_random_damage_mode
			}
			
			ModBulletPuffBase puff = ModBulletPuffBase(LineAttack(aim.x,range,aim.y,realdmg,GetDefaultByType(puff).default.damagetype,puff,laflags,t));
			if(drawTracer && sv_enemy_tracers){
				A_CustomRailgun(0,0,"","FFFF7F",RGF_SILENT|RGF_NOPIERCING|RGF_EXPLICITANGLE|RGF_FULLBRIGHT,0,0,"VisTracer",aim.x - angle,aim.y - pitch,range,1,0.25,0);
			}
			if(puff) {
				Line line = null;
				
				FLineTraceData l;
				bool ok = LineTrace(aim.x,range,aim.y,offsetz:height/2,data:l);
				if(ok){
					line = l.hitLine;
				}
				puff.doPuffFX(aim.x,line,t.lineTarget,l.hitLocation);
			}
		}
	}
}