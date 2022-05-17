local addon, rs = ...


local function NameplateBuffContainerShowsBuff(name, caster, nameplateShowPersonal, nameplateShowAll)
    if (not name) then
        return false;
    end
    return nameplateShowAll or
           (nameplateShowPersonal and (caster == "player" or caster == "pet" or caster == "vehicle"));
end

function rs.OnUnitAuraUpdateRS(self, unit, isFullUpdate, updatedAuraInfos)

    -- print("\n", UnitName(unit),"    全更新:", isFullUpdate, "  更新数据:", updatedAuraInfos)
    
	local filter;
	local showAll = false;
    
	local isPlayer = UnitIsUnit("player", unit);
	local reaction = UnitReaction("player", unit);
	-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
	local hostileUnit = reaction and reaction <= 4;
	local showDebuffsOnFriendly = GetCVarBool("nameplateShowDebuffsOnFriendly");
	if isPlayer then
		filter = "HELPFUL|INCLUDE_NAME_PLATE_ONLY";
	else
		if hostileUnit then
            -- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
			filter = "HARMFUL|INCLUDE_NAME_PLATE_ONLY";
		else
			if (showDebuffsOnFriendly) then
				-- dispellable debuffs
				filter = "HARMFUL|RAID";
				showAll = true;
			else
				filter = "NONE";
			end
		end
	end

    local isStolenAura 
    local isWhitelistAura
    local isBarColorAura
    if updatedAuraInfos then 
        for _, oAura in pairs(updatedAuraInfos) do 
            if rs.tabDB[rs.iDBmark]["ShowStolenBuff"] and oAura.isHelpful then 
                isStolenAura = true 
            end
            if rs.tabDB[rs.iDBmark]["DctColorAura"][oAura.spellId] then 
                isBarColorAura = true 
            end
            if rs.tabDB[rs.iDBmark]["AuraWhite"] and rs.tabDB[rs.iDBmark]["DctAura"][oAura.spellId] then 
                isWhitelistAura = true 
            end
            -- print(oAura.name)
            -- print("偷取:",isStolenAura, "  白名单:",isWhitelistAura, "   自定义光环染色:",isBarColorAura, "\n")
        end
    end

	local nameplate = C_NamePlate.GetNamePlateForUnit(unit, false);
	if (nameplate) then
		-- Early out if the update cannot affect the nameplate
		local function AuraCouldDisplayAsBuff(auraInfo)
			if not NameplateBuffContainerShowsBuff(auraInfo.name, auraInfo.sourceUnit, auraInfo.nameplateShowPersonal, auraInfo.nameplateShowAll or showAll) then
				return false;
			elseif isPlayer then
				return auraInfo.isHelpful;
			elseif hostileUnit then
				return auraInfo.isHarmful;
			elseif showDebuffsOnFriendly then
				return auraInfo.isHarmful and auraInfo.isRaid;
			end

			return false;
		end

        -- blizzard skip case
		-- if filter ~= "NONE" and AuraUtil.ShouldSkipAuraUpdate(isFullUpdate, updatedAuraInfos, AuraCouldDisplayAsBuff) then
		-- 	-- return;
        --     if isStolenAura or isBarColorAura or isWhitelistAura then 
        --         nameplate.UnitFrame.BuffFrame:UpdateBuffs(nameplate.namePlateUnitToken, filter, showAll);
        --     end
		-- end

		-- nameplate.UnitFrame.BuffFrame:UpdateBuffs(nameplate.namePlateUnitToken, filter, showAll);
		rs.UpdateBuffsRS(nameplate.UnitFrame.BuffFrame, nameplate.namePlateUnitToken, filter, showAll);
	end
end



function rs:UpdateAnchor()
    if not (self:GetParent() and self:GetParent().unit) then return end 
    if UnitIsUnit("player", self:GetParent().unit) then 
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, rs.tabDB[rs.iDBmark]["SelfAuraHeight"]);
    else
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, rs.tabDB[rs.iDBmark]["AuraHeight"]);
    end
end



local function CreateSingleBuff(self, buffIndex, index, texture, count, expirationTime, duration, type, name, spellID)
    if (not self.buffList[buffIndex]) then
        self.buffList[buffIndex] = CreateFrame("Frame", nil, self, "NameplateBuffButtonTemplate");
        self.buffList[buffIndex]:SetMouseClickEnabled(false);
        self.buffList[buffIndex].layoutIndex = buffIndex;
    end
    
    local buff = self.buffList[buffIndex];
    
    if type == "buff" then 
        if not UnitIsUnit(self.unit, "player") then 
            buff.Border:SetColorTexture(0.1,0.9,0.1)
        else
            buff.Border:SetColorTexture(0,0,0)
        end
    elseif type == "debuff" then 
        if UnitIsUnit(self.unit, "player") then
            buff.Border:SetColorTexture(.9, .3, .3)
        else
            buff.Border:SetColorTexture(0,0,0)
        end
    end

    if rs.tabDB[rs.iDBmark]["SquareAura"] then 
        buff:SetSize(rs.tabDB[rs.iDBmark]["AuraSize"],rs.tabDB[rs.iDBmark]["AuraSize"])
        buff.Icon:SetPoint("TOPLEFT", buff,"TOPLEFT", 1, -1)
        buff.Icon:SetPoint("BOTTOMRIGHT", buff,"BOTTOMRIGHT", -1, 1)
        buff.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
    end
    buff.Cooldown:SetHideCountdownNumbers(not rs.tabDB[rs.iDBmark]["AuraTimer"])
    local regon = buff.Cooldown:GetRegions()
    if regon.GetText then 
        regon:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["AuraTimerSize"], nil)  --Default : 15 "OUTLINE"
    end
    
    -- buff.tool = CreateFrame("GameTooltip", "mybufftooltip", nil, "GameTooltipTemplate")
    
    buff:SetScript("OnEnter", function()
        GameTooltip:SetOwner(UIParent,"ANCHOR_CURSOR")
        -- GameTooltip:SetOwner(buff,"TOPLEFT")
        -- GameTooltip:AddLine(name)
        -- local desc = GetSpellDescription(spellID)
        -- GameTooltip:AddLine(desc)
        if type == "buff" then 
            -- GameTooltip:SetUnitAura(self.unit, 1)
            GameTooltip:SetUnitBuff(self.unit, index)
        elseif type == "debuff" then 
            GameTooltip:SetUnitDebuff(self.unit, index)
        end
        GameTooltip:Show()
    --     local desc = GetSpellDescription(spellID)
    --     buff.tool:SetOwner(buff, "ANCHOR_LEFT")
    --     buff.tool:AddLine(name)
    --     buff.tool:AddLine(string.format("|cffFFFFFF%s|r", desc))
    --     buff.tool:Show()
    --     buff.tooltip:SetOwner(buff, "ANCHOR_LEFT")

    --     local desc = GetSpellDescription(spellID)
    --     local spellMixin = Spell:CreateFromSpellID(spellID)
    --     spellMixin:ContinueOnSpellLoad(function()
    --         local desc = spellMixin:GetSpellDescription()
    --         buff.tooltip:AddLine(name)
    --         buff.tooltip:AddLine(string.format("|cffFFFFFF%s|r", desc))
    --     end)
    --     buff.tooltip:Show()
    end)

    buff:SetScript("OnLeave", function()
        GameTooltip:ClearLines()
        GameTooltip:Hide()
    end)

    -- buff:SetID(index);

    buff.Icon:SetTexture(texture);
    if (count > 1) then
        buff.CountFrame.Count:SetText(count);
        buff.CountFrame.Count:Show();
    else
        buff.CountFrame.Count:Hide();
    end
    
    CooldownFrame_Set(buff.Cooldown, expirationTime - duration, duration, duration > 0, true);
    
    buff:Show();
end







function rs.UpdateBuffsRS(self, unit, filter, showAll)
    local hasColorAura
    local hasStolenAura
    local RSDB = rs.tabDB[rs.iDBmark]
    local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)
    if not namePlate then return end 
    namePlate.UnitFrame.healthBar.AuraColor = nil
    namePlate.UnitFrame.StolenFrame:Hide()
    namePlate.UnitFrame.healthBar.curTarget:SetPoint("LEFT", namePlate.UnitFrame.healthBar, "RIGHT", 0, 0)

	if not self.isActive then
		for i = 1, BUFF_MAX_DISPLAY do
			if (self.buffList[i]) then
				self.buffList[i]:Hide();
			else
				break;
			end
		end

		return;
	end
    
	self.unit = unit;
	self.filter = filter;
	self:UpdateAnchor();
    
	if filter == "NONE" then
		for i, buff in ipairs(self.buffList) do
			buff:Hide();
		end
	else
        -------DEBUFF
		local buffIndex = 1;
		local index = 1;
        local rsDebuffIndex  = 1
		AuraUtil.ForEachAura(unit, "HARMFUL", BUFF_MAX_DISPLAY, function(...)
			local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = ...;
            if not name then rsDebuffIndex = rsDebuffIndex + 1 return end

            if RSDB["DctColorAura"][spellId] then 
                hasColorAura = RSDB["DctColorAura"][spellId]
            end

            if buffIndex > RSDB["AuraNum"] then rsDebuffIndex = rsDebuffIndex + 1 return end
            --  资源条 debuff
            if UnitIsUnit(self.unit, "player") then
                if RSDB["personalNpdeBuffEnable"] then 
                    local filterAll = RSDB["personalNpdeBuffFilterAll"]
                    local filterWatchlist = RSDB["personalNpdeBuffFilterWatchList"] and RSDB["DctAura"][spellId]
                    local filterLessMinite = RSDB["personalNpdeBuffFilterLessMinite"] and (duration > 59 or duration == 0 or expirationTime == 0) 
                    if filterAll or filterWatchlist then 
                        if filterLessMinite then 
                            rsDebuffIndex = rsDebuffIndex + 1
                            return
                        end
                        if RSDB["BlackList"][spellId] then rsDebuffIndex = rsDebuffIndex + 1 return end
                        CreateSingleBuff(self, buffIndex, rsDebuffIndex, texture, count, expirationTime, duration, "debuff", name, spellId)
                        buffIndex = buffIndex + 1
                    end
                end
            -- 姓名板debuff
            else
                if RSDB["otherNpdeBuffEnable"] then 
                    local filterAll = RSDB["otherNpdeBuffFilterAll"]
                    local filterBlizzard = RSDB["otherNpdeBuffFilterBlizzard"] and self:ShouldShowBuff(name, caster, nameplateShowPersonal, nameplateShowAll or showAll, duration)
                    local filterWatchlist = RSDB["otherNpdeBuffFilterWatchList"] and RSDB["DctAura"][spellId]
                    local filterLessMinite = RSDB["otherNpdeBuffFilterLessMinite"] and (duration > 59 or duration == 0 or expirationTime == 0) 
                    local filterOnlyMe = RSDB["otherNpdeBuffFilterOnlyMe"] and (caster ~= "player" and caster ~= "pet")
                    if filterAll or filterWatchlist or filterBlizzard then 
                        if filterLessMinite or filterOnlyMe then 
                            rsDebuffIndex = rsDebuffIndex + 1;
                            return
                        end
                        if RSDB["BlackList"][spellId] then rsDebuffIndex = rsDebuffIndex + 1 return end
                        CreateSingleBuff(self, buffIndex, rsDebuffIndex, texture, count, expirationTime, duration, "debuff", name, spellId)
                        buffIndex = buffIndex + 1
                    end
                end
            end
            
            rsDebuffIndex = rsDebuffIndex + 1;
			index = index + 1;
			return buffIndex > BUFF_MAX_DISPLAY;
		end);
        

        -- BUFF
        local index = 1;
        local rsBuffIndex = 1
        AuraUtil.ForEachAura(unit, "HELPFUL", BUFF_MAX_DISPLAY, function(...)
            local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = ...;
            if not name then rsBuffIndex = rsBuffIndex + 1 return end

            if RSDB["DctColorAura"][spellId] then 
                hasColorAura = RSDB["DctColorAura"][spellId]
            end
            if canStealOrPurge and RSDB["ShowStolenBuff"] then 
                hasStolenAura = {texture, expirationTime, duration}
            end

            if buffIndex > RSDB["AuraNum"] then rsBuffIndex = rsBuffIndex + 1 return end

            -- 资源条 buff
            if UnitIsUnit(self.unit, "player") then
                if RSDB["personalNpBuffEnable"] then
                    local filterAll = RSDB["personalNpBuffFilterAll"]
                    local filterBlizzard = RSDB["personalNpBuffFilterBlizzard"] and self:ShouldShowBuff(name, caster, nameplateShowPersonal, nameplateShowAll or showAll, duration)
                    local filterWatchlist = RSDB["personalNpBuffFilterWatchList"] and RSDB["DctAura"][spellId]
                    local filterLessMinite = RSDB["personalNpBuffFilterLessMinite"] and (duration > 59 or duration == 0 or expirationTime == 0) 
                    if filterAll or filterBlizzard or filterWatchlist then 
                        if filterLessMinite then
                            rsBuffIndex = rsBuffIndex + 1
                            return
                        end
                        if RSDB["BlackList"][spellId] then rsBuffIndex = rsBuffIndex + 1 return end
                        CreateSingleBuff(self, buffIndex, rsBuffIndex, texture, count, expirationTime, duration, "buff", name, spellId)
                        buffIndex = buffIndex + 1;
                    end
                end
            -- 姓名板 buff
            else
                if RSDB["otherNpBuffEnable"] then 
                    local filterAll = RSDB["otherNpBuffFilterAll"]
                    local filterWatchlist = RSDB["otherNpBuffFilterWatchList"] and RSDB["DctAura"][spellId]
                    local filterLessMinite = RSDB["otherNpBuffFilterLessMinite"] and (duration > 59 or duration == 0 or expirationTime == 0) 
                    if filterAll or filterWatchlist then
                        if filterLessMinite then 
                            rsBuffIndex = rsBuffIndex + 1
                            return 
                        end
                        if RSDB["BlackList"][spellId] then rsBuffIndex = rsBuffIndex + 1 return end
                        CreateSingleBuff(self, buffIndex, rsBuffIndex, texture, count, expirationTime, duration, "buff", name, spellId)
                        buffIndex = buffIndex + 1;
                    end
                end
            end

            index = index + 1;
            rsBuffIndex = rsBuffIndex + 1
            return false   -- BUFF全部遍历,因为不止是这里要显示，要找可驱散偷取的
            -- When Match, return true . it will exit Iter
            -- Blzzard info: return true --The callback function should return true once it's fine to stop processing further auras.
        end)
        
        if hasStolenAura then 
            namePlate.UnitFrame.StolenFrame:Show()
            namePlate.UnitFrame.StolenFrame.Texture:SetTexture(hasStolenAura[1])
            namePlate.UnitFrame.StolenFrame.Cooldown:SetCooldown(hasStolenAura[2] - hasStolenAura[3], hasStolenAura[3])
            namePlate.UnitFrame.healthBar.curTarget:SetPoint("LEFT", namePlate.UnitFrame.StolenFrame, "RIGHT", 0, 0)
           
        end

        if hasColorAura then 
            namePlate.UnitFrame.healthBar.AuraColor = hasColorAura
        end
        
        rs.SetBarColor(namePlate.UnitFrame)


		for i = buffIndex, BUFF_MAX_DISPLAY do
			if (self.buffList[i]) then
				self.buffList[i]:Hide();
			else
				break;
			end
		end
	end
	self:Layout();
end
