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

class IntHashTable {
	const table_size = 256; // rather small, but should be enough for what it might be used for in this mod
	private Array<IntHashTableElement> table[table_size];
	
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
		return true;
	}
	
	private bool delAt(out Array<IntHashTableElement> arr,int key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				arr.delete(i);
				return true;
			}
		}
		return false;
	}
	
	Object get(int key){
		return getFrom(table[hash(key)%table_size],key);
	}
	
	void set(int key,Object obj){
		setAt(table[hash(key)%table_size],key,obj,true);
	}
	
	bool insert(int key,Object obj){//only inserts if key doesn't exist, otherwise fails and returns false
		return setAt(table[hash(key)%table_size],key,obj,false);
	}
	
	bool delete(int key){
		return delAt(table[hash(key)%table_size],key);
	}
}