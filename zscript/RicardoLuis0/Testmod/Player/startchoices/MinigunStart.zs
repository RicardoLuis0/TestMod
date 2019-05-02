class MinigunStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "Minigun Start (Much Easier)";

		Player.StartItem "Minigun";
		Player.StartItem "MyPistol";
		Player.StartItem "Clip", 200;//max ammo
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}