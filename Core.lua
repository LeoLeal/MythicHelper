MythicHelper = LibStub("AceAddon-3.0"):NewAddon("MythicHelper", "AceEvent-3.0", "AceTimer-3.0");
MYTHIC_CHEST_TIMERS_LOOT_ILVL = {340,345,345,350,355,355,360,365,365,370,370,370,370,370,370};
MYTHIC_CHEST_TIMERS_AZERITE_ILVL = {340,340,340,355,355,355,370,370,370,385,385,385,385,385,385};
MYTHIC_CHEST_TIMERS_WEEKLY_ILVL = {0,355,355,360,360,365,370,370,375,380,380,380,380,380,380};

MYTHIC_KEYSTONE_TEXT_TABLE = {};
SLASH_MYTHIC1 = '/mythic'

function SlashCmdList.MYTHIC(msg, editbox)
  print("|cFFFFFFFF======================================================");
  print("|cFFFFFFFF= Mythic Dungeon Chest rewards");
  print("|cFFFFFFFF======================================================");

  if tonumber(msg) == nil then
    for i = 1, 15 do
      print(MYTHIC_KEYSTONE_TEXT_TABLE[i]);
    end
  else
    if MYTHIC_KEYSTONE_TEXT_TABLE[tonumber(msg)] == nil then
      for i = 1, 15 do
        print(MYTHIC_KEYSTONE_TEXT_TABLE[i]);
      end
    else
      print(MYTHIC_KEYSTONE_TEXT_TABLE[tonumber(msg)]);
    end
  end
end
-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:OnInitialize()
  MythicHelper.L = LibStub("AceLocale-3.0"):GetLocale("MythicHelper")

  MythicHelperCMTimer:Init();
  MythicHelperKeystoneTooltip:Init();
  FeedKeystoneTextTable();
end

function FeedKeystoneTextTable()
  for i = 1, 15 do
    levelPrefix = "Keystone Level ";
    weeklyChestText = " | Weekly Chest - " .. MYTHIC_CHEST_TIMERS_LOOT_ILVL[i] .. "+";

    if i == 1 then
      levelText = "";
      levelPrefix = "Base Mythic Level";
      weeklyChestText = "";
    else
      levelText = i;
      if i < 10 then
        levelText = "0"..i;
      end
    end

    levelColor = "|cFFFFFFFF";
    if i == 1 then
      levelColor = "|cFF999999";
    end
    if i > 3 then
      levelColor = "|cFF00FF00";
    end
    if i > 6 then
      levelColor = "|cFF3377FF";
    end
    if i > 9 then
      levelColor = "|cFFCC00FF";
    end

    MYTHIC_KEYSTONE_TEXT_TABLE[i] = "|cFFFFFF00[ " .. levelPrefix .. levelText .. " ] " .. levelColor .. "Dungeon Chest - " .. MYTHIC_CHEST_TIMERS_LOOT_ILVL[i] .. "+" .. weeklyChestText;
  end
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
end

-- ---------------------------------------------------------------------------------------------------------------------
function MythicHelper:CancelCMTimer()
  if MythicHelper.cmTimer then
    self:CancelTimer(MythicHelper.cmTimer)
    MythicHelper.cmTimer = nil
  end
end
