local addon, rs = ...


function rs:UpdateAnchor()
    if not (self:GetParent() and self:GetParent().unit) then return end 
    if UnitIsUnit("player", self:GetParent().unit) then 
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, 20);
    else
        self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, RSPlatesDB["AuraHeight"]);
    end
end



function rs.UpdateBuffsOri(self, unit, filter, showAll)
    local hasColorAura
    local hasStolenAura
    local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
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
                    if RSPlatesDB["SquareAura"] then 
                        self.buffList[buffIndex]:SetSize(RSPlatesDB["AuraSize"],RSPlatesDB["AuraSize"])
                        self.buffList[buffIndex].Icon:SetPoint("TOPLEFT",self.buffList[buffIndex],"TOPLEFT", 1, -1)
                        self.buffList[buffIndex].Icon:SetPoint("BOTTOMRIGHT",self.buffList[buffIndex],"BOTTOMRIGHT", -1, 1)
                        self.buffList[buffIndex].Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
                    end
                    self.buffList[buffIndex].Cooldown:SetHideCountdownNumbers(not RSPlatesDB["AuraTimer"])
                    local regon = self.buffList[buffIndex].Cooldown:GetRegions()
                    if regon.GetText then 
                        regon:SetFont(STANDARD_TEXT_FONT, RSPlatesDB["AuraTimerSize"], nil)  --Default : 15 "OUTLINE"
                    end
				end
				local buff = self.buffList[buffIndex];
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
            rs.SetBarColor(namePlate.UnitFrame)
        end


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
