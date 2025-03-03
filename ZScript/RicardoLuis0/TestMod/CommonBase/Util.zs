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
	
	static play void SetPlayerRestrict(Actor item, PlayerInfo player)
	{
		if(item is 'LightClip')
		{
			LightClip(item).PlayerRestrict = player;
			LightClip(item).UpdateLocalRendering();
		}
		else if(item is 'HeavyClip')
		{
			HeavyClip(item).PlayerRestrict = player;
			HeavyClip(item).UpdateLocalRendering();
		}
		else if(item is 'NewShell')
		{
			NewShell(item).PlayerRestrict = player;
			NewShell(item).UpdateLocalRendering();
		}
		else if(item is 'NewCell')
		{
			NewCell(item).PlayerRestrict = player;
			NewCell(item).UpdateLocalRendering();
		}
		else if(item is 'NewRocketAmmo')
		{
			NewRocketAmmo(item).PlayerRestrict = player;
			NewRocketAmmo(item).UpdateLocalRendering();
		}
		else if(item is 'ArmorShard')
		{
			ArmorShard(item).PlayerRestrict = player;
			ArmorShard(item).UpdateLocalRendering();
		}
		else if(item is 'IncrementalBackpack')
		{
			IncrementalBackpack(item).PlayerRestrict = player;
			IncrementalBackpack(item).UpdateLocalRendering();
		}
		else if(item is 'PortableMedKit')
		{
			PortableMedKit(item).PlayerRestrict = player;
			PortableMedKit(item).UpdateLocalRendering();
		}
		else if(item is 'TestModMedikit')
		{
			TestModMedikit(item).PlayerRestrict = player;
			TestModMedikit(item).UpdateLocalRendering();
		}
		else if(item is 'ModWeaponBase')
		{
			ModWeaponBase(item).PlayerRestrict = player;
			ModWeaponBase(item).UpdateLocalRendering();
		}
		else
		{
			Console.Printf("\c[Red] Cannot set PlayerRestrict for unmanaged item "..item.GetClassName());
		}
	}
	
	
	static play PlayerInfo GetPlayerRestrict(Actor item)
	{
		if(item is 'LightClip')
		{
			return LightClip(item).PlayerRestrict;
		}
		else if(item is 'HeavyClip')
		{
			return HeavyClip(item).PlayerRestrict;
		}
		else if(item is 'NewShell')
		{
			return NewShell(item).PlayerRestrict;
		}
		else if(item is 'NewCell')
		{
			return NewCell(item).PlayerRestrict;
		}
		else if(item is 'NewRocketAmmo')
		{
			return NewRocketAmmo(item).PlayerRestrict;
		}
		else if(item is 'ArmorShard')
		{
			return ArmorShard(item).PlayerRestrict;
		}
		else if(item is 'IncrementalBackpack')
		{
			return IncrementalBackpack(item).PlayerRestrict;
		}
		else if(item is 'PortableMedKit')
		{
			return PortableMedKit(item).PlayerRestrict;
		}
		else if(item is 'TestModMedikit')
		{
			return TestModMedikit(item).PlayerRestrict;
		}
		else if(item is 'ModWeaponBase')
		{
			return ModWeaponBase(item).PlayerRestrict;
		}
		else
		{
			return nullptr;
		}
	}
	
	static play void UpdateLocalRendering(Actor item)
	{
		if(item is 'LightClip')
		{
			LightClip(item).UpdateLocalRendering();
		}
		else if(item is 'HeavyClip')
		{
			HeavyClip(item).UpdateLocalRendering();
		}
		else if(item is 'NewShell')
		{
			NewShell(item).UpdateLocalRendering();
		}
		else if(item is 'NewCell')
		{
			NewCell(item).UpdateLocalRendering();
		}
		else if(item is 'NewRocketAmmo')
		{
			NewRocketAmmo(item).UpdateLocalRendering();
		}
		else if(item is 'ArmorShard')
		{
			ArmorShard(item).UpdateLocalRendering();
		}
		else if(item is 'IncrementalBackpack')
		{
			IncrementalBackpack(item).UpdateLocalRendering();
		}
		else if(item is 'PortableMedKit')
		{
			PortableMedKit(item).UpdateLocalRendering();
		}
		else if(item is 'TestModMedikit')
		{
			TestModMedikit(item).UpdateLocalRendering();
		}
		else if(item is 'ModWeaponBase')
		{
			ModWeaponBase(item).UpdateLocalRendering();
		}
	}
}