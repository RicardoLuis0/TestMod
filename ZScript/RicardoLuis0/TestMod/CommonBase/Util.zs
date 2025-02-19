class TestModUtil
{
	static clearscope Vector2 ConvertUnitToAngle(Vector3 Unit)
	{
		return (atan2(Unit.y, Unit.x), -asin(Unit.z));
	}
	
	static clearscope Vector3 OffsetAngleV(Vector3 orig, Vector3 offset)
	{
		return (Quat.FromAngles(orig.x, orig.y, orig.z) * Quat.AxisAngle((1,0,0), offset.z) * Quat.AxisAngle((0,0,1), offset.x) * Quat.AxisAngle((0,1,0), offset.y)) * (1,0,0);
	}

	static clearscope Vector3 OffsetAngle(double angle, double pitch, double roll, double angleOffset, double pitchOffset, double rollOffset)
	{
		return OffsetAngleV((angle, pitch, roll), (angleOffset, pitchOffset, rollOffset));
	}
	
	static clearscope Vector2 OffsetAngleVA(Vector3 orig, Vector3 offset)
	{
		return ConvertUnitToAngle(OffsetAngleV(orig, offset));
	}

	static clearscope Vector2 OffsetAngleA(double angle, double pitch, double roll, double angleOffset, double pitchOffset, double rollOffset)
	{
		return OffsetAngleVA((angle, pitch, roll), (angleOffset, pitchOffset, rollOffset));
	}
}