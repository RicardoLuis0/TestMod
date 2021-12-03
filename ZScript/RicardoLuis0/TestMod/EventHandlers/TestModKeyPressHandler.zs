class TestModKeyPressHandler : StaticEventHandler {
		
	override void NetworkProcess(ConsoleEvent e){
		if(e.name=="grenade_key_pressed"){
			TestModPlayer(players[e.player].mo).grenade_key_pressed=true;
		}else if(e.name=="melee_key_pressed"){
			TestModPlayer(players[e.player].mo).melee_key_pressed=true;
		}
	}
}