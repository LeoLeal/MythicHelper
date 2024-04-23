MythicHelper = LibStub("AceAddon-3.0"):NewAddon("MythicHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL   = {493,496,499,499,502,502,506,506,509,509};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {506,509,509,512,512,515,515,519,519,522};
-- |cFF50FA7B[Easy] |cFFFFB86C[Medium] |cFFFF5555[Hard]
AFFIXES_DIFICULTY = {
  '|cFFFF5555', -- 1: Overflowing
  '|cFFFFB86C', -- 2: Skittish
  '|cFF50FA7B', -- 3: Volcanic
  '|cFFFF5555', -- 4: Necrotic
  '|cFFFFB86C', -- 5: Teeming
  '|cFFFFB86C', -- 6: Raging
  '|cFFFFB86C', -- 7: Bolstering
  '|cFF50FA7B', -- 8: Sanguine
  '|cFFFF5555', -- 9: Tyrannical
  '|cFFFF5555', -- 10: Fortified
  '|cFFFFB86C', -- 11: Bursting
  '|cFFFFB86C', -- 12: Grievous
  '|cFFFFB86C', -- 13: Explosive
  '|cFF50FA7B', -- 14: Quaking
  nil,
  '|cFFFFFFFF', -- 16: Infested
  nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,nil,
  '|cFFFF5555', -- 117: Reaping
  nil,
  '|cFFFF5555', -- 119: Beguiling
  '|cFFFFFFFF', -- 120: Awakened
  '|cFFFF5555', -- 121: Prideful
  '|cFFFF5555', -- 122: Inspiring
  '|cFFFFB86C', -- 123: Spiteful
  '|cFFFFB86C', -- 124: Storming
  nil,
  nil,
  nil,
  '|cFFFFB86C', -- 128: Tormented
  '|cFF50FA7B', -- 129: Infernal
  '|cFF50FA7B', -- 130: Encrypted
  '|cFF50FA7B', -- 131: Shrouded
  '|cFF50FA7B', -- 132: Thundering
  '|cFF50FA7B', -- 133: [PH]
  '|cFF50FA7B', -- 134: Entangling
  '|cFFFFB86C', -- 135: Afflicted
  '|cFFFF5555', -- 136: Incorporeal
  '|cFF50FA7B' -- 137: Shielding
}

AFFIXES_SCHEDULE = {
	{10,136,8},
	{9,134,11},
	{10,3,123},
	{9,124,6},
	{10,134,7},
	{9,136,123},
	{10,135,6},
	{9,3,8},
	{10,124,11},
  {9,135,7}
}

-- SEASON_AFFIX = 125;

function MythicHelper:GetGearTrack(itemLevel)
  local itemTrack = MythicHelper.L["Gear_Track_Myth"]
  
  if itemLevel < 519 then
    itemTrack = MythicHelper.L["Gear_Track_Hero"]
  end
  if itemLevel < 506 then
    itemTrack = MythicHelper.L["Gear_Track_Champion"]
  end
  if itemLevel < 493 then
    itemTrack = MythicHelper.L["Gear_Track_Veteran"]
  end

  return itemTrack
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:OnInitialize()
  MythicHelper.L = LibStub("AceLocale-3.0"):GetLocale("MythicHelper")

  MythicHelperCMTimer:Init();
  MythicHelperKeystoneTooltip:Init();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:OnEnable()
  self:RegisterEvent("CHALLENGE_MODE_START");
  self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
  self:RegisterEvent("CHALLENGE_MODE_RESET");
  self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CHALLENGE_MODE_START()
  MythicHelperCMTimer:OnStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:StartCMTimer()
  MythicHelper:CancelCMTimer()
  MythicHelper.cmTimer = self:ScheduleRepeatingTimer("OnCMTimerTick", 1)
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CHALLENGE_MODE_COMPLETED()
  MythicHelperCMTimer:OnComplete();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CHALLENGE_MODE_RESET()
  MythicHelperCMTimer:OnReset();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:OnCMTimerTick()
  MythicHelperCMTimer:Draw();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:PLAYER_ENTERING_WORLD()
  MythicHelperCMTimer:ReStart();
  MythicHelperSlashCommands:Init();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CancelCMTimer()
  if MythicHelper.cmTimer then
    self:CancelTimer(MythicHelper.cmTimer)
    MythicHelper.cmTimer = nil
  end
end
