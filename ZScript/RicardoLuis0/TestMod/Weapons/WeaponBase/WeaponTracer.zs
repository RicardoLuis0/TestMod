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
		
		double attack_zoff = (player.mo.attackZOffset * player.crouchfactor);
		
		double view_height = (player.mo.viewHeight * player.crouchfactor);
		
		double attack_height = (player.mo.height / 2) + attack_zoff;
		
		double view_zviewatk = player.viewz - (view_height - attack_height);
		
		double zoff = ((player.viewZ - pos.z) - view_height) + int(attack_zoff*1.5);
		
		
		console.printf(
			"attack_height: "..attack_height..
			" view_height: "..view_height..
			" view_zviewatk: "..view_zviewatk..
			" viewz: "..(player.viewZ-pos.z)..
			" zoff: "..zoff
		);
		
		
		FTranslatedLineTarget t;
		
		int laflags = (flags & FBF_NORANDOMPUFFZ)? LAF_NORANDOMPUFFZ : 0;
		
		if(flags & FBF_NORANDOMPUFFZ) {
			laflags |= LAF_NORANDOMPUFFZ;
		}
		
		/*
		if(drawTracer){
			laflags |= LAF_NOIMPACTDECAL;
		}
		*/
		
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
			
			Line line = null;
			
			if(puff || drawTracer) {
				FLineTraceData l;
				bool ok = LineTrace(aim.x,range,aim.y,TRF_SOLIDACTORS,attack_height,data:l);
				if(ok){
					line = l.hitLine;
				}
				
				if(drawTracer && ok) {
					vector3 tAnglePitch = Level.SphericalCoords((pos.x,pos.y,view_zviewatk),l.hitLocation,(angle,pitch));
					
					tAnglePitch = (-tAnglePitch.x,-tAnglePitch.y,tAnglePitch.z);
					
					//console.printf("tAnglePitch: "..tAnglePitch.xy.." aim: "..(aim-(angle,pitch)));
					
					A_RailAttack(0,
						spawnofs_xy:0,
						useammo:false,
						color1:"",
						color2:"FFFF7F",
						flags:RGF_SILENT|RGF_NOPIERCING|RGF_EXPLICITANGLE|RGF_FULLBRIGHT|RGF_CENTERZ,
						maxdiff:0,
						pufftype:"VisTracer",
						spread_xy:tAnglePitch.x,
						spread_z:tAnglePitch.y,
						range:range,
						duration:1,
						sparsity:0.25,
						driftspeed:0,
						spawnofs_z:zoff
					);
				}
				
				if(puff) {
					puff.doPuffFX(aim.x,line,t.lineTarget);
				}
			}
		}
	}
	
	action void W_FireTracerSpreadXY(int dmg,double min,double max,double refire_rate=1.0,double refire_max=0.25,double refire_start=0.0,int count = 1,class<ModBulletPuffBase> puff = "ModBulletPuffBase",int flags = FBF_USEAMMO,double range = PLAYERMISSILERANGE,bool drawTracer = true){
		Vector2 spread;
		for(int i=0;i<count;i++){
			[spread.x,spread.y]=W_CalcSpreadXY(min,max,refire_rate,refire_max,refire_start);
			W_FireTracer(spread,dmg,1,puff,flags|FBF_EXPLICITANGLE,range,drawTracer);
			flags &= ~FBF_USEAMMO;
		}
	}
}