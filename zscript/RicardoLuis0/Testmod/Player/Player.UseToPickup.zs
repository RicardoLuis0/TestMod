extend class TestModPlayer {
	Actor inv_lasthit;
	bool inv_lastbright;
	bool inv_hold;
	double pickup_distance;
	void glow(Actor a,out bool lastbright){
		if(a is "MyInventory"){
			MyInventory(a).glowStart();
		}else if(a is "MyWeapon"){
			MyWeapon(a).glowStart();
		}else if(a is "MyHealth"){
			MyHealth(a).glowStart();
		}else if(a is "MyHealthPickup"){
			MyHealthPickup(a).glowStart();
		}else if(a is "MyArmorPickup"){
			MyArmorPickup(a).glowStart();
		}else if(a is "MyArmorBonus"){
			MyArmorBonus(a).glowStart();
		}else{
			a.A_SetTranslation("HoverGlow");
			lastbright=a.bBright;
			a.bBright=true;
		}
	}

	void unglow(Actor a,bool lastbright){
		if(a is "MyInventory"){
			MyInventory(a).glowEnd();
		}else if(a is "MyWeapon"){
			MyWeapon(a).glowEnd();
		}else if(a is "MyHealth"){
			MyHealth(a).glowEnd();
		}else if(a is "MyHealthPickup"){
			MyHealthPickup(a).glowEnd();
		}else if(a is "MyArmorPickup"){
			MyArmorPickup(a).glowEnd();
		}else if(a is "MyArmorBonus"){
			MyArmorBonus(a).glowEnd();
		}else{
			a.A_SetTranslation("None");
			a.bBright=lastbright;
		}
	}

	void UseToPickupInit(){
		pickup_distance=150;
	}

	void UseToPickupTick(){
		if(sv_use_to_pickup){
			if(sv_auto_pickup){
				bPickup=true;
			}else{
				bPickup=false;
			}
			FLineTraceData t;
			bool inv_use=GetPlayerInput(INPUT_BUTTONS)&BT_USE;
			if(LineTrace(angle,4096,pitch,TRF_THRUHITSCAN|TRF_ALLACTORS,height-12,0,0,t)){
				Actor hit=null;
				if((t.HitType==TRACE_HitActor)){
					if(t.HitActor is "Inventory"&&Distance3D(t.HitActor)<=pickup_distance){
						hit=t.HitActor;
						if(hit!=inv_lasthit){
							if(inv_lasthit){
								unglow(inv_lasthit,inv_lastbright);
							}
							inv_lasthit=hit;
							glow(hit,inv_lastbright);
						}
						if(inv_use&&!inv_hold){
							if(hit is "MyInventory"&&MyInventory(hit).notouch){
								MyInventory(hit).SuperTouch(self);
							}else{
								Inventory(hit).Touch(self);
							}
						}
					}
				}
				if(inv_lasthit&&!hit){
					unglow(inv_lasthit,inv_lastbright);
					inv_lasthit=null;
				}
			}
			inv_hold=(inv_use)?!sv_hold_to_pickup:false;
		}else{
			bPickup=true;
			if(inv_lasthit){
				unglow(inv_lasthit,inv_lastbright);
				inv_lasthit=null;
			}
		}
	}

}