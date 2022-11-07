
local ADDONName, rs = ...


function rs.UpdateUnitAurasFull(unit, UnitFrame)
    local RSDB = rs.tabDB[rs.iDBmark] 

    local function HandleAura(aura)
        if RSDB["DctNeedColorAura"][aura.spellId] then
            local unMatched = RSDB["DctNeedColorAura"][aura.spellId][2] and (aura.sourceUnit ~= "player" and aura.sourceUnit ~= "pet")
            if not unMatched then
                UnitFrame.ColorAura[aura.auraInstanceID] = RSDB["DctNeedColorAura"][aura.spellId][1]
                rs.SetBarColor(UnitFrame)
            end
        end
        if RSDB["ShowStolenBuff"] and aura.isStealable then
            -- UnitFrame.StolenAura[aura.auraInstanceID] = {aura.icon, aura.expirationTime, aura.duration}
            UnitFrame.StolenAura[aura.auraInstanceID] = aura
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
            local thisAuraColor = RSDB["DctNeedColorAura"][aura.spellId]
            local thisAuraStolen = RSDB["ShowStolenBuff"] and aura.isStealable
            if thisAuraColor then
                local unMatched = thisAuraColor[2] and (aura.sourceUnit ~= "player" and aura.sourceUnit ~= "pet")
                if not unMatched then
                    UnitFrame.ColorAura[aura.auraInstanceID] = thisAuraColor[1]
                    rs.SetBarColor(UnitFrame)
                end
            end
            if thisAuraStolen then
                -- UnitFrame.StolenAura[aura.auraInstanceID] = {aura.icon, aura.expirationTime, aura.duration}
                UnitFrame.StolenAura[aura.auraInstanceID] = aura
                rs.SetStolen(UnitFrame)
            end
            -- Perform any setup tasks for this aura here.
        end
    end

    if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
        for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
            local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraInstanceID)
            if newAura then
                local thisAuraColor = RSDB["DctNeedColorAura"][newAura.spellId]
                local thisAuraStolen = RSDB["ShowStolenBuff"] and newAura.isStealable
                if thisAuraColor then
                    local unMatched = thisAuraColor[2] and (newAura.sourceUnit ~= "player" and newAura.sourceUnit ~= "pet")
                    if not unMatched then
                        UnitFrame.ColorAura[newAura.auraInstanceID] = thisAuraColor[1]
                        rs.SetBarColor(UnitFrame)
                    end
                end
                if thisAuraStolen then
                    -- UnitFrame.StolenAura[newAura.auraInstanceID] = {newAura.icon, newAura.expirationTime, newAura.duration}
                    UnitFrame.StolenAura[newAura.auraInstanceID] = newAura
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