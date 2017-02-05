MythicChestTimers = LibStub("AceAddon-3.0"):NewAddon("MythicChestTimers", "AceEvent-3.0", "AceTimer-3.0");

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:OnInitialize()
    if MythicChestTimersDB == nil then
        MythicChestTimersDB = {}
    end
    
    if not MythicChestTimersDB.currentRun then
        MythicChestTimersDB.currentRun = {} 
    end

    MythicChestTimers.L = LibStub("AceLocale-3.0"):GetLocale("MythicChestTimers")

    local options = {
        name = "MythicChestTimers",
        handler = MythicChestTimersDB,
        type = "group",
        args = {},
    }
    
    MythicChestTimersCMTimer:Init();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:OnEnable()
    self:RegisterEvent("CHALLENGE_MODE_START");
    self:RegisterEvent("CHALLENGE_MODE_COMPLETED");
    self:RegisterEvent("CHALLENGE_MODE_RESET");
    self:RegisterEvent("PLAYER_ENTERING_WORLD");
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:CHALLENGE_MODE_START()
    MythicChestTimersCMTimer:OnStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:StartCMTimer()
    MythicChestTimers:CancelCMTimer()
    MythicChestTimers.cmTimer = self:ScheduleRepeatingTimer("OnCMTimerTick", 1)
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:CHALLENGE_MODE_COMPLETED()
    MythicChestTimersCMTimer:OnComplete();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:CHALLENGE_MODE_RESET()
    MythicChestTimersCMTimer:OnReset();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:OnCMTimerTick()
    MythicChestTimersCMTimer:Draw();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:PLAYER_ENTERING_WORLD()
    MythicChestTimersCMTimer:ReStart();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimers:CancelCMTimer()
    if MythicChestTimers.cmTimer then
        self:CancelTimer(MythicChestTimers.cmTimer)
        MythicChestTimers.cmTimer = nil
    end
end
