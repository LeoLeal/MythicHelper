local function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local modifierOffset = 4
	local instanceID, mythicLevel, notDepleted, _ = ... -- "keystone" links
	if linkType:find('item') then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel = ...
		if ... == '138019' then -- mythic keystone
			modifierOffset = 16
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local modifierID = tonumber((select(i, ...)))
		--if not modifierID then break end
		tinsert(modifiers, modifierID)
	end
	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem()
	if type(link) == 'string' then
		local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			mythicLevel = tonumber(mythicLevel);

			if mythicLevel and mythicLevel > 15 then
				mythicLevel = 15;
			end
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('\n|cff00ff00%s: |cffffffff%s|r', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			if mythicLevel and mythicLevel > 0 then
				self:AddLine(format('\n|cffffcc00%s|r', format(MythicHelper.L["BaseLootLevel"], MYTHIC_CHEST_TIMERS_LOOT_ILVL[mythicLevel])), 0, 1, 0, true)
			end
			self:Show()
		end
	end
end

MythicHelperKeystoneTooltip = {}
function MythicHelperKeystoneTooltip:Init()
	ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
	GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
end