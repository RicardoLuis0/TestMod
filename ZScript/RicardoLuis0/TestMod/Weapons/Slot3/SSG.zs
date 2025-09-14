class SSGLoaded : Ammo{
	Default{
		Inventory.MaxAmount 2;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "DESSA0";
	}
}

class SSG : ModWeaponBase
{
	int pellets;
	int dmg;
	
	int firemode;
	
	
	
	int leftstate;
	int rightstate;
	
	Default{
		Tag "Super Shotgun";
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "SSGLoaded";
		Weapon.AmmoType2 "NewShell";
		Weapon.AmmoUse1 2;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 4;
		Weapon.SlotPriority 0.99;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Super Shotgun!";
		
		ModWeaponBase.PickupHandleMagazine true;
		ModWeaponBase.HasChamber true;
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=25;
		pellets=13;
		dmg=4;
		
		leftstate = 1;
		rightstate = 1;
	}
	
	override void ReadyTick()
	{
		if(ammo1.amount == 2)
		{
			leftstate = 1;
			rightstate = 1;
		}
	}
	
	States{
	
		altfire:
			DSSG A 4 A_WeaponOffset(5, 40, WOF_INTERPOLATE);
			DSSG A 0
			{
				A_StartSound("weapons/click02", CHAN_AUTO);
				if(invoker.firemode)
				{
					A_Print("Double Shot");
					invoker.firemode=0;
				}
				else
				{
					A_Print("Single Shot");
					invoker.firemode=1;
				}
			}
			DSSG A 4 A_WeaponOffset(0,32,WOF_INTERPOLATE);
		altloop:
			DSSG A 1;
			DSSG A 0 A_ReFire("altloop");
			Goto Ready;
	
	
		ready:
			DSSG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			DSSG A 1 A_Raise;
			loop;
		deselect:
			DSSG A 1 A_Lower;
			loop;
		fire:
			TNT1 A 0 {
				int loaded=invoker.ammo1.amount;
				if(loaded==0)
				{ // out of ammo
					if(invoker.ammo2.amount==0){
						return ResolveState("noammo"); // no ammo to reload
					}
					else
					{
						return ResolveState("reload");//reload
					}
				}
				else if(loaded == 1 || invoker.firemode)
				{ // single shot
					SSG_FireSingle();
					if(invoker.rightstate == 1)
					{
						invoker.rightstate = 2;
						return ResolveState("fireright");
					}
					invoker.leftstate = 2;
					return ResolveState("fireleft");
				}
				else
				{
					SSG_FireBoth();
					invoker.rightstate = 2;
					invoker.leftstate = 2;
					return ResolveState("fireboth");
				}
			}
			Goto Ready;
		fireboth:
			DSSF A 2 Bright;
			DSSF B 2 Bright;
			DSSF C 2;
			DSSF J 2;
			DSSG B 4 A_WeaponOffset(20,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(18,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(15,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(12,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(10,32,WOF_INTERPOLATE);
			TNT1 A 0 SSG_AutoReload();
			DSSG B 1 A_WeaponOffset(8,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(6,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(4,32,WOF_INTERPOLATE);
			DSSG B 1 A_WeaponOffset(2,32,WOF_INTERPOLATE);
			DSSG A 1 A_WeaponOffset(0,32,WOF_INTERPOLATE);
			goto ready;
		fireright:
			DSSF D 2 Bright;
			DSSF E 2 Bright;
			DSSF F 2;
			DSSF J 2;
			TNT1 A 0 SSG_AutoReload();
			goto ready;
		fireleft:
			DSSF G 2 Bright;
			DSSF H 2 Bright;
			DSSF I 2;
			DSSF J 2;
			TNT1 A 0 SSG_AutoReload();
			goto ready;
		reload:
			TNT1 A 0 {
				if(invoker.ammo2.amount == 0 || invoker.ammo1.amount == 2) return ResolveState("ready");
				return ResolveState(null);
			}
			DSSG C 2;
			TNT1 A 0 {
				return P_CallJmpChain(SSG_ChamberJump("eject", sv_drop_magazine_reload), "ejectdone");
			}
			goto ready;
		ejectdone:
			TNT1 A 0 SSG_ChamberJump("reload");
			
		eject00://all empty
			DSSE IJH 2;
			TNT1 A 0 P_Return;
		eject01://right good, left empty
			TNT1 A 0 A_JumpIf(!sv_ssg_forgiving_reload, "eject02");
			DSSE DEK 2;
			TNT1 A 0 P_Return;
		//TODO
		eject02://right spent, left empty
			DSSE DEFG 2;
			TNT1 A 0
			{
				if(invoker.ammo1.amount == 1)
				{
					invoker.ammo1.amount = 0;
					SSG_DropShell("ShellCasingAmmo");
				}
				else
				{
					SSG_DropShell();
				}
				invoker.rightstate = 0;
			}
			DSSE H 2;
			TNT1 A 0 P_Return;
		eject12://right spent, left good, 12 -> 10
			DSSG D 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSS AB 2;
			TNT1 A 0
			{
				SSG_DropShell();
				invoker.rightstate = 0;
			}
			DSSG V 2;
			TNT1 A 0 P_Return;
		eject11://all good, only reachable when unloading
			goto eject22;
		eject10://left good, right empty, unreachable
		eject21://left spent, right good, unreachable
		eject20://left spent, right empty, unreachable
		eject22://all spent
			DSSG D 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSD AB 2;
			TNT1 A 0
			{
				if(invoker.ammo1.amount == 2)
				{
					invoker.ammo1.amount = 0;
					SSG_DropShell("ShellCasingAmmo");
					SSG_DropShell("ShellCasingAmmo");
				}
				else if(invoker.ammo1.amount == 1)
				{
					invoker.ammo1.amount = 0;
					SSG_DropShell("ShellCasingAmmo");
					SSG_DropShell();
				}
				else
				{
					SSG_DropShell();
					SSG_DropShell();
				}
				invoker.rightstate = 0;
				invoker.leftstate = 0;
			}
			DSSG H 2;
			TNT1 A 0 P_Return;
			
		reload01:
			TNT1 A 0 {
				invoker.ammo2.amount-=1;
			}
			DXSS CDE 2;
			DSSG L 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			TNT1 A 0
			{
				invoker.ammo1.amount=2;
				invoker.leftstate = 1;
				invoker.rightstate = 1;
			}
			DXSS F 2;
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
			
		reload10:
			TNT1 A 0 {
				invoker.ammo2.amount-=1;
			}
			DSSG WOP 2;
			DSSG Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			TNT1 A 0
			{
				invoker.ammo1.amount=2;
				invoker.leftstate = 1;
				invoker.rightstate = 1;
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reload00:
			DSSG A 0
			{
				if(invoker.ammo2.amount==1){
					return ResolveState("reloadright2");
				}else{
					return ResolveState("reloadboth2");
				}
			}
		reloadboth2:
			TNT1 A 0 {
				invoker.ammo2.amount-=2;
			}
			DSSG IJK 2;
			DSSG L 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			TNT1 A 0{
				invoker.ammo1.amount=1;
			}
			DSSG MNOP 2;
			DSSG Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			TNT1 A 0{
				invoker.ammo1.amount=2;
				invoker.rightstate = 1;
				invoker.leftstate = 1;
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reloadright2:
			TNT1 A 0 {
				invoker.ammo2.amount-=1;
			}
			DSSE NOP 2;
			DSSE Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSE A 0{
				invoker.ammo1.amount=1;
				invoker.rightstate = 1;
				invoker.leftstate = 0;
			}
			DSSE RS 2;
			DSSE T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSE U 2;
			DSSG C 2;
			goto ready;
		closeempty:
			DSSE HJI 2;
			goto ready;
		noammo:
			DSSG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			goto ready;
		spawn:
			DESS A -1;
			stop;
	}
	
	action state SSG_ChamberJump(String base, bool unload = false)
	{
		base = base..(unload ? int(!!invoker.leftstate)*2 : invoker.leftstate)..(unload ? int(!!invoker.rightstate)*2 : invoker.rightstate);
		return invoker.FindStateByString(base);
	}
	
	action void SSG_FireSingle(){
		A_GunFlash();
		A_AlertMonsters();
		invoker.ammouse1=1;
		W_FireTracer((5,5),invoker.dmg,invoker.pellets,drawTracer:sv_shotgun_tracers);
		invoker.ammouse1=2;
		A_Recoil(2.0);
		A_SetPitch(pitch+frandom[TestModWeapon](-5,-2),SPF_INTERPOLATE);
		A_SetAngle(angle+(invoker.ammo1.amount==1?frandom[TestModWeapon](-5,-2):frandom[TestModWeapon](2,5)),SPF_INTERPOLATE);
		A_StartSound("weapons/ssg_fire1",CHAN_AUTO);
	}
	
	action void SSG_FireBoth(){
		A_GunFlash();
		A_AlertMonsters();
		W_FireTracer((10,6),invoker.dmg,int(invoker.pellets*2.25),drawTracer:sv_shotgun_tracers);
		A_Recoil(5.0);
		A_SetPitch(pitch+frandom[TestModWeapon](-10,-5),SPF_INTERPOLATE);
		A_StartSound("weapons/ssg_fire2_01",CHAN_AUTO);
		A_StartSound("weapons/ssg_fire2_02",CHAN_AUTO,CHANF_DEFAULT,500);
	}
	
	action state SSG_AutoReload(){
		if(CVar.GetCVar("cl_ssg_autoreload",player).getBool() && invoker.ammo1.amount == 0 && invoker.ammo2.amount > 0){
			return ResolveState("Reload");
		}
		return ResolveState(null);
	}
	
	action void SSG_DropShell(class<actor> casing = "ShellCasing"){
		Actor c=W_FireProjectile(casing,-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random[TestModWeapon](80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
	}
	
	override bool OnUnloadKeyPressed()
	{
		if(ammo1.amount > 0)
		{
			P_RemoteCallJmpChain(PSP_WEAPON, SSG_ChamberJump("eject", true), "closeempty");
			return true;
		}
		return false;
	}
}