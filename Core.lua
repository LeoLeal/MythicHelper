MythicPlusHelper = LibStub("AceAddon-3.0"):NewAddon("MythicPlusHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {840,845,845,850,850,855,855,860,860,865,870,870,875,880,885};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,850,855,860,865,865,870,870,875,880,880,885,890,895,900};
-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:OnInitialize()
    MythicPlusHelper.L = LibStub("AceLocale-3.0"):GetLocale("MythicPlusHelper")
    
    MythicPlusHelperCMTimer:Init();
    MythicPlusHelperKeystoneTooltip:Init();
    MythicPlusHelperWeeklyBest:Init();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:OnEnable()
    self:RegisterEvent("CHALLENGE_MODE_START");
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    self:RegisterEvent("CHALLENGE_MODE_RESET");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:CHALLENGE_MODE_START()
    MythicPlusHelperCMTimer:OnStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:StartCMTimer()
    MythicPlusHelper:CancelCMTimer()
    MythicPlusHelper.cmTimer = self:ScheduleRepeatingTimer("OnCMTimerTick", 1)
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:CHALLENGE_MODE_COMPLETED()
    MythicPlusHelperCMTimer:OnComplete();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:CHALLENGE_MODE_RESET()
    MythicPlusHelperCMTimer:OnReset();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:OnCMTimerTick()
    MythicPlusHelperCMTimer:Draw();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:PLAYER_ENTERING_WORLD()
    MythicPlusHelperCMTimer:ReStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelper:CancelCMTimer()
    if MythicPlusHelper.cmTimer then
        self:CancelTimer(MythicPlusHelper.cmTimer)
        MythicPlusHelper.cmTimer = nil
    end
end
