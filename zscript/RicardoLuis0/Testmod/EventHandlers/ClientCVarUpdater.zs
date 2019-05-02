class ClientCVarUpdater : StaticEventHandler {
	override void NetworkProcess(ConsoleEvent e){
		if(e.player==consoleplayer){
			if(e.name=="player_UpdateCVars"){
				TestModPlayer p=TestModPlayer(players[e.player].mo);
				if(p)p.player_UpdateCVars();
				console.printf("player cvars updated");
			}
			if(e.name=="weaponinertia_UpdateCVars"){
				TestModPlayer p=TestModPlayer(players[e.player].mo);
				if(p)p.weaponinertia_UpdateCVars();
				console.printf("inertia cvars updated");
			}
		}
	}
}