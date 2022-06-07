class StringToIntHashTableElement {
	String key;
	int val;
	
	StringToIntHashTableElement Init(String _key,int _val){
		key=_key;
		val=_val;
		return self;
	}
	
	static StringToIntHashTableElement newElem(String key,int val){
		return new("StringToIntHashTableElement").Init(key,val);
	}
}

class StringToIntHashTableKeys {
	Array<String> keys;
}

class StringToIntHashTable {
	const table_size = 256; // rather small, but should be enough for what it might be used for in this mod
	private Array<StringToIntHashTableElement> table[table_size];
	private uint elems;
	
	private uint hash(String s){ // djb2 hashing algorithm
		uint h=5381;
		for(uint i=0;i<s.length();i++){
			h=(h*33)+s.byteat(i);
		}
		return h;
	}
	
	private int getFrom(out Array<StringToIntHashTableElement> arr,String key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				return arr[i].val;
			}
		}
		//ThrowAbortException("Could not find item for key '"+key+"'");
		return -1;
	}
	
	private bool setAt(out Array<StringToIntHashTableElement> arr,String key,int val,bool replace){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				if(replace){
					arr[i].val=val;
				}
				return replace;
			}
		}
		arr.push(StringToIntHashTableElement.newElem(key,val));
		elems++;
		return true;
	}
	
	private bool delAt(out Array<StringToIntHashTableElement> arr,String key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				arr.delete(i);
				elems--;
				return true;
			}
		}
		return false;
	}
	
	int get(String key){
		uint sz=table_size;
		return getFrom(table[hash(key)%sz],key);
	}
	
	void set(String key,int val){
		uint sz=table_size;
		setAt(table[hash(key)%sz],key,val,true);
	}
	
	bool insert(String key,int val){//only inserts if key doesn't exist, otherwise fails and returns false
		uint sz=table_size;
		return setAt(table[hash(key)%sz],key,val,false);
	}
	
	bool delete(String key){
		uint sz=table_size;
		return delAt(table[hash(key)%sz],key);
	}
	
	StringToIntHashTableKeys getKeys(){
		StringToIntHashTableKeys keys = new("StringToIntHashTableKeys");
		for(uint i=0;i<table_size;i++){
			for(uint j=0;j<table[i].size();j++){
				keys.keys.push(table[i][j].key);
			}
		}
		return keys;
	}
	
	bool empty(){
		return elems==0;
	}
}