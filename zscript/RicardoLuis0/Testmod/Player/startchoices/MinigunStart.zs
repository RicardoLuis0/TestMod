class MinigunStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "Minigun Start (Much Easier)";

		Player.StartItem "Minigun";
		Player.StartItem "MyPistol";
		Player.StartItem "LightClip", 300;//max clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}