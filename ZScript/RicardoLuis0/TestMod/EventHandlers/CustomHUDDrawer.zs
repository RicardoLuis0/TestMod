extend class TestModHandler
{
	TextureID tex;
	TextureID tex2;
	Font f;
	
	void OnRegisterCustomHUDDrawer()
	{
		tex = TexMan.CheckForTexture("Patches/HUD/rpm.png");
		tex2 = TexMan.CheckForTexture("Patches/HUD/uifill.png");
		
		//f = NewSmallFont;
		f = NewConsoleFont;
		
		if(!tex) ThrowAbortException("Failed to open texture 'Patches/HUD/rpm.png'");
		if(!tex2) ThrowAbortException("Failed to open texture 'Patches/HUD/uifill.png'");
	}
	
	const spacing = 5; // 5px spacing
	const rpm_w = 282.0 / 5.0;
	const rpm_h = 131.0 / 5.0;
	override void RenderOverlay(RenderEvent e)
	{
		if(playeringame[consoleplayer])
		{
			if(CVar.GetCVar('cl_showrpm', players[consoleplayer]).GetBool() && players[consoleplayer].readyweapon is 'ModRotatingWeapon')
			{
				let w = ModRotatingWeapon(players[consoleplayer].readyweapon);
				
				let fill_pct = double(w.rotSpeed) / double(w.rotSpeedMax);
				
				double px = CVar.GetCVar('cl_rpm_x', players[consoleplayer]).GetInt(); // 5 - 315
				double py = CVar.GetCVar('cl_rpm_y', players[consoleplayer]).GetInt(); // 5 - 195
				
				double fw = f.StringWidth("RPM");
				
				double tw = spacing + fw + spacing + rpm_w + spacing;
				
				double fh = f.GetHeight();
				
				double th = spacing + max(fh, rpm_h) + spacing;
				
				double offset_x = tw * ((px - 5.0)/310.0);
				double offset_y = th * ((py - 5.0) / 190.0);
				
				px = ((px / 320) * Screen.GetWidth()) - offset_x;
				py = ((py / 200) * Screen.GetHeight()) - offset_y;
				
				Screen.DrawTexture(tex2, false, px,  py, DTA_DestWidthF, tw, DTA_DestHeightF, th, DTA_FillColor, 0x0, DTA_Alpha, 0.25);
				
				Screen.DrawLine(px, py, px + tw, py, 0xFFFFFFFF);
				Screen.DrawLine(px, py, px, py + th, 0xFFFFFFFF);
				Screen.DrawLine(px, py + th, px + tw, py + th, 0xFFFFFFFF);
				Screen.DrawLine(px + tw, py, px + tw, py + th, 0xFFFFFFFF);
				
				px += spacing;
				
				Screen.DrawText(f, Font.CR_WHITE, px, py + ((th - fh) / 2), "RPM");
				
				px += fw + spacing;
				
				Screen.DrawTexture(tex, false, px,  py + ((th - rpm_h) / 2), DTA_DestWidthF, rpm_w, DTA_DestHeightF, rpm_h, DTA_FillColor, 0x0, DTA_Alpha, 0.5);
				
				Screen.SetClipRect(int(floor(px)), int(floor(py)), int(ceil(rpm_w * fill_pct)), int(ceil(th)));
				
				Screen.DrawTexture(tex, false, px,  py + ((th - rpm_h) / 2), DTA_DestWidthF, rpm_w, DTA_DestHeightF, rpm_h);
				
				Screen.ClearClipRect();
			}
		}
	}
	
	static clearscope Vector3 ItemCoord(Vector3 sourcePos, double viewAngle, double viewPitch, readonly<Inventory> item, bool top, bool left)
	{
		//doesn't take rollsprite/state animations/etc into account
		let [spawnsprite, flip, scale] = item.SpawnState.GetSpriteTexture(0);
		
		if(scale.length() > 0)
		{
			scale.x *= item.scale.x;
			scale.y *= item.scale.y;
		}
		else
		{
			scale = item.scale;
		}
		
		//TODO
		double xoff = (Screen.GetTextureLeftOffset(spawnsprite) * scale.x);
		double yoff = (Screen.GetTextureTopOffset(spawnsprite) * scale.y);
		double width = (Screen.GetTextureWidth(spawnsprite) * scale.x);
		double height = (Screen.GetTextureHeight(spawnsprite) * scale.y);
		
		Vector3 posDiff = Level.Vec3Diff(item.Pos, sourcePos);
		
		bool billboardXY = !item.bForceYBillboard && (gl_billboard_mode == 1 || item.bForceXYBillboard);
		//bool faceCamera = !item.bBilboardNoFaceCamera (gl_billboard_faces_camera || item.bBilboardFaceCamera);
		//double angle = (faceCamera ? (atan2(posDiff.Y, posDiff.X) - 90) : viewAngle);
		
		//TODO does roll matter?
		double angle = viewAngle + 90;
		double pitch = viewPitch + 90;
		
		Vector3 XYZ;
		
		if(left) width = -width;
		
		XYZ = (-xoff * cos(angle), -xoff * sin(angle), -yoff);
		
		
		/*if(billboardXY)
		{
			//TODO, currently broken
			if(top) height = -height;
			double c = cos(pitch);
			XYZ += (height * c * cos(angle), height * c * sin(angle), height * sin(pitch));
		}
		else */
		if(left)
		{
			XYZ += (-width * cos(angle), -width * sin(angle), 0);
		}
		if(!top)
		{
			XYZ += (0, 0, height);
		}
		
		return sourcePos + XYZ + posDiff;
	}
	
	
	static ui Vector2 WorldToView(TMGM_Matrix4 worldToClip, Vector3 pos)
	{
		Vector3 ndc = worldToClip.MultiplyVector3(pos);
		return TMGM_GlobalMaths.NDCToViewPort(ndc);
	}
	
	override void RenderUnderlay(RenderEvent e)
	{
		Menu m = Menu.GetCurrentMenu();
		if(!(automapactive&&viewactive) && playeringame[consoleplayer] && (!m || m.DontBlur))
		{
			TestModPlayer p = TestModPlayer(players[consoleplayer].mo);
			if(sv_use_to_pickup && e.camera == p && p.inv_lasthit)
			{
				/*
				// prevfov isn't exported 💀
				double frac = 1.0 - e.FracTic;
				double ifrac = 1.0 - e.FracTic;
				double view_fov = p.player.fov * frac + p.prevfov * ifrac;
				TMGM_Matrix4 worldToClip = TMGM_Matrix4.worldToClip(e.viewPos, e.viewAngle, e.viewPitch, e.viewRoll, view_fov);
				*/
				
				TMGM_Matrix4 worldToClip = TMGM_Matrix4.WorldToClip(e.viewPos, e.viewAngle, e.viewPitch, e.viewRoll, p.player.fov, Screen.getAspectRatio());
				
				//double width = topX - bottomX;
				//double height = topY - bottomY;
				
				int style = CVar.GetCVar('cl_item_highlight_style', p.player).GetInt();
				bool bounding = true;//CVar.GetCVar('cl_item_highlight_bouding', p.player).GetBool();
				
				let item = p.inv_lasthit;
				
				double leftX;
				double rightX;
				double topY;
				double bottomY;
					
				if(CVar.GetCVar('cl_item_highlight_bounding', p.player).GetBool())
				{
					Vector3 relPos = e.viewPos + Level.Vec3Diff(item.Pos, e.viewPos);
					Vector2 point1 = WorldToView(worldToClip, relPos + (item.Radius, item.Radius, 0));
					Vector2 point2 = WorldToView(worldToClip, relPos + (-item.Radius, item.Radius, 0));
					Vector2 point3 = WorldToView(worldToClip, relPos + (-item.Radius, -item.Radius, 0));
					Vector2 point4 = WorldToView(worldToClip, relPos + (item.Radius, -item.Radius, 0));
					Vector2 point5 = WorldToView(worldToClip, relPos + (item.Radius, item.Radius, -item.Height));
					Vector2 point6 = WorldToView(worldToClip, relPos + (-item.Radius, item.Radius, -item.Height));
					Vector2 point7 = WorldToView(worldToClip, relPos + (-item.Radius, -item.Radius, -item.Height));
					Vector2 point8 = WorldToView(worldToClip, relPos + (item.Radius, -item.Radius, -item.Height));
					
					leftX = min(point1.X, point2.X, point3.X, point4.X, point5.X, point6.X, point7.X, point8.X);
					rightX = max(point1.X, point2.X, point3.X, point4.X, point5.X, point6.X, point7.X, point8.X);
					topY = min(point1.Y, point2.Y, point3.Y, point4.Y, point5.Y, point6.Y, point7.Y, point8.Y);
					bottomY = max(point1.Y, point2.Y, point3.Y, point4.Y, point5.Y, point6.Y, point7.Y, point8.Y);
				}
				else
				{
					Vector2 point1 = WorldToView(worldToClip, ItemCoord(e.viewPos, e.viewAngle, e.viewPitch, item, false, false));
					Vector2 point2 = WorldToView(worldToClip, ItemCoord(e.viewPos, e.viewAngle, e.viewPitch, item, false, true));
					Vector2 point3 = WorldToView(worldToClip, ItemCoord(e.viewPos, e.viewAngle, e.viewPitch, item, true, true));
					Vector2 point4 = WorldToView(worldToClip, ItemCoord(e.viewPos, e.viewAngle, e.viewPitch, item, true, false));
					
					leftX = min(point1.X, point2.X, point3.X, point4.X);
					rightX = max(point1.X, point2.X, point3.X, point4.X);
					topY = min(point1.Y, point2.Y, point3.Y, point4.Y);
					bottomY = max(point1.Y, point2.Y, point3.Y, point4.Y);
				}
				
				if(style == 1)
				{
					Screen.DrawThickLine(leftX, topY, rightX, topY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(rightX, topY, rightX, bottomY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(rightX, bottomY, leftX, bottomY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(leftX, bottomY, leftX, topY, 2, 0xFFFFFFFF, 255);
				}
				else
				{
					
					Screen.DrawThickLine(leftX, topY, leftX + 10, topY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(leftX, topY, leftX, topY + 10, 2, 0xFFFFFFFF, 255);
					
					Screen.DrawThickLine(rightX, topY, rightX - 10, topY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(rightX, topY, rightX, topY + 10, 2, 0xFFFFFFFF, 255);
					
					Screen.DrawThickLine(rightX, bottomY, rightX - 10, bottomY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(rightX, bottomY, rightX, bottomY - 10, 2, 0xFFFFFFFF, 255);
					
					Screen.DrawThickLine(leftX, bottomY, leftX + 10, bottomY, 2, 0xFFFFFFFF, 255);
					Screen.DrawThickLine(leftX, bottomY, leftX, bottomY - 10, 2, 0xFFFFFFFF, 255);
					
					//Screen.DrawThickLine(rightX, topY, rightX, bottomY, 2, 0xFFFFFFFF, 255);
					//Screen.DrawThickLine(rightX, bottomY, leftX, bottomY, 2, 0xFFFFFFFF, 255);
					//Screen.DrawThickLine(leftX, bottomY, leftX, topY, 2, 0xFFFFFFFF, 255);
					
				}
			}
		}
	}
}
