extend class TestModHandler
{
	Array<int> invuse_buttons;
	ui int invuse_key_count;

	private void UpdateBindings()
	{
		Bindings.GetAllKeysForCommand(invuse_buttons,"invuse");
	}

	void OnRegisterKeyHandler()
	{
		UpdateBindings();
	}

	override void WorldTick()
	{
		if(gameTic % 35)
		{
			UpdateBindings();
		}
	}

	override bool InputProcess(InputEvent e)
	{
		if(e.type == InputEvent.Type_KeyDown
		 ||e.type == InputEvent.Type_KeyUp)
		{
			bool wasDown = (invuse_key_count > 0);
			if(invuse_buttons.Find(e.keyScan) != invuse_buttons.Size())
			{
				if(e.type == InputEvent.Type_KeyDown)
				{
					invuse_key_count++;
				}
				else
				{
					invuse_key_count--;
				}
			}
			bool isDown = (invuse_key_count > 0);
			if(isDown != wasDown)
			{
				if(isDown)
				{
					EventHandler.SendNetworkEvent("invuse_key_down");
				}
				else
				{
					EventHandler.SendNetworkEvent("invuse_key_up");
				}
			}
		}
		return false;
	}
	
	void ProcessKeyNetEvent(ConsoleEvent e)
	{
		if(e.name == "grenade_key_pressed")
		{
			TestModPlayer(players[e.player].mo).grenade_key_pressed = true;
		}
		else if(e.name == "melee_key_pressed")
		{
			TestModPlayer(players[e.player].mo).melee_key_pressed = true;
		}
		else if(e.name == "unload_key_pressed")
		{
			TestModPlayer(players[e.player].mo).unload_key_pressed = true;
		}
		else if(e.name == "invuse_key_down")
		{
			TestModPlayer(players[e.player].mo).invuse_key_down = true;
		}
		else if(e.name == "invuse_key_up")
		{
			TestModPlayer(players[e.player].mo).invuse_key_down = false;
		}
	}
}