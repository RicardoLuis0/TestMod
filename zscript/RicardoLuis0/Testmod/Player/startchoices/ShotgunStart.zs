class ShotgunStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "Shotgun Start (Easier)";

		Player.StartItem "PumpShotgun";
		Player.StartItem "MyPistol";
		Player.StartItem "Clip", 51;//3 pistol clips
		Player.StartItem "Shell",24;//3 shotgun clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 9;//8+1
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}