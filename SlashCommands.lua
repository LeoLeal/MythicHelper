MythicHelperSlashCommands = {}

function MythicHelperSlashCommands:Init()
  MythicHelperSlashCommands:FeedKeystoneTextTable();
  C_MythicPlus.RequestCurrentAffixes()
  C_MythicPlus.RequestRewards()
	C_Timer.After(3, function()
    MythicHelperSlashCommands:DiscoverCurrentMythicAffixes();
  end)
  print("|cFFFFFF00[Mythic Helper] "..MythicHelper.L["LOAD_1"]);
  print("|cFFFFFF00[Mythic Helper] "..MythicHelper.L["LOAD_2"]);
  print("|cFFFFFF00[Mythic Helper] "..MythicHelper.L["LOAD_3"]);
  print("|cFFFFFFFFType |cFF00FFFF/mythic |cFFFFFFFF"..MythicHelper.L["LOAD_4"]);
  print("|cFFFFFFFFType |cFF00FFFF/affixes |cFFFFFFFF"..MythicHelper.L["LOAD_5"]);
end

-- Mythic ILevel Prizes Command
SLASH_MYTHIC1 = '/mythic'
MYTHIC_KEYSTONE_TEXT_TABLE = {};

function SlashCmdList.MYTHIC(msg, editbox)
  print("|cFFFFFFFF=====================================");
  print("|cFFFFFFFF= Mythic Dungeon Chest rewards");
  print("|cFFFFFFFF=====================================");

  if tonumber(msg) == nil then
    for i = 1, 10 do
      print(MYTHIC_KEYSTONE_TEXT_TABLE[i]);
    end
  else
    if MYTHIC_KEYSTONE_TEXT_TABLE[tonumber(msg)] == nil then
      for i = 1, 10 do
        print(MYTHIC_KEYSTONE_TEXT_TABLE[i]);
      end
    else
      print(MYTHIC_KEYSTONE_TEXT_TABLE[tonumber(msg)]);
    end
  end
end

function MythicHelperSlashCommands:FeedKeystoneTextTable()
  for i = 1, 10 do
    levelPrefix = MythicHelper.L["Keystone"].." ";
    weeklyChestText = " | "..MythicHelper.L["Weekly_Chest"].." - " .. MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[i] .. " ("..MythicHelper:GetGearTrack(MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[i])..")";

    if i == 1 then
      levelText = "";
      levelPrefix = MythicHelper.L["Base"];
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
    if i > 1 then
      levelColor = "|cFF1eff00";
    end
    if i > 4 then
      levelColor = "|cFF0070dd";
    end
    if i > 9 then
      levelColor = "|cFFa335ee";
    end

    MYTHIC_KEYSTONE_TEXT_TABLE[i] = "|cFFFFFF00[ " .. levelPrefix .. levelText .. " ] " .. levelColor .. MythicHelper.L["Dungeon"] .. " - " .. MYTHIC_CHEST_TIMERS_LOOT_ILVL[i] .. " ("..MythicHelper:GetGearTrack(MYTHIC_CHEST_TIMERS_LOOT_ILVL[i])..")" .. weeklyChestText;
  end
end

-- Mythic Affixes Schedule Command
SLASH_AFFIXES1 = '/affixes'
local currentWeek

function SlashCmdList.AFFIXES()

  print("|cFFFFFFFF=====================================");
  print("|cFFFFFFFF= Mythic Keystone Dungeon Affixes Schedule");
  print("|cFFFFFFFF= Affixes are introduced respectively at Dungeon levels |cFF1eff002|cFFFFFFFF, |cFF0070dd5 |cFFFFFFFFand |cFFa335ee10 |cFFFFFFFF");
  print("|cFFFFFFFF= |cFFAAAAAAAffix Dificulty: |cFF50FA7B[Easy] |cFFFFB86C[Medium] |cFFFF5555[Hard] ");
  print("|cFFFFFFFF=====================================");

  if currentWeek then
		for i = 1, 3 do
      local scheduleWeek = (currentWeek + i - 1) % (#AFFIXES_SCHEDULE);

      if scheduleWeek == 0 then
        scheduleWeek = #AFFIXES_SCHEDULE;
      end

      local affixes = AFFIXES_SCHEDULE[scheduleWeek]
      local affixString = ''
      if i == 1 then
        affixString = '|cFFFFFFFF[ '.. MythicHelper.L["THIS_WEEK"] ..' ] => |cFFFFFFFF'
      end
      if i == 2 then
        affixString = '|c77AAAAAA[ '.. MythicHelper.L["NEXT_WEEK"] ..' ] => |cFFFFFFFF'
      end
      if i == 3 then
        affixString = '|c77888888[ '.. MythicHelper.L["IN_2_WEEKS"] ..' ] => |cFFFFFFFF'
      end

			for j = 1, #affixes do
        local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(affixes[j])
        affixString = affixString .. (affixes[j] and AFFIXES_DIFICULTY[affixes[j]] or '|cFFFFFFFF') .. modifierName
        if j < 3 then
          affixString = affixString .. ', '
        end
      end
      print(affixString);
		end
	end
end

function MythicHelperSlashCommands:DiscoverCurrentMythicAffixes()
  currentWeek = nil
  local currentAffixes = C_MythicPlus.GetCurrentAffixes();
  if currentAffixes then
    for index, affixes in ipairs(AFFIXES_SCHEDULE) do
      local matches = 0
      for _, affix in ipairs(currentAffixes) do
        if affix.id == affixes[1] or affix.id == affixes[2] or affix.id == affixes[3] then
          matches = matches + 1
        end
      end

      if matches >= 3 then
        currentWeek = index
      end
    end
  end
end
