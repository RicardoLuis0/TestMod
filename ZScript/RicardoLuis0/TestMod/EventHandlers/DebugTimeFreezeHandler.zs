class DebugTimeFreezeHandler : StaticEventHandler {
	
	void doFreezeTime(int tics,PlayerPawn p){
		if(!p || tics <= 0) return;
		Powerup power=Powerup(p.Spawn("PowerTimeFreezer"));
		power.effecttics = tics;
		power.bAlwaysPickup = true;
		if(!power.callTryPickup(p)){
			power.destroy();
		}
	}
	
	override void NetworkProcess(ConsoleEvent e){
		if(!multiplayer && developer>0){
			if(e.name.IndexOf("FreezeTime") == 0){
				Array<string> s;
				e.name.split(s,":");
				if(s.size() > 1){
					string num = s[1];
					int len = num.length();
					bool ok = len > 0;
					for(int i = 0; i < len;){
						int c;
						[c,i] = num.GetNextCodePoint(i);
						if(c < 0x30 || c > 0x39) {
							ok = false;
							break;
						}
					}
					if(ok){
						int i=num.toInt();
						console.printf("Freezing time for %d Tics",i);
						doFreezeTime(i,players[e.player].mo);
					} else {
						console.printf("non-numeric argument passed to 'FreezeTime'");
					}
				} else {
					console.printf("Freezing time for 350 Tics");
					doFreezeTime(350,players[e.player].mo);
				}
			}
		}
	}
}
		