class LightClipCasing : Casing {
	Default {
		Speed 2;
		Scale 0.05;
	}
	States {
	Spawn:
		CAS1 A 10;
	Bounce:
	Stay:
		CAS1 A 1 {
			A_SetScale(0.1);
		}
		Loop;
	}
}

class MyPistolClip : Ammo{
	Default{
		Inventory.MaxAmount 18;
		+Inventory.IgnoreSkill;
	}
}

class MyPistol : MyWeapon{
	bool partial;
	Default{
		Weapon.SlotNumber 2;
		Weapon.SlotPriority 0;
		Weapon.AmmoType1 "MyPistolClip";
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 0;
		Weapon.AmmoGive2 10;
		Inventory.Pickupmessage "You've got the Pistol!";
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
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
				if(CountInv("LightClip")==0){
					return ResolveState("Ready");
				}else{
					return ResolveState("Reload");
				}
			}
			return ResolveState(null);
		}
		DPIF A 1 Fire;
		DPIF AA 1 UpdateRefire;
		DPIG CCC 1 UpdateRefire;
		TNT1 A 0 {
			if(CountInv("MyPistolClip")==0){
				return ResolveState("FireEmpty");
			}else{
				return ResolveState(null);
			}
		}
		DPIG BB 1 TryRefire;
		TNT1 A 0 {
			player.refire=0;
		}
		Goto Ready;
	FireEmpty:
		DPIG C 9;
		Goto ReadyEmpty;
	Flash:
		TNT1 A 3 A_Light1;
		Goto LightDone;
 	Spawn:
		DEPI A -1;
		Stop;
	Reload:
		TNT1 A 0 CheckReload("LightClip","MyPistolClip",18,"Ready","Ready","ReloadPartial","ReloadPartialEmpty","ReloadEmpty","ReloadFull");
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
		DPIR A 3 A_PlaySound("weapons/pistolclipout",CHAN_5);
		DPIR B 3;
		DPIR C 3;
		DPIR D 6;
		DPIR E 3;
		DPIR F 3;
		DPIR G 3 A_PlaySound("weapons/pistolclipin",CHAN_5);
		DPIR H 3;
		DPIR I 3;
		DPIR J 3;
		TNT1 A 0 {
			if(invoker.partial){
				A_GiveInventory("MyPistolClip",CountInv("LightClip"));
				A_SetInventory("LightClip",0);
			}else{
				A_TakeInventory("LightClip",18-CountInv("MyPistolClip"));
				A_SetInventory("MyPistolClip",18);
			}
		}
		Goto Ready;
	ReloadEmptyAnim:
		DPIE A 3 A_PlaySound("weapons/pistolclipout",CHAN_5);
		DPIE B 3;
		DPIE C 3;
		DPIE D 6;
		DPIE E 3;
		DPIE F 3;
		DPIE G 3 A_PlaySound("weapons/pistolclipin",CHAN_5);
		DPIE H 5;
		DPIR I 4 A_PlaySound("weapons/pistolclose",CHAN_5);
		DPIR J 3;
		TNT1 A 0 {
			if(invoker.partial){
				A_GiveInventory("MyPistolClip",CountInv("LightClip"));
				A_SetInventory("LightClip",0);
			}else{
				A_TakeInventory("LightClip",17);
				A_SetInventory("MyPistolClip",17);
			}
		}
		Goto Ready;
	}
	bool i;
	bool canrefire;
	action void fire(){
		A_PlaySound("weapons/pistol_fire",invoker.i?CHAN_6:CHAN_7,0.25);
		invoker.canrefire=false;
		Actor c=A_FireProjectile("LightClipCasing",random(-80, -100),false,0,6-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random(15,45));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		invoker.i=!invoker.i;
		if(player.refire<3){
			int old=player.refire;
			player.refire=1;
			W_FireBullets(1,1,1,5,"BulletPuff");
			player.refire=old;
		}else{
			W_FireBullets(2+(player.refire/2),1+(player.refire/3),1,5,"BulletPuff");
		}
		A_GunFlash();
	}
	action void UpdateRefire(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(!(input&BT_ATTACK)){
			invoker.canrefire=true;
		}
	}
	action State TryRefire(){
		int input=GetPlayerInput(INPUT_BUTTONS);
		if(input&BT_ATTACK){
			if(invoker.canrefire&&CountInv("MyPistolClip")>0){
				player.refire++;
				return ResolveState("Fire");
			}
		}else{
			invoker.canrefire=true;
		}
		return null;
	}
}