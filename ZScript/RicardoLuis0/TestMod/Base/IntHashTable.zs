class IntHashTableElement {
	int key;
	Object obj;
	
	IntHashTableElement Init(int _key,Object _obj){
		key=_key;
		obj=_obj;
		return self;
	}
	
	static IntHashTableElement newElem(int key,Object obj){
		return new("IntHashTableElement").Init(key,obj);
	}
}

class IntHashTableKeys {
	Array<int> keys;
}

class IntHashTable {
	const table_size = 256; // rather small, but should be enough for what it might be used for in this mod
	private Array<IntHashTableElement> table[table_size];
	private uint elems;
	
	private uint hash(int i){
		return abs(i);
	}
	
	private Object getFrom(out Array<IntHashTableElement> arr,int key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				return arr[i].obj;
			}
		}
		return null;
	}
	
	private bool setAt(out Array<IntHashTableElement> arr,int key,Object obj,bool replace){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				if(replace){
					arr[i].obj=obj;
				}
				return replace;
			}
		}
		arr.push(IntHashTableElement.newElem(key,obj));
		elems++;
		return true;
	}
	
	private bool delAt(out Array<IntHashTableElement> arr,int key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				arr.delete(i);
				elems--;
				return true;
			}
		}
		return false;
	}
	
	Object get(int key){
		uint sz=table_size;
		return getFrom(table[hash(key)%sz],key);
	}
	
	void set(int key,Object obj){
		uint sz=table_size;
		setAt(table[hash(key)%sz],key,obj,true);
	}
	
	bool insert(int key,Object obj){//only inserts if key doesn't exist, otherwise fails and returns false
		uint sz=table_size;
		return setAt(table[hash(key)%sz],key,obj,false);
	}
	
	bool delete(int key){
		uint sz=table_size;
		return delAt(table[hash(key)%sz],key);
	}
	
	IntHashTableKeys getKeys(){
		IntHashTableKeys keys = new("IntHashTableKeys");
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