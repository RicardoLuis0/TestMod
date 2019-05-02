class ManaCapacity:Inventory{
	Default{
		Inventory.MaxAmount 9999;
	}
}

class ManaRegenAmt:Inventory{
	Default{
		Inventory.MaxAmount 9999;
	}
}

class Mana : Ammo {
	MyPlayer p;
	bool allow;
	bool first;
	Default{
		Inventory.MaxAmount 0;
	}
	override void BeginPlay(){
		Super.BeginPlay();
		p=null;
	}
	override void Tick(){
		Super.Tick();
		if(p==null){
			let pt = MyPlayer(owner);
			if(pt){
				p=pt;
				allow=p.allowMana();
			}
		}else if(allow){
			if(p.pCountInv("ManaCapacity")!=MaxAmount){
				MaxAmount=p.pCountInv("ManaCapacity");
			}
		}
	}
}

class ManaRegenHandler : Inventory{
	MyPlayer p;
	bool allow;
	int delay;
	int count;
	override void BeginPlay(){
		Super.BeginPlay();
		p=null;
		delay=15;
		count=0;
	}
	override void Tick(){
		Super.Tick();
		if(p==null){
			let pt = MyPlayer(owner);
			if(pt){
				p=pt;
				allow=p.allowMana();
			}
		}else if(allow){
			if(count<=0){
				p.pGiveInventory("Mana",p.pCountInv("ManaRegenAmt"));
				count=delay;
			}else{
				count--;
			}
		}
	}
}
