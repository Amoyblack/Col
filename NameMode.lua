local addon, rs = ...

-- local RSNpcTitleTooltip = CreateFrame("GameTooltip", "RS_Name_Tooltip", nil, "GameTooltipTemplate")

local outlinetable = {
    ["s1"] = "nil",
    ["s2"] = "OUTLINE",
    ["s3"] = "THICKOUTLINE",
}


local function GetNpcTitle(unit)
    if not unit then return end

    local tooltipData = C_TooltipInfo.GetUnit(unit)

    if tooltipData then
        for _, line in ipairs(tooltipData.lines) do
            TooltipUtil.SurfaceArgs(line)
        end

        if tooltipData.lines[2] and not (string.match(tooltipData.lines[2].leftText or "", "%d") or string.match(tooltipData.lines[2].leftText or "", "?")) then 
            return tooltipData.lines[2].leftText
        else
            return 
        end
    end
    -- local GUID = UnitGUID(unit)
    -- RSNpcTitleTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    -- RSNpcTitleTooltip:SetHyperlink("unit:" .. GUID)
    -- -- local line = _G["RS_Name_TooltipTextLeft" .. 2]
    -- if RS_Name_TooltipTextLeft2 and RS_Name_TooltipTextLeft2.GetText then
    -- -- local line = RS_Name_TooltipTextLeft2
    --     local text = RS_Name_TooltipTextLeft2:GetText()
    --     if not text then return end 
    --     -- local res,_ = text:gsub("%D+", "")
    --     if not (string.match(text, "?") or string.match(text, "%d")) then 
    --         return text 
    --     else
    --         return 
    --     end
    -- end
end



function rs.SetNameMode(unitFrame)
    if rs.IsLegalUnit(unitFrame) then 
        -- 先初始化状态
        local unit = unitFrame.unit
        
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
        if namePlate and namePlate.NpcNameRS and namePlate.NameSelectGlow then 
            namePlate.NpcNameRS:Hide()
            namePlate.NpcNameRS:SetText("")
            namePlate.NpcNameRS:SetTextColor(1,1,1)
            namePlate.NameSelectGlow:Hide()
        else
            return
        end
        
        if UnitIsUnit("player", unit) then 
            return 
        end
        
        local inInstance, instanceType = IsInInstance()  --  "pvp", "arena"  "raid"
        if inInstance and instanceType == "party" then 
            return 
        end

        unitFrame.hasShownAsName = false
        unitFrame:Show()
        
        -- 再匹配
        if rs.tabDB[rs.iDBmark]["EnableNamemode"] then 
            local NpcTitle = GetNpcTitle(unit)
            local name, _ = UnitName(unit)
            local reaction = UnitReaction("player", unit)
            local IsPlayer = UnitIsPlayer(unit)
            local IsFriendly = UnitIsFriend("player", unit)
            local CanAttack = UnitCanAttack("player", unit)

            -- NPC Friendly
            if reaction >= 5 and not IsPlayer and rs.tabDB[rs.iDBmark]["NameModeFriendlyNpc"] then 
                unitFrame:Hide()
                unitFrame.hasShownAsName = true
                namePlate.NpcNameRS:Show()
                if NpcTitle then
                    namePlate.NpcNameRS:SetText(format("|cff94FF80%s|r\n%s",name, NpcTitle))
                else
                    namePlate.NpcNameRS:SetText(format("|cff94FF80%s|r",name))
                end
                namePlate.NpcNameRS:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["NameModeFriendlyNPCSize"], outlinetable[rs.tabDB[rs.iDBmark]["NameModeNameType"]])
                namePlate.NpcNameRS:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, rs.tabDB[rs.iDBmark]["NameModeNpcOffY"])

            -- NPC Not Friendly
            elseif reaction < 5 and not IsPlayer and not CanAttack and rs.tabDB[rs.iDBmark]["NameModeFriendlyNpc"] then 
                local r, g, b, a = UnitSelectionColor(unit, true)
                unitFrame:Hide()
                unitFrame.hasShownAsName = true
                namePlate.NpcNameRS:Show()
                if NpcTitle then
                    namePlate.NpcNameRS:SetText(format("%s\n|cffFFFFFF%s|r",name, NpcTitle))
                else
                    namePlate.NpcNameRS:SetText(format("%s",name))
                end
                    
                namePlate.NpcNameRS:SetTextColor(r,g,b,a)
                namePlate.NpcNameRS:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["NameModeFriendlyNPCSize"], outlinetable[rs.tabDB[rs.iDBmark]["NameModeNameType"]])
                namePlate.NpcNameRS:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, rs.tabDB[rs.iDBmark]["NameModeNpcOffY"])

            -- Player
            elseif IsFriendly and IsPlayer and not CanAttack and rs.tabDB[rs.iDBmark]["NameModeFriendlyPlayer"] then 
                local r, g, b, a
                local _, englishClass = UnitClass(unit)
                local classColor = rs.V.Ccolors[englishClass]
                r, g, b, a = classColor.r , classColor.g, classColor.b, 1
                
                unitFrame:Hide()
                unitFrame.hasShownAsName = true
                namePlate.NpcNameRS:Show()
                namePlate.NpcNameRS:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["NameModeFriendlyPlayerSize"], outlinetable[rs.tabDB[rs.iDBmark]["NameModeNameType"]])
                namePlate.NpcNameRS:SetText(name)
                namePlate.NpcNameRS:SetTextColor(r,g,b,a)
                namePlate.NpcNameRS:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, rs.tabDB[rs.iDBmark]["NameModePlayerOffY"])
                
            end
        end
    end
end

