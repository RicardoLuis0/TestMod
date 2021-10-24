class LightClipCasing : CasingBase {
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

class PistolLoaded : Ammo{
	Default{
		Inventory.MaxAmount 18;
		+Inventory.IgnoreSkill;
	}
}

class NewPistol : ModWeaponBase {
	bool partial;
	
	Default{
		Tag "Pistol";
		Weapon.SlotNumber 2;
		Weapon.SlotPriority 0;
		Weapon.AmmoType1 "PistolLoaded";
		Weapon.AmmoType2 "LightClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoUse2 0;
		Weapon.AmmoGive1 0;
		Weapon.AmmoGive2 10;
		Inventory.Pickupmessage "You've got the Pistol!";
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOALERT;
		+WEAPON.NOAUTOFIRE;
	}
	override void BeginPlay(){
		super.BeginPlay();
		crosshair=43;
	}
	States{
	Ready:
		TNT1 A 0 {
			if(CountInv(invoker.AmmoType1)==0){
				return ResolveState("ReadyEmpty");
			}else{
				return ResolveState(null);
			}
		}
	ReadyLoop:
		DPIG A 1 W_WeaponReady(WRF_ALLOWRELOAD);
		Loop;
	Select:
		TNT1 A 0 {
			if(CountInv(invoker.AmmoType1)==0){
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
			if(CountInv(invoker.AmmoType1)==0){
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
			if(CountInv(invoker.AmmoType1)==0){
				if(CountInv(invoker.AmmoType2)==0){
					return ResolveState("Ready");
				}else{
					return ResolveState("Reload");
				}
			}
			return ResolveState(null);
		}
		DPIF A 1 BRIGHT A_FireGun;
		DPIF A 1 BRIGHT UpdateRefire;
		DPIF A 1 BRIGHT UpdateRefire;
		DPIG CCC 1 UpdateRefire;
		TNT1 A 0 {
			if(CountInv(invoker.AmmoType1)==0){
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
		TNT1 A 0 {
			if(CountInv(invoker.AmmoType1)==18||CountInv(invoker.AmmoType2)==0){
				return ResolveState("Ready");
			}else if(CountInv(invoker.AmmoType1)==0){
				return ResolveState("ReloadEmpty");
			}
			return ResolveState(null);
		}
		DPIR A 3 A_StartSound("weapons/pistolclipout",CHAN_AUTO);
		DPIR B 3;
		DPIR C 3;
		DPIR D 6;
		DPIR E 3;
		DPIR F 3;
		DPIR G 3 A_StartSound("weapons/pistolclipin",CHAN_AUTO);
		DPIR H 3;
		TNT1 A 0 A_ReloadAmmo(17,18);
		DPIR I 3;
		DPIR J 3;
		Goto Ready;
	ReloadEmpty:
		DPIE A 3 A_StartSound("weapons/pistolclipout",CHAN_AUTO);
		DPIE B 3;
		DPIE C 3;
		DPIE D 6;
		DPIE E 3;
		DPIE F 3;
		DPIE G 3 A_StartSound("weapons/pistolclipin",CHAN_AUTO);
		DPIE H 5;
		TNT1 A 0 A_ReloadAmmo(17,18);
		DPIR I 4 A_StartSound("weapons/pistolclose",CHAN_AUTO);
		DPIR J 3;
		Goto Ready;
	}
	
	bool canrefire;
	
	action void A_FireGun(){
		A_AlertMonsters();
		A_StartSound("weapons/pistol_fire",CHAN_AUTO,CHANF_DEFAULT,0.25);
		invoker.canrefire=false;
		Actor c=A_FireProjectile("LightClipCasing",random(-80, -100),false,0,6-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,-random(15,45));
		if(c)c.SetOrigin(c.pos+AngleToVector(angle,10),false);
		W_FireBulletsSpreadXY(0.5,5,1,5,refire_rate:0.5,refire_max:0.25);
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
			if(invoker.canrefire&&CountInv(invoker.AmmoType1)>0){
				player.refire++;
				return ResolveState("Fire");
			}
		}else{
			invoker.canrefire=true;
		}
		return null;
	}
}