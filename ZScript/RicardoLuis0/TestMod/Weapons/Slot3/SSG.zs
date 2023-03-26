class SSGLoaded : Ammo{
	Default{
		Inventory.MaxAmount 2;
		+INVENTORY.IGNORESKILL;
		Inventory.Icon "DESSA0";
	}
}

class SSG : ModWeaponBase {
	bool fireright;
	int pellets;
	int dmg;
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
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=25;
		pellets=13;
		dmg=4;
		fireright=false;
	}
	States{
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
				if(loaded==0){//out of ammo
					if(invoker.ammo2.amount==0){
						return ResolveState("noammo");//no ammo to reload
					}else{
						return ResolveState("reload");//reload
					}
				}else if(loaded==1){//only a single shot left
					SSG_FireSingle();
					if(invoker.fireright)return ResolveState("fireright");
					return ResolveState("fireleft");
				}else{
					SSG_FireBoth();
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
			TNT1 A 0 {
				if(invoker.fireright){
					return ResolveState(null);
				}else{
					return ResolveState("ready");
				}
			}
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
				if(invoker.ammo2.amount == 0 || invoker.ammo1.amount == 2)return ResolveState("ready");
				return ResolveState(null);
			}
			DSSG C 2;
			TNT1 A 0 {
				switch(invoker.ammo1.amount){
					case 1:
						return ResolveState("reloadsingle");
					case 0:
						if(invoker.fireright){
							return ResolveState("reloadright");
						}else{
							return ResolveState("reloadboth");
						}
					default:
						return ResolveState("ready");
				}
			}
			goto ready;
		reloadsingle: // THIS IS VERY BROKEN SOMEHOW? PROBABLY FORGOT TO RE-SPRITE STUFF FOR IT -- TODO: REWORK RELOAD ANIMATIONS
			DSSG D 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSS AB 2;
			TNT1 A 0 SSG_DropShell();
			TNT1 A 0 {
				invoker.ammo2.amount-=1;
			}
			DSSG VWOP 2;
			DSSG Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			TNT1 A 0{
				if(invoker.fireright){
					invoker.ammo1.amount=1;
				}else{
					invoker.ammo1.amount=2;
				}
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reloadboth:
			DSSG D 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSD AB 2;
			TNT1 A 0 {
				SSG_DropShell();
				SSG_DropShell();
			}
			DSSG H 2 {
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
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reloadright:
			DSSE D 2;
			DSSE E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DSSE FG 2;
			TNT1 A 0 SSG_DropShell();
			DSSE H 2 {
				if(invoker.ammo2.amount>1){
					return ResolveState("reloadboth2");
				}else{
					return ResolveState("reloadright2");
				}
			}
		reloadright2:
			TNT1 A 0 {
				invoker.fireright=true;
				invoker.ammo2.amount-=1;
			}
			DSSE NOP 2;
			DSSE Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSE A 0{
				invoker.ammo1.amount=1;
			}
			DSSE RS 2;
			DSSE T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSE U 2;
			DSSG C 2;
			goto ready;
		flash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		noammo:
			DSSG A 3 A_StartSound("weapons/sshoto",CHAN_AUTO);
			goto ready;
		spawn:
			DESS A -1;
			stop;
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
		if(CVar.GetCVar("cl_ssg_autoreload",player).getBool() && invoker.ammo2.amount > 0){
			return ResolveState("Reload");
		}
		return ResolveState(null);
	}
	
	action void SSG_DropShell(){
		Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random[TestModWeapon](80,100));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
	}
}