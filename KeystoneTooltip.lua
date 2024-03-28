function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end

	local modifierOffset = 4
  local _, _, mythicLevel, _, _ = ... -- "keystone" links

  if mythicLevel and mythicLevel ~= "" then
		mythicLevel = tonumber(mythicLevel)
		if mythicLevel and mythicLevel > 20 then
			mythicLevel = 20;
		end
	else
		mythicLevel = nil;
	end

  if linkType:find('item') then -- only used for ItemRefTooltip currently
		_, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, _, mythicLevel = ...
		mythicLevel = tonumber(mythicLevel)
		if ... == '180653' then -- mythic keystone
			modifierOffset = 20
		else
			return
		end
	elseif not linkType:find('keystone') then
		return
	end

	local modifiers = {}
	for i = modifierOffset, select('#', ...) do
		local num = strmatch(select(i, ...) or '', '^(%d+)')
		if num then
			local modifierID = tonumber(num)
			--if not modifierID then break end
			tinsert(modifiers, modifierID)
		end
	end

	local numModifiers = #modifiers
	if modifiers[numModifiers] and modifiers[numModifiers] < 2 then
		tremove(modifiers, numModifiers)
	end

	return modifiers, mythicLevel
end

local function DecorateTooltip(self)
	if not self['GetItem'] then return end
	local _, link, itemId = self:GetItem()
	if type(link) == 'string' and itemId == 180653 then
		local modifiers, mythicLevel = GetModifiers(strsplit(':', link))
		if modifiers then
			for _, modifierID in ipairs(modifiers) do
				local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(modifierID)
				if modifierName and modifierDescription then
					self:AddLine(format('\n|cff00ff00%s: |cffffffff%s|r', modifierName, modifierDescription), 0, 1, 0, true)
				end
			end
			if type(mythicLevel) == "number" and mythicLevel > 0 then
        self:AddLine(format('\n|cffffcc00%s|r', format(MythicHelper.L["BaseLootLevel"], MYTHIC_CHEST_TIMERS_LOOT_ILVL[mythicLevel])), 0, 1, 0, true)
			end
			self:Show()
		end
	end
end

MythicHelperKeystoneTooltip = {}
function MythicHelperKeystoneTooltip:Init()
	TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, DecorateTooltip)
end

