
class SmartGunMarker : Actor {
	Default{
		+NOINTERACTION
		+FORCEXYBILLBOARD
		FloatBobPhase 0;
	}
	States{
		Spawn:
			TNT1 A -1;
			Stop;
	}
}

class SmartGun : ModWeaponBase {
	Default {
		Weapon.SlotNumber 7;
		Weapon.AmmoType1 "HeavyClip";
		Weapon.AmmoUse1 1;
		Weapon.AmmoGive1 50;
		
		+WEAPON.NOALERT;
		+WEAPON.AMMO_OPTIONAL;
		+WEAPON.NOAUTOFIRE;
		
		ModWeaponBase.PickupHandleNoMagazine true;
	}
	
	SmartGunMarker marker;
	
	Actor last_target;
	
	Array<Actor> targets;
	
	//get angle and delta from two positions
	static vector3,double,double lookAt(Vector3 pos1,Vector3 pos2){
		//calculate difference between pos1 and pos2 (level.Vec3Diff takes portals into account)
		
		Vector3 delta=level.Vec3Diff(pos1,pos2);
		
		//calculate angle and pitch to other actor
		double target_angle=atan2(delta.y,delta.x);
		double target_pitch=-asin(delta.z/delta.length());

		return delta,target_angle,target_pitch;
	}
	
	Vector2 VecAngle(Vector3 delta){
		return (atan2(delta.y, delta.x), -asin(delta.z / delta.length()));
	}
	
	double actorDist(Actor a){
		let delta=level.Vec3Diff(owner.pos,a.pos);
		let ang_delta=VecAngle(delta);
		ang_delta.x=DeltaAngle(ang_delta.x,owner.angle);
		ang_delta.y=DeltaAngle(ang_delta.y,owner.pitch);
		ang_delta*=5;
		return delta.length()+abs(ang_delta.x)+abs(ang_delta.y);
	}
	
	Vector2 angle_offset;
	Vector2 pos_offset;
	
	Vector2 aim_angle;
	
	Vector3, bool doTrace(double x_a,double y_a){
		FLineTraceData t;
		
		owner.player.mo.LineTrace(owner.angle + x_a,1024, owner.pitch + y_a, TRF_NOSKY | TRF_SOLIDACTORS,
						//offsetz: (owner.player.ViewZ) + pos_offset.y,
						offsetz: (owner.player.mo.viewheight * owner.player.crouchfactor) + pos_offset.y,
						offsetside: pos_offset.x,
						data: t);
		
		if(t.HitActor){
			if(t.HitActor.bIsMonster && !t.HitActor.bFriendly){
				int sz=targets.size();
				for(int i=0;i<sz;i++){
					if(targets[i]==t.HitActor){
						return t.HitLocation, true;
					}
				}
				targets.push(t.HitActor);
				return t.HitLocation, true;
			}
		}
		return t.HitLocation, false;
	}
	
	void TraceVisible(double x_a,double y_a){
		Vector3 hLoc;
		bool hit_monster;
		[hLoc, hit_monster] = doTrace(x_a, y_a);
		
		Vector3 diff=level.Vec3Diff((owner.pos.x,owner.pos.y,owner.player.ViewZ),hLoc);
		let hLoc2=hLoc-(diff/diff.length());
		marker.SetOrigin(hLoc2,false);
		double dist=diff.length();
		
		Color enemy_color="#FF0000";
		Color not_enemy_color="#00FF00";
		
		marker.A_SpawnParticle(hit_monster?enemy_color:not_enemy_color,SPF_FULLBRIGHT,1,clamp(dist/100,2.5,75));
	}
	
	void pspReset(PSPrite psp){
		psp.x=0;
		psp.y=0;
		psp.scale.y=1.0;
		psp.rotation=0;
		psp.InterpolateTic=true;
	}
	
	void pspBarrelAim(PSPrite psp,Vector2 d){
		psp.x=d.x*6;
		psp.y=d.y*-2.5;
		psp.scale.y=1.0+(d.y*0.10);
		psp.rotation=(d.x*-20);
		psp.InterpolateTic=true;
	}
	
	void pspMuzzleAim(PSPrite psp,Vector2 d){
		psp.x=d.x*6;
		psp.y=d.y*-2.5;
		psp.rotation=(d.x*-20);
		psp.InterpolateTic=true;
	}
	
	void pspFrameAim(PSPrite psp,Vector2 d){
		psp.x=d.x*-5;
		psp.y=d.y*-1;
		psp.scale.y=1.0+(d.y*0.05);
		psp.rotation=(d.x*-22);
		psp.InterpolateTic=true;
	}
	
	override void ReadyTick() {
		
		targets.clear();
		
		if(marker){
			marker.Destroy();
		}
		
		marker=SmartGunMarker(owner.Spawn("SmartGunMarker",owner.pos,NO_REPLACE));
		
		[angle_offset, pos_offset] = TestModPlayer(owner).InertiaBobAim();
		
		double x_a=31.5;
		double m_x=16.5;
		double y_a=16.5;
		double m_y=7.5;
		//corners
		TraceVisible(x_a,y_a);
		TraceVisible(-x_a,y_a);
		TraceVisible(-x_a,-y_a);
		TraceVisible(x_a,-y_a);
		
		//top
		TraceVisible(m_x,-y_a);
		TraceVisible(0,-y_a);
		TraceVisible(-m_x,-y_a);
		
		//bottom
		TraceVisible(m_x,y_a);
		TraceVisible(0,y_a);
		TraceVisible(-m_x,y_a);
		
		//left
		TraceVisible(x_a,m_y);
		TraceVisible(x_a,0);
		TraceVisible(x_a,-m_y);
		
		//right
		TraceVisible(-x_a,m_y);
		TraceVisible(-x_a,0);
		TraceVisible(-x_a,-m_y);
		
		int start_x=-30;
		int end_x=31;
		
		int start_y=-15;
		int end_y=16;
		
		int step=3;
		
		for(int x=start_x;x<end_x;x+=step){
			for(int y=start_y;y<end_y;y+=step){
				TraceVisible(x,y);
			}
		}
		
		marker.Destroy();
		marker=null;
		
		if(targets.size()>0){
			Actor closest=targets[0];
			double closest_dist=actorDist(closest);
			
			int sz=targets.size();
			
			for(int i=1;i<sz;i++){
				double dist=actorDist(targets[i]);
				if(dist<closest_dist){
					closest=targets[i];
					closest_dist=dist;
				}
			}
			last_target=closest;
			
			Vector3 diff=level.Vec3Diff(owner.pos,closest.pos);
			
			aim_angle=VecAngle(diff);
			
			aim_angle.x=DeltaAngle(aim_angle.x,owner.angle);
			aim_angle.y=DeltaAngle(aim_angle.y,owner.pitch);
			
			
			let muzzle_psp=PSP_Get(-150);
			let barrel_psp=PSP_Get(-50);
			let barrel_glow_psp=PSP_Get(-49);
			
			let back_psp=PSP_Get(-100);
			let top_psp=PSP_Get(-25);
			let top_glow_psp=PSP_Get(-24);
			let cable_psp=PSP_Get(25);
			
			if(barrel_psp){
				Vector2 d=(
					clamp(aim_angle.x/40,-1,1),
					clamp(aim_angle.y/20,-1,1)
				);
				
				pspMuzzleAim(muzzle_psp,d);
				pspBarrelAim(barrel_psp,d);
				pspBarrelAim(barrel_glow_psp,d);
				
				pspFrameAim(back_psp,d);
				pspFrameAim(top_psp,d);
				pspFrameAim(top_glow_psp,d);
				pspFrameAim(cable_psp,d);
			}
			
		} else {
			last_target=null;
			
			let muzzle_psp=PSP_Get(-150);
			let barrel_psp=PSP_Get(-50);
			let barrel_glow_psp=PSP_Get(-49);
			
			let back_psp=PSP_Get(-100);
			let top_psp=PSP_Get(-25);
			let top_glow_psp=PSP_Get(-24);
			let cable_psp=PSP_Get(25);
			
			if(barrel_psp){
				pspReset(muzzle_psp);
				pspReset(barrel_psp);
				pspReset(barrel_glow_psp);
				
				pspReset(back_psp);
				pspReset(top_psp);
				pspReset(top_glow_psp);
				pspReset(cable_psp);
			}
			aim_angle=(0,0);
		}
		if(firing){
			barrel_glow_alpha+=0.1;
			top_glow_alpha+=0.05;
		}else{
			barrel_glow_alpha-=0.0125;
			top_glow_alpha-=0.025;
		}
		
		barrel_glow_alpha=clamp(barrel_glow_alpha,0.0,1.0);
		SetLayerAlpha(-49,barrel_glow_alpha);
		top_glow_alpha=clamp(top_glow_alpha,0.0,1.0);
		SetLayerAlpha(-24,top_glow_alpha);
		
	}
	
	bool firing;
	double barrel_glow_alpha;
	double top_glow_alpha;
	
	States {
	Ready:
		SGUN A 1 A_WeaponReady;
		Loop;
	Deselect: 
		SGUN A 1 A_Lower;
		Loop;
	Select:
		TNT1 A 0 {
			A_Overlay(-150,"MuzzleFlashOverlay");
			A_OverlayFlags(-150,PSPF_PIVOTPERCENT,false);
			A_OverlayFlags(-150,PSPF_RENDERSTYLE,true);
			A_OverlayRenderstyle(-150,STYLE_Add);
			A_OverlayPivot(-150,76,139);
			
			A_Overlay(-100,"BackOverlay");
			A_OverlayFlags(-100,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(-100,76,107);
			
			A_Overlay(-50,"BarrelOverlay");
			A_OverlayFlags(-50,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(-50,76,83);
			
			A_Overlay(-49,"BarrelOverlay.Glow");
			A_OverlayFlags(-49,PSPF_PIVOTPERCENT,false);
			A_OverlayFlags(-49,PSPF_FORCEALPHA,true);
			A_OverlayPivot(-49,76,83);
			A_OverlayAlpha(-49,0.0);
			
			A_Overlay(-25,"TopOverlay");
			A_OverlayFlags(-25,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(-25,76,107);
			
			A_Overlay(-24,"TopOverlay.Glow");
			A_OverlayFlags(-24,PSPF_PIVOTPERCENT,false);
			A_OverlayFlags(-24,PSPF_FORCEALPHA,true);
			A_OverlayPivot(-24,76,107);
			A_OverlayAlpha(-24,0.0);
			
			A_Overlay(25,"CableOverlay");
			A_OverlayFlags(25,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(25,76,107);
		}
	SelectLoop:
		SGUN A 1 A_Raise;
		Loop;
	NoAmmo:
		SGUN A 1 {
			A_WeaponOffset(0,32,WOF_INTERPOLATE);
			invoker.firing=false;
		}
		Goto Ready;
	Fire:
		TNT1 A 0 {
			invoker.AmmoUse1=true;
		}
		TNT1 A 0 A_JumpIfNoAmmo("NoAmmo");
		TNT1 A 0 {
			A_WeaponOffset(0,40,WOF_INTERPOLATE);
			
			A_Overlay(-50,"BarrelOverlay.Fire");
			A_OverlayFlags(-50,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(-50,76,83);
			
			A_Overlay(-49,"BarrelOverlay.Glow.Fire");
			A_OverlayFlags(-49,PSPF_PIVOTPERCENT,false);
			A_OverlayPivot(-49,76,83);
			A_OverlayFlags(-49,PSPF_FORCEALPHA,true);
			
			if(invoker.barrel_glow_alpha<0.25){
				invoker.barrel_glow_alpha=0.25;
			}
			
			invoker.barrel_glow_alpha=clamp(invoker.barrel_glow_alpha,0,1.0);
			A_OverlayAlpha(-49,invoker.barrel_glow_alpha);
			
			invoker.firing = true;
		}
	Hold:
		TNT1 A 0 A_JumpIfNoAmmo("NoAmmo");
		SGUN A 2 {
			A_Overlay(-150,"MuzzleFlashOverlay.Fire");
			A_OverlayFlags(-150,PSPF_PIVOTPERCENT,false);
			A_OverlayFlags(-150,PSPF_RENDERSTYLE,true);
			A_OverlayRenderstyle(-150,STYLE_Add);
			
			A_OverlayPivot(-150,76,139);
			double xoff=frandom(2,-2);
			double yoff=frandom(2,-2);
			xoff-=invoker.aim_angle.x;
			yoff-=invoker.aim_angle.y;
			A_AlertMonsters();
			A_FireProjectile("HeavyClipCasing",-75,false,3,5-(8*(1-player.crouchfactor)),FPF_NOAUTOAIM,random(80,100));
			
			W_FireTracer((xoff,yoff),15,puff:"PiercingPuff",flags:FBF_EXPLICITANGLE|FBF_USEAMMO);
			
			A_StartSound("weapons/smartgun",CHAN_WEAPON,CHANF_OVERLAP);
			invoker.AmmoUse1=!invoker.AmmoUse1;
		}
		TNT1 A 0 A_ReFire;
		TNT1 A 0 {
			A_WeaponOffset(0,32,WOF_INTERPOLATE);
			invoker.firing=false;
		}
		Goto Ready;
	Spawn:
		SGUN J -1;
		Stop;
	CableOverlay:
		SGUN E -1;
		Loop;
		
	BackOverlay:
		SGUN B -1;
		Loop;
		
	TopOverlay:
		SGUN D -1;
		Loop;
	
	TopOverlay.Glow:
		SGUN I -1 BRIGHT;
		Loop;
		
	BarrelOverlay:
		SGUN C -1;
		Loop;
	BarrelOverlay.Fire:
		SGUN L 1 BRIGHT;
		SGUN M 1 BRIGHT;
		TNT1 A 0 CheckFire("BarrelOverlay.Fire");
		//TNT1 A 0 A_ReFire("BarrelOverlay.Fire");
		Goto BarrelOverlay;
		
	BarrelOverlay.Glow:
		SGUN K 1 BRIGHT;
		Loop;
		
	BarrelOverlay.Glow.Fire:
		SGUN F 1 BRIGHT;
		SGUN H 1 BRIGHT;
		TNT1 A 0 CheckFire("BarrelOverlay.Glow.Fire");
		//TNT1 A 0 A_ReFire("BarrelOverlay.Glow.Fire");
		Goto BarrelOverlay.Glow;
	
	MuzzleFlashOverlay:
		TNT1 A -1;
		Loop;
		
	MuzzleFlashOverlay.Fire:
		SGUN G 1 BRIGHT;
		Goto MuzzleFlashOverlay;
	}
}