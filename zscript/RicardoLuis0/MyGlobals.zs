class MyGlobals:Thinker{
	MyGlobals Init(){
		Console.Printf("MyGlobals init");
		ChangeStatNum(STAT_STATIC);
		//inits
		return self;
	}
	static MyGlobals Get(){
		Console.Printf("MyGlobals get");
		ThinkerIterator it = ThinkerIterator.Create("MyGlobals",STAT_STATIC);
		let p=MyGlobals(it.Next());
		if(p==null){
			p=new("MyGlobals").Init();
		}
		return p;
	}
}