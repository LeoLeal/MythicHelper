MythicPlusHelperCMTimer = {}
MYTHIC_CHEST_TIMERS_LOOT_HEIGHT = 18;
-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:Init()

    TimersPosition = {};
    TimersPosition.left = 29;
    TimersPosition.top = -59;
    TimersPosition.relativePoint = "TOPLEFT";

    LootPosition = {};
    LootPosition.right = -29;
    LootPosition.top = -59;
    LootPosition.relativePoint = "TOPRIGHT";

    MythicPlusHelperCMTimer.isCompleted = false;
    MythicPlusHelperCMTimer.started = false;
    MythicPlusHelperCMTimer.reset = false;
    MythicPlusHelperCMTimer.frames = {};
    MythicPlusHelperCMTimer.timerStarted = false;

    MythicPlusHelperCMTimer.frame = CreateFrame("Frame", "CmTimer", ScenarioChallengeModeBlock);
    MythicPlusHelperCMTimer.frame:SetPoint(TimersPosition.relativePoint,TimersPosition.left,TimersPosition.top);
    MythicPlusHelperCMTimer.frame:EnableMouse(false);
    MythicPlusHelperCMTimer.frame:SetWidth(190);
    MythicPlusHelperCMTimer.frame:SetHeight(18);

    MythicPlusHelperCMTimer.lootFrame = CreateFrame("Frame", "LootTimer", ScenarioChallengeModeBlock);
    MythicPlusHelperCMTimer.lootFrame:SetPoint(LootPosition.relativePoint,LootPosition.right,LootPosition.top);
    MythicPlusHelperCMTimer.lootFrame:EnableMouse(false);
    MythicPlusHelperCMTimer.lootFrame:SetWidth(200);
    MythicPlusHelperCMTimer.lootFrame:SetHeight(MYTHIC_CHEST_TIMERS_LOOT_HEIGHT);

    MythicPlusHelperCMTimer.eventFrame = CreateFrame("Frame")
    MythicPlusHelperCMTimer.eventFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:OnComplete()
    MythicPlusHelperCMTimer.isCompleted = true;
    MythicPlusHelperCMTimer.frame:Hide();
    MythicPlusHelperCMTimer.lootFrame:Hide();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:OnStart()
    MythicPlusHelperCMTimer.isCompleted = false;
    MythicPlusHelperCMTimer.started = true;
    MythicPlusHelperCMTimer.reset = false;
    
    MythicPlusHelper:StartCMTimer()
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:OnReset()
    MythicPlusHelperCMTimer.frame:Hide();
    MythicPlusHelperCMTimer.lootFrame:Hide();
    MythicPlusHelperCMTimer.isCompleted = false;
    MythicPlusHelperCMTimer.started = false;
    MythicPlusHelperCMTimer.reset = true;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:ReStart()
    local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
    local _, timeCM = GetWorldElapsedTime(1);
    
    if difficulty == 8 and timeCM > 0 then
        MythicPlusHelperCMTimer.started = true;
        MythicPlusHelper:StartCMTimer()
        return
    end

    MythicPlusHelperCMTimer.frame:Hide();
    MythicPlusHelperCMTimer.lootFrame:Hide();
    MythicPlusHelperCMTimer.reset = false
    MythicPlusHelperCMTimer.timerStarted = false
    MythicPlusHelperCMTimer.started = false
    MythicPlusHelperCMTimer.isCompleted = false
    return
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:Draw()
    local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
    if difficulty ~= 8 then
        MythicPlusHelperCMTimer.frame:Hide();
        MythicPlusHelperCMTimer.lootFrame:Hide();
        return
    end

    if not MythicPlusHelperCMTimer.started and not MythicPlusHelperCMTimer.reset and MythicPlusHelperCMTimer.timerStarted then
        MythicPlusHelper:CancelCMTimer()
        MythicPlusHelperCMTimer.timerStarted = false
        MythicPlusHelperCMTimer.frame:Hide();
        MythicPlusHelperCMTimer.lootFrame:Hide();
        return
    end

    if MythicPlusHelperCMTimer.reset or MythicPlusHelperCMTimer.isCompleted then
        MythicPlusHelperCMTimer.reset = false
        MythicPlusHelperCMTimer.timerStarted = false
        MythicPlusHelperCMTimer.started = false
        MythicPlusHelper:CancelCMTimer();
        MythicPlusHelperCMTimer.frame:Hide();
        MythicPlusHelperCMTimer.lootFrame:Hide();
        return
    end

    
    MythicPlusHelperCMTimer.timerStarted = true
    local _, timeCM = GetWorldElapsedTime(1)
    if not timeCM or timeCM <= 0 then
        return
    end

    if not MythicPlusHelperCMTimer.isCompleted then
        MythicPlusHelperCMTimer.frame:Show();
        MythicPlusHelperCMTimer.lootFrame:Show();
    end
    
    local cmLevel, _, _ = C_ChallengeMode.GetActiveKeystoneInfo();
    local _, _, maxTime = C_ChallengeMode.GetMapInfo(currentZoneID);
    
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

    -- loot frame
    if not MythicPlusHelperCMTimer.frames.chestloot then
        local label = CreateFrame("Frame", nil, MythicPlusHelperCMTimer.lootFrame);
        label:SetAllPoints()
        label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        label.text:SetPoint("TOPRIGHT", 0,0);
        label.text:SetJustifyH("RIGHT");
        label.text:SetFontObject("GameFontHighlight");

        MythicPlusHelperCMTimer.frames.chestloot = {
            labelFrame = label
        }
    end

    -- -- Chest Timers
    if not MythicPlusHelperCMTimer.frames.chesttimer then
        local label = CreateFrame("Frame", nil, MythicPlusHelperCMTimer.frame)
        label:SetAllPoints()
        label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
        label.text:SetPoint("TOPLEFT", 0,0);
        MythicPlusHelperCMTimer.frames.chesttimer = {
            labelFrame = label
        }
    end

    local lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel];
    if ScenarioChallengeModeBlock.wasDepleted then
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicPlusHelper.L["No_Loot"]);
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontDisable");
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame:Hide();
    elseif timeLeft3 > 0 then
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetText("3 "..MythicPlusHelper.L["Chests"]..": "..MythicPlusHelperCMTimer:FormatSeconds(timeLeft3));
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame:Show();
        if MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+2] then
            lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+2]
        elseif MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+1] then
            lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+1]
        else
            lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel]
        end
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame.text:SetText("|cFFFFFFFF"..MythicPlusHelper.L["Loot"].." |cFF00FF00" .. lootLevel .. "+");
    elseif timeLeft2 > 0 then
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetText("2 "..MythicPlusHelper.L["Chests"]..": "..MythicPlusHelperCMTimer:FormatSeconds(timeLeft2));
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame:Show();
        if MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+1] then
            lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel+1]
        else
            lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel]
        end
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame.text:SetText("|cFFFFFFFF"..MythicPlusHelper.L["Loot"].." |cFF00FF00" .. lootLevel .. "+");
    elseif timeLeft1 > 0 then
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicPlusHelper.L["NoChests"]);
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame:Show();
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame.text:SetText("|cFFFFFFFF"..MythicPlusHelper.L["Loot"].." |cFF00FF00" .. lootLevel .. "+");
    else
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(MythicPlusHelper.L["NoChests_KeyDepleted"]);
        MythicPlusHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame:Show();
        MythicPlusHelperCMTimer.frames.chestloot.labelFrame.text:SetText("|cFFAAAAAA"..MythicPlusHelper.L["Loot"].." |cFF00FF00" .. lootLevel .. "+");
    end
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:ResolveTime(seconds)
    local min = math.floor(seconds/60);
    local sec = seconds - (min * 60);
    return min, sec;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicPlusHelperCMTimer:FormatSeconds(seconds)
    local min, sec = MythicPlusHelperCMTimer:ResolveTime(seconds)
    if min < 10 then
        min = "0" .. min
    end
    
    if sec < 10 then
        sec = "0" .. sec
    end
    
    return min .. ":" .. sec
end

