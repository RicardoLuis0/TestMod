extend class ModWeaponBase
{
	action Actor, Actor W_FireProjectile(
			class<Actor> missiletype,
			double angle = 0,
			bool useammo = true,
			double spawnofs_xy = 0,
			double spawnheight = 0,
			int flags = 0,
			double pitch = 0)
	{
		Vector2 newAngles = ConvertUnitToAngle((Quat.FromAngles(self.angle, self.pitch, self.roll) * Quat.AxisAngle((0,0,1), angle) * Quat.AxisAngle((0,1,0), pitch)) * (1,0,0));
		
		angle = DeltaAngle(self.angle, newAngles.x);
		pitch = DeltaAngle(self.pitch, newAngles.y);
		
		return A_FireProjectile(missiletype, angle, useammo, spawnofs_xy, spawnheight, flags, pitch);
	}
}