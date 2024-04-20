class CustomHUDDrawer : StaticEventHandler
{
	TextureID tex;
	TextureID tex2;
	Font f;
	
	override void OnRegister()
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
		if(playeringame[consoleplayer] && CVar.GetCVar('cl_showrpm', players[consoleplayer]).GetBool() && players[consoleplayer].readyweapon is 'ModRotatingWeapon')
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
			
			Screen.SetClipRect(px, py, rpm_w * fill_pct, th);
			
			Screen.DrawTexture(tex, false, px,  py + ((th - rpm_h) / 2), DTA_DestWidthF, rpm_w, DTA_DestHeightF, rpm_h);
			
			Screen.ClearClipRect();
			
		}
	}
}