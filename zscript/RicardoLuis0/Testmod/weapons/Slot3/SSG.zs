class SSGLoaded : Ammo{
	Default{
		Inventory.MaxAmount 2;
		+INVENTORY.IGNORESKILL;
	}
}

class SSG : MyWeapon {
	bool fireright;
	int pellets;
	int dmg;
	Default{
		Weapon.SlotNumber 3;
		Weapon.AmmoType1 "SSGLoaded";
		Weapon.AmmoType2 "Shell";
		Weapon.AmmoUse1 0;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive2 8;
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.ALT_AMMO_OPTIONAL;
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
			DSSG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
			loop;
		Select:
			TNT1 A 0 A_UpdateBob();
		SelectLoop:
			DSSG A 1 A_Raise;
			loop;
		deselect:
			DSSG A 1 A_Lower;
			loop;
		fire:
			DSSG A 0 {
				switch(CountInv("SSGLoaded")){
				case 0:
					if(CountInv("Shell")==0){
						return ResolveState("noammo");
					}else{
						return ResolveState("reload");
					}
				case 1:
					A_FireSingle();
					if(invoker.fireright)return ResolveState("fireright");
					return ResolveState("fireleft");
				case 2:
					A_FireSingle();
					return ResolveState("fireright");
				default:
					return ResolveState("ready");
				}
			}
			goto ready;
		altfire:
			DSSG A 0{
				switch(CountInv("SSGLoaded")){
				case 0:
					if(CountInv("Shell")==0){
						return ResolveState("noammo");
					}else{
						return ResolveState("reload");
					}
				case 1:
					return ResolveState("fire");
				default:
					A_FireBoth();
					return ResolveState("fireboth");
				}
			}
			goto ready;
		fireboth:
			DSSG A 0 A_Bob();
			DSSF A 2 Bright;
			DSSG A 0 A_Bob();
			DSSF B 2 Bright;
			DSSG A 0 A_Bob();
			DSSF C 2;
			DSSG A 0 A_Bob();
			DSSF J 2;
			DSGG A 0 {
				if(CVar.GetCVar("ssg_autoreload",player).getInt()!=0){
					return ResolveState("Reload");
				}
				return ResolveState(null);
			}
			DSSF A 0 A_ReFire("reload");
			goto ready;
		fireright:
			DSSG A 0 A_Bob();
			DSSF D 2 Bright;
			DSSG A 0 A_Bob();
			DSSF E 2 Bright;
			DSSG A 0 A_Bob();
			DSSF F 2;
			DSSG A 0 A_Bob();
			DSSF J 2;
			DSSG A 0 {
				if(invoker.fireright){
					return ResolveState(null);
				}else{
					return ResolveState("ready");
				}
			}
			DSGG A 0 {
				if(CVar.GetCVar("ssg_autoreload",player).getInt()!=0){
					return ResolveState("Reload");
				}
				return ResolveState(null);
			}
			DSGG A 0 A_ReFire("reload");
			goto ready;
		fireleft:
			DSSG A 0 A_Bob();
			DSSF G 2 Bright;
			DSSG A 0 A_Bob();
			DSSF H 2 Bright;
			DSSG A 0 A_Bob();
			DSSF I 2;
			DSSG A 0 A_Bob();
			DSSF J 2;
			DSGG A 0 {
				if(CVar.GetCVar("ssg_autoreload",player).getInt()!=0){
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
			DSSG E 2 A_PlaySound("weapons/sshoto", CHAN_AUTO);
			DXSS AB 2;
			DSSG A 0 {
				A_SetInventory("Shell",CountInv("Shell")-1);
			}
			DSSG VWOP 2;
			DSSG Q 2 A_PlaySound("weapons/sshotl", CHAN_WEAPON);
			DSSG A 0{
				if(invoker.fireright){
					A_SetInventory("SSGLoaded",1);
				}else{
					A_SetInventory("SSGLoaded",2);
				}
			}
			DSSG RS 2;
			DSSG T 2 A_PlaySound("weapons/sshotc", CHAN_WEAPON);
			DSSG UC 2;
			goto ready;
		reloadboth:
			DSSG BCD 2;
			DSSG E 2 A_PlaySound("weapons/sshoto", CHAN_AUTO);
			DXSD AB 2;
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
			DSSG L 2 A_PlaySound("weapons/sshotl", CHAN_WEAPON);
			DSSG A 0{
				A_SetInventory("SSGLoaded",1);
			}
			DSSG MNOP 2;
			DSSG Q 2 A_PlaySound("weapons/sshotl", CHAN_WEAPON);
			DSSG A 0{
				A_SetInventory("SSGLoaded",2);
			}
			DSSG RS 2;
			DSSG T 2 A_PlaySound("weapons/sshotc", CHAN_WEAPON);
			DSSG UC 2;
			goto ready;
		reloadright:
			DSSG BC 2;
			DSSE D 2;
			DSSE E 2 A_PlaySound("weapons/sshoto", CHAN_AUTO);
			DSSE FG 2;
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
			DSSE Q 2 A_PlaySound("weapons/sshotl", CHAN_WEAPON);
			DSSE A 0{
				A_SetInventory("SSGLoaded",1);
			}
			DSSE RS 2;
			DSSE T 2 A_PlaySound("weapons/sshotc", CHAN_WEAPON);
			DSSE U 2;
			DSSG C 2;
			goto ready;
		flash:
			TNT1 A 4 Bright A_Light1;
			TNT1 A 4 Bright A_Light2;
			goto lightdone;
		noammo:
			DSSG A 0 A_Bob();
			DSSG A 3 A_PlaySound("weapons/sshoto");
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
		A_TakeInventory("SSGLoaded",1);
		W_FireBullets(5,5,invoker.pellets,invoker.dmg,"BulletPuff");
		A_Recoil(2.0);
		A_SetPitch(pitch+frandom(-5,-2),SPF_INTERPOLATE);
		A_SetAngle(angle+(CountInv("SSGLoaded")==1?frandom(-5,-2):frandom(2,5)),SPF_INTERPOLATE);
		A_PlaySound("weapons/ssg_fire1",CHAN_AUTO);
	}

	action void A_FireBoth(){
		A_GunFlash();
		A_AlertMonsters();
		A_TakeInventory("SSGLoaded",2);
		W_FireBullets(10,6,int(invoker.pellets*2.2),invoker.dmg,"BulletPuff");
		A_Recoil(5.0);
		A_SetPitch(pitch+frandom(-10,-5),SPF_INTERPOLATE);
		A_PlaySound("weapons/ssg_fire2_01",CHAN_AUTO);
		A_PlaySound("weapons/ssg_fire2_02",CHAN_AUTO,500);
	}
}