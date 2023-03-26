extend class ModWeaponBase {
	static double CalcSpreadRate(double movement,double refire,double refire_rate=1.0,double refire_max=0.30){
		return Clamp(Clamp((refire/6.0)*refire_rate,0.0,refire_max),0.0,1.0);
	}
	
	action double W_CalcSpreadRange(double min,double max,double refire_rate=1.0,double refire_max=0.25,double start=0.0){//min and max will be used to determine a range for spread
		double rate=CalcSpreadRate(player.vel.length(),player.refire,refire_rate,refire_max);
		if(rate>=start){
			double range=min+(rate-start)*(max-min);
			return range>0?range:0;
		}else{
			return min>0?min:0;
		}
	}
	
	action double W_CalcSpread(double min,double max,double refire_rate=1.0,double refire_max=0.25,double start=0.0){//min and max will be used to determine a range for spread, returning frandom[TestModWeapon](-range,range)
		double rate=CalcSpreadRate(player.vel.length(),player.refire,refire_rate,refire_max);
		if(rate>=start){
			double range=min+(rate-start)*(max-min);
			return range>0?frandom[TestModWeapon](-range,range):0;
		}else{
			return min>0?frandom[TestModWeapon](-min,min):0;
		}
	}
	
	action double,double W_CalcSpreadXY(double min,double max,double refire_rate=1.0,double refire_max=0.25,double start=0.0){//min and max will be used to determine a range for spread, returning frandom[TestModWeapon](-range,range)
		double rate=CalcSpreadRate(player.vel.length(),player.refire,refire_rate,refire_max);
		if(rate>=start){
			double range=min+(rate-start)*(max-min);
			return (range>0?frandom[TestModWeapon](-range,range):0),(range>0?frandom[TestModWeapon](-range,range):0);
		}else{
			return (min>0?frandom[TestModWeapon](-min,min):0),(min>0?frandom[TestModWeapon](-min,min):0);
		}
	}
}