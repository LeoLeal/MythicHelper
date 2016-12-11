MythicChestTimersCMTimer = {}

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:Init()

    TimersPosition = {};
    TimersPosition.left = 29;
    TimersPosition.top = -59;
    TimersPosition.relativePoint = "TOPLEFT";

    MythicChestTimersCMTimer.isCompleted = false;
    MythicChestTimersCMTimer.started = false;
    MythicChestTimersCMTimer.reset = false;
    MythicChestTimersCMTimer.frames = {};
    MythicChestTimersCMTimer.timerStarted = false;

    
    MythicChestTimersCMTimer.frame = CreateFrame("Frame", "CmTimer", ScenarioChallengeModeBlock);
    MythicChestTimersCMTimer.frame:SetPoint(TimersPosition.relativePoint,TimersPosition.left,TimersPosition.top);
    MythicChestTimersCMTimer.frame:EnableMouse(false);
    MythicChestTimersCMTimer.frame:SetWidth(200);
    MythicChestTimersCMTimer.frame:SetHeight(20);


    MythicChestTimersCMTimer.eventFrame = CreateFrame("Frame")
    MythicChestTimersCMTimer.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:OnComplete()
    MythicChestTimersCMTimer.isCompleted = true;
    MythicChestTimersCMTimer.frame:Hide();

    MythicChestTimersDB.currentRun = {}
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:OnStart()
    MythicChestTimersDB.currentRun = {}
    
    MythicChestTimersCMTimer.isCompleted = false;
    MythicChestTimersCMTimer.started = true;
    MythicChestTimersCMTimer.reset = false;
    
    MythicChestTimers:StartCMTimer()
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:OnReset()
    MythicChestTimersCMTimer.frame:Hide();
    MythicChestTimersCMTimer.isCompleted = false;
    MythicChestTimersCMTimer.started = false;
    MythicChestTimersCMTimer.reset = true;

    MythicChestTimersDB.currentRun = {}
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:ReStart()
    local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
    local _, timeCM = GetWorldElapsedTime(1);
    
    if difficulty == 8 and timeCM > 0 then
        MythicChestTimersCMTimer.started = true;
        MythicChestTimers:StartCMTimer()
        return
    end

    MythicChestTimersCMTimer.frame:Hide();
    MythicChestTimersCMTimer.reset = false
    MythicChestTimersCMTimer.timerStarted = false
    MythicChestTimersCMTimer.started = false
    MythicChestTimersCMTimer.isCompleted = false
    MythicChestTimersDB.currentRun = {}
    return
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:Draw()
    local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
    if difficulty ~= 8 then
        MythicChestTimersCMTimer.frame:Hide();
        return
    end

    if not MythicChestTimersCMTimer.started and not MythicChestTimersCMTimer.reset and MythicChestTimersCMTimer.timerStarted then
        MythicChestTimers:CancelCMTimer()
        MythicChestTimersCMTimer.timerStarted = false
        MythicChestTimersCMTimer.frame:Hide();
        return
    end

    if MythicChestTimersCMTimer.reset or MythicChestTimersCMTimer.isCompleted then
        MythicChestTimersCMTimer.reset = false
        MythicChestTimersCMTimer.timerStarted = false
        MythicChestTimersCMTimer.started = false
        MythicChestTimers:CancelCMTimer()
        MythicChestTimersCMTimer.frame:Hide();
        return
    end

    
    MythicChestTimersCMTimer.timerStarted = true
    local _, timeCM = GetWorldElapsedTime(1)
    if not timeCM or timeCM <= 0 then
        return
    end

    if not MythicChestTimersCMTimer.isCompleted then
        MythicChestTimersCMTimer.frame:Show();
    end

    if not MythicChestTimersDB.currentRun.times  then
        MythicChestTimersDB.currentRun.times = {}
    end
    
    local cmLevel, affixes, empowered = C_ChallengeMode.GetActiveKeystoneInfo();
    local zoneName, _, maxTime = C_ChallengeMode.GetMapInfo(currentZoneID);
    local bonus = C_ChallengeMode.GetPowerLevelDamageHealthMod(cmLevel);
    
    -- Chest Timer
    local threeChestTime = maxTime * 0.6;
    local twoChestTime = maxTime * 0.8;

    local timeLeft3 = threeChestTime - timeCM;
    if timeLeft3 < 0 then
        timeLeft3 = 0;
    end

    local timeLeft2 = twoChestTime - timeCM;
    if timeLeft2 < 0 then
        timeLeft2 = 0;
    end
    
    if not MythicChestTimersCMTimer.frames.chesttimer then
        local label = CreateFrame("Frame", nil, MythicChestTimersCMTimer.frame)
        label:SetAllPoints()
        label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        label.text:SetPoint("TOPLEFT", 0,0);
        MythicChestTimersCMTimer.frames.chesttimer = {
            labelFrame = label
        }
    end

    -- -- Chest Timers
    if timeLeft3 > 0 then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText("3 "..MythicChestTimers.L["Chests"]..": "..MythicChestTimersCMTimer:FormatSeconds(timeLeft3));
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
    elseif timeLeft2 > 0 then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText("2 "..MythicChestTimers.L["Chests"]..": "..MythicChestTimersCMTimer:FormatSeconds(timeLeft2));
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
    else
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicChestTimers.L["NoChests"]);
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontDisable");
    end
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:ResolveTime(seconds)
    local min = math.floor(seconds/60);
    local sec = seconds - (min * 60);
    return min, sec;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:FormatSeconds(seconds)
    local min, sec = MythicChestTimersCMTimer:ResolveTime(seconds)
    if min < 10 then
        min = "0" .. min
    end
    
    if sec < 10 then
        sec = "0" .. sec
    end
    
    return min .. ":" .. sec
end

