class TID_Handler:Thinker{
	MyMap TID_MAP;
	TID_Handler Init(){
		Console.Printf("TID_Handler init");
		ChangeStatNum(STAT_STATIC);
		TID_MAP=new("MyMap");
		return self;
	}
	/*
	static int getTIDstatic(string key){
		Console.Printf("TID_Handler getTIDstatic");
		ThinkerIterator it = ThinkerIterator.Create("TID_Handler");
		let p=TID_Handler(it.Next());
		if(p==null){
			p=new("TID_Handler").Init();
		}
		return p.getTID(key);
	}
	*/
	virtual int getTID(string key){
		Console.Printf("TID_Handler getTID");
		Console.Printf("TID map");
		int index=TID_MAP.find(key);
		Console.Printf("TID map OK");
		if(index<0){
			ThinkerIterator it = ThinkerIterator.Create("MyPlayer");
			let p=MyPlayer(it.Next());
			if(p){
				Console.Printf("TID Cast OK");
				int TID=p.pFindUniqueTid();
				TID_MAP.set(key,TID);
				return TID;
			}else{
				return -1;
			}
		}else{
			return TID_MAP.getIndex(index);
		}
	}
}