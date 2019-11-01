ACTOR Rifle : Weapon Replaces Pistol
{
	Weapon.AmmoUse1 0
	Weapon.AmmoGive1 10
	Weapon.AmmoUse2 0
	Weapon.AmmoGive2 0
	YScale 0.6
	XScale 0.8
	Weapon.SelectionOrder 1500
	Weapon.AmmoType1 "Clip"
	Weapon.AmmoType2 "RifleAmmo"
	Obituary "%o was shot down by %k's PDW."
    AttackSound "None"
    Inventory.PickupSound "CLIPIN"
	Inventory.Pickupmessage "You got the UAC-PDW!"
	+WEAPON.WIMPY_WEAPON
    +WEAPON.NOAUTOAIM
    +WEAPON.NOALERT
    +WEAPON.NOAUTOFIRE
	+FORCEXYBILLBOARD
    Scale 0.8
	States
	{
	PickUp:
	TNT1 A 0 A_Playsound("PICKUPONELINER")
	TNT1 A 0
	Stop
	
	Steady:
	TNT1 A 1
	Goto Ready
	
	
	Ready:
        TNT1 A 2 A_JumpIfInventory("GoFatality", 1, "Steady")
        TNT1 A 0 A_PlaySound("CLIPIN")
        RIFS ABC 1
        TNT1 AAAAAAAA 0
        TNT1 A 0 //A_JumpIfInventory("RifleAmmo",1,2)
        //Goto Reload
        TNT1 AAAA 0

        TNT1 A 0 A_JumpIfInventory("Kicking",1,"DoKick")
        TNT1 A 0 A_JumpIfInventory("Taunting",1,"Taunt")
		TNT1 A 0 A_JumpIfInventory("Salute1", 1, "Salute")
		TNT1 A 0 A_JumpIfInventory("Salute2", 1, "Salute")
        TNT1 A 0 A_JumpIfInventory("Reloading",1,"Reload")
		
		RIFG A 1 A_WeaponReady
		
        Goto Ready+9
    Ready2:
        TNT1 A 0 A_JumpIfInventory("Kicking",1,"DoKick")
        TNT1 A 0 A_JumpIfInventory("Taunting",1,"Taunt")
        TNT1 A 0 A_JumpIfInventory("Reloading",1,"Reload")
		TNT1 A 0 A_JumpIfInventory("Salute1", 1, "Salute")
		TNT1 A 0 A_JumpIfInventory("Salute2", 1, "Salute")
		
		RI2G A 2 A_WeaponReady
		Loop
	Deselect:
		TNT1 A 0 A_Takeinventory("Zoomed",1)
        TNT1 A 0 A_ZoomFactor(1.0)
		RIFS CBA 1
		TNT1 AAAAAAAAAAAAAAAAAA 0 A_Lower
		TNT1 A 0 A_Takeinventory("ADSmode",1)
		TNT1 A 1
		Wait
	Select:
	
	TNT1 A 0 A_Takeinventory("FistsSelected",1)
	TNT1 A 0 A_Takeinventory("SawSelected",1)
	TNT1 A 0 A_Takeinventory("ShotgunSelected",1)
	TNT1 A 0 A_Takeinventory("SSGSelected",1)
	TNT1 A 0 A_Takeinventory("MinigunSelected",1)
	TNT1 A 0 A_Takeinventory("PlasmaGunSelected",1)
	TNT1 A 0 A_Takeinventory("RocketLauncherSelected",1)
    TNT1 A 0 A_Takeinventory("GrenadeLauncherSelected",1)
	TNT1 A 0 A_Takeinventory("BFGSelected",1)
	TNT1 A 0 A_Takeinventory("BFG10kSelected",1)
	TNT1 A 0 A_Takeinventory("RailGunSelected",1)
	TNT1 A 0 A_Takeinventory("SubMachineGunSelected",1)
	TNT1 A 0 A_Takeinventory("RevenantLauncherSelected",1)
	TNT1 A 0 A_Takeinventory("LostSoulSelected",1)
	TNT1 A 0 A_Takeinventory("FlameCannonSelected",1)
	TNT1 A 0 A_Takeinventory("HasBarrel",1)
	
		TNT1 A 0 A_Raise
		Wait
    Fire:
        TNT1 A 0 A_JumpIfInventory("RifleAmmo",1,2)
        Goto Reload
        TNT1 AAAA 0
		
		
		
		TNT1 A 0 A_JumpIfInventory("Zoomed",1,"Fire2")
        TNT1 A 0 A_PlaySound("weapons/pistol")
        //TNT1 A 0 A_FireCustomMissile("SmokeSpawner",0,0,0,5)
		RIFF A 1 BRIGHT A_AlertMonsters
		//TNT1 A 0 A_FireCustomMissile("YellowFlareSpawn",0,0,0,0)
		TNT1 A 0 A_SpawnItemEx("PlayerMuzzle1",30,5,30)
		RIFF B 1 BRIGHT A_FireBullets (2, 2, -1, 10, "HitPuff")
        RIFF A 0 A_FireCustomMissile("Tracer", random(-3,3), 0, -1, -12, 0, random(-3,3))
        TNT1 A 0 A_SetPitch(-1.3 + pitch)
		//TNT1 A 0 ACS_Execute(373, 0, 0, 0, 0)
		//TNT1 A 0 A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0)
		//TNT1 A 0 A_FireCustomMissile("YellowFlareSpawn",0,0,0,0)
		TNT1 A 0 A_Takeinventory("RifleAmmo",1)
		TNT1 A 0 A_SetPitch(+0.4 + pitch)
		RIFF C 1 A_FireCustomMissile("RifleCaseSpawn",5,0,6,-6)
        RIFG AA 1 A_SetPitch(+0.4 + pitch)
		RIFG A 1 A_Refire
		RIFG A 7 A_WeaponReady(1)
		Goto Ready+6

      Fire2:
        TNT1 A 0 A_PlaySound("weapons/rifle")
        //TNT1 A 0 A_FireCustomMissile("SmokeSpawner",0,0,0,5)
		RI2G A 0 A_AlertMonsters
		//TNT1 A 0 A_FireCustomMissile("YellowFlareSpawn",0,0,0,5)
		TNT1 A 0 A_SpawnItemEx("PlayerMuzzle1",30,0,45)
		RI2F A 1 BRIGHT A_FireBullets (0.1, 0.1, -1, 10, "HitPuff")
        RI2F A 0 BRIGHT A_FireCustomMissile("Tracer", 0, 0, -1, 0)
        //TNT1 A 0 ACS_Execute(373, 0, 0, 0, 0)
		//TNT1 A 0 A_FireCustomMissile("ShakeYourAssMinor", 0, 0, 0, 0)
		TNT1 A 0 A_SetPitch(-0.9 + pitch)
		TNT1 A 0 A_Takeinventory("RifleAmmo",1)
		RI2F B 1 A_WeaponReady(1)
		TNT1 A 0 A_SetPitch(+0.3 + pitch)
		TNT1 A 0 A_FireCustomMissile("RifleCaseSpawn",1,0,8,0)
        RI2F C 1 A_WeaponReady(1)
		TNT1 A 0 A_SetPitch(+0.3 + pitch)
        RI2F B 0
		RI2G A 2 A_WeaponReady(1)
		TNT1 A 0 A_SetPitch(+0.3 + pitch)
		TNT1 A 0 A_Refire
		RI2G A 10 A_WeaponReady(1)
        RI2G A 0
		Goto Ready2

    AltFire:
        TNT1 A 0
		TNT1 A 0 A_JumpIfInventory("Zoomed",1,8)
		TNT1 A 0 A_Giveinventory("Zoomed",1)
		TNT1 A 0 A_Giveinventory("GoSpecial",1)
        TNT1 A 0 A_ZoomFactor(2.3)
		TNT1 A 0 A_Giveinventory("ADSmode",1)
        RIFZ AB 1
        Goto Ready2
        TNT1 AAAAAA 0
        RIFZ BA 1
		TNT1 A 0 A_Takeinventory("Zoomed",1)
        TNT1 A 0 A_ZoomFactor(1.0)
		TNT1 A 0 A_Takeinventory("ADSmode",1)
        Goto Ready+6
		
	NoAmmo:
	RIFG A 1 A_PlaySound("weapons/empty")
	TNT1 A 0 A_Takeinventory("Zoomed",1)
    TNT1 A 0 A_ZoomFactor(1.0)
	TNT1 A 0 A_Takeinventory("ADSmode",1)
	Goto Ready+12
	
    Reload:
		RIFG A 1 A_WeaponReady
		TNT1 A 0 A_ZoomFactor(1.0)
		TNT1 A 0 A_Takeinventory("Reloading",1)
		TNT1 A 0 A_Takeinventory("ADSmode",1)
		TNT1 A 0 A_Takeinventory("Zoomed",1)
		TNT1 A 0 A_JumpIfInventory("RifleAmmo",30,64)

        TNT1 A 0 A_JumpIfInventory("Clip",1,3)
        Goto NoAmmo
        TNT1 AAA 0
		TNT1 A 0 A_Takeinventory("Zoomed",1)
        TNT1 A 0 A_PlaySound("Reload")
		TNT1 A 0 A_GiveInventory ("Pumping", 1)
		TNT1 A 0 A_Takeinventory("Reloading",1)
		
		TNT1 A 0 A_SetAngle(-1 + angle)
        RIFR ABCDE 1  A_JumpIfInventory("Kicking",1,"DoKick")
        RIFR F 1 A_FireCustomMissile("EmptyClipSpawn",-5,0,8,-4)
		TNT1 A 0 A_SetAngle(+1 + angle)
        RIFR GGGGGGGG 1
		RIFR HIKL 1
		TNT1 A 0 A_SetAngle(-4 + angle)
		TNT1 A 0 A_SetPitch(-2 + pitch)
		RIFR MMM 1
		TNT1 A 0 A_SetPitch(+2 + pitch)
		TNT1 A 0 A_SetAngle(+4 + angle)
		RIFR NOPQRST 1 A_JumpIfInventory("Kicking",1,"DoKick")
		
		InsertBullets:
		TNT1 AAAA 0
		TNT1 A 0 A_JumpIfInventory("RifleAmmo",30,15)
		TNT1 A 0 A_JumpIfInventory("Clip",1,3)
		Goto Ready+6
        TNT1 AAAAAA 0
		TNT1 A 0 A_Giveinventory("RifleAmmo",1)
		TNT1 A 0 A_Takeinventory("Clip",1)
		Goto InsertBullets
		
		TNT1 AAAAAAAAAA 0
		TNT1 A 0 A_Takeinventory("Reloading",1)
        Goto Ready+6
		TNT1 AAAA 0
				TNT1 A 0 A_Takeinventory("Reloading",1)
        Goto Ready+6
 	Spawn:
		RIFL A -1
		Stop
		
		
    DoKick:
	    TNT1 A 0
		TNT1 A 0 A_Takeinventory("Zoomed",1)
        TNT1 A 0 A_ZoomFactor(1.0)
		TNT1 A 0 A_Takeinventory("ADSmode",1)
		NULL A 0 A_JumpIf (momZ > 0, "AirKick")
		NULL A 0 A_JumpIf (momZ < 0, "AirKick")
		NULL A 0 A_JumpIf (pitch > 32, "LowKickChecker1")
	InitializeNormalKick:
        TNT1 A 0 A_jumpifinventory("PowerStrength",1,"BerserkerKick")
		TNT1 A 0 A_PlaySound("KICK")
		TNT1 A 0 SetPlayerProperty(0,1,0)
		KICK BCD 1
		//TNT1 A 0 A_Custompunch(4,0,1,"KickPuff")
		RIFF A 0 A_FireCustomMissile("KickAttack", 0, 0, 0, -7)
        KICK H 4
		KICK A 0 A_Takeinventory("Kicking",1)
		KICK IGFEDCBA 1
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
		TNT1 A 0 SetPlayerProperty(0,0,0)
		Goto Ready+6
	LowKickChecker1:
	    TNT1 A 1
	    NULL A 0 A_JumpIf (pitch > 90, "InitializeNormalKick")
		Goto AirKick
		
    BerserkerKick:
		TNT1 A 0 A_PlaySound("KICK")
		TNT1 A 0 SetPlayerProperty(0,1,0)
		KICK ABCDEFG 1
        RIFF A 0 A_FireCustomMissile("SuperKickAttack", 0, 0, 0, -7)
        KICK H 3
		KICK A 0 A_Takeinventory("Kicking",1)
		KICK IGFEDCBA 1
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
		TNT1 A 0 SetPlayerProperty(0,0,0)
		Goto Ready+6
	
	AirKick:
	    TNT1 A 0 A_jumpifinventory("PowerStrength",1,"SuperAirKick")
		TNT1 A 0 A_PlaySound("KICK")
		TNT1 A 0 A_Recoil (-2)
		KICK JKLMN 1
        RIFF A 0 A_FireCustomMissile("AirKickAttack", 0, 0, 0, -31)
        KICK O 3
		KICK A 0 A_Takeinventory("Kicking",1)
		KICK PQRST 2
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
		Goto Ready+6
		
	SuperAirKick:
		TNT1 A 0 A_PlaySound("KICK")
		TNT1 A 0 A_Recoil (-2)
		KICK JKLMN 1
        RIFF A 0 A_FireCustomMissile("SuperAirKickAttack", 0, 0, 0, -31)
        KICK O 3
		KICK A 0 A_Takeinventory("Kicking",1)
		KICK PQRST 2
		TNT1 A 0 A_JumpIfInventory("GoFatality", 1, "Steady")
		Goto Ready+6
	Taunt:
		TNT1 A 0 A_Takeinventory("Zoomed",1)
        TNT1 A 0 A_ZoomFactor(1.0)
        TNT1 A 10
		FUCK A 1
		TNT1 A 0 BRIGHT A_FireCustomMissile("Taunter", 0, 0, -1, 0)
		TNT1 A 0 BRIGHT A_FireCustomMissile("Taunter", -9, 0, -1, 0)
		TNT1 A 0 BRIGHT A_FireCustomMissile("Taunter", 9, 0, -1, 0)
        FUCK B 1 A_PlaySound("FUCK", 2)
        FUCK CD 1 A_AlertMonsters
		FUCK E 15 A_Takeinventory("Taunting",1)
        FUCK DCBA 1
        TNT1 A 10
		Goto Ready
	Salute:
	    TNT1 A 0 SetPlayerProperty(0,1,0)
		TNT1 A 0 A_ALertMonsters
		SALU ABCDEDCDEDCDEDCBA 4
		TNT1 A 0 A_TakeInventory("Salute1",1)
		TNT1 A 0 A_TakeInventory("Salute2",1)
		TNT1 A 0 SetPlayerProperty(0,0,0)
		Goto Ready
	}
}
