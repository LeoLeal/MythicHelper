--TODO: TESTAR SE CHAVE TÄ ESGOTADA PRA ESCONDER ILEVEL.

local function GetModifiers(_, itemID, _, _, _, _, _, _, _, _, _, upgradeID, _, _, instanceID, mythicLevel, ...)
	local modifiers
	if itemID == '138019' then -- mythic keystone
		modifiers = {}
		for i = 1, select('#', ...) do
			local modifierID = tonumber((select(i, ...)))
			--if not modifierID then break end
			tinsert(modifiers, modifierID)
		end
		local numModifiers = #modifiers
		if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
			tremove(modifiers, numModifiers)
		end
	end
	return modifiers, upgradeID, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem()
	if type(link) == 'string' then
		local modifiers, upgradeID, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			mythicLevel = tonumber(mythicLevel);
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('\n|cff888888%s: %s|r', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			if mythicLevel and mythicLevel > 0 then
				-- print(link);
				self:AddLine(format('\n|cffffcc00%s|r', format(MythicChestTimers.L["BaseLootLevel"], MYTHIC_CHEST_TIMERS_LOOT_ILVL[mythicLevel])), 0, 1, 0, true)
			end
			self:Show()
		end
	end
end

ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)