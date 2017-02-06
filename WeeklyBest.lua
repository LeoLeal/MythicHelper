-- TODO: ORGANIZAR CODIGO E COLOCAR LABEL NO LUGAR CORRETO COM UMA ARTE MELHOR
local lineAdded = false
local numScreen = ""
local frame = CreateFrame("Frame");
frame:RegisterEvent("ADDON_LOADED");

frame:SetScript("OnEvent",function(self,event,...)  
    if (event == "ADDON_LOADED") then       
        local addon = ...

        if (addon == "Blizzard_ChallengesUI") then      
            
            local iLvlFrm = CreateFrame("Frame","WeeklyBestILevel",ChallengesModeWeeklyBest);
            iLvlFrm:SetWidth(100);
            iLvlFrm:SetHeight(50);
            iLvlFrm:SetPoint("CENTER",-128,-37); 
            
            sdm_SetTooltip(iLvlFrm, "This shows the level of the item you'll find in this week's chest.");

            iLvlFrm.text = iLvlFrm:CreateFontString(nil, "MEDIUM", "GameFontHighlightLarge");
            iLvlFrm.text:SetAllPoints(iLvlFrm);
            iLvlFrm.text:SetFont("Fonts\\FRIZQT__.TTF",30);
            iLvlFrm.text:SetPoint("CENTER",0,0);
            iLvlFrm.text:SetTextColor(1,0,1,1);
            iLvlFrm:SetScript("OnUpdate",function(self,elaps)       
                self.time = (self.time or 1)-elaps
                
                if (self.time > 0) then
                    return
                end
                
                while (self.time <= 0) do               
                    if (ChallengesModeWeeklyBest) then                    
                        numScreen = ChallengesModeWeeklyBest.Child.Level:GetText();             
                        
                        self.time = self.time+1;
                        
                        self.text:SetText(MYTHIC_CHEST_TIMERS_WEEKLY_ILVL[tonumber(numScreen)]);    
                        --self.text:SetText(numScreen);
                        self:SetScript("OnUpdate",nil);
                    end                 
                end
            end)        
        end
    end
end)

-- Tooltip functions
function sdm_OnEnterTippedButton(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    --GameTooltip:SetText(self.tooltipText, nil, nil, nil, nil, true)
        
    GameTooltip:AddLine("|cffff00ff" .. MythicChestTimers.L["Loot"]  .."|r")
    GameTooltip:AddLine("|cff00ff00" .. self.tooltipText .."|r")
    GameTooltip:Show()
end

function sdm_OnLeaveTippedButton()
    GameTooltip_Hide()
end

-- if text is provided, sets up the button to show a tooltip when moused over. Otherwise, removes the tooltip.
function sdm_SetTooltip(self, text)
    if text then
        self.tooltipText = text
        self:SetScript("OnEnter", sdm_OnEnterTippedButton)
        self:SetScript("OnLeave", sdm_OnLeaveTippedButton)
    else
        self:SetScript("OnEnter", nil)
        self:SetScript("OnLeave", nil)
    end
end