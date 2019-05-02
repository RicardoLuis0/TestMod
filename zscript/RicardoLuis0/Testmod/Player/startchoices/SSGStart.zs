class SSGStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "SSG Start (...)";

		Player.StartItem "SSG";
		Player.StartItem "MyPistol";
		Player.StartItem "Clip", 51;//3 pistol clips
		Player.StartItem "Shell",24;//3 shotgun clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}