local lineAdded = false
local numScreen = ""
MythicHelperWeeklyBest = {};

local iLvlFrm = nil;

function MythicHelperWeeklyBest:Init()
    if ChallengesModeWeeklyBest and iLvlFrm == nil then
        iLvlFrm = CreateFrame("Frame","WeeklyBestILevel",ChallengesModeWeeklyBest);
        iLvlFrm:SetWidth(160);
        iLvlFrm:SetHeight(150);
        iLvlFrm:SetPoint("CENTER",-128,-67); 

        iLvlFrm.text = iLvlFrm:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge");
        iLvlFrm.text:SetAllPoints(iLvlFrm);
        iLvlFrm.text:SetFont(MythicHelper.L["FONT"],13);
        iLvlFrm.text:SetPoint("CENTER",0,0);
        iLvlFrm.text:SetTextColor(1,1,1,1);
    end

    if iLvlFrm then
        iLvlFrm:SetScript("OnUpdate",function(self,elaps)
            self.time = (self.time or 1)-elaps
            
            if (self.time > 0) then
                return
            end
            
            while (self.time <= 0) do               
                if (ChallengesModeWeeklyBest) then                    
                    numScreen = ChallengesModeWeeklyBest.Child.Level:GetText();             
                    
                    self.time = self.time+1;
                    if MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[tonumber(numScreen)] and MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[tonumber(numScreen)] > 0 then
                        self.text:SetText(format(MythicHelper.L["WeeklyChestText"], MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[tonumber(numScreen)]));
                    else
                        self.text:SetText(MythicHelper.L["EmptyWeeklyChestText"]);
                    end
                    self:SetScript("OnUpdate",nil);
                end                 
            end
        end)
    end
end
