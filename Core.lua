MythicHelper = LibStub("AceAddon-3.0"):NewAddon("MythicHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {865,870,870,875,875,880,880,885,885,890,890,895,900,905,910};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,875,880,885,890,890,895,895,900,905,910,915,920,925,930};
-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:OnInitialize()
    MythicHelper.L = LibStub("AceLocale-3.0"):GetLocale("MythicHelper")

    MythicHelperCMTimer:Init();
    MythicHelperKeystoneTooltip:Init();
    MythicHelperWeeklyBest:Init();
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
function MythicHelper:CHALLENGE_MODE_LEADERS_UPDATE()
    MythicHelperWeeklyBest:Init();
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
