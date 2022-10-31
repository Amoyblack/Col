
local ADDONName, rs = ...


function rs.UpdateUnitAurasFull(unit, UnitFrame)
    local RSDB = rs.tabDB[rs.iDBmark] 

    local function HandleAura(aura)
        if RSDB["DctColorAura"][aura.spellId] then
            UnitFrame.ColorAura[aura.auraInstanceID] = RSDB["DctColorAura"][aura.spellId]
            rs.SetBarColor(UnitFrame)
        end
        if RSDB["ShowStolenBuff"] and aura.isStealable then
            UnitFrame.StolenAura[aura.auraInstanceID] = {aura.icon, aura.expirationTime, aura.duration}
            rs.SetStolen(UnitFrame)
        end
        return false
        -- Perform any setup or update tasks for this aura here.
    end

    local batchCount = nil
    local usePackedAura = true
    AuraUtil.ForEachAura(unit, "HELPFUL", BUFF_MAX_DISPLAY, HandleAura, usePackedAura)
    AuraUtil.ForEachAura(unit, "HARMFUL", BUFF_MAX_DISPLAY, HandleAura, usePackedAura)

end


function rs.UpdateUnitAurasIncremental(unit, unitAuraUpdateInfo, UnitFrame)
    local RSDB = rs.tabDB[rs.iDBmark]
        if unitAuraUpdateInfo.addedAuras ~= nil then
        for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
            local thisAuraColor = RSDB["DctColorAura"][aura.spellId]
            local thisAuraStolen = RSDB["ShowStolenBuff"] and aura.isStealable
            if thisAuraColor then
                UnitFrame.ColorAura[aura.auraInstanceID] = thisAuraColor
                rs.SetBarColor(UnitFrame)
            end
            if thisAuraStolen then
                UnitFrame.StolenAura[aura.auraInstanceID] = {aura.icon, aura.expirationTime, aura.duration}
                rs.SetStolen(UnitFrame)
            end
            -- Perform any setup tasks for this aura here.
        end
    end

    if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
            local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            if newAura then
                local thisAuraColor = RSDB["DctColorAura"][newAura.spellId]
                local thisAuraStolen = RSDB["ShowStolenBuff"] and newAura.isStealable
                if thisAuraColor then
                    UnitFrame.ColorAura[newAura.auraInstanceID] = thisAuraColor
                    rs.SetBarColor(UnitFrame)
                end
                if thisAuraStolen then
                    UnitFrame.StolenAura[newAura.auraInstanceID] = {newAura.icon, newAura.expirationTime, newAura.duration}
                    rs.SetStolen(UnitFrame)
                end
            end
            -- Perform any update tasks for this aura here.
        end
    end

    if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
            if UnitFrame.ColorAura[auraInstanceID] then 
                UnitFrame.ColorAura[auraInstanceID] = nil
                rs.SetBarColor(UnitFrame)
            end
            if UnitFrame.StolenAura[auraInstanceID] then 
                UnitFrame.StolenAura[auraInstanceID] = nil
                rs.SetStolen(UnitFrame)
            end
            -- Perform any cleanup tasks for this aura here.
        end
    end
end