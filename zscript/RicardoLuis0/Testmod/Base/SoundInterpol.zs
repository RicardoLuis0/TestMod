class InterpolData {
	double step;
	double cur;
	double end;
}

mixin class SoundInterpol {
	private IntHashTable volume_interpol_data;
	private IntHashTable pitch_interpol_data;
	
	private IntHashTableKeys volume_interpol_keys;
	private IntHashTableKeys pitch_interpol_keys;
	
	private bool volume_interpol_keys_stale;
	private bool pitch_interpol_keys_stale;
	
	void SoundInterpolInit(){
		volume_interpol_data=new("IntHashTable");
		pitch_interpol_data=new("IntHashTable");
		volume_interpol_keys_stale=true;
		pitch_interpol_keys_stale=true;
	}
	
	void SoundInterpolTick(Actor sound_source){
		if(!volume_interpol_data.empty()){
			if(volume_interpol_keys_stale){
				volume_interpol_keys=volume_interpol_data.getKeys();
			}
			let keys=volume_interpol_keys;
			Array<int> goneKeys;
			for(uint i=0;i<keys.keys.size();i++){
				let key=keys.keys[i];
				let data=InterpolData(volume_interpol_data.get(key));
				double val=data.cur+data.step;
				if((data.cur>0&&val>=data.end)||(data.cur<0&&val<=data.end)){
					sound_source.A_SoundVolume(key,data.end);
					goneKeys.push(key);
				}else{
					sound_source.A_SoundVolume(key,val);
					data.cur=val;
				}
			}
			for(uint i=0;i<goneKeys.size();i++){
				volume_interpol_data.delete(goneKeys[i]);
				volume_interpol_keys_stale=true;
			}
		}
		if(!pitch_interpol_data.empty()){
			if(pitch_interpol_keys_stale){
				pitch_interpol_keys=pitch_interpol_data.getKeys();
			}
			let keys=pitch_interpol_keys;
			Array<int> goneKeys;
			for(uint i=0;i<keys.keys.size();i++){
				let key=keys.keys[i];
				let data=InterpolData(pitch_interpol_data.get(key));
				double val=data.cur+data.step;
				if((data.cur>0&&val>=data.end)||(data.cur<0&&val<=data.end)){
					sound_source.A_SoundPitch(key,data.end);
					goneKeys.push(key);
				}else{
					sound_source.A_SoundPitch(key,val);
					data.cur=val;
				}
			}
			for(uint i=0;i<goneKeys.size();i++){
				pitch_interpol_data.delete(goneKeys[i]);
				pitch_interpol_keys_stale=true;
			}
		}
	}
	
	action void A_IncrementalSoundVolume(int slot,double start,double end,double step){
		InterpolData data=new("InterpolData");
		data.cur=start+step;
		data.end=end;
		data.step=step;
		A_SoundVolume(slot,data.cur);
		invoker.volume_interpol_data.set(slot,data);
		invoker.volume_interpol_keys_stale=true;
	}
	
	action void A_IncrementalSoundPitch(int slot,double start,double end,double step){
		InterpolData data=new("InterpolData");
		data.cur=start+step;
		data.end=end;
		data.step=step;
		A_SoundPitch(slot,data.cur);
		invoker.pitch_interpol_data.set(slot,data);
		invoker.pitch_interpol_keys_stale=true;
	}
	
	action void A_StopIncrementalSoundVolume(int slot,bool set_to_end=false){
		if(set_to_end){
			let data=InterpolData(invoker.volume_interpol_data.get(slot));
			if(data){
				A_SoundVolume(slot,data.end);
			}
		}
		invoker.volume_interpol_data.delete(slot);
		invoker.volume_interpol_keys_stale=true;
	}
	
	action void A_StopIncrementalSoundPitch(int slot,bool set_to_end=false){
		if(set_to_end){
			let data=InterpolData(invoker.pitch_interpol_data.get(slot));
			if(data){
				A_SoundPitch(slot,data.end);
			}
		}
		invoker.pitch_interpol_data.delete(slot);
		invoker.pitch_interpol_keys_stale=true;
	}
	
}
