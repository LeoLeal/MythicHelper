MythicHelperCMTimer = {}
MYTHIC_CHEST_TIMERS_LOOT_HEIGHT = 18;
-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:Init()

  TimersPosition = {};
  TimersPosition.left = 29;
  TimersPosition.top = 10;
  TimersPosition.relativePoint = "BOTTOMLEFT";

  LootPosition = {};
  LootPosition.right = -34;
  LootPosition.top = 14;
  LootPosition.relativePoint = "BOTTOMRIGHT";

  MythicHelperCMTimer.isCompleted = false;
  MythicHelperCMTimer.started = false;
  MythicHelperCMTimer.reset = false;
  MythicHelperCMTimer.frames = {};
  MythicHelperCMTimer.timerStarted = false;

  MythicHelperCMTimer.frame = CreateFrame("Frame", "CmTimer", ScenarioChallengeModeBlock);
  MythicHelperCMTimer.frame:SetPoint(TimersPosition.relativePoint,TimersPosition.left,TimersPosition.top);
  MythicHelperCMTimer.frame:EnableMouse(false);
  MythicHelperCMTimer.frame:SetWidth(190);
  MythicHelperCMTimer.frame:SetHeight(MYTHIC_CHEST_TIMERS_LOOT_HEIGHT);
  MythicHelperCMTimer.frame:SetScale(0.9);

  MythicHelperCMTimer.lootFrame = CreateFrame("Frame", "LootTimer", ScenarioChallengeModeBlock);
  MythicHelperCMTimer.lootFrame:SetPoint(LootPosition.relativePoint,LootPosition.right,LootPosition.top);
  MythicHelperCMTimer.lootFrame:EnableMouse(false);
  MythicHelperCMTimer.lootFrame:SetWidth(200);
  MythicHelperCMTimer.lootFrame:SetHeight(MYTHIC_CHEST_TIMERS_LOOT_HEIGHT);
  MythicHelperCMTimer.lootFrame:SetScale(0.8);

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:OnComplete()
  MythicHelperCMTimer.isCompleted = true;
  MythicHelperCMTimer.frame:Hide();
  MythicHelperCMTimer.lootFrame:Hide();
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:OnStart()
  MythicHelperCMTimer.isCompleted = false;
  MythicHelperCMTimer.started = true;
  MythicHelperCMTimer.reset = false;

  MythicHelper:StartCMTimer()
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:OnReset()
  MythicHelperCMTimer.frame:Hide();
  MythicHelperCMTimer.lootFrame:Hide();
  MythicHelperCMTimer.isCompleted = false;
  MythicHelperCMTimer.started = false;
  MythicHelperCMTimer.reset = true;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:ReStart()
  local _, _, difficulty, _, _, _, _, _ = GetInstanceInfo();
  local _, timeCM = GetWorldElapsedTime(1);
  if difficulty == 8 and timeCM > 0 then
    MythicHelperCMTimer.started = true;
    MythicHelper:StartCMTimer()
    return
  end

  MythicHelperCMTimer.frame:Hide();
  MythicHelperCMTimer.lootFrame:Hide();
  MythicHelperCMTimer.reset = false
  MythicHelperCMTimer.timerStarted = false
  MythicHelperCMTimer.started = false
  MythicHelperCMTimer.isCompleted = false
  return
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:Draw()
  local _, _, difficulty, _, _, _, _, currentZoneID = GetInstanceInfo();
  if difficulty ~= 8 then
    MythicHelperCMTimer.frame:Hide();
    MythicHelperCMTimer.lootFrame:Hide();
    return
  end

  if not MythicHelperCMTimer.started and not MythicHelperCMTimer.reset and MythicHelperCMTimer.timerStarted then
    MythicHelper:CancelCMTimer()
    MythicHelperCMTimer.timerStarted = false
    MythicHelperCMTimer.frame:Hide();
    MythicHelperCMTimer.lootFrame:Hide();
    return
  end

  if MythicHelperCMTimer.reset or MythicHelperCMTimer.isCompleted then
    MythicHelperCMTimer.reset = false
    MythicHelperCMTimer.timerStarted = false
    MythicHelperCMTimer.started = false
    MythicHelper:CancelCMTimer();
    MythicHelperCMTimer.frame:Hide();
    MythicHelperCMTimer.lootFrame:Hide();
    return
  end


  MythicHelperCMTimer.timerStarted = true
  local _, timeCM = GetWorldElapsedTime(1)
  if not timeCM or timeCM <= 0 then
    return
  end

  if not MythicHelperCMTimer.isCompleted then
    MythicHelperCMTimer.frame:Show();
    MythicHelperCMTimer.lootFrame:Show();
  end

  local cmLevel, _, _ = C_ChallengeMode.GetActiveKeystoneInfo();
  local currentMapId = C_ChallengeMode.GetActiveChallengeMapID();
  local _, _, maxTime = C_ChallengeMode.GetMapUIInfo(currentMapId);

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
  if not MythicHelperCMTimer.frames.chestloot then
    local label = CreateFrame("Frame", nil, MythicHelperCMTimer.lootFrame);
    label:SetAllPoints();
    label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    label.text:SetPoint("TOPRIGHT", 0, 0);
    label.text:SetJustifyH("RIGHT");
    label.text:SetFontObject("GameFontHighlight");

    MythicHelperCMTimer.frames.chestloot = {
      labelFrame = label
    }
  end

  -- -- Chest Timers
  if not MythicHelperCMTimer.frames.chesttimer then
    local label = CreateFrame("Frame", nil, MythicHelperCMTimer.frame)
    label:SetAllPoints()
    label.text = label:CreateFontString(nil, "BACKGROUND", "GameFontHighlight");
    label.text:SetPoint("TOPLEFT", 0,0);
    MythicHelperCMTimer.frames.chesttimer = {
      labelFrame = label
    }
  end

  local lootLevel = 0;
  if cmLevel > 10 then
    lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[10];
  else
    lootLevel = MYTHIC_CHEST_TIMERS_LOOT_ILVL[cmLevel];
  end
  MythicHelperCMTimer.frames.chestloot.labelFrame.text:SetText("|cFF00FF00" .. lootLevel .. " ("..MythicHelper:GetGearTrack(lootLevel)..")");

  if timeLeft3 > 0 then
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicHelper.L["Keystone_Level"], '+3')..": "..MythicHelperCMTimer:FormatSeconds(timeLeft3));
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  elseif timeLeft2 > 0 then
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicHelper.L["Keystone_Level"], '+2')..": "..MythicHelperCMTimer:FormatSeconds(timeLeft2));
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  elseif timeLeft1 > 0 then
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicHelper.L["Keystone_Level"], '+1'));
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  else
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetText(format(MythicHelper.L["Keystone_Level"], '|cffff0000-1'));
    MythicHelperCMTimer.frames.chesttimer.labelFrame.text:SetFontObject("GameFontHighlight");
  end

end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:ResolveTime(seconds)
  local min = math.floor(seconds/60);
  local sec = seconds - (min * 60);
  return min, sec;
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelperCMTimer:FormatSeconds(seconds)
  local min, sec = MythicHelperCMTimer:ResolveTime(seconds)
  if min < 10 then
    min = "0" .. min
  end

  if sec < 10 then
    sec = "0" .. sec
  end

  return min .. ":" .. sec
end

