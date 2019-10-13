class GatlingGunStartTestModPlayer:TestModPlayer{
	Default{
		Player.DisplayName "Heavy Gatling Gun Start (Ridiculously Easier)";

		Player.StartItem "HeavyGatlingGun";
		Player.StartItem "MyPistol";
		Player.StartItem "LightClip", 51;//3 pistol clips
		Player.StartItem "HeavyClip", 600;//max clips
		Player.StartItem "MyPistolClip", 18;//17+1
		Player.StartItem "AssaultRifleLoadedAmmo", 20;
		Player.StartItem "PumpLoaded", 8;
		Player.StartItem "SSGLoaded", 2;
		Player.StartItem "Fist";
	}
}