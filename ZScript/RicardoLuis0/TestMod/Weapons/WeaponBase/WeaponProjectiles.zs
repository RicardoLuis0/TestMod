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
		Vector2 newAngles = TestModUtil.OffsetAngleVA((self.angle, self.pitch, self.roll), (angle, pitch, 0));
		
		angle = DeltaAngle(self.angle, newAngles.x);
		pitch = DeltaAngle(self.pitch, newAngles.y);
		
		let [a, b] = A_FireProjectile(missiletype, angle, useammo, spawnofs_xy, spawnheight, flags, pitch);
		
		return a, b;
	}
}