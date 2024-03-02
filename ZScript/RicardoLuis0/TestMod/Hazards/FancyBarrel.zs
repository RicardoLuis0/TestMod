class FancyExplosiveBarrel : ExplosiveBarrel replaces ExplosiveBarrel
{
	Default
	{
		Health 50; // make it sturdier so that the 'leak' effect can be seen more often
	}
	
	Array<Float> bleed_angle;
	Array<Float> bleed_height;
	Array<Float> bleed_strength;
	
	override int DamageMobj (Actor i, Actor s, int d, Name m, int f, double a)
	{
		int dam = super.DamageMobj(i,s,d,m,f,a);
		if(dam > 0 && health > 0)
		{
			double ang;
			double hgt;
			if(i != s)
			{
				let p = Level.Vec3Diff(pos,i.pos);
				ang = atan2(p.y,p.x);
				hgt = p.z;
			}
			else
			{
				let p = Level.Vec3Diff(pos,i.pos);
				ang = atan2(p.y,p.x);
				hgt = random[BarrelFX](0,height);
			}
			bleed_angle.Push(ang);
			bleed_height.Push(hgt);
			bleed_strength.Push(double(dam) / double(GetSpawnHealth()));
		}
		return dam;
	}
	
	override void Tick()
	{
		super.Tick();
		if(health > 0)
		{
			int n = bleed_angle.Size();
			for(int i = 0; i < n; i++)
			{
				console.printf("i: "..i.." str: "..bleed_strength[i]);
				A_SpawnParticle(0x00FF00,SPF_FULLBRIGHT|SPF_RELVEL|SPF_RELPOS,size:5,angle:bleed_angle[i],xoff:radius,zoff:bleed_height[i],velx:bleed_strength[i]*10,accelz:-1,startalphaf:0.5);
			}
		}
	}
}