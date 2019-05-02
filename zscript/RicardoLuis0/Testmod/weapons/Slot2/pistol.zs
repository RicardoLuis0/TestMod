class MyPistolClip : Ammo{
	Default{
		Inventory.MaxAmount 13;
		+Inventory.IgnoreSkill;
	}
}

class MyPistol : MyWeapon{
	bool partial;
	Default{
		Weapon.SlotNumber 2;
		Weapon.AmmoType1 "MyPistolClip";
		Weapon.AmmoType2 "Clip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 0;
		Weapon.AmmoGive2 12;
		Inventory.Pickupmessage "You've got the Pistol!";
		+WEAPON.AMMO_OPTIONAL;
		//+WEAPON.NOAUTOFIRE;
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=43;
	}
	States{
	Ready:
		TNT1 A 0 {
			if(CountInv("MyPistolClip")==0){
				return ResolveState("ReadyEmpty");
			}else{
				return ResolveState(null);
			}
		}
	ReadyLoop:
		DPIG A 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Select:
		TNT1 A 0 {
			if(CountInv("MyPistolClip")==0){
				return ResolveState("SelectEmpty");
			}else{
				return ResolveState(null);
			}
		}
	SelectLoop:
		DPIG A 1 A_Raise;
		Loop;
	Deselect:
		TNT1 A 0 {
			if(CountInv("MyPistolClip")==0){
				return ResolveState("DeselectEmpty");
			}else{
				return ResolveState(null);
			}
		}
	DeselectLoop:
		DPIG A 1 A_Lower;
		Loop;
	ReadyEmpty:
		DPIG C 1 A_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	SelectEmpty:
		DPIG C 1 A_Raise;
		Loop;
	DeselectEmpty:
		DPIG C 1 A_Lower;
		Loop;
	Fire:
		DPIG A 0 {
			if(CountInv("MyPistolClip")==0){
				if(CountInv("Clip")==0){
					return ResolveState("Ready");
				}else{
					return ResolveState("Reload");
				}
			}
			return ResolveState(null);
		}
		TNT1 A 0 A_Bob();
		DPIF A 3 Fire;
		DPIG C 3;
		TNT1 A 0 {
			if(CountInv("MyPistolClip")==0){
				return ResolveState("FireEmpty");
			}else{
				return ResolveState(null);
			}
		}
		DPIG B 3;
		TNT1 A 0 A_ReFire;
		Goto Ready;
	FireEmpty:
		TNT1 A 0 A_Bob();
		DPIG C 9;
		Goto ReadyEmpty;
	Flash:
		TNT1 A 3 A_Light1;
		Goto LightDone;
 	Spawn:
		DEPI A -1;
		Stop;
	Reload:
		TNT1 A 0 CheckReload("Clip","MyPistolClip",13,"Ready","Ready","ReloadPartial","ReloadPartialEmpty","ReloadEmpty","ReloadFull");
		Goto Ready;
	ReloadPartial:
		TNT1 A 0 {
			invoker.partial=true;
		}
		Goto ReloadAnim;
	ReloadFull:
		TNT1 A 0 {
			invoker.partial=false;
		}
		Goto ReloadAnim;
	ReloadPartialEmpty:
		TNT1 A 0 {
			invoker.partial=true;
		}
		Goto ReloadEmptyAnim;
	ReloadEmpty:
		TNT1 A 0 {
			invoker.partial=false;
		}
		Goto ReloadEmptyAnim;
	ReloadAnim:
		DPIR ABC 3;
		DPIR D 6;
		DPIR EFGHIJ 3;
		TNT1 A 0 {
			if(invoker.partial){
				A_GiveInventory("MyPistolClip",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}else{
				A_TakeInventory("Clip",13-CountInv("MyPistolClip"));
				A_SetInventory("MyPistolClip",13);
			}
		}
		Goto Ready;
	ReloadEmptyAnim:
		DPIE ABC 3;
		DPIE D 6;
		DPIE EFG 3;
		DPIE H 5;
		DPIR I 4;
		DPIR J 3;
		TNT1 A 0 {
			if(invoker.partial){
				A_GiveInventory("MyPistolClip",CountInv("Clip"));
				A_SetInventory("Clip",0);
			}else{
				A_TakeInventory("Clip",12);
				A_SetInventory("MyPistolClip",12);
			}
		}
		Goto Ready;
	}
	action void fire(){
		A_PlaySound("weapons/pistol", CHAN_WEAPON);
		if(player.refire==0){
			player.refire=1;
			A_FireBullets(1,1,1,5,"BulletPuff");
			player.refire=0;
		}else{
			A_FireBullets(5,3,1,5,"BulletPuff");
		}
		A_GunFlash();
	}
}