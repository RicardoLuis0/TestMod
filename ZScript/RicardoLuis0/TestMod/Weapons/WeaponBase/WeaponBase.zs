class ModWeaponBase : Weapon {
	
	
	mixin StateCalls;
	
	bool partialPickupHasMagazine;
	bool partialPickupNoMagazine;
	bool magazineWeaponHasChamber;
	bool magazineWeaponChamberLoaded;
	Class<Ammo> customUnloadAmmo;
	
	Property PickupHandleMagazine : partialPickupHasMagazine;
	Property PickupHandleNoMagazine : partialPickupNoMagazine;
	Property HasChamber : magazineWeaponHasChamber;
	Property CustomUnloadAmmo : customUnloadAmmo;
	
	Default{
		Decal "BulletChip";
		+WEAPON.NOAUTOAIM;
		ModWeaponBase.HasChamber false;
	}
	
	static Vector3 angleToVec3(double a_yaw,double a_pitch,double length=1){
		Vector3 o;
		o.x=cos(a_pitch)*cos(a_yaw);
		o.y=cos(a_pitch)*sin(a_yaw);
		o.z=-sin(a_pitch);
		return o*length;
	}
	
	static void DoParticleExplosion(actor origin,Color x_color,int count,double strength,double size,int lifetime=20){
		for(int i=0;i<count;i++){
			double r_yaw=random[explosion_fx](0,360);
			double r_pitch=random[explosion_fx](0,360);
			vector3 vel=angleToVec3(r_yaw,r_pitch,strength);
			origin.A_SpawnParticle(x_color,SPF_FULLBRIGHT,lifetime,size,0,0,0,0,vel.x,vel.y,vel.z);
		}
	}

	virtual void ReadyTick() {}
	virtual void PredictedReadyTick() {}
	
	action void A_ReloadAmmo(int empty,int nonempty)
	{
		if(sv_drop_magazine_reload) invoker.UnloadAmmo(false);
		
		int reloadAmount = min(
							invoker.ammo1.amount > 0 ? nonempty : empty,
							invoker.ammo1.amount + invoker.ammo2.amount
						   );
		invoker.ammo2.amount -= reloadAmount - invoker.ammo1.amount;
		invoker.ammo1.amount = reloadAmount;
	}
	
	action void A_ReloadAmmoMagazineDefaults()
	{
		A_ReloadAmmo(invoker.magazineWeaponHasChamber ? invoker.ammo1.maxamount-1 : invoker.ammo1.maxamount,
					 (!invoker.magazineWeaponHasChamber || invoker.magazineWeaponChamberLoaded)? invoker.ammo1.maxamount : invoker.ammo1.maxamount - 1);
	}
	
	virtual bool OnGrenadeKeyPressed(){
		let st=owner.player.ReadyWeapon.FindState("ThrowGrenade");
		if(st){
			owner.player.setPSprite(PSP_WEAPON,st);
			return true;
		}
		return false;
	}
	
	virtual bool OnMeleeKeyPressed(){
		let st=owner.player.ReadyWeapon.FindState("AttackMelee");
		if(st){
			owner.player.setPSprite(PSP_WEAPON,st);
			return true;
		}
		return false;
	}
	
	virtual void GrenadeThrowAnimOver()
	{
	}
	
	virtual bool OnUnloadKeyPressed()
	{
		return UnloadAmmo();
	}
	
	virtual bool OnCycleKeyPressed()
	{
		return false;
	}
	
	action void A_NotifyGrenadeThrowAnimEnd(){
		invoker.GrenadeThrowAnimOver();
	}
	
	enum ext_wpflags{
		WRFX_NOGRENADE=1,
		WRFX_NOMELEE=2,
		WRFX_NOUNLOAD=4,
		WRFX_NOCYCLE=8,
	};
	
	action void W_WeaponReady(int flags=0,int flags_extra=0){
		if(!(flags_extra&WRFX_NOGRENADE)&&TestModPlayer(self).grenade_key_pressed){
			if(invoker.OnGrenadeKeyPressed())
			{
				TestModPlayer(self).ClearActionKeys();
				return;
			}
		}
		if(!(flags_extra&WRFX_NOMELEE)&&TestModPlayer(self).melee_key_pressed){
			if(invoker.OnMeleeKeyPressed())
			{
				TestModPlayer(self).ClearActionKeys();
				return;
			}
		}
		if(invoker.partialPickupHasMagazine && !(flags_extra&WRFX_NOUNLOAD) && TestModPlayer(self).unload_key_pressed)
		{
			if(invoker.OnUnloadKeyPressed())
			{
				TestModPlayer(self).ClearActionKeys();
				return;
			}
		}
		if(invoker.partialPickupHasMagazine && !(flags_extra&WRFX_NOCYCLE) && TestModPlayer(self).cycle_key_pressed)
		{
			if(invoker.OnCycleKeyPressed())
			{
				TestModPlayer(self).ClearActionKeys();
				return;
			}
		}
		TestModPlayer(self).ClearActionKeys();
		A_WeaponReady(flags);
	}
	
	States {
		ThrowGrenadeLArmAnim:
			TNT1 A 0 A_NotifyGrenadeThrowAnimEnd;
			Stop;
		ThrowGrenadeRArmAnim:
			TNT1 A 0 A_NotifyGrenadeThrowAnimEnd;
			Stop;
	}
	
	
}