local addon, rs = ...



function rs.RsShouldShowBuff(unit, aura, BlizzardShouldShow)
    local RSDB = rs.tabDB[rs.iDBmark]

    local spellId = aura.spellId
    local duration = aura.duration
    local expirationTime = aura.expirationTime
    local caster = aura.sourceUnit

    if UnitIsUnit(unit, "player") then
        -- 资源条buff
        if RSDB["personalNpBuffEnable"] and aura.isHelpful then
            local filterAll = RSDB["personalNpBuffFilterAll"]
            local filterBlizzard = RSDB["personalNpBuffFilterBlizzard"] and BlizzardShouldShow
            local filterWatchlist = RSDB["personalNpBuffFilterWatchList"] and RSDB["DctAura"][spellId]
            local filterLessMinite = RSDB["personalNpBuffFilterLessMinite"] and (duration > 60 or duration == 0 or expirationTime == 0) 
            if filterAll or filterBlizzard or filterWatchlist then 
                if filterLessMinite then return end
                if RSDB["BlackList"][spellId] then return end
                return true
            end
        end
        -- 资源条 debuff
        if RSDB["personalNpdeBuffEnable"] and aura.isHarmful then
            local filterAll = RSDB["personalNpdeBuffFilterAll"]
            local filterWatchlist = RSDB["personalNpdeBuffFilterWatchList"] and RSDB["DctAura"][spellId]
            local filterLessMinite = RSDB["personalNpdeBuffFilterLessMinite"] and (duration > 60 or duration == 0 or expirationTime == 0) 
            if filterAll or filterWatchlist then 
                if filterLessMinite then return end
                if RSDB["BlackList"][spellId] then return end
                return true
            end
        end
    else
        -- 姓名板 buff
        if RSDB["otherNpBuffEnable"] and aura.isHelpful then
            local filterAll = RSDB["otherNpBuffFilterAll"]
            local filterWatchlist = RSDB["otherNpBuffFilterWatchList"] and RSDB["DctAura"][spellId]
            local filterLessMinite = RSDB["otherNpBuffFilterLessMinite"] and (duration > 60 or duration == 0 or expirationTime == 0) 
            if filterAll or filterWatchlist then
                if filterLessMinite then return end
                if RSDB["BlackList"][spellId] then return end
                return true
            end
        end
        -- 姓名板 debuff
        if RSDB["otherNpdeBuffEnable"] and aura.isHarmful then
            local filterAll = RSDB["otherNpdeBuffFilterAll"]
            local filterBlizzard = RSDB["otherNpdeBuffFilterBlizzard"] and BlizzardShouldShow
            local filterWatchlist = RSDB["otherNpdeBuffFilterWatchList"] and RSDB["DctAura"][spellId]
            local filterLessMinite = RSDB["otherNpdeBuffFilterLessMinite"] and (duration > 60 or duration == 0 or expirationTime == 0) 
            local filterOnlyMe = RSDB["otherNpdeBuffFilterOnlyMe"] and (caster ~= "player" and caster ~= "pet")
            if filterAll or filterWatchlist or filterBlizzard then 
                if filterLessMinite or filterOnlyMe then return end
                if RSDB["BlackList"][spellId] then return end
                return true
            end
        end
    end
end

function rs.OnUnitAuraUpdateRSV(self, unit, unitAuraUpdateInfo)
    local filter;
	local showAll = false;

	local isPlayer = UnitIsUnit("player", unit);
	local reaction = UnitReaction("player", unit);
	-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
	local hostileUnit = reaction and reaction <= 4;
	local showDebuffsOnFriendly = self.showDebuffsOnFriendly;

	local auraSettings =
	{
		helpful = false;
		harmful = false;
		raid = false;
		includeNameplateOnly = false;
		showAll = false;
		hideAll = false;
	};

	if isPlayer then
		auraSettings.helpful = true;
		auraSettings.includeNameplateOnly = true;
		auraSettings.showPersonalCooldowns = self.showPersonalCooldowns;
	else
		if hostileUnit then
			-- Reaction 4 is neutral and less than 4 becomes increasingly more hostile
			auraSettings.harmful = true;
			auraSettings.includeNameplateOnly = true;
		else
			if (showDebuffsOnFriendly) then
				-- dispellable debuffs
				auraSettings.harmful = true;
				auraSettings.raid = true;
				auraSettings.showAll = true;
			else
				auraSettings.hideAll = true;
			end
		end
	end

	local nameplate = C_NamePlate.GetNamePlateForUnit(unit, issecure());
	if (nameplate) then
		-- nameplate.UnitFrame.BuffFrame:UpdateBuffsRSV(nameplate.namePlateUnitToken, unitAuraUpdateInfo, auraSettings);
		rs.UpdateBuffsRSV(nameplate.UnitFrame.BuffFrame, nameplate.namePlateUnitToken, unitAuraUpdateInfo, auraSettings, nameplate.UnitFrame);
		-- if isPlayer and self.personalFriendlyBuffFrame then
		-- 	local auraSettingsFriendlyBuffs = {
		-- 		helpful = true;
		-- 		includeNameplateOnly = true;
		-- 		showFriendlyBuffs = self.showFriendlyBuffs;
		-- 		showPersonalCooldowns = false;
		-- 	};
		-- 	self.personalFriendlyBuffFrame:UpdateBuffs(nameplate.namePlateUnitToken, unitAuraUpdateInfo, auraSettingsFriendlyBuffs);
		-- end
	end
end

function rs.UpdateBuffsRSV(self, unit, unitAuraUpdateInfo, auraSettings, UnitFrame)
    local RSDB = rs.tabDB[rs.iDBmark]

    local filters = {};
	if auraSettings.helpful then
		table.insert(filters, AuraUtil.AuraFilters.Helpful);
	end
	if auraSettings.harmful then
		table.insert(filters, AuraUtil.AuraFilters.Harmful);
	end
	if auraSettings.raid then
		table.insert(filters, AuraUtil.AuraFilters.Raid);
	end
	if auraSettings.includeNameplateOnly then
		table.insert(filters, AuraUtil.AuraFilters.IncludeNameplateOnly);
	end
	local filterString = AuraUtil.CreateFilterString(unpack(filters));

	local previousFilter = self.filter;
	local previousUnit = self.unit;
	self.unit = unit;
	self.filter = filterString;
	self.showFriendlyBuffs = auraSettings.showFriendlyBuffs;

	local aurasChanged = false;
	if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate or unit ~= previousUnit or self.auras == nil or filterString ~= previousFilter then
		rs.ParseAllAurasRSV(self, auraSettings.showAll, UnitFrame);
		aurasChanged = true;
	else
		if unitAuraUpdateInfo.addedAuras ~= nil then
			for _, aura in ipairs(unitAuraUpdateInfo.addedAuras) do
                local BlizzardShouldShow = self:ShouldShowBuff(aura, auraSettings.showAll) and not C_UnitAuras.IsAuraFilteredOutByInstanceID(unit, aura.auraInstanceID, filterString)
				if rs.RsShouldShowBuff(unit, aura, BlizzardShouldShow) then
					self.auras[aura.auraInstanceID] = aura;
					aurasChanged = true;
				end
                --- TempAura 
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

			end
		end

		if unitAuraUpdateInfo.updatedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.updatedAuraInstanceIDs) do
				if self.auras[auraInstanceID] ~= nil then
					local newAura = C_UnitAuras.GetAuraDataByAuraInstanceID(self.unit, auraInstanceID);
					self.auras[auraInstanceID] = newAura;
					aurasChanged = true;
				end

                --- TempAura
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
                --- End
			end
		end

		if unitAuraUpdateInfo.removedAuraInstanceIDs ~= nil then
			for _, auraInstanceID in ipairs(unitAuraUpdateInfo.removedAuraInstanceIDs) do
				if self.auras[auraInstanceID] ~= nil then
					self.auras[auraInstanceID] = nil;
					aurasChanged = true;
				end

                --- Aura Temp
                if UnitFrame.ColorAura[auraInstanceID] then 
                    UnitFrame.ColorAura[auraInstanceID] = nil
                    rs.SetBarColor(UnitFrame)
                end
                if UnitFrame.StolenAura[auraInstanceID] then 
                    UnitFrame.StolenAura[auraInstanceID] = nil
                    rs.SetStolen(UnitFrame)
                end
                --- End
			end
		end
	end

	self:UpdateAnchor();

	if not aurasChanged then
		return;
	end

	self.buffPool:ReleaseAll();

	if auraSettings.hideAll or not self.isActive then
		return;
	end

	local buffIndex = 1;
    local RsMaxAuraNum = RSDB["AuraNum"]
	self.auras:Iterate(function(auraInstanceID, aura)
        if buffIndex > RsMaxAuraNum then return true end
		local buff = self.buffPool:Acquire();
		buff.auraInstanceID = auraInstanceID;
		buff.isBuff = aura.isHelpful;
		buff.layoutIndex = buffIndex;
		buff.spellID = aura.spellId;

        
        
		buff.Icon:SetTexture(aura.icon);
        buff:SetMouseClickEnabled(false)
        if RSDB["SquareAura"] then
            buff:SetSize(RSDB["AuraSize"],RSDB["AuraSize"])
            buff.Icon:SetPoint("TOPLEFT", buff,"TOPLEFT", 1, -1)
            buff.Icon:SetPoint("BOTTOMRIGHT", buff,"BOTTOMRIGHT", -1, 1)
            buff.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
        end
		if (aura.applications > 1) then
			buff.CountFrame.Count:SetText(aura.applications);
			buff.CountFrame.Count:Show();
		else
			buff.CountFrame.Count:Hide();
		end
		CooldownFrame_Set(buff.Cooldown, aura.expirationTime - aura.duration, aura.duration, aura.duration > 0, true);
        buff.Cooldown:SetHideCountdownNumbers(not RSDB["AuraTimer"])
        local regon = buff.Cooldown:GetRegions()
        if regon.GetText then 
            regon:SetFont(STANDARD_TEXT_FONT, RSDB["AuraTimerSize"], "OUTLINE")  --Default : 15 "OUTLINE"
        end

		buff:Show();

		buffIndex = buffIndex + 1;
		return buffIndex >= BUFF_MAX_DISPLAY;
	end);

	--Add Cooldowns 
	-- if(auraSettings.showPersonalCooldowns and buffIndex < BUFF_MAX_DISPLAY and UnitIsUnit(unit, "player")) then 
	-- 	local nameplateSpells = C_SpellBook.GetTrackedNameplateCooldownSpells(); 
	-- 	for _, spellID in ipairs(nameplateSpells) do 
	-- 		if (not self:HasActiveBuff(spellID) and buffIndex < BUFF_MAX_DISPLAY) then
	-- 			local locStart, locDuration = GetSpellLossOfControlCooldown(spellID);
	-- 			local start, duration, enable, modRate = GetSpellCooldown(spellID);
	-- 			if (locDuration ~= 0 or duration ~= 0) then 
	-- 				local spellInfo = C_SpellBook.GetSpellInfo(spellID);
	-- 				if(spellInfo) then 
	-- 					local buff = self.buffPool:Acquire();
	-- 					buff.isBuff = true;
	-- 					buff.layoutIndex = buffIndex;
	-- 					buff.spellID = spellID; 
	-- 					buff.auraInstanceID = nil;
	-- 					buff.Icon:SetTexture(spellInfo.iconID); 

	-- 					local charges, maxCharges, chargeStart, chargeDuration, chargeModRate = GetSpellCharges(spellID);
	-- 					buff.Cooldown:SetEdgeTexture("Interface\\Cooldown\\edge");
	-- 					buff.Cooldown:SetSwipeColor(0, 0, 0);
	-- 					CooldownFrame_Set(buff.Cooldown, start, duration, enable, false, modRate);

	-- 					if (maxCharges and maxCharges > 1) then
	-- 						buff.CountFrame.Count:SetText(charges);
	-- 						buff.CountFrame.Count:Show();
	-- 					else
	-- 						buff.CountFrame.Count:Hide();
	-- 					end
	-- 					buff:Show();
	-- 					buffIndex = buffIndex + 1; 
	-- 				end
	-- 			end
	-- 		end
	-- 	end 
	-- end

	self:Layout();
end

function rs.ParseAllAurasRSV(self, forceAll, UnitFrame)
    local RSDB = rs.tabDB[rs.iDBmark] 

    if self.auras == nil then
		self.auras = TableUtil.CreatePriorityTable(AuraUtil.DefaultAuraCompare, TableUtil.Constants.AssociativePriorityTable);
	else
		self.auras:Clear();
	end

    if next(UnitFrame.ColorAura) then
        UnitFrame.ColorAura = {}
        rs.SetBarColor(UnitFrame)
    end
    if next(UnitFrame.StolenAura) then
        UnitFrame.StolenAura = {}
        rs.SetStolen(UnitFrame)
    end

	local function HandleAura(aura)
        local BlizzardShouldShow = self:ShouldShowBuff(aura, forceAll)
		if rs.RsShouldShowBuff(self.unit, aura, BlizzardShouldShow) then
			self.auras[aura.auraInstanceID] = aura;
		end

        -- From AuraTemp
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
        -- From AuraTemp End

		return false;
	end

	local batchCount = nil;
	local usePackedAura = true;
	AuraUtil.ForEachAura(self.unit, "HARMFUL", batchCount, HandleAura, usePackedAura);
	AuraUtil.ForEachAura(self.unit, "HELPFUL", batchCount, HandleAura, usePackedAura);
end



-- Source
function rs:UpdateAnchor()
    local SquareExtraOffSet = 0
    if rs.tabDB[rs.iDBmark]["SquareAura"] then 
        SquareExtraOffSet = (rs.tabDB[rs.iDBmark]["AuraSize"]-15)
    end

    local isPlayer = self:GetParent().unit and UnitIsUnit("player", self:GetParent().unit)
    local isTarget = self:GetParent().unit and UnitIsUnit(self:GetParent().unit, "target");
	local targetYOffset = self:GetBaseYOffset() + (isTarget and self:GetTargetYOffset() or 0.0);
    if isPlayer then 
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, 5 + targetYOffset + rs.tabDB[rs.iDBmark]["SelfAuraHeight"] + SquareExtraOffSet);
	elseif (self:GetParent().unit and ShouldShowName(self:GetParent())) then
        if rs.tabDB[rs.iDBmark]["NarrowCast"] then
		    self:SetPoint("BOTTOM", self:GetParent(), "TOP", 0, targetYOffset + rs.tabDB[rs.iDBmark]["AuraHeight"] + SquareExtraOffSet - 13);
        else
		    self:SetPoint("BOTTOM", self:GetParent(), "TOP", 0, targetYOffset + rs.tabDB[rs.iDBmark]["AuraHeight"] + SquareExtraOffSet );
        end
	else
		self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, 5 + targetYOffset + rs.tabDB[rs.iDBmark]["AuraHeight"] + SquareExtraOffSet);
	end

end

--RS Fixed 
function rs:UpdateAnchorFixRS()
    local NameExtraOffset = 20
    local SquareExtraOffSet = 0
    if rs.tabDB[rs.iDBmark]["SquareAura"] then 
        SquareExtraOffSet = (rs.tabDB[rs.iDBmark]["AuraSize"]-15)
    end
    if not (self:GetParent() and self:GetParent().unit) then return end 
    if UnitIsUnit("player", self:GetParent().unit) then 
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, rs.tabDB[rs.iDBmark]["SelfAuraHeight"] + SquareExtraOffSet);
    else
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, rs.tabDB[rs.iDBmark]["AuraHeight"] + NameExtraOffset + SquareExtraOffSet);
    end
end
