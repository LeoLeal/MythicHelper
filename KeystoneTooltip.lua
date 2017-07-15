local function GetModifiers(linkType, ...)
	if type(linkType) ~= 'string' then return end
	local instanceID, mythicLevel, affix1, affix2, affix3
	if linkType:find('keystone') then
	  instanceID, mythicLevel, affix1, affix2, affix3 = ... -- "keystone" links
	elseif linkType:find('item') then
		_, _, _, _, _, _, _, _, _, _, _, _, _, instanceID, mythicLevel, affix1, affix2, affix3 = ...
  else
		return
	end

	if mythicLevel and mythicLevel ~= "" then
		mythicLevel = tonumber(mythicLevel);
		if mythicLevel and mythicLevel > 15 then
			mythicLevel = 15;
		end
	else
		mythicLevel = nil;
	end

	local modifiers = {}
  if affix1 then
		tinsert(modifiers, tonumber(affix1))
	  if affix2 then
			tinsert(modifiers, tonumber(affix2))
			if affix3 then
				tinsert(modifiers, tonumber(affix3))
			end
		end
	end
	return modifiers, instanceID, mythicLevel
end

local function DecorateTooltip(self)
	local _, link = self:GetItem();
	if type(link) == 'string' and (link:find("keystone") or link:find("item:138019")) then
		if link:find("keystone") then
			link = string.match(link, "(keystone:.-)|h")
		end
    local modifiers, instanceID, mythicLevel = GetModifiers(strsplit(':', link))
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
	ItemRefTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
	GameTooltip:HookScript('OnTooltipSetItem', DecorateTooltip)
end
