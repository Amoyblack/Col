

-- CPU usage :  obj Event set << obj Func Override < hookscript == hook

-- Blizzard source frame  --> hook

-- New frame --> set event

-- Dont set event on blizzard np obj cuz it will overide its event

-- so, compromise it by Hooking blizzard ui, Global Set Event on new ui obj that Got by C_N API (api still occupied cpu lightly)


local ADDONName, rs = ...
local L = rs.L

local arrorTexture = "Interface\\AddOns\\RSPlates\\media\\arrorH"
local questTexture = "Interface\\AddOns\\RSPlates\\media\\questQuestion"
local dctTexture = {
    ["s1"] = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill",
    ["s2"] = "Interface\\AddOns\\RSPlates\\media\\bar_rs",
    ["s3"] = "Interface\\AddOns\\RSPlates\\media\\bar_rs_bright",
    ["s4"] = "Interface\\AddOns\\RSPlates\\media\\bar_raid",
    ["s5"] = "Interface\\AddOns\\RSPlates\\media\\bar_raid_bright",
    ["s6"] = "Interface\\AddOns\\RSPlates\\media\\bar_solid",
}

local tabGUID2unit = {}
-------------------------------------------------
function rs.RSOn()
	rs.HookBlizzedFunc()
	if RSPlatesDB["ExpballHelper"] then
		rs.BallScanner()
	end
end
-------------------------------------------------



function rs.On_Np_Add(unitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, false)
    if namePlateFrameBase then
        local unitFrame = namePlateFrameBase.UnitFrame
        unitFrame.healthBar.AuraR, unitFrame.healthBar.AuraG, unitFrame.healthBar.AuraB = nil, nil, nil
        rs.SetGUIDTable(unitToken, UnitGUID(unitToken))
        rs.CreateUIObj(unitFrame, namePlateFrameBase)
        rs.RegExtraUIEvent(unitFrame)
        rs.On_NpRefreshOnce(unitFrame)
    end
end

function rs.On_Np_Remove(unitToken)
    rs.SetGUIDTable(unitToken, nil)
end

function rs.SetGUIDTable(unit, GUID)
    if GUID then
        tabGUID2unit[unit] = GUID
    else
        tabGUID2unit[unit] = nil
    end
end


function rs.On_Np_Create(self, namePlateFrameBase)
    print (self.healthBar, namePlateFrameBase, namePlateFrameBase.healthBar)
end


local function MouseoverOnUpdate(self, elapsed)
    if not UnitIsUnit(self.unit, "mouseover") then
        self:Hide()
    end
end

local function OnNpMouseover(MouseoverFrame)
    if rs.IsLegalUnit(MouseoverFrame) then
        if UnitIsUnit(MouseoverFrame.unit, "mouseover") and not UnitIsUnit(MouseoverFrame.unit, "player") then
            MouseoverFrame:Show()
        else
            MouseoverFrame:Hide()
        end
        MouseoverFrame:SetScript("OnUpdate", MouseoverOnUpdate)
    end
end

local function MouseOverFrame_OnEvent(self, event, ...)
    if event == "UPDATE_MOUSEOVER_UNIT" then
        OnNpMouseover(self)
    end
end

-- abandon test func
local function CastingExpandFrame_OnHookScript(self, escape)
    local castingTime
    local unitframe = self:GetParent()
    if (self.maxValue - self.value)<0 then
        castingTime = ""
    elseif UnitCastingInfo(self.unit) then
        castingTime = string.format("%.1f", self.maxValue - self.value, 0)
    elseif UnitChannelInfo(self.unit) then
        castingTime = string.format("%.1f", self.value, 0)
    end
    unitframe.CastingExpandFrame.CastingTimer:SetText(castingTime)
end

-- 0.1ms（to next test, old data) CPU per uf
local function CastingTimerUpdate(self, escape)
        local castingTime
        local UnitFramecastBar = self:GetParent()
        if not UnitFramecastBar.maxValue then return end
        if (UnitFramecastBar.maxValue - UnitFramecastBar.value)<0 then
            castingTime = " "
        elseif UnitCastingInfo(UnitFramecastBar.unit) then
            castingTime = string.format("%.1f", UnitFramecastBar.maxValue - UnitFramecastBar.value, 0)
        elseif UnitChannelInfo(UnitFramecastBar.unit) then
            castingTime = string.format("%.1f", UnitFramecastBar.value, 0)
        end
        self.CastingTimer:SetText(castingTime)
        self.CastingTimer:Show()
        -- print(UnitFramecastBar, self, UnitFramecastBar.maxValue, UnitFramecastBar.value)
        -- print(castingTime)
end

local function CastingExpandFrame_OnSetEvent(self, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, iSpell = ...
        if unit == "player" and RSPlatesDB["DctInterrupteSpell"][iSpell] then
            C_Timer.After(0.05, function()
                local castBar = self:GetParent()
                rs.RefInterrupteIndicator(castBar:GetParent())
            end)
        end
    end
end

function rs.RegExtraUIEvent(unitFrame)
    -- remove 会 unRegallevent, release pool , 不要判断rsed, each time
    if RSPlatesDB["MouseoverGlow"] then
        unitFrame.MouseoverFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
        unitFrame.MouseoverFrame:SetScript("OnEvent", MouseOverFrame_OnEvent)
    else
        unitFrame.MouseoverFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
        unitFrame.MouseoverFrame:SetScript("OnEvent", nil)
    end

    -- +0.7s
    -- unitFrame.castBar:HookScript("OnUpdate", CastingExpandFrame_OnHookScript)
    if RSPlatesDB["CastTimer"] then
        unitFrame.CastingExpandFrame:SetScript("OnUpdate", CastingTimerUpdate)
    else
        unitFrame.CastingExpandFrame:SetScript("OnUpdate", nil)
        unitFrame.CastingExpandFrame.CastingTimer:Hide()
    end

    if RSPlatesDB["CastInterrupteIndicatorEnable"] then
        unitFrame.CastingExpandFrame:SetScript("OnEvent", CastingExpandFrame_OnSetEvent)
        unitFrame.CastingExpandFrame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
    else
        unitFrame.CastingExpandFrame:SetScript("OnEvent", nil)
        unitFrame.CastingExpandFrame.InterrupteIndicator:Hide()
    end


end

---------------------------------------------------

function rs.CreateUIObj(unitFrame, namePlate)

    local unit = unitFrame.unit
    if not unit then return end
    if unitFrame.MouseoverFrame then
        unitFrame.MouseoverFrame.unit = unit
    end


	if not unitFrame.rsed then


        unitFrame.BuffFrame.UpdateBuffs = rs.UpdateBuffsRS
        unitFrame.BuffFrame.UpdateAnchor = rs.UpdateAnchor

		-- 施法条毛玻璃边
		unitFrame.castBar.castBG = rs.CreateBackDrop(unitFrame.castBar, unitFrame.castBar, 1)

		-- 施法图标 黑边
		unitFrame.castBar.Icon.iconborder = rs.CreateBG(unitFrame.castBar.Icon)
		unitFrame.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)  -- IconLayer = 1

		if not RSPlatesDB["NarrowCast"] then
			unitFrame.castBar.Icon.iconborder:Hide()
			unitFrame.castBar.castBG:Hide()
		end


		-- 血量
		unitFrame.healthBar.value = rs.createtext(unitFrame.healthBar, "OVERLAY", 11, "OUTLINE", "CENTER")
		unitFrame.healthBar.value:SetShadowColor(0,0,0,1)
		unitFrame.healthBar.value:SetShadowOffset(0.5,-0.5)
		unitFrame.healthBar.value:SetTextColor(1,1,1)
		unitFrame.healthBar.value:Hide()
		if RSPlatesDB["CenterDetail"] then
			unitFrame.healthBar.value:SetPoint("BOTTOM", unitFrame.healthBar, "CENTER", 0, -4)
		else
			unitFrame.healthBar.value:SetPoint("BOTTOMRIGHT", unitFrame.healthBar, "RIGHT", 0, -4)
		end

		-- 箭头 new ui
		unitFrame.healthBar.curTarget = unitFrame.healthBar:CreateTexture("ArrowH", "OVERLAY")
		unitFrame.healthBar.curTarget:SetSize(50, 50)
		unitFrame.healthBar.curTarget:SetTexture(arrorTexture)
		unitFrame.healthBar.curTarget:SetPoint("LEFT", unitFrame.healthBar, "RIGHT", 0, 0)
		unitFrame.healthBar.curTarget:Hide()

        -- 鼠标指向 new ui
        unitFrame.MouseoverFrame = CreateFrame("Frame", nil, unitFrame)
        unitFrame.MouseoverFrame.unit = unit
		unitFrame.MouseoverFrame:Hide()

        unitFrame.MouseoverFrame.Glow =  unitFrame.MouseoverFrame:CreateTexture("mouseoverhighlight", "BACKGROUND", nil, -3)
        unitFrame.MouseoverFrame.Glow:SetTexture("Interface\\AddOns\\RSPlates\\media\\spark-flat")
        unitFrame.MouseoverFrame.Glow:SetPoint("TOPLEFT", unitFrame.healthBar, "TOPLEFT", -25, 15)
        unitFrame.MouseoverFrame.Glow:SetPoint("BOTTOMRIGHT", unitFrame.healthBar, "BOTTOMRIGHT", 25, -15)
        unitFrame.MouseoverFrame.Glow:SetVertexColor(1, .95, .25, 1)

        unitFrame.MouseoverFrame.Border =  unitFrame.MouseoverFrame:CreateTexture("MGlowBorder", "BACKGROUND", nil, -2)
        unitFrame.MouseoverFrame.Border:SetTexture("Interface\\AddOns\\RSPlates\\media\\bar_solid")
        unitFrame.MouseoverFrame.Border:SetPoint("TOPLEFT", unitFrame.healthBar, "TOPLEFT", -3, 3)
        unitFrame.MouseoverFrame.Border:SetPoint("BOTTOMRIGHT", unitFrame.healthBar, "BOTTOMRIGHT", 3, -3)
        unitFrame.MouseoverFrame.Border:SetVertexColor(1, .95, .25, 1)

        -- 施法条 Frame Expand
        unitFrame.CastingExpandFrame = CreateFrame("Frame", nil, unitFrame.castBar)
        unitFrame.CastingExpandFrame.unit = unit
        unitFrame.CastingExpandFrame:Show()

        -- Target
        unitFrame.CastingExpandFrame.CastingTarget = rs.createtext(unitFrame.castBar, "OVERLAY", 12, "OUTLINE", "CENTER")
        unitFrame.CastingExpandFrame.CastingTarget:SetPoint("LEFT", unitFrame.castBar, "RIGHT", 0, 0)
        unitFrame.CastingExpandFrame.CastingTarget:Hide()

        -- Timer
        unitFrame.CastingExpandFrame.CastingTimer = rs.createtext(unitFrame.castBar, "OVERLAY", 12, "OUTLINE", "CENTER")
        unitFrame.CastingExpandFrame.CastingTimer:SetPoint("RIGHT", unitFrame.castBar, "RIGHT", 0, 0)
        unitFrame.CastingExpandFrame.CastingTimer:Hide()

        -- Interrupte Indicator

        unitFrame.CastingExpandFrame.InterrupteIndicator = CreateFrame("Frame", nil, unitFrame.CastingExpandFrame)
        unitFrame.CastingExpandFrame.InterrupteIndicator:SetSize(7, 7)
		unitFrame.CastingExpandFrame.InterrupteIndicator:SetPoint("BOTTOMLEFT", unitFrame.healthBar, "TOPLEFT", 0, 3)
		unitFrame.CastingExpandFrame.InterrupteIndicator:Hide()

        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture = unitFrame.CastingExpandFrame.InterrupteIndicator:CreateTexture("InterrupteIndicator", "BACKGROUND")
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetTexture("Interface\\AddOns\\RSPlates\\media\\bar_solid")
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetVertexColor(0,.9,0)
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetAllPoints()

        unitFrame.CastingExpandFrame.InterrupteIndicator.around = rs.CreateBackDrop(unitFrame.CastingExpandFrame.InterrupteIndicator, unitFrame.CastingExpandFrame.InterrupteIndicator, 2)




		-- 任务 new ui
		unitFrame.healthBar.questIcon = unitFrame.healthBar:CreateTexture("QuestIcon", "OVERLAY")
		unitFrame.healthBar.questIcon:SetSize(30, 30)
		unitFrame.healthBar.questIcon:SetTexture(questTexture)
		unitFrame.healthBar.questIcon:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, 45)
		unitFrame.healthBar.questIcon:SetVertexColor(.96, .85 , .1)
		unitFrame.healthBar.questIcon:Hide()

		-- 偷取/驱散buff模块 new ui
		unitFrame.StolenFrame = CreateFrame("Frame", nil, unitFrame.healthBar)
		unitFrame.StolenFrame:SetSize(25, 25)
		unitFrame.StolenFrame:SetPoint("LEFT", unitFrame.healthBar, "RIGHT", 10, 0)
		unitFrame.StolenFrame:Hide()

		unitFrame.StolenFrame.Texture = unitFrame.StolenFrame:CreateTexture(nil, "OVERLAY")
		unitFrame.StolenFrame.Texture:SetAllPoints()

		unitFrame.StolenFrame.around = rs.CreateBackDrop(unitFrame.StolenFrame, unitFrame.StolenFrame, 2)

		unitFrame.StolenFrame.Cooldown = CreateFrame("Cooldown", nil, unitFrame.StolenFrame, "CooldownFrameTemplate")
		unitFrame.StolenFrame.Cooldown:SetAllPoints()
		unitFrame.StolenFrame.Cooldown:SetReverse(true)
		unitFrame.StolenFrame.Cooldown:SetHideCountdownNumbers(true)

        namePlate.NpcNameRS = rs.createtext(namePlate, "OVERLAY", 12, "OUTLINE", "CENTER")
        namePlate.NpcNameRS:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, 0)
		namePlate.NpcNameRS:Hide()

        -- target glow new ui
        namePlate.NameSelectGlow = namePlate:CreateTexture("targethighlight", "BACKGROUND", nil, -1)
        namePlate.NameSelectGlow:SetTexture("Interface\\AddOns\\RSPlates\\media\\spark-flat")
        namePlate.NameSelectGlow:SetPoint("TOPLEFT", namePlate.NpcNameRS, "TOPLEFT", 0, 7)
        namePlate.NameSelectGlow:SetPoint("BOTTOMRIGHT", namePlate.NpcNameRS, "BOTTOMRIGHT", 0, -7)
        namePlate.NameSelectGlow:SetVertexColor(1, 1, 1, .8)
        -- namePlate.NameSelectGlow:SetTexCoord(0, 1, 1, 0)
        namePlate.NameSelectGlow:SetBlendMode("ADD")
        namePlate.NameSelectGlow:Hide()

		unitFrame.rsed = true
	end
end


---- Method
--------------------------------------

--血条数值
function rs.SetBloodText(unitFrame)
    if rs.IsLegalUnit(unitFrame) then
        if unitFrame.healthBar.value then
            if UnitIsUnit("player", unitFrame.unit) then
                unitFrame.healthBar.value:Hide()
                return
            end

            unitFrame.healthBar.value:Show()
            unitFrame.healthBar.value:SetText(rs.GetDetailText(unitFrame.unit))
        end
    end
end

function rs.IsLegalUnit(frame)
    if not (frame and frame.unit) then return end
    if not string.match(frame.unit, "nameplate") then return end
    if frame:IsForbidden() then return end
    return true
end


function rs.SetBarColor(frame)
    if rs.IsLegalUnit(frame) then
        local unit = frame.unit

        local r, g, b, a
        local guid = UnitGUID(frame.unit)
        local _, _, _, _, _, id = strsplit("-", guid or "")
        local _, threatStatus = UnitDetailedThreatSituation("player", unit)
        local NpcColor = RSPlatesDB["DctColorNpc"][tonumber(id)]

        -- 锁定玩家颜色
        if RSPlatesDB["LockPlayerColor"] and (UnitIsPlayer(unit) or UnitIsPossessed(unit) or UnitPlayerControlled(unit)) then
            do end

        elseif RSPlatesDB["TargetColorEnable"] and UnitIsUnit("target", unit) and not UnitIsUnit("player", unit) then
            r, g, b = RSPlatesDB["TargetColor"][1], RSPlatesDB["TargetColor"][2], RSPlatesDB["TargetColor"][3]

        -- 资源条不染色
        elseif UnitIsUnit("player", unit) then
            do end
        -- 灰名
        elseif UnitIsTapDenied(unit) then
            do end
        -- 1 自定义NpcID
        elseif NpcColor then
            r, g, b = NpcColor[1], NpcColor[2], NpcColor[3]
        -- 2 携带自定义光环
        elseif frame.healthBar.AuraColor then
            r, g, b = frame.healthBar.AuraColor[1], frame.healthBar.AuraColor[2], frame.healthBar.AuraColor[3]
        -- 3 斩杀
        elseif RSPlatesDB["SlayEnable"] and rs.IsOnKillHealth(unit) then
            r, g, b = RSPlatesDB["SlayColor"][1], RSPlatesDB["SlayColor"][2], RSPlatesDB["SlayColor"][3]

        -- 4 仇恨，目标与玩家处于战斗状态
        elseif RSPlatesDB["ThreatColorEnable"] and threatStatus then
            r, g, b = rs.IsOnThreatList(frame.unit)
        end



        if not r then
            r, g, b =  frame.healthBar.r, frame.healthBar.g, frame.healthBar.b
        end

        frame.healthBar:SetStatusBarColor(r, g, b);

        if (frame.optionTable.colorHealthWithExtendedColors) then
            frame.selectionHighlight:SetVertexColor(r, g, b);
        else
            frame.selectionHighlight:SetVertexColor(1, 1, 1);
        end
        if RSPlatesDB["BarBgCol"] then
            if UnitIsUnit("player", unit) then
                frame.healthBar.background:SetColorTexture(.5 , .5, .5,.1)
            else
                frame.healthBar.background:SetColorTexture(2/5*r, 2/5*g, 2/5*b, .7)
            end
        end
    end

end


function rs.SetName(frame)
    if rs.IsLegalUnit(frame) then
        rs.SetNameMode(frame)

        if frame.name then
            if RSPlatesDB["NameWhite"] then
                frame.name:SetVertexColor(1, 1, 1)
            end
            if RSPlatesDB["NameSizeEnable"] then
                frame.name:SetFont(STANDARD_TEXT_FONT, RSPlatesDB["NameSize"], nil)
            end
        end
    end
end


function rs.ThinCastBar(self, event, ...)
    if rs.IsLegalUnit(self) then
        -- Thin cast bar
        if RSPlatesDB["NarrowCast"]then
            local function SetThin(self)
                self.Icon:SetShown(true)
                -- self.Icon:SetTexture(texture)
                self:SetHeight(RSPlatesDB["CastHeight"])
                self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -3, 0)
                self.Icon:SetSize(RSPlatesDB["CastHeight"] + 13, RSPlatesDB["CastHeight"] + 13)  -- 13 + height
                self.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
                self.BorderShield:SetPoint("LEFT",self, "LEFT", -2, 0)
            end

            SetThin(self)
            self:SetScript("OnSizeChanged", function ( ... )
                SetThin(self)
            end)
        end
    end
end


function rs.RefCastingTarget(frame)
    if not RSPlatesDB["CastTarget"] then
        frame.CastingExpandFrame.CastingTarget:Hide()
        return
    end
    if rs.IsLegalUnit(frame) then
        if UnitCastingInfo(frame.unit) ~= nil or UnitChannelInfo(frame.unit) ~= nil then
            local targetunit = string.format("%starget", frame.unit)
            local sUnit = UnitName(targetunit)
            local color = {["r"] = 1, ["g"] = 1, ["b"] = 1}
            if sUnit then
                if UnitIsPlayer(targetunit) then
                    color = RAID_CLASS_COLORS[select(2, UnitClass(targetunit))]
                end
                frame.CastingExpandFrame.CastingTarget:SetText(string.format(" [%s]", sUnit))
                frame.CastingExpandFrame.CastingTarget:SetTextColor(color.r, color.g, color.b)
                frame.CastingExpandFrame.CastingTarget:Show()
            else
                frame.CastingExpandFrame.CastingTarget:SetText("")
                frame.CastingExpandFrame.CastingTarget:Show()
            end
        end
    end
end


function rs.RefInterrupteIndicator(frame)
    if not frame.unit then return end
    if not RSPlatesDB["CastInterrupteIndicatorEnable"] then
        frame.CastingExpandFrame.InterrupteIndicator:Hide()
        return
    end
    local notInterruptible
    notInterruptible = select(8, UnitCastingInfo(frame.unit))
    if notInterruptible == nil then
        notInterruptible = select(7, UnitChannelInfo(frame.unit))
    end

    -- unit is casting
    if notInterruptible ~= nil then
        if notInterruptible == true then
            frame.CastingExpandFrame.InterrupteIndicator:Hide()
        else
            for i,v in pairs(RSPlatesDB["DctInterrupteSpell"]) do
                if IsSpellKnown(i) then
                    local start, duration, enable = GetSpellCooldown(i)
                    if duration == 0 then
                        frame.CastingExpandFrame.InterrupteIndicator:Show()
                        return
                    else
                        frame.CastingExpandFrame.InterrupteIndicator:Hide()
                    end
                end
            end
        end
    -- unit is not casting
    else
        frame.CastingExpandFrame.InterrupteIndicator:Hide()
    end
end

function rs.GetDetailText(unit)
	local iType = RSPlatesDB["DetailType"]
	if iType == "s1" then return "" end

	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)

	local fPer = string.format("%.0f%%",(CurHealth/MaxHealth*100))
	local fCur

	if RSPlatesDB["WesternDetail"] then
		if CurHealth > 1000 and CurHealth<1000000 then
			fCur = string.format("%.1fK", CurHealth/1000)
		elseif CurHealth > 1000000  then
			fCur = string.format("%.1fM", CurHealth/1000000)
		else
			fCur = tostring(CurHealth)
		end
	else
		if CurHealth > 10000 and CurHealth < 100000000 then
			fCur = string.format("%.1f万", CurHealth/10000)
		elseif CurHealth > 100000000 then
			fCur = string.format("%.1f亿", CurHealth/100000000)
		else
			fCur = tostring(CurHealth)
		end
	end


	if iType == "s2" then  --百分比
		return fPer

	elseif iType == "s3" then --数值
		return fCur

	elseif iType == "s4" then --数值/百分比
        return string.format("%s / %s",fCur, fPer)
	end
end


function rs.IsOnThreatList(unit)
	local _, threatStatus = UnitDetailedThreatSituation("player", unit)
	if threatStatus == 3 then  --穩定仇恨，當前坦克/securely tanking, highest threat
        return RSPlatesDB["TankSafeColor"][1], RSPlatesDB["TankSafeColor"][2], RSPlatesDB["TankSafeColor"][3]
		-- return .9, .1, .4  --紅色/red
	elseif threatStatus == 2 then  --非當前仇恨，當前坦克(已OT或坦克正在丟失仇恨)/insecurely tanking, another unit have higher threat but not tanking.
        return RSPlatesDB["TankLoseColor"][1], RSPlatesDB["TankLoseColor"][2], RSPlatesDB["TankLoseColor"][3]
		-- return .9, .1, .9  --粉色/pink
	elseif threatStatus == 1 then  --當前仇恨，非當前坦克(非坦克高仇恨或坦克正在獲得仇恨)/not tanking, higher threat than tank.
        return RSPlatesDB["dpsOTColor"][1], RSPlatesDB["dpsOTColor"][2], RSPlatesDB["dpsOTColor"][3]
		-- return .4, .1, .9  --紫色/purple
	elseif threatStatus == 0 then  --低仇恨，安全/not tanking, lower threat than tank.
        return RSPlatesDB["dpsSafeColor"][1], RSPlatesDB["dpsSafeColor"][2], RSPlatesDB["dpsSafeColor"][3]
		-- return .1, .7, .9  --藍色/blue
	end
end


function rs.IsOnKillHealth(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)
	return ((CurHealth/MaxHealth) < RSPlatesDB["Slayline"]/100);
end


function rs.SetSelectionHighlight(unitFrame)
    if rs.IsLegalUnit(unitFrame) then
        if not unitFrame.healthBar.curTarget then return end
        local unit = unitFrame.unit
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)

        if UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player") then
            if RSPlatesDB["ShowArrow"] then
                unitFrame.healthBar.curTarget:Show()
            else
                unitFrame.healthBar.curTarget:Hide()
            end

            unitFrame:SetAlpha(1)
            -- unitFrame.castBar.Icon:SetAlpha(1)
            -- Namemode Select Glow
            if namePlate and namePlate.NpcNameRS then
                if namePlate.NpcNameRS:IsShown() then
                    namePlate.NameSelectGlow:Show()
                end
            end

        else
            unitFrame.healthBar.curTarget:Hide()
            if UnitIsUnit(unit, "player") then
                unitFrame:SetAlpha(1)
            else
                unitFrame:SetAlpha(RSPlatesDB["UnSelectAlpha"])
                -- unitFrame.castBar.Icon:SetAlpha(RSPlatesDB["UnSelectAlpha"])
            end

            -- Namemode Select Glow
            if namePlate and namePlate.NameSelectGlow then
                namePlate.NameSelectGlow:Hide()
            end
        end
        -- 精英图标
        if not RSPlatesDB["EliteIcon"] then
            unitFrame.ClassificationFrame:Hide()
        else
            unitFrame.ClassificationFrame:Show()
        end
    end
end


function rs.SetUnitQuestState(unitFrame)
    if rs.IsLegalUnit(unitFrame) then
        local inInstance, instanceType = IsInInstance()
        if not inInstance and rs.IsQuestUnit(unitFrame.unit) and RSPlatesDB["ShowQuestIcon"] then
            unitFrame.healthBar.questIcon:Show()
            return
        end
        unitFrame.healthBar.questIcon:Hide()
    end
end



--血条材质
function rs.SetBarTexture(unitFrame)
    local texturePath = dctTexture[RSPlatesDB["BarTexture"]]
    if texturePath then
		unitFrame.healthBar:SetStatusBarTexture(texturePath)
		unitFrame.castBar:SetStatusBarTexture(texturePath)
		ClassNameplateManaBarFrame:SetStatusBarTexture(texturePath)
	end
end



---手动设置一次需要设置的
function rs.On_NpRefreshOnce(unitFrame)
	rs.SetBarTexture(unitFrame)

	rs.SetBloodText(unitFrame)

	rs.SetSelectionHighlight(unitFrame)

    rs.SetBarColor(unitFrame)

	rs.SetUnitQuestState(unitFrame)

	rs.RefAuraForOneNp(unitFrame)

    rs.SetName(unitFrame)

    rs.RefCastingTarget(unitFrame)

    rs.RefInterrupteIndicator(unitFrame)
end


function rs.RefAuraForOneNp(unitFrame)
	local unit = unitFrame.unit
	if not unit then return end
    NamePlateDriverFrame:OnUnitAuraUpdate(unit, true, nil)
end


--- Hook Part
------------------------------------------------

function rs.HookBlizzedFunc()
    -- print('---> hoocsuccessful')

    -- Size Change
    hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function()
        for k, namePlate in pairs(C_NamePlate.GetNamePlates()) do
            rs.On_NpRefreshOnce(namePlate.UnitFrame)
        end
    end)

    -- Unit Faction
    hooksecurefunc(NamePlateDriverFrame, "OnUnitFactionChanged", function(self,unit)
        if not string.match(unit, "nameplate") then return end
        local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)
        if npbase then
            rs.On_NpRefreshOnce(npbase.UnitFrame)
        end
            -- print("OnUnitFactionChanged", unit, UnitName(unit))
    end)

    -- Thin CastBar
    hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)
        rs.ThinCastBar(self, event, ...)
    end)
    hooksecurefunc("CastingBarFrame_OnShow", function(self)
    	rs.ThinCastBar(self)
    end)


    -- Do nothing  + 0.8ms
    -- hooksecurefunc("CastingBarFrame_OnUpdate", function(self, escape)
    --     CastingExpandFrame_OnHookScript(self, escape)
    -- end)


    -- 名字
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        rs.SetName(frame)
    end)


    -- 血条颜色
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
        rs.SetBarColor(frame)
    end)

    -- -- 目标选择
    hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", function(frame)
        rs.SetSelectionHighlight(frame)
        rs.SetBarColor(frame)
    end)
end



----------ONLOAD EVENT---------

-- todo: 更新逻辑重做,抽一个单独模块解耦

local loadFrame = CreateFrame("FRAME");
loadFrame:RegisterEvent("ADDON_LOADED");
-- loadFrame:RegisterEvent("PLAYER_LOGOUT");
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadFrame:RegisterEvent("LOADING_SCREEN_DISABLED")

function loadFrame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == ADDONName then
        rs.V.AddonFirstLoad = false
        local hasbeenForced
		if not RSPlatesDB then
			rs.V.AddonFirstLoad = true
			RSPlatesDB = rs.V.DefaultSetting
		else
            -- 版本号不一样
            if RSPlatesDB["Version"] ~= rs.V.DefaultSetting["Version"] then
                rs.V.AddonFirstLoad = true
                RSPlatesDB, hasbeenForced = rs.GetMarginDB(RSPlatesDB)
                if not hasbeenForced then
                    -- print (rs.L["UpdateInfo"])
                    print ("|cffFFD700---RSPlates"..L["UpdateVersion"].."|r"..RSPlatesDB["Version"] )
                else
                    print(rs.L["UpdateForce"])
                    print("|cffFFD700---RSPlates: "..L["UpdateVersion"].."|r"..RSPlatesDB["Version"] )
                end
            -- 版本号一样长度不一样 (因为意外导致版本升级时DB复写失败？ is possible????)
            elseif rs.table_leng(RSPlatesDB) ~= rs.table_leng(rs.V.DefaultSetting) then
                rs.V.AddonFirstLoad = true
                RSPlatesDB, hasbeenForced = rs.GetMarginDB(RSPlatesDB)
            end
        end

			-- -- 代码库与玩家存储的配置长度不一样时，直接更新
			-- if (rs.table_leng(RSPlatesDB) ~= rs.table_leng(rs.V.DefaultSetting)) then
			-- 	RSPlatesDB = rs.V.DefaultSetting
			-- 	rs.V.AddonFirstLoad = true
			-- 	print ("|cffFFD700---RSPlates : "..L["UpdateInfo"].." |r")
			-- 	print ("|cffFFD700---".. L["UpdateVersion"]..": |r"..RSPlatesDB["Version"] )

			-- -- 长度一样，版本号不同，只更新版本号
			-- elseif RSPlatesDB["Version"] ~= rs.V.DefaultSetting["Version"] then
			-- 	-- RSPlatesDB["Version"] = rs.V.DefaultSetting["Version"]
            --     RSPlatesDB = rs.V.DefaultSetting
			-- 	rs.V.AddonFirstLoad = true
            --     print ("|cffFFD700---RSPlates : "..L["UpdateInfo"].." |r")
			-- 	print ("|cffFFD700---".. L["UpdateVersion"]..": |r"..RSPlatesDB["Version"] )
			-- end

        rs.OnColCheck()
		rs.RSOn()
        rs.InitMinimapBtn()
        -- rs.SwitchConfigGUI()

    -- time : entering_world --> WA set --> loading_screen_disabled
    elseif event == "PLAYER_ENTERING_WORLD" then
        if rs.V.AddonFirstLoad then
            rs.SetCVarOnFirstTime()
        end
    elseif event == "LOADING_SCREEN_DISABLED" then
        C_Timer.After(1, rs.UpdateCvars)
	end
end
loadFrame:SetScript("OnEvent", loadFrame.OnEvent);



----------- On Check Margin Col ---------------------


function rs.OnColCheck()
	for i = 1, GetNumAddOns() do
		local name, title, notes, enabled, loadable, reason, security = GetAddOnInfo(i);
        if name == "Col" and title == "|cff00FF7FRS|rPlates" then
            rs.SwitchColMarginInfoWindow()
        end
	end
end


------------------------------------------------------------


local function UIObj_Event(self, event, ...)
    if event == "NAME_PLATE_UNIT_ADDED" then
        local unit = ...
        rs.On_Np_Add(unit)

    elseif event == "NAME_PLATE_UNIT_REMOVED" then
        local unit = ...
        rs.On_Np_Remove(unit)

    elseif event == "UNIT_HEALTH" then
        local unit = ...
        local frame = C_NamePlate.GetNamePlateForUnit(unit, false)
        if frame then
            rs.SetBloodText(frame.UnitFrame)
            rs.SetBarColor(frame.UnitFrame)
        end

    elseif event == "UNIT_AURA" then
        local unit, isFullUpdate, updatedAuraInfos = ...
        if not string.match(unit, "nameplate") then return end
        rs:OnUnitAuraUpdateRS(unit, isFullUpdate, updatedAuraInfos)

    elseif event == "UNIT_TARGET" then
        -- local unit = ...
        -- if not string.match(unit, "nameplate") then return end
        -- local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)  -- safe,  no need to check
        -- if npbase then
        --     rs.RefCastingTarget(npbase.UnitFrame)
        -- end

    -- todo : 找出延迟的原因, UNIT_TARGET 可以解决部分但仍有少数情况失效，先延迟处理（逻辑上也更倾向于只判断初始阶段而非过程中UNIT_TARGET)
    elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
        if RSPlatesDB["CastTarget"] or RSPlatesDB["CastInterrupteIndicatorEnable"] then
            local unit, _, _ = ...
            if not string.match(unit, "nameplate") then return end
            local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)
            if npbase and RSPlatesDB["CastTarget"] then
                C_Timer.After(0.1, function()
                    rs.RefCastingTarget(npbase.UnitFrame)
                end)
            end
            if npbase and RSPlatesDB["CastInterrupteIndicatorEnable"] then
                rs.RefInterrupteIndicator(npbase.UnitFrame)
            end
        end

        -- elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
        -- local unit, _, _ = ...

    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
        if subevent == "SPELL_INTERRUPT" then
            for npUnit, npGUID in pairs(tabGUID2unit) do
                if npGUID == destGUID then
                    local npbase = C_NamePlate.GetNamePlateForUnit(npUnit)
                    if npbase then
                        npbase.UnitFrame.CastingExpandFrame.CastingTarget:Hide()
                        npbase.UnitFrame.CastingExpandFrame.InterrupteIndicator:Hide()
                        if not RSPlatesDB["CastInterrupteFrom"] then return end
                        if sourceName then
                            local name, server = strsplit("-", sourceName)
                            -- print("-----", npUnit, npGUID , destGUID)
                            -- print("打断者", sourceName)
                            -- print("被打断者：", UnitName(npUnit))
                            local colorStr = "ffFFFFFF"

                            if C_PlayerInfo.GUIDIsPlayer(sourceGUID) then
                                local localizedClass, englishClass, localizedRace, englishRace, sex, _name, realm = GetPlayerInfoByGUID(sourceGUID)
                                colorStr = RAID_CLASS_COLORS[englishClass].colorStr
                            end
                            npbase.UnitFrame.castBar.Text:SetText(string.format("|c%s[%s]|r 打断", colorStr, name))
                        end
                    end
                end
            end
        end

    end
end


local UIObjectDriveFrame = CreateFrame("Frame", "RS_Plates", UIParent)
UIObjectDriveFrame:SetScript("OnEvent", UIObj_Event)
UIObjectDriveFrame:RegisterEvent("UNIT_HEALTH")
UIObjectDriveFrame:RegisterEvent("UNIT_AURA")
UIObjectDriveFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
UIObjectDriveFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

-- UIObjectDriveFrame:RegisterEvent("UNIT_TARGET")
UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_START")
UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
-- UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
UIObjectDriveFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")



SLASH_TEST1 = "/rslog"
SlashCmdList.TEST = function()
    -- for i, k in pairs(tabGUID2unit) do
    --     print(i, k)
    -- end
end

SLASH_CONFIG1 = "/rs"
SlashCmdList.CONFIG = function() rs.SwitchConfigGUI() end


