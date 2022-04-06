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
            if RSPlatesDB["ShowStolenBuff"] and oAura.isHelpful then 
                isStolenAura = true 
            end
            if RSPlatesDB["DctColorAura"][oAura.spellId] then 
                isBarColorAura = true 
            end
            if RSPlatesDB["AuraWhite"] and RSPlatesDB["DctAura"][oAura.spellId] then 
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
		if filter ~= "NONE" and AuraUtil.ShouldSkipAuraUpdate(isFullUpdate, updatedAuraInfos, AuraCouldDisplayAsBuff) then
			-- return;
            if isStolenAura or isBarColorAura or isWhitelistAura then 
                nameplate.UnitFrame.BuffFrame:UpdateBuffs(nameplate.namePlateUnitToken, filter, showAll);
            end
		end

		-- nameplate.UnitFrame.BuffFrame:UpdateBuffs(nameplate.namePlateUnitToken, filter, showAll);
	end
end



function rs:UpdateAnchor()
    if not (self:GetParent() and self:GetParent().unit) then return end 
    if UnitIsUnit("player", self:GetParent().unit) then 
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, RSPlatesDB["SelfAuraHeight"]);
    else
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, RSPlatesDB["AuraHeight"]);
    end
end



function rs.UpdateBuffsRS(self, unit, filter, showAll)
    local hasColorAura
    local hasStolenAura
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
		-- Some buffs may be filtered out, use this to create the buff frames.
		local buffIndex = 1;
		local index = 1;
		AuraUtil.ForEachAura(unit, filter, BUFF_MAX_DISPLAY, function(...)
			local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = ...;
            if RSPlatesDB["DctColorAura"][spellId] then 
                hasColorAura = RSPlatesDB["DctColorAura"][spellId]
            end

            if buffIndex > RSPlatesDB["AuraNum"] then return nil end

			local ShouldShow = self:ShouldShowBuff(name, caster, nameplateShowPersonal, nameplateShowAll or showAll, duration) and RSPlatesDB["AuraDefault"]
			local WhiteList = RSPlatesDB["AuraWhite"] and RSPlatesDB["DctAura"][spellId]
			local notPlayerself = RSPlatesDB["AuraOnlyMe"] and caster ~= "player"
			if (ShouldShow or WhiteList and not notPlayerself) then
				if (not self.buffList[buffIndex]) then
					self.buffList[buffIndex] = CreateFrame("Frame", nil, self, "NameplateBuffButtonTemplate");
					self.buffList[buffIndex]:SetMouseClickEnabled(false);
					self.buffList[buffIndex].layoutIndex = buffIndex;
				end
                
                local buff = self.buffList[buffIndex];
                
                if RSPlatesDB["SquareAura"] then 
                    buff:SetSize(RSPlatesDB["AuraSize"],RSPlatesDB["AuraSize"])
                    buff.Icon:SetPoint("TOPLEFT", buff,"TOPLEFT", 1, -1)
                    buff.Icon:SetPoint("BOTTOMRIGHT", buff,"BOTTOMRIGHT", -1, 1)
                    buff.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
                end
                buff.Cooldown:SetHideCountdownNumbers(not RSPlatesDB["AuraTimer"])
                local regon = buff.Cooldown:GetRegions()
                if regon.GetText then 
                    regon:SetFont(STANDARD_TEXT_FONT, RSPlatesDB["AuraTimerSize"], nil)  --Default : 15 "OUTLINE"
                end

				buff:SetID(index);
				buff.Icon:SetTexture(texture);
				if (count > 1) then
					buff.CountFrame.Count:SetText(count);
					buff.CountFrame.Count:Show();
				else
					buff.CountFrame.Count:Hide();
				end
                
				CooldownFrame_Set(buff.Cooldown, expirationTime - duration, duration, duration > 0, true);
                
				buff:Show();
				buffIndex = buffIndex + 1;
			end
			index = index + 1;
            -- todo: 这里需要 强制false，后续解耦，单独做Combat_Log_Module模块
			return buffIndex > BUFF_MAX_DISPLAY;
		end);
        
		
        
        AuraUtil.ForEachAura(unit, "HELPFUL", BUFF_MAX_DISPLAY, function(...)
            local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = ...;
            if RSPlatesDB["DctColorAura"][spellId] then 
                hasColorAura = RSPlatesDB["DctColorAura"][spellId]
            end
            if canStealOrPurge and RSPlatesDB["ShowStolenBuff"] then 
                hasStolenAura = {texture, expirationTime, duration}
            end
            return false   -- BUFF全部遍历
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
