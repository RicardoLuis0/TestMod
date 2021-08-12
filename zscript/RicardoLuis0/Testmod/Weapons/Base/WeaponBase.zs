class ModWeaponBase : Weapon {
	
	Default{
		Decal "BulletChip";
	}

	static Vector3 angleToVec3(double a_yaw,double a_pitch,double length=1){
		Vector3 o;
		o.x=cos(a_pitch)*cos(a_yaw);
		o.y=cos(a_pitch)*sin(a_yaw);
		o.z=-sin(a_pitch);
		return o*length;
	}

	static void DoParticleExplosion(actor origin,string x_color,int count,double strength,double size,int lifetime=20){
		for(int i=0;i<count;i++){
			double r_yaw=random(0,360);
			double r_pitch=random(0,360);
			vector3 vel=angleToVec3(r_yaw,r_pitch,strength);
			origin.A_SpawnParticle(x_color,SPF_FULLBRIGHT,lifetime,size,0,0,0,0,vel.x,vel.y,vel.z);
		}
	}

	action void W_FireBullets(double spread_horiz, double spread_vert, int count, int dmg, class<Actor> puff = "PuffBase", int flags = FBF_USEAMMO, double range = 0, class<Actor> missile = null, double vert_offset = 32, double horiz_offset = 0){
		if(player.refire==0){
			player.refire=1;
			W_FireBullets(spread_horiz,spread_vert,count,dmg,puff,flags,range,missile,vert_offset,horiz_offset);
			player.refire=1;
		}else if(flags&FBF_NORANDOM){
			A_FireBullets(spread_horiz,spread_vert,count,dmg,puff,flags,range,missile,vert_offset,horiz_offset);
		}else{
			switch(sv_random_damage_mode){
			default:
			case 0://doom type random
				A_FireBullets(spread_horiz,spread_vert,count,dmg,puff,flags,range,missile,vert_offset,horiz_offset);
				break;
			case 1://full random
				A_FireBullets(spread_horiz,spread_vert,count,random(dmg,dmg*3),puff,flags|FBF_NORANDOM,range,missile,vert_offset,horiz_offset);
				break;
			case 2://no random
				A_FireBullets(spread_horiz,spread_vert,count,dmg*2,puff,flags|FBF_NORANDOM,range,missile,vert_offset,horiz_offset);
				break;
			}
		}
	}

	virtual void ReadyTick() {
	}

	
	
}