MythicHelper = LibStub("AceAddon-3.0"):NewAddon("MythicHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {184,187,190,194,194,197,200,200,200,207,207,207,207,207,210};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,200,203,207,210,210,213,216,216,220,220,223,223,226,226};

-- 1: Overflowing
-- 2: Skittish
-- 3: Volcanic
-- 4: Necrotic
-- 5: Teeming
-- 6: Raging
-- 7: Bolstering
-- 8: Sanguine
-- 9: Tyrannical
-- 10: Fortified
-- 11: Bursting
-- 12: Grievous
-- 13: Explosive
-- 14: Quaking
AFFIXES_DIFICULTY = {
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFF50FA7B',
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFF50FA7B',
  '|cFFFF5555',
  '|cFFFF5555',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFFFFB86C',
  '|cFF50FA7B'
}
-- 1: Overflowing, 2: Skittish, 3: Volcanic, 4: Necrotic, 5: Teeming, 6: Raging, 7: Bolstering, 8: Sanguine, 9: Tyrannical, 10: Fortified, 11: Bursting, 12: Grievous, 13: Explosive, 14: Quaking, 121: Prideful
AFFIXES_SCHEDULE = {
	{10,7,12},
	{9,6,13},
	{10,8,12},
	{9,5,3},
	{10,7,2},
	{9,11,4},
	{10,8,14},
	{9,7,13},
	{10,11,3},
	{9,6,4},
	{10,5,14},
	{9,11,2}
}

SEASON_AFFIX = 121;

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
