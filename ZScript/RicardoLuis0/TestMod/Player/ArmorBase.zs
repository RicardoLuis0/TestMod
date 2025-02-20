class ArmorBase : BasicArmor
{
	override void AbsorbDamage (int damage, Name damageType, out int newdamage, Actor inflictor, Actor source, int flags)
	{
		int saved;
		int armorDamage;

		if (!DamageTypeDefinition.IgnoreArmor(damageType))
		{
			bool isHell = (G_SkillPropertyInt(SKILLP_ACSReturn) == 5);
			
			/*
			//armor is 25% more effective in the hidden difficulty, and lasts longer
			armorDamage = int(damage * (isHell ? SavePercent * 0.75 : SavePercent));
			*/
			
			//armor is 25% more effective in the hidden difficulty
			armorDamage = int(damage * SavePercent);
			saved = int(damage * (isHell ? SavePercent + 0.25 : SavePercent));
			
			if (Amount < armorDamage)
			{ // armor fully protects the last attack before it breaks
				armorDamage = Amount;
			}
			
			newdamage -= saved;
			Amount -= armorDamage;
			AbsorbCount += saved;
			if (Amount == 0)
			{
				// The armor has become useless
				SavePercent = 0;
				ArmorType = 'None'; // Not NAME_BasicArmor.
				// Now see if the player has some more armor in their inventory
				// and use it if so. As in Strife, the best armor is used up first.
				BasicArmorPickup best = null;
				Inventory probe = Owner.Inv;
				while (probe != null)
				{
					let inInv = BasicArmorPickup(probe);
					if (inInv != null)
					{
						if (best == null || best.SavePercent < inInv.SavePercent)
						{
							best = inInv;
						}
					}
					probe = probe.Inv;
				}
				if (best != null)
				{
					Owner.UseInventory (best);
				}
			}
			damage = newdamage;
		}

		// Once the armor has absorbed its part of the damage, then apply its damage factor, if any, to the player
		if ((damage > 0) && (ArmorType != 'None')) // BasicArmor is not going to have any damage factor, so skip it.
		{
			newdamage = ApplyDamageFactors(ArmorType, damageType, damage, damage);
		}
	}
}