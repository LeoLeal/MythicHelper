MythicChestTimersCMTimer = {}
LOOT_HEIGHT = 20;
LOOT_ILVL = { 840,845,845,850,850,855,855,860,860,865,870,870,870,870,870,870 };
-- ---------------------------------------------------------------------------------------------------------------------
function MythicChestTimersCMTimer:Init()

    TimersPosition = {};
    TimersPosition.left = 29;
    TimersPosition.top = -59;
    TimersPosition.relativePoint = "TOPLEFT";

    LootPosition = {};
    LootPosition.left = 10;
    LootPosition.bottom = (LOOT_HEIGHT-25);
    LootPosition.relativePoint = "BOTTOMLEFT";

    MythicChestTimersCMTimer.isCompleted = false;
    MythicChestTimersCMTimer.started = false;
    MythicChestTimersCMTimer.reset = false;
    MythicChestTimersCMTimer.frames = {};
    MythicChestTimersCMTimer.timerStarted = false;

    
    MythicChestTimersCMTimer.frame = CreateFrame("Frame", "CmTimer", ScenarioChallengeModeBlock);
    MythicChestTimersCMTimer.frame:SetPoint(TimersPosition.relativePoint,TimersPosition.left,TimersPosition.top);
    MythicChestTimersCMTimer.frame:EnableMouse(false);
    MythicChestTimersCMTimer.frame:SetWidth(190);
    MythicChestTimersCMTimer.frame:SetHeight(18);

    --LOOT FRAME AINDA DESENVOLVENDO
    MythicChestTimersCMTimer.lootFrame = CreateFrame("Frame", "LootTimer", ScenarioBlocksFrame);
    MythicChestTimersCMTimer.lootFrame:Hide();
    MythicChestTimersCMTimer.lootFrame:EnableMouse(false);
    MythicChestTimersCMTimer.lootFrame:SetWidth(200);
    MythicChestTimersCMTimer.lootFrame:SetHeight(LOOT_HEIGHT);

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
    local oneChestTime = maxTime;

    local timeLeft3 = threeChestTime - timeCM;
    if timeLeft3 < 0 then
        timeLeft3 = 0;
    end

    local timeLeft2 = twoChestTime - timeCM;
    if timeLeft2 < 0 then
        timeLeft2 = 0;
    end

    local timeLeft1 = oneChestTime - timeCM;
    if timeLeft1 < 0 then
        timeLeft1 = 0;
    end

    if not MythicChestTimersCMTimer.frames.chestloot then
        local label = CreateFrame("Frame", nil, MythicChestTimersCMTimer.lootFrame);
        label:SetAllPoints()
        label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        label.text:SetPoint("TOPLEFT", 0,0);
        label.text:SetFontObject("GameFontHighlight");

        MythicChestTimersCMTimer.frames.chestloot = {
            labelFrame = label
        }
        
        if not ScenarioChallengeModeBlock.StartedDepleted then
            MythicChestTimersCMTimer.lootFrame:Show();
            ScenarioBlocksFrame:SetHeight(ScenarioBlocksFrame:GetHeight()+20);
            MythicChestTimersCMTimer.lootFrame:SetPoint(LootPosition.relativePoint,LootPosition.left,LootPosition.bottom);
        end
    end

    -- -- Chest Timers
    dungeonLevel = ScenarioChallengeModeBlock.Level:GetText();
    dungeonLevel = dungeonLevel:gsub("Level ", "");
    dungeonLevel = tonumber(dungeonLevel);

    if not MythicChestTimersCMTimer.frames.chesttimer then
        local label = CreateFrame("Frame", nil, MythicChestTimersCMTimer.frame)
        label:SetAllPoints()
        label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        label.text:SetPoint("TOPLEFT", 0,0);
        MythicChestTimersCMTimer.frames.chesttimer = {
            labelFrame = label
        }
    end

    if ScenarioChallengeModeBlock.StartedDepleted then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicChestTimers.L["No_Loot"]);
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontDisable");
        MythicChestTimersCMTimer.frames.chestloot.labelFrame:Hide();
    elseif timeLeft3 > 0 then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText("3 "..MythicChestTimers.L["Chests"]..": "..MythicChestTimersCMTimer:FormatSeconds(timeLeft3));
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicChestTimersCMTimer.frames.chestloot.labelFrame:Show();
        if (LOOT_ILVL[dungeonLevel+2] == LOOT_ILVL[dungeonLevel] and LOOT_ILVL[dungeonLevel+1] == LOOT_ILVL[dungeonLevel]) or (not LOOT_ILVL[dungeonLevel+2] and not LOOT_ILVL[dungeonLevel+1]) then
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA6x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
        elseif LOOT_ILVL[dungeonLevel+2] == LOOT_ILVL[dungeonLevel+1] or not LOOT_ILVL[dungeonLevel+2] then
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA4x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+1] .. "+|cFFAAAAAA, 2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
        elseif LOOT_ILVL[dungeonLevel+1] == LOOT_ILVL[dungeonLevel] or not LOOT_ILVL[dungeonLevel+1] then
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+2] .. "+|cFFAAAAAA, 4x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+1] .. "+");
        else
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+2] .. "+|cFFAAAAAA, 2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+1] .. "+|cFFAAAAAA, 2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
        end
    elseif timeLeft2 > 0 then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText("2 "..MythicChestTimers.L["Chests"]..": "..MythicChestTimersCMTimer:FormatSeconds(timeLeft2));
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicChestTimersCMTimer.frames.chestloot.labelFrame:Show();
        if LOOT_ILVL[dungeonLevel+1] == LOOT_ILVL[dungeonLevel] or not LOOT_ILVL[dungeonLevel+1] then
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA4x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+1] .. "+");
        else
            MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel+1] .. "+|cFFAAAAAA, 2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
        end
    elseif timeLeft1 > 0 then
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicChestTimers.L["NoChests"]);
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicChestTimersCMTimer.frames.chestloot.labelFrame:Show();
        MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
    else
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicChestTimers.L["NoChests_KeyDepleted"]);
        MythicChestTimersCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontDisable");
        MythicChestTimersCMTimer.frames.chestloot.labelFrame:Show();
        MythicChestTimersCMTimer.frames.chestloot.labelFrame.text:SetText(MythicChestTimers.L["Rewards"] .. ": |cFFAAAAAA2x|cFF00FF00" .. LOOT_ILVL[dungeonLevel] .. "+");
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

