local addon, rs = ...

local RSNpcTitleTooltip = CreateFrame("GameTooltip", "RS_Name_Tooltip", nil, "GameTooltipTemplate")


local function GetNpcTitle(unit)
    if not unit then return end
    local GUID = UnitGUID(unit)
    RSNpcTitleTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    RSNpcTitleTooltip:SetHyperlink("unit:" .. GUID)
    -- local line = _G["RS_Name_TooltipTextLeft" .. 2]
    if RS_Name_TooltipTextLeft2 and RS_Name_TooltipTextLeft2.GetText then
    -- local line = RS_Name_TooltipTextLeft2
        local text = RS_Name_TooltipTextLeft2:GetText()
        local res,_ = text:gsub("%D+", "")
        if res == "" then 
            return text
        else
            return nil
        end
    end
end



function rs.SetNameMode(unitFrame)
    -- 先初始化状态
    local unit = unitFrame.unit
    if not rs.IsNameplateUnit(unitFrame) then return end 
    local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
    if namePlate and namePlate.NpcNameRS then 
        namePlate.NpcNameRS:Hide()
        namePlate.NpcNameRS:SetTextColor(1,1,1)
    else
        return
    end

    if rs.IsPlayerself(unitFrame) then return end
    
    if rs.IsExpBall(unit) and RSPlatesDB["ExpballHelper"] then 
        unitFrame:Hide()
    else
        unitFrame:Show()
    end
    
    -- 再匹配
    if RSPlatesDB["EnableNamemode"] then 
        local NpcTitle = GetNpcTitle(unit)
        local name, _ = UnitName(unit)
        local reaction = UnitReaction("player", unit)
        local IsPlayer = UnitIsPlayer(unit)

        -- NPC
        if reaction == 5 and not IsPlayer and RSPlatesDB["NameModeFriendlyNpc"] then 
            if NpcTitle then 
                sTitle = NpcTitle
            else
                sTitle = ""
            end

            unitFrame:Hide()
            namePlate.NpcNameRS:Show()
            namePlate.NpcNameRS:SetText(format("|cff94FF80%s|r\n%s",name, sTitle))
            namePlate.NpcNameRS:SetFont(STANDARD_TEXT_FONT, RSPlatesDB["NameModeFriendlyNPCSize"], "THICKOUTLINE")

        -- Player
        elseif reaction ==5 and IsPlayer and RSPlatesDB["NameModeFriendlyPlayer"] then 
            local r, g, b, a
            local _, englishClass = UnitClass(unit)
            local classColor = rs.V.Ccolors[englishClass]
            r, g, b, a = classColor.r , classColor.g, classColor.b, 1
            
            unitFrame:Hide()
            namePlate.NpcNameRS:Show()
            namePlate.NpcNameRS:SetFont(STANDARD_TEXT_FONT, RSPlatesDB["NameModeFriendlyPlayerSize"], "THICKOUTLINE")
            namePlate.NpcNameRS:SetText(name)
            namePlate.NpcNameRS:SetTextColor(r,g,b,a)
            
        end
    end
end

