class ShellCasing : CasingBase {
	Default {
		Scale 0.10;
	}
	States {
	Spawn:
		CAS2 AB 3;
	Bounce:
	Stay:
		CAS2 C 1 {
			A_SetScale(0.15);
		}
		Loop;
	}
}

class ShellCasingAmmo : NewShell
{
	mixin CasingBehavior;
	
	Default {
		Scale 0.10;
		Inventory.Amount 1;
	}
	
	States {
	Death:
		"####" "#" 100;
		Loop;
	Spawn:
		CAS2 C 0;
		CAS2 AB 3;
	Bounce:
	Stay:
		CAS2 C 1 {
			A_SetScale(0.15);
		}
		Loop;
	}
}

class PumpLoaded : Ammo{
	Default{
		Inventory.MaxAmount 9;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "0ESGA0";
	}
}

class PumpShotgun : ModWeaponBase {
	int pellets;
	int dmg;
	bool firecasing;
	
	Default{
		Tag "Pump Shotgun";
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "PumpLoaded";
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 8;
		Weapon.SlotPriority 0.25;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Pump Shotgun!";
		
		ModWeaponBase.PickupHandleMagazine true;
		ModWeaponBase.HasChamber true;
	}
	
	override void BeginPlay()
	{
		super.BeginPlay();
		crosshair=23;
		pellets=14;
		dmg=4;
		firecasing=false;
		magazineWeaponChamberLoaded=true;
	}
	
	override void ReadyTick()
	{
		if(ammo1.amount == 9)
		{
			magazineWeaponChamberLoaded = true;
		}
	}
	
	States{
		ready:
			0SGG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			0SGG A 1 A_Raise;
			loop;
		deselect:
			0SGG A 1 A_Lower;
			loop;
		fire:
			0SGG A 0 A_FirePump();
			0SGF A 2 Bright A_GunFlash;
			0SGF B 2 Bright;
			0SGF C 2 Bright;
			0SGF D 1;
			0SGF E 1;
			0SGG A 0
			{
				if(CountInv(invoker.AmmoType1) == 0 && sv_automatic_reload)
				{
					return ResolveState("Reload");
				}
				
				if(sv_automatic_bolt || sv_automatic_shotgun || TestModPlayer(self).cycle_key_pressed)
				{
					TestModPlayer(self).cycle_key_pressed = false;
					return P_Call("Pump");
				}
				
				return ResolveState("ready");
			}
			0SGG A 5 A_Refire;
			goto ready;
		reload:
			0SGG A 0 A_ReloadStart;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
		reloadloop:
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 A_ReloadMid;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 0 A_StartSound("weapons/sshotl",CHAN_AUTO);
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,77,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 1 PollInterruptReload;
			0SGG A 0 PollInterruptReload;
			0SGG A 1 A_WeaponOffset(28,66,WOF_INTERPOLATE);
			0SGG A 1 PollInterruptReload;
			0SGG A 0 A_ReloadEnd;
			0SGG A 0 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			loop;
		reloadstop:
			0SGG A 2 A_WeaponOffset(14,54,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(7,43,WOF_INTERPOLATE);
			0SGG A 2 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			0SGG A 0 P_Return;
			goto ready;
		firecheck:
			0SGG A 0 CheckFire("fire");
			goto ready;
		pump:
			0SGG A 5;
			0SGG A 0 A_StartSound("weapons/shotgun_pump",CHAN_AUTO);
			0SGG B 3;
			0SGG C 3;
			0SGG D 3 A_PumpCasing;
			0SGG E 4;
			0SGG D 3;
			0SGG C 3;
			0SGG B 3;
			0SGG A 5;
			0SGG A 0 P_Return;
			goto ready;
		noammo:
			0SGG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			goto ready;
		spawn:
			0ESG A -1;
			stop;
	}

	action State A_FirePump()
	{
		if(!ChamberLoaded() && invoker.ammo2.amount > 0 && (sv_automatic_reload || TestModPlayer(self).cycle_key_pressed))
		{
			TestModPlayer(self).cycle_key_pressed = false;
			return P_CallJmp("pump", "ready");
		}
		
		if(invoker.ammo1.amount == 0 || !ChamberLoaded())
		{
			if(invoker.ammo2.amount == 0 || !sv_automatic_reload)
			{
				return ResolveState("noammo");
			}
			else
			{
				return ResolveState("reload");
			}
		}
		A_AlertMonsters();
		invoker.firecasing=true;
		A_Recoil(2.0);
		W_FireTracer((1.5,1.5),invoker.dmg,invoker.pellets,drawTracer:sv_shotgun_tracers);
		A_SetPitch(pitch+frandom[TestModWeapon](-5,0),SPF_INTERPOLATE);
		A_SetAngle(angle+frandom[TestModWeapon](-2,2),SPF_INTERPOLATE);
		A_StartSound("weapons/shotgun_fire",CHAN_AUTO,CHANF_DEFAULT,0.5);
		A_UnloadChamber();
		return ResolveState(null);
	}

	action void A_PumpCasing()
	{
		if(invoker.firecasing || ChamberLoaded())
		{
			if(ChamberLoaded())
			{
				invoker.ammo1.amount--;
			}
			else
			{
				invoker.firecasing = false;
			}
			Actor c=W_FireProjectile(ChamberLoaded() ? "ShellCasingAmmo" : "ShellCasing",random[TestModWeapon](-30, -50),false,2,2-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random[TestModWeapon](15,30));
			if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		}
		if(invoker.ammo1.amount > 0) A_LoadChamber();
	}

	action State A_ReloadStart()
	{
		InitInterruptReload();
		
		if(invoker.ammo1.amount > 0 && !ChamberLoaded() && sv_automatic_bolt) return P_CallJmp("pump", "reload");
		
		if(invoker.ammo1.amount >= (ChamberLoaded() ? 9 : 8) || invoker.ammo2.amount==0)
		{
			return ResolveState("ready");
		}
		
		if(invoker.ammo1.amount > 0)
		{
			return CheckFire("fire");
		}
		return ResolveState(null);
	}

	action State A_ReloadMid()
	{
		if(invoker.ammo1.amount > 0 && !ChamberLoaded() && sv_automatic_bolt) return P_CallJmp("reloadstop", P_CallJmpSL("pump","reload"));
		
		if(player.PendingWeapon != WP_NOCHANGE){
			return P_CallJmp("reloadstop","ready");
		}
		if(invoker.ammo1.amount >= (ChamberLoaded() ? 9 : 8) || invoker.ammo2.amount == 0)
		{
			return P_CallJmp("reloadstop","ready");
		}
		if(invoker.ammo1.amount>0)
		{
			return InterruptReload(true);
		}
		return ResolveState(null);
	}

	action State A_ReloadEnd()
	{
		invoker.ammo2.amount-=1;
		invoker.ammo1.amount+=1;
		if(invoker.ammo1.amount == 1 && sv_automatic_bolt) return P_CallJmp("reloadstop",P_CallJmpSL("pump","reload"));
		return InterruptReload();
	}
	
	bool do_interrupt;
	
	action void InitInterruptReload(){
		invoker.do_interrupt=false;
	}
	
	action void PollInterruptReload(){
		if(iCheckFire()>0){
			invoker.do_interrupt=true;
		}
	}
	
	override bool OnUnloadKeyPressed()
	{
		P_RemoteCallJmp(PSP_WEAPON, "pump","ready");
		return true;
	}
	override bool OnCycleKeyPressed()
	{
		P_RemoteCallJmp(PSP_WEAPON, "pump","ready");
		return true;
	}
	
	action state InterruptReload(bool first = false)
	{
		if(invoker.do_interrupt || iCheckFire()>0 || (!first && sv_shotgun_reload_hold && !(player.cmd.buttons&BT_RELOAD)))
		{
			return P_CallJmp("reloadstop","firecheck");
		}
		return ResolveState(null);
	}
	
}