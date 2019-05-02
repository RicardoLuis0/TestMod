class RifleStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "Rifle Start (Easier)";

		Player.StartItem "AssaultRifle";
		Player.StartItem "MyPistol";
		Player.StartItem "Clip", 111;//3 pistol clips, 3 rifle clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 21;//20+1
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}