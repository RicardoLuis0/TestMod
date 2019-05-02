class My_Globals:Thinker{
	My_Globals Init(){
		Console.Printf("MyGlobals init");
		ChangeStatNum(STAT_STATIC);
		//inits
		return self;
	}
	static My_Globals Get(){
		Console.Printf("MyGlobals get");
		ThinkerIterator it = ThinkerIterator.Create("My_Globals",STAT_STATIC);
		let p=My_Globals(it.Next());
		if(p==null){
			p=new("My_Globals").Init();
		}
		return p;
	}
}