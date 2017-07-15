local lineAdded = false
local numScreen = ""
MythicHelperWeeklyBest = {};

local iLvlFrm = nil;

function MythicHelperWeeklyBest:Init()
    if ChallengesModeWeeklyBest and iLvlFrm == nil then
        iLvlFrm = CreateFrame("Frame","WeeklyBestILevel",ChallengesModeWeeklyBest);
        iLvlFrm:SetWidth(150);
        iLvlFrm:SetHeight(150);
        iLvlFrm:SetPoint("CENTER",-128,-47); 

        iLvlFrm.text = iLvlFrm:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge");
        iLvlFrm.text:SetAllPoints(iLvlFrm);
        iLvlFrm.text:SetFont(MythicHelper.L["FONT"],11);
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
                    numScreen = tonumber(ChallengesModeWeeklyBest.Child.Level:GetText());
                    if numScreen > 15 then
                        numScreen = 15;
                    end
                    
                    self.time = self.time+1;
                    if MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[numScreen] and MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[numScreen] > 0 then
                        self.text:SetText(format(MythicHelper.L["WeeklyChestText"], MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[numScreen]));
                    else
                        self.text:SetText(MythicHelper.L["EmptyWeeklyChestText"]);
                    end
                    self:SetScript("OnUpdate",nil);
                end                 
            end
        end)
    end
end
