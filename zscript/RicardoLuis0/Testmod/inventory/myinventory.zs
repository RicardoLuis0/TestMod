class MyInventory:Inventory{
	bool glowing;
	bool notouch;
	string glow;
	string noglow;
	bool lastbright;
	property glow:glow;
	property noglow:noglow;
	property notouch:notouch;
	Default{
		MyInventory.glow "HoverGlow";
		MyInventory.noglow "None";
		MyInventory.notouch false;
	}

	override void Touch(Actor toucher){
		if(notouch)return;
		Super.Touch(toucher);
	}

	void SuperTouch(Actor toucher){
		Super.Touch(toucher);
	}

	virtual void GlowStart(){
		if(!glowing){
			A_SetTranslation(glow);
			lastbright=bBright;
			bBright=true;
			glowing=true;
		}
	}
	
	virtual void GlowEnd(){
		if(glowing){
			A_SetTranslation(noglow);
			bBright=lastbright;
			glowing=false;
		}
	}
}

class MyHealthPickup:HealthPickup{
	bool glowing;
	string glow;
	string noglow;
	bool lastbright;
	property glow:glow;
	property noglow:noglow;
	Default{
		MyHealthPickup.glow "HoverGlow";
		MyHealthPickup.noglow "None";
	}
	
	virtual void GlowStart(){
		if(!glowing){
			A_SetTranslation(glow);
			lastbright=bBright;
			bBright=true;
			glowing=true;
		}
	}
	
	virtual void GlowEnd(){
		if(glowing){
			A_SetTranslation(noglow);
			bBright=lastbright;
			glowing=false;
		}
	}
}

class MyHealth:Health{
	bool glowing;
	string glow;
	string noglow;
	bool lastbright;
	property glow:glow;
	property noglow:noglow;
	Default{
		MyHealth.glow "HoverGlow";
		MyHealth.noglow "None";
	}
	
	virtual void GlowStart(){
		if(!glowing){
			A_SetTranslation(glow);
			lastbright=bBright;
			bBright=true;
			glowing=true;
		}
	}
	
	virtual void GlowEnd(){
		if(glowing){
			A_SetTranslation(noglow);
			bBright=lastbright;
			glowing=false;
		}
	}
}

class MyArmor:Armor{
	bool glowing;
	string glow;
	string noglow;
	bool lastbright;
	property glow:glow;
	property noglow:noglow;
	Default{
		MyArmor.glow "HoverGlow";
		MyArmor.noglow "None";
	}
	
	virtual void GlowStart(){
		if(!glowing){
			A_SetTranslation(glow);
			lastbright=bBright;
			bBright=true;
			glowing=true;
		}
	}
	
	virtual void GlowEnd(){
		if(glowing){
			A_SetTranslation(noglow);
			bBright=lastbright;
			glowing=false;
		}
	}
}