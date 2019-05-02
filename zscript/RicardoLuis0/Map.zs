class MyMap{
	const MAXLEN=200;
	int currentmax;
	string indexes[MAXLEN];
	int values[MAXLEN];
	
	int find(string index){
		for(int i=0;i<currentmax;i++){
			if(indexes[i]==index) return i;
		}
		return -1;
	}
	
	int get(string index){
		int i=find(index);
		if(i==-1)return -1;
		return values[i];
	}
	
	int getIndex(int index){
		if(index<0||index>=MAXLEN) return -1;
		return values[index];
	}
	
	bool set(string index,int value){
		int i=find(index);
		if(i==-1){
			if(currentmax==MAXLEN){
				return false;
			}
			i=currentmax++;
			indexes[i]=index;
		}
		values[i]=value;
		return true;
	}

	bool setIndex(int index,int value){
		if(index<0||index>=MAXLEN) return false;
		values[index]=value;
		return true;
	}

	bool key_exists(string key){
		for(int i=0;i<currentmax;i++){
			if(indexes[i]==key) return true;
		}
		return false;
	}
}