class SSGLoaded : Ammo{
	Default{
		Inventory.MaxAmount 2;
		+INVENTORY.IGNORESKILL;
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
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 2;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 4;
		Weapon.SlotPriority 0.99;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		Inventory.PickupMessage "You've got the Super Shotgun!";
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=25;
		pellets=15;
		dmg=6;
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
			DSSG A 0 {
				int loaded=CountInv("SSGLoaded");
				if(loaded==0){//out of ammo
					if(CountInv("Shell")==0){
						return ResolveState("noammo");//no ammo to reload
					}else{
						return ResolveState("reload");//reload
					}
				}else if(loaded==1){//only a single shot left
					A_FireSingle();
					if(invoker.fireright)return ResolveState("fireright");
					return ResolveState("fireleft");
				}else{
					A_FireBoth();
					return ResolveState("fireboth");
				}
			}
			goto ready;
		altloop:
			DSSG A 1;
			DSSG A 0 A_ReFire("altloop");
			Goto Ready;
		fireboth:
			DSSF A 2 Bright;
			DSSF B 2 Bright;
			DSSF C 2;
			DSSF J 2;
			DSGG A 0 {
				if(CVar.GetCVar("cl_ssg_autoreload",player).getInt()!=0){
					return ResolveState("Reload");
				}
				return ResolveState(null);
			}
			DSSF A 0 A_ReFire("reload");
			goto ready;
		fireright:
			DSSF D 2 Bright;
			DSSF E 2 Bright;
			DSSF F 2;
			DSSF J 2;
			DSSG A 0 {
				if(invoker.fireright){
					return ResolveState(null);
				}else{
					return ResolveState("ready");
				}
			}
			DSGG A 0 {
				if(CVar.GetCVar("cl_ssg_autoreload",player).getInt()!=0){
					return ResolveState("Reload");
				}
				return ResolveState(null);
			}
			DSGG A 0 A_ReFire("reload");
			goto ready;
		fireleft:
			DSSF G 2 Bright;
			DSSF H 2 Bright;
			DSSF I 2;
			DSSF J 2;
			DSGG A 0 {
				if(CVar.GetCVar("cl_ssg_autoreload",player).getInt()!=0){
					return ResolveState("Reload");
				}
				return ResolveState(null);
			}
			DSGG A 0 A_ReFire("reload");
			goto ready;
		reload:
			DSSG A 0{
				if(CountInv("SSGLoaded")==2||CountInv("Shell")==0)return ResolveState("ready");
				switch(CountInv("SSGLoaded")){
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
		reloadsingle:
			DSSG BCD 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSS AB 2;
			TNT1 A 0 {
				Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
				if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
			}
			DSSG A 0 {
				A_SetInventory("Shell",CountInv("Shell")-1);
			}
			DSSG VWOP 2;
			DSSG Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSG A 0{
				if(invoker.fireright){
					A_SetInventory("SSGLoaded",1);
				}else{
					A_SetInventory("SSGLoaded",2);
				}
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reloadboth:
			DSSG BCD 2;
			DSSG E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DXSD AB 2;
			TNT1 A 0 {
				Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
				if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
				c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
				if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
			}
			DSSG H 2 {
				if(CountInv("Shell")==1){
					return ResolveState("reloadright2");
				}else{
					return ResolveState("reloadboth2");
				}
			}
		reloadboth2:
			DSSG A 0 {
				A_SetInventory("Shell",CountInv("Shell")-2);
			}
			DSSG IJK 2;
			DSSG L 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSG A 0{
				A_SetInventory("SSGLoaded",1);
			}
			DSSG MNOP 2;
			DSSG Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSG A 0{
				A_SetInventory("SSGLoaded",2);
			}
			DSSG RS 2;
			DSSG T 2 A_StartSound("weapons/sshotc",CHAN_AUTO);
			DSSG UC 2;
			goto ready;
		reloadright:
			DSSG BC 2;
			DSSE D 2;
			DSSE E 2 A_StartSound("weapons/sshoto",CHAN_AUTO);
			DSSE FG 2;
			TNT1 A 0 {
				Actor c=A_FireProjectile("ShellCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
				if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
			}
			DSSE H 2 {
				if(CountInv("Shell")>1){
					return ResolveState("reloadboth2");
				}else{
					return ResolveState("reloadright2");
				}
			}
		reloadright2:
			DSSG A 0 {
				invoker.fireright=true;
				A_SetInventory("Shell",CountInv("Shell")-1);
			}
			DSSE NOP 2;
			DSSE Q 2 A_StartSound("weapons/sshotl",CHAN_AUTO);
			DSSE A 0{
				A_SetInventory("SSGLoaded",1);
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
	
	action State A_CheckAmmo(bool doreload){
		if(CountInv("PumpLoaded")==0){
			if(CountInv("Shell")==0||doreload==false){
				return ResolveState("noammo");
			}else{
				return ResolveState("reload");
			}
		}
		return ResolveState(null);
	}
	
	action void A_FireSingle(){
		A_GunFlash();
		A_AlertMonsters();
		invoker.ammouse1=1;
		W_FireBullets(5,5,invoker.pellets,invoker.dmg);
		invoker.ammouse1=2;
		A_Recoil(2.0);
		A_SetPitch(pitch+frandom(-5,-2),SPF_INTERPOLATE);
		A_SetAngle(angle+(CountInv("SSGLoaded")==1?frandom(-5,-2):frandom(2,5)),SPF_INTERPOLATE);
		A_StartSound("weapons/ssg_fire1",CHAN_AUTO);
	}
	
	action void A_FireBoth(){
		A_GunFlash();
		A_AlertMonsters();
		W_FireBullets(10,6,int(invoker.pellets*2.2),invoker.dmg);
		A_Recoil(5.0);
		A_SetPitch(pitch+frandom(-10,-5),SPF_INTERPOLATE);
		A_StartSound("weapons/ssg_fire2_01",CHAN_AUTO);
		A_StartSound("weapons/ssg_fire2_02",CHAN_AUTO,CHANF_DEFAULT,500);
	}
}