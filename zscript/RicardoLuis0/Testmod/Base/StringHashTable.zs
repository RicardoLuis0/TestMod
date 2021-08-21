class StringHashTableElement {
	String key;
	Object obj;
	StringHashTableElement Init(String _key,Object _obj){
		key=_key;
		obj=_obj;
		return self;
	}
}

class StringHashTable {
	const table_size = 256; // rather small, but should be enough for what it might be used for in this mod
	Array<StringHashTableElement> table[table_size];
	uint hash(String s){ // djb2 hashing algorithm
		uint h=5381;
		for(uint i=0;i<s.length();i++){
			h=(h*33)+s.byteat(i);
		}
		return h;
	}
	
	Object getFrom(out Array<StringHashTableElement> arr,String key){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				return arr[i].obj;
			}
		}
		return null;
	}
	
	bool setAt(out Array<StringHashTableElement> arr,String key,Object obj,bool replace){
		for(uint i=0;i<arr.size();i++){
			if(arr[i].key==key){
				if(replace){
					arr[i].obj=obj;
				}
				return replace;
			}
		}
		arr.push(new("StringHashTableElement").Init(key,obj));
		return true;
	}
	
	Object get(String key){
		return getFrom(table[hash(key)%table_size],key);
	}
	
	void set(String key,Object obj){
		setAt(table[hash(key)%table_size],key,obj,true);
	}
	
	bool insert(String key,Object obj){//only inserts if key doesn't exist, otherwise fails and returns false
		return setAt(table[hash(key)%table_size],key,obj,false);
	}
}