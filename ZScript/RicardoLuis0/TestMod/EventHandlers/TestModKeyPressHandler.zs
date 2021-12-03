class TestModKeyPressHandler : StaticEventHandler {
	
	array<int> invuse_buttons;
	ui int invuse_key_count;
	
	private void updateBindings(){
		Bindings.GetAllKeysForCommand(invuse_buttons,"invuse");
	}
	
	override void OnRegister(){
		updateBindings();
	}
	
	override void WorldTick(){
		if(gametic%35){
			updateBindings();
		}
	}
	
	override bool InputProcess(InputEvent e){
		if(e.type==InputEvent.Type_KeyDown||e.type==InputEvent.Type_KeyUp){
			bool wasDown=invuse_key_count>0;
			uint n=invuse_buttons.size();
			for(uint i=0;i<n;i++){
				if(e.keyScan==invuse_buttons[i]){
					if(e.type==InputEvent.Type_KeyDown){
						invuse_key_count++;
					}else{
						invuse_key_count--;
					}
				}
			}
			bool isDown=invuse_key_count>0;
			if(isDown!=wasDown){
				if(isDown){
					EventHandler.SendNetworkEvent("invuse_key_down");
				}else{
					EventHandler.SendNetworkEvent("invuse_key_up");
				}
			}
		}
		return false;
	}
	
	override void NetworkProcess(ConsoleEvent e){
		if(e.name=="grenade_key_pressed"){
			TestModPlayer(players[e.player].mo).grenade_key_pressed=true;
		}else if(e.name=="melee_key_pressed"){
			TestModPlayer(players[e.player].mo).melee_key_pressed=true;
		}else if(e.name=="invuse_key_down"){
			TestModPlayer(players[e.player].mo).invuse_key_down=true;
		}else if(e.name=="invuse_key_up"){
			TestModPlayer(players[e.player].mo).invuse_key_down=false;
		}
	}
}