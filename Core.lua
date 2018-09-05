MythicHelper = LibStub("AceAddon-3.0"):NewAddon("MythicHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {340,345,345,350,355,355,360,365,365,370,370,370,370,370,370};
MYTHIC_CHEST_TIMERS_AZERITE_ILVL = {340,340,340,355,355,355,370,370,370,385,385,385,385,385,385};
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
    self:RegisterEvent("CHALLENGE_MODE_LEADERS_UPDATE");
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
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CancelCMTimer()
    if MythicHelper.cmTimer then
        self:CancelTimer(MythicHelper.cmTimer)
        MythicHelper.cmTimer = nil
    end
end
