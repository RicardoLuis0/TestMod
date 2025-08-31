class InvUseTracer : LineTracer
{
	override ETraceStatus TraceCallback()
	{
		if(results.HitType != TRACE_HitActor || results.HitActor is "Inventory")
		{
			return TRACE_Stop;
		}
		else
		{
			return TRACE_Skip;
		}
	}
}


extend class TestModPlayer
{
	Inventory inv_lasthit;
	
	double pickup_distance;
	
	void UseToPickupInit(){
		pickup_distance=150;
	}
	
	void UseToPickupTick()
	{
		if(sv_use_to_pickup)
		{
			bPickup = false;
			
			bool inv_use = player.cmd.buttons & BT_USE;
			bool inv_hold = (player.oldbuttons&player.cmd.buttons) & BT_USE;
			
			let t = new('InvUseTracer');
			
			//if(LineTrace(angle, 4096, pitch, TRF_THRUHITSCAN | TRF_ALLACTORS, height-12, 0, 0, t))
			double c = cos(pitch);
			
			Vector3 dir = (cos(angle) * c, sin(angle) * c, -sin(pitch));
			
			inv_lasthit = null;
			if(t.Trace((Pos.X, Pos.Y, Player.ViewZ), cursector, dir, pickup_distance, TRACE_NoSky, Line.ML_BLOCKEVERYTHING, false, self))
			{
				
				if((t.results.HitType == TRACE_HitActor))
				{
					if(t.results.HitActor is "Inventory")
					{
						inv_lasthit=Inventory(t.results.HitActor);
						
						if(inv_use && !inv_hold)
						{
							inv_lasthit.Touch(self);
						}
					}
				}
			}
		}
		else
		{
			bPickup=true;
			if(inv_lasthit)
			{
				inv_lasthit=null;
			}
		}
	}

}