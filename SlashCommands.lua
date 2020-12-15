MythicHelperSlashCommands = {}

function MythicHelperSlashCommands:Init()
  MythicHelperSlashCommands:FeedKeystoneTextTable();
  C_MythicPlus.RequestCurrentAffixes()
  C_MythicPlus.RequestRewards()
	C_Timer.After(3, function()
    MythicHelperSlashCommands:DiscoverCurrentMythicAffixes();
  end)
  print("|cFFFFFF00[Mythic Helper] Added |cFFFFFFFFAffix Descriptions |cFFFFFF00and |cFFFFFFFFLoot Level |cFFFFFF00to Keystone tooltips!");
  print("|cFFFFFF00[Mythic Helper] Added |cFFFFFFFFKeystone upgrade timers |cFFFFFF00and |cFFFFFFFFLoot Quantity |cFFFFFF00to Dungeon Frames!");
  print("|cFFFFFF00[Mythic Helper] Slash commands created!");
  print("|cFFFFFFFFType |cFF00FFFF/mythic |cFFFFFFFFfor Mythic Keystone Loot tables");
  print("|cFFFFFFFFType |cFF00FFFF/affixes |cFFFFFFFFfor Mythic Keysone Affixes schedule.");
end

-- Mythic ILevel Prizes Command
SLASH_MYTHIC1 = '/mythic'
MYTHIC_KEYSTONE_TEXT_TABLE = {};

function SlashCmdList.MYTHIC(msg, editbox)
  print("|cFFFFFFFF=====================================");
  print("|cFFFFFFFF= Mythic Dungeon Chest rewards");
  print("|cFFFFFFFF=====================================");

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

function MythicHelperSlashCommands:FeedKeystoneTextTable()
  for i = 1, 15 do
    levelPrefix = "Keystone ";
    weeklyChestText = " | Weekly Chest - " .. MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[i];

    if i == 1 then
      levelText = "";
      levelPrefix = "Base Mythic";
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
      levelColor = "|cFF1eff00";
    end
    if i > 6 then
      levelColor = "|cFF0070dd";
    end
    if i > 9 then
      levelColor = "|cFFa335ee";
    end

    MYTHIC_KEYSTONE_TEXT_TABLE[i] = "|cFFFFFF00[ " .. levelPrefix .. levelText .. " ] " .. levelColor .. "Dungeon - " .. MYTHIC_CHEST_TIMERS_LOOT_ILVL[i] .. weeklyChestText;
  end
end

-- Mythic Affixes Schedule Command
SLASH_AFFIXES1 = '/affixes'
local currentWeek

function SlashCmdList.AFFIXES()

  local modifierName, _ = C_ChallengeMode.GetAffixInfo(121);
  print("|cFFFFFFFF=====================================");
  print("|cFFFFFFFF= Mythic Keystone Dungeon Affixes Schedule");
  print("|cFFFFFFFF= |cFFAAAAAAAffix Dificulty: |cFF50FA7B[Easy] |cFFFFB86C[Medium] |cFFFF5555[Hard] ");
  print("|cFFFFFFFF=====================================");
  print("|cFFFFFFFF= Current Season Affix 10+ : |cFFFF5555" .. modifierName);
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
        affixString = '|cFFFFFFFF[ This Week ] => |cFFFFFFFF'
      end
      if i == 2 then
        affixString = '|c77AAAAAA[ Next Week ] => |cFFFFFFFF'
      end
      if i == 3 then
        affixString = '|c77888888[ In 2 Weeks ] => |cFFFFFFFF'
      end
			for j = 1, #affixes do
        local modifierName, modifierDescription = C_ChallengeMode.GetAffixInfo(affixes[j])
        affixString = affixString .. (affixes[j] and AFFIXES_DIFICULTY[(affixes[j] < 100 and affixes[j] or affixes[j] - 100)] or '|cFFFFFFFF') .. modifierName
        if j < 3 then
          affixString = affixString .. ', '
        end
      end
      print(affixString);
		end
	else
    print("No Week Discovered yet.");
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
