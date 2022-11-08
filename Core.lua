

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
    ["s2"] = "Interface\\TargetingFrame\\UI-TargetingFrame-BarFill",
    ["s3"] = "Interface\\AddOns\\RSPlates\\media\\bar_rs",
    ["s4"] = "Interface\\AddOns\\RSPlates\\media\\bar_rs_bright",
    ["s5"] = "Interface\\AddOns\\RSPlates\\media\\bar_raid",
    ["s6"] = "Interface\\AddOns\\RSPlates\\media\\bar_raid_bright",
    ["s7"] = "Interface\\AddOns\\RSPlates\\media\\bar_solid",
    ["s8"] = "Interface\\MyRsTexture",
}

local tabGUID2unit = {}

local rgbYello = {245/256, 161/256, 5/256}
local rgbGreen = {0/256, 250/256, 0/256}
local rgbGrey = {180/256, 180/256, 180/256}
local rgbRed = {256/256, 0/256, 0/256}

-------------------------------------------------
function rs.RSOn()
    if not rs.tabDB[rs.iDBmark]["DynamicHeightOffSet"] then 
        rs.UpdateAnchor = rs.UpdateAnchorFixRS
    end
	rs.HookBlizzedFunc()
	if rs.tabDB[rs.iDBmark]["ExpballHelper"] then
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
        -- print(castingTime)
end


local function CastingExpandFrame_OnSetEvent(self, event, ...)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unit, castGUID, iSpell = ...
        if unit == "player" and rs.tabDB[rs.iDBmark]["DctInterrupteSpell"][iSpell] then
            C_Timer.After(0.05, function()
                local castBar = self:GetParent()
                rs.RefInterrupteIndicator(castBar:GetParent())
            end)
        end
    end
end


function rs.RegExtraUIEvent(unitFrame)
    -- remove 会 unRegallevent, release pool , 不要判断rsed, each time
    if rs.tabDB[rs.iDBmark]["MouseoverGlow"] then
        unitFrame.MouseoverFrame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
        unitFrame.MouseoverFrame:SetScript("OnEvent", MouseOverFrame_OnEvent)
    else
        unitFrame.MouseoverFrame:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
        unitFrame.MouseoverFrame:SetScript("OnEvent", nil)
    end

    -- +0.7s
    -- unitFrame.castBar:HookScript("OnUpdate", CastingExpandFrame_OnHookScript)
    if rs.tabDB[rs.iDBmark]["CastTimer"] then
        unitFrame.CastingExpandFrame:SetScript("OnUpdate", CastingTimerUpdate)
    else
        unitFrame.CastingExpandFrame:SetScript("OnUpdate", nil)
        unitFrame.CastingExpandFrame.CastingTimer:Hide()
    end

    if rs.tabDB[rs.iDBmark]["CastInterrupteIndicatorEnable"] then
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

    unitFrame.ColorAura = {}
    unitFrame.StolenAura = {}

	if not unitFrame.rsed then

        unitFrame.BuffFrame.UpdateBuffs = function() return end
        -- unitFrame.BuffFrame.UpdateAnchor = rs.UpdateAnchor

        -- unitFrame.BuffFrame.OnUnitAuraUpdate = rs.OnUnitAuraUpdateRSV
        -- unitFrame.BuffFrame.UpdateBuffs = rs.UpdateBuffsRSV
        -- unitFrame.BuffFrame.ParseAllAuras = rs.ParseAllAurasRSV
        unitFrame.BuffFrame.UpdateAnchor = rs.UpdateAnchor

		-- 施法条毛玻璃边
		unitFrame.castBar.castBG = rs.CreateBackDrop(unitFrame.castBar, unitFrame.castBar, 1)

		-- 施法图标 黑边
		unitFrame.castBar.Icon.iconborder = rs.CreateBG(unitFrame.castBar.Icon)
		unitFrame.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)  -- IconLayer = 1

		if not rs.tabDB[rs.iDBmark]["NarrowCast"] then
			unitFrame.castBar.Icon.iconborder:Hide()
			unitFrame.castBar.castBG:Hide()
		end


		-- 血量
		unitFrame.healthBar.value = rs.createtext(unitFrame.healthBar, "OVERLAY", 11, "OUTLINE", "CENTER")
		unitFrame.healthBar.value:SetShadowColor(0,0,0,1)
		unitFrame.healthBar.value:SetShadowOffset(0.5,-0.5)
		unitFrame.healthBar.value:SetTextColor(1,1,1)
		unitFrame.healthBar.value:Hide()
		if rs.tabDB[rs.iDBmark]["CenterDetail"] then
			unitFrame.healthBar.value:SetPoint("CENTER", unitFrame.healthBar, "CENTER", 0, 0)
		else
			unitFrame.healthBar.value:SetPoint("RIGHT", unitFrame.healthBar, "RIGHT", 0, 0)
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
        unitFrame.CastingExpandFrame.CastingTimer = rs.createtext(unitFrame.castBar, "OVERLAY", rs.ExtraConfig.CastingTimerSize, "OUTLINE", "CENTER")
        unitFrame.CastingExpandFrame.CastingTimer:SetPoint("RIGHT", unitFrame.castBar, "RIGHT", 0, 0)
        unitFrame.CastingExpandFrame.CastingTimer:Hide()

        -- Interrupte Indicator

        unitFrame.CastingExpandFrame.InterrupteIndicator = CreateFrame("Frame", nil, unitFrame.CastingExpandFrame)
        unitFrame.CastingExpandFrame.InterrupteIndicator:SetSize(rs.ExtraConfig.InterrupteIndicatorSize, rs.ExtraConfig.InterrupteIndicatorSize)
		unitFrame.CastingExpandFrame.InterrupteIndicator:SetPoint("BOTTOMLEFT", unitFrame.healthBar, "TOPLEFT", 0, 3)
		unitFrame.CastingExpandFrame.InterrupteIndicator:Hide()

        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture = unitFrame.CastingExpandFrame.InterrupteIndicator:CreateTexture("InterrupteIndicator", "BACKGROUND")
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetTexture("Interface\\AddOns\\RSPlates\\media\\bar_solid")
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetVertexColor(0,.9,0)
        unitFrame.CastingExpandFrame.InterrupteIndicator.Texture:SetAllPoints()

        unitFrame.CastingExpandFrame.InterrupteIndicator.around = rs.CreateBackDrop(unitFrame.CastingExpandFrame.InterrupteIndicator, unitFrame.CastingExpandFrame.InterrupteIndicator, 2)


		-- 任务 new ui
		unitFrame.healthBar.questIcon = unitFrame.healthBar:CreateTexture("QuestIcon", "OVERLAY")
		unitFrame.healthBar.questIcon:SetSize(rs.ExtraConfig.questIconSize, rs.ExtraConfig.questIconSize)
		unitFrame.healthBar.questIcon:SetTexture(questTexture)
		unitFrame.healthBar.questIcon:SetPoint("BOTTOM", unitFrame.healthBar, "TOP", 0, 20)
		unitFrame.healthBar.questIcon:SetVertexColor(.96, .85 , .1)
		unitFrame.healthBar.questIcon:Hide()

		-- 偷取/驱散buff模块 new ui
		unitFrame.StolenFrame = CreateFrame("Frame", nil, unitFrame.healthBar)
		unitFrame.StolenFrame:SetSize(rs.ExtraConfig.stolenBuffSize, rs.ExtraConfig.stolenBuffSize)
		unitFrame.StolenFrame:SetPoint("LEFT", unitFrame.healthBar, "RIGHT", 10, 0)
		unitFrame.StolenFrame:Hide()

		unitFrame.StolenFrame.Texture = unitFrame.StolenFrame:CreateTexture(nil, "OVERLAY")
		unitFrame.StolenFrame.Texture:SetAllPoints()

		unitFrame.StolenFrame.around = rs.CreateBackDrop(unitFrame.StolenFrame, unitFrame.StolenFrame, 2)

		unitFrame.StolenFrame.Cooldown = CreateFrame("Cooldown", nil, unitFrame.StolenFrame, "CooldownFrameTemplate")
		unitFrame.StolenFrame.Cooldown:SetAllPoints()
		unitFrame.StolenFrame.Cooldown:SetReverse(true)
		unitFrame.StolenFrame.Cooldown:SetHideCountdownNumbers(true)

		unitFrame.StolenFrame.count = rs.createtext(unitFrame.StolenFrame.Cooldown, "OVERLAY", 10, "OUTLINE", "CENTER")
		unitFrame.StolenFrame.count:SetPoint("BOTTOMRIGHT", unitFrame.StolenFrame, "BOTTOMRIGHT", -1, 1)

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
        local NpcColor = rs.tabDB[rs.iDBmark]["DctColorNpc"][tonumber(id)]
        local AuraColor 
        if frame.ColorAura then 
            for k, v in pairs(frame.ColorAura) do
                AuraColor = v
            end
        end

        for key in string.gmatch(rs.ExtraConfig.ColorOrder, "%a") do 
            -- 资源条不染色
            if UnitIsUnit("player", unit) then
                break
            -- 锁定玩家颜色
            elseif rs.tabDB[rs.iDBmark]["LockPlayerColor"] and (UnitIsPlayer(unit) or UnitIsPossessed(unit) or UnitPlayerControlled(unit)) then
                break
            -- A 焦点
            elseif key == "A" and rs.tabDB[rs.iDBmark]["FocusColorEnable"] and UnitIsUnit("focus", unit) then
                r, g, b = rs.tabDB[rs.iDBmark]["FocusColor"][1], rs.tabDB[rs.iDBmark]["FocusColor"][2], rs.tabDB[rs.iDBmark]["FocusColor"][3]
                break
            -- B 目标颜色
            elseif key == "B" and rs.tabDB[rs.iDBmark]["TargetColorEnable"] and UnitIsUnit("target", unit) then
                r, g, b = rs.tabDB[rs.iDBmark]["TargetColor"][1], rs.tabDB[rs.iDBmark]["TargetColor"][2], rs.tabDB[rs.iDBmark]["TargetColor"][3]
                break
            -- C 灰名
            elseif key == "C" and UnitIsTapDenied(unit) then
                break
            -- D 自定义NpcID
            elseif key == "D" and NpcColor then
                r, g, b = NpcColor[1], NpcColor[2], NpcColor[3]
                break
            -- E 携带自定义光环
            elseif key == "E" and AuraColor then
                r, g, b = AuraColor[1], AuraColor[2], AuraColor[3]
                break
            -- F 斩杀
            elseif key == "F" and rs.tabDB[rs.iDBmark]["SlayEnable"] and rs.IsOnKillHealth(unit) then
                r, g, b = rs.tabDB[rs.iDBmark]["SlayColor"][1], rs.tabDB[rs.iDBmark]["SlayColor"][2], rs.tabDB[rs.iDBmark]["SlayColor"][3]
                break
            -- G 仇恨，目标与玩家处于战斗状态
            elseif key == "G" and rs.tabDB[rs.iDBmark]["ThreatColorEnable"] and threatStatus then
                r, g, b = rs.IsOnThreatList(frame.unit)
                break
            end
        end
        
        -- 焦点
        -- if UnitIsUnit("focus", unit) and rs.tabDB[rs.iDBmark]["FocusColorEnable"] then
        --     r, g, b = rs.tabDB[rs.iDBmark]["FocusColor"][1], rs.tabDB[rs.iDBmark]["FocusColor"][2], rs.tabDB[rs.iDBmark]["FocusColor"][3]

        -- -- 锁定玩家颜色
        -- elseif rs.tabDB[rs.iDBmark]["LockPlayerColor"] and (UnitIsPlayer(unit) or UnitIsPossessed(unit) or UnitPlayerControlled(unit)) then
        --     do end

        -- -- 目标颜色
        -- elseif rs.tabDB[rs.iDBmark]["TargetColorEnable"] and UnitIsUnit("target", unit) and not UnitIsUnit("player", unit) then
        --     r, g, b = rs.tabDB[rs.iDBmark]["TargetColor"][1], rs.tabDB[rs.iDBmark]["TargetColor"][2], rs.tabDB[rs.iDBmark]["TargetColor"][3]

        -- -- 资源条不染色
        -- elseif UnitIsUnit("player", unit) then
        --     do end
        -- -- 灰名
        -- elseif UnitIsTapDenied(unit) then
        --     do end
        -- -- 1 自定义NpcID
        -- elseif NpcColor then
        --     r, g, b = NpcColor[1], NpcColor[2], NpcColor[3]
        -- -- 2 携带自定义光环
        -- elseif AuraColor then
        --     r, g, b = AuraColor[1], AuraColor[2], AuraColor[3]
        -- -- 3 斩杀
        -- elseif rs.tabDB[rs.iDBmark]["SlayEnable"] and rs.IsOnKillHealth(unit) then
        --     r, g, b = rs.tabDB[rs.iDBmark]["SlayColor"][1], rs.tabDB[rs.iDBmark]["SlayColor"][2], rs.tabDB[rs.iDBmark]["SlayColor"][3]

        -- -- 4 仇恨，目标与玩家处于战斗状态
        -- elseif rs.tabDB[rs.iDBmark]["ThreatColorEnable"] and threatStatus then
        --     r, g, b = rs.IsOnThreatList(frame.unit)
        -- end



        if not r then
            r, g, b =  frame.healthBar.r, frame.healthBar.g, frame.healthBar.b
        end

        frame.healthBar:SetStatusBarColor(r, g, b);

        if (frame.optionTable.colorHealthWithExtendedColors) then
            frame.selectionHighlight:SetVertexColor(r, g, b);
        else
            frame.selectionHighlight:SetVertexColor(1, 1, 1);
        end
        if rs.tabDB[rs.iDBmark]["BarBgCol"] then
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
        if frame.name then
            if rs.tabDB[rs.iDBmark]["NameWhite"] then
                frame.name:SetVertexColor(1, 1, 1)
            end
            if rs.tabDB[rs.iDBmark]["NameSizeEnable"] then
                frame.name:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["NameSize"], nil)
            end
        end
    end
end


function rs.ThinCastBar(self, event, ...)
    if rs.IsLegalUnit(self) then
        -- Thin cast bar
        if rs.tabDB[rs.iDBmark]["NarrowCast"]then
            local function SetThin(self)
                local uf = self:GetParent()
                local health = uf.healthBar
                local healthbarHeight = health:GetHeight()
                self.Icon:SetShown(true)
                -- self.Icon:SetTexture(texture)
                self:SetHeight(rs.tabDB[rs.iDBmark]["CastHeight"])
                self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -3, 0)
                self.Icon:SetSize(rs.tabDB[rs.iDBmark]["CastHeight"] + healthbarHeight + 2, rs.tabDB[rs.iDBmark]["CastHeight"] + healthbarHeight + 2)  -- 13 + height
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
    if not rs.tabDB[rs.iDBmark]["CastTarget"] then
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
    if not rs.tabDB[rs.iDBmark]["CastInterrupteIndicatorEnable"] then
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
            for i,v in pairs(rs.tabDB[rs.iDBmark]["DctInterrupteSpell"]) do
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
	local iType = rs.tabDB[rs.iDBmark]["DetailType"]
	if iType == "s1" then return "" end

	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)

	local fPer = string.format("%.0f%%",(CurHealth/MaxHealth*100))
	local fCur

	if rs.tabDB[rs.iDBmark]["WesternDetail"] then
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
        return rs.tabDB[rs.iDBmark]["TankSafeColor"][1], rs.tabDB[rs.iDBmark]["TankSafeColor"][2], rs.tabDB[rs.iDBmark]["TankSafeColor"][3]
		-- return .9, .1, .4  --紅色/red
	elseif threatStatus == 2 then  --非當前仇恨，當前坦克(已OT或坦克正在丟失仇恨)/insecurely tanking, another unit have higher threat but not tanking.
        return rs.tabDB[rs.iDBmark]["TankLoseColor"][1], rs.tabDB[rs.iDBmark]["TankLoseColor"][2], rs.tabDB[rs.iDBmark]["TankLoseColor"][3]
		-- return .9, .1, .9  --粉色/pink
	elseif threatStatus == 1 then  --當前仇恨，非當前坦克(非坦克高仇恨或坦克正在獲得仇恨)/not tanking, higher threat than tank.
        return rs.tabDB[rs.iDBmark]["dpsOTColor"][1], rs.tabDB[rs.iDBmark]["dpsOTColor"][2], rs.tabDB[rs.iDBmark]["dpsOTColor"][3]
		-- return .4, .1, .9  --紫色/purple
	elseif threatStatus == 0 then  --低仇恨，安全/not tanking, lower threat than tank.
        return rs.tabDB[rs.iDBmark]["dpsSafeColor"][1], rs.tabDB[rs.iDBmark]["dpsSafeColor"][2], rs.tabDB[rs.iDBmark]["dpsSafeColor"][3]
		-- return .1, .7, .9  --藍色/blue
	end
end


function rs.IsOnKillHealth(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)
	return ((CurHealth/MaxHealth) < rs.tabDB[rs.iDBmark]["Slayline"]/100);
end


function rs.SetSelectionHighlight(unitFrame)
    if rs.IsLegalUnit(unitFrame) then
        if not unitFrame.healthBar.curTarget then return end
        local unit = unitFrame.unit
        local namePlate = C_NamePlate.GetNamePlateForUnit(unit, false)

        if UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player") then
            if rs.tabDB[rs.iDBmark]["ShowArrow"] then
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
                unitFrame:SetAlpha(rs.tabDB[rs.iDBmark]["UnSelectAlpha"])
                -- unitFrame.castBar.Icon:SetAlpha(rs.tabDB[rs.iDBmark]["UnSelectAlpha"])
            end

            -- Namemode Select Glow
            if namePlate and namePlate.NameSelectGlow then
                namePlate.NameSelectGlow:Hide()
            end
        end
        -- 精英图标
        if not rs.tabDB[rs.iDBmark]["EliteIcon"] then
            unitFrame.ClassificationFrame:Hide()
        else
            unitFrame.ClassificationFrame:Show()
        end
    end
end


function rs.SetUnitQuestState(unitFrame)
    if rs.IsLegalUnit(unitFrame) then
        local inInstance, instanceType = IsInInstance()
        if not inInstance and rs.IsQuestUnit(unitFrame.unit) and rs.tabDB[rs.iDBmark]["ShowQuestIcon"] then
            unitFrame.healthBar.questIcon:Show()
            return
        end
        unitFrame.healthBar.questIcon:Hide()
    end
end



--血条材质
function rs.SetBarTexture(unitFrame)
    local texturePath = dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]]
    
    if texturePath then
        if rs.tabDB[rs.iDBmark]["BarTexture"] == "s1" then 
            unitFrame.healthBar:SetStatusBarTexture(texturePath)
            -- unitFrame.castBar:SetStatusBarTexture(texturePath)
            ClassNameplateManaBarFrame:SetStatusBarTexture(texturePath)
        else
            unitFrame.healthBar:SetStatusBarTexture(texturePath)
            unitFrame.castBar:SetStatusBarTexture(texturePath)
            ClassNameplateManaBarFrame:SetStatusBarTexture(texturePath)
            -- background will not be changed by Obj OnShow or OnEvent Event, So just set one time
            unitFrame.castBar.Background:SetTexture(dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]])
            unitFrame.castBar.Background:SetColorTexture(.2, .2, .2)
            unitFrame.castBar.Background:SetPoint("TOPLEFT", unitFrame.castBar, 1, 0)
            unitFrame.castBar.Background:SetPoint("BOTTOMRIGHT", unitFrame.castBar, -1, 0)
        end
	end
end

function rs.SetStolen(unitFrame)
    local stolenAura
    if unitFrame.StolenAura then
        for k, v in pairs(unitFrame.StolenAura) do
            stolenAura = v
        end
    end
    if stolenAura then
        unitFrame.StolenFrame:Show()
        unitFrame.StolenFrame.Texture:SetTexture(stolenAura.icon)
        unitFrame.StolenFrame.Cooldown:SetCooldown(stolenAura.expirationTime - stolenAura.duration, stolenAura.duration)
        unitFrame.healthBar.curTarget:SetPoint("LEFT", unitFrame.StolenFrame, "RIGHT", 0, 0)
        if stolenAura.applications > 1 then
            unitFrame.StolenFrame.count:SetText(stolenAura.applications)
        else
            unitFrame.StolenFrame.count:SetText("")
        end
    else
        unitFrame.StolenFrame:Hide()
        unitFrame.healthBar.curTarget:SetPoint("LEFT", unitFrame.healthBar, "RIGHT", 0, 0)
    end
end


---手动设置一次需要设置的
function rs.On_NpRefreshOnce(unitFrame)
    if unitFrame:IsForbidden() then return end
    --Stolen/ColorAura
    rs.UpdateUnitAurasFull(unitFrame.unit, unitFrame)
    rs.SetStolen(unitFrame)

	rs.SetBarTexture(unitFrame)

	rs.SetBloodText(unitFrame)

	rs.SetSelectionHighlight(unitFrame)

    rs.SetBarColor(unitFrame)

	rs.SetUnitQuestState(unitFrame)

	-- rs.RefAuraForOneNp(unitFrame)

    rs.SetName(unitFrame)

    rs.SetNameMode(unitFrame)

    rs.RefCastingTarget(unitFrame)

    rs.RefCastingBar(unitFrame)

    rs.RefInterrupteIndicator(unitFrame)

    rs.RefUnitAuraTotally(unitFrame)
end

function rs.RefUnitAuraTotally(unitFrame)
    local unit = unitFrame.unit
    -- unitFrame.BuffFrame:UpdateBuffs(unit, nil, {})
    rs.UpdateBuffsRSV(unitFrame.BuffFrame, unit, nil, {})
    -- rs.UpdateBuffsRSV(unitFrame.BuffFrame, unit, nil, {})
end
-- function rs.RefAuraForOneNp(unitFrame)
-- 	local unit = unitFrame.unit
-- 	if not unit then return end
--     rs:OnUnitAuraUpdateRS(unit, true, nil)
-- end

function rs.RefCastingBar(unitFrame)
    local self = unitFrame.castBar
    local unit = self.unit
    -- print(unit, "                             RefCastingBar")
    if not unit then return end
    if unit then 

        local r, g, b
        if rs.tabDB[rs.iDBmark]["BarTexture"] ~= "s1" then
            local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
            if name then
                if notInterruptible then
                    r, g, b = rgbGrey[1], rgbGrey[2], rgbGrey[3]
                else
                    r, g, b = rgbYello[1], rgbYello[2], rgbYello[3]
                end
            end

            local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages = UnitChannelInfo(unit);
            if name then
                if notInterruptible then
                    r, g, b = rgbGrey[1], rgbGrey[2], rgbGrey[3]
                else
                    r, g, b = rgbGreen[1], rgbGreen[2], rgbGreen[3]
                end
            end

            if r and g and b then
                self:SetStatusBarColor(r, g, b)
                self:SetStatusBarTexture(dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]])
            end
        end
    end
end


--- Hook Part
------------------------------------------------

function rs.HookBlizzedFunc()
    -- print('---> hoocsuccessful')

    -- Size Change or Options Change
    hooksecurefunc(NamePlateDriverFrame, "UpdateNamePlateOptions", function()
        rs.UpdateCvars()
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
    hooksecurefunc(CastingBarMixin, "FinishSpell", function(self)
        if not self.unit then return end
        -- print(self.unit, "                             FinishSpell")
        if rs.tabDB[rs.iDBmark]["BarTexture"] ~= "s1" then
            if self:IsForbidden() then return end
            self:SetStatusBarTexture(dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]])
        end
    end)

    hooksecurefunc(CastingBarMixin, "OnShow", function(self)
        if self.unit then
            rs.ThinCastBar(self)
        end
    end)

    hooksecurefunc(CastingBarMixin, "OnEvent", function(self, event, ...)
        local arg1 = ...;
        if not self.unit then return end
        if ( arg1 ~= self.unit ) then return end
        if self:IsForbidden() then return end

        -- print(arg1, "  ", self.unit, "    OnEvent")

        rs.ThinCastBar(self)

        local unit = self.unit
        local r, g, b
        local onlyTexture

        if rs.tabDB[rs.iDBmark]["BarTexture"] ~= "s1" then
            if event == "UNIT_SPELLCAST_START" then
                -- local unitTarget, castGUID, spellID = ...
                local name, text, texture, startTime, endTime, isTradeSkill, castID, notInterruptible = UnitCastingInfo(unit);
                if notInterruptible then
                    r, g, b = rgbGrey[1], rgbGrey[2], rgbGrey[3]
                else
                    r, g, b = rgbYello[1], rgbYello[2], rgbYello[3]
                end

            elseif event == "UNIT_SPELLCAST_CHANNEL_START" then
                -- local unitTarget, castGUID, spellID = ...
                local name, text, texture, startTime, endTime, isTradeSkill, notInterruptible, spellID, _, numStages = UnitChannelInfo(unit);
                if notInterruptible then
                    r, g, b = rgbGrey[1], rgbGrey[2], rgbGrey[3]
                else
                    r, g, b = rgbGreen[1], rgbGreen[2], rgbGreen[3]
                end

            elseif ( event == "UNIT_SPELLCAST_STOP" or event == "UNIT_SPELLCAST_CHANNEL_STOP" or event == "UNIT_SPELLCAST_EMPOWER_STOP") then
                -- local unitTarget, castGUID, spellID = ...
                onlyTexture = true

                -- 施法完成，被打断(先触发UNIT_SPELLCAST_INTERRUPTED)
            elseif ( event == "UNIT_SPELLCAST_FAILED" or event == "UNIT_SPELLCAST_INTERRUPTED" ) then
                -- local unitTarget, castGUID, spellID = ...
                r, g, b = rgbRed[1], rgbRed[2], rgbRed[3]
            elseif ( event == "UNIT_SPELLCAST_INTERRUPTIBLE" or event == "UNIT_SPELLCAST_NOT_INTERRUPTIBLE" ) then
                -- local unitTarget = ...
                onlyTexture = true
                -- print(event)
            elseif ( event == "UNIT_SPELLCAST_DELAYED" ) then
                -- local unitTarget, castGUID, spellID = ...
                onlyTexture = true
                -- print(event)
            end

            -- local npbase = C_NamePlate.GetNamePlateForUnit(self.unit, false)
            if r and g and b then
                self:SetStatusBarColor(r, g, b)
                self:SetStatusBarTexture(dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]])
            end

            if onlyTexture then
                self:SetStatusBarTexture(dctTexture[rs.tabDB[rs.iDBmark]["BarTexture"]])
            end
        end
    end)

    -- hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)
    --     rs.ThinCastBar(self, event, ...)
    -- end)
    -- hooksecurefunc("CastingBarFrame_OnShow", function(self)
    -- 	rs.ThinCastBar(self)
    -- end)


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
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
loadFrame:RegisterEvent("LOADING_SCREEN_DISABLED")

function loadFrame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1 == ADDONName then
        local hasbeenForced
		if not RSPlatesDB then
			RSPlatesDB = rs.V.DefaultSetting
        end
        
        if not RSPlatesDBPer then
            RSPlatesDBPer = rs.V.DefaultSetting
        end

        -- Battle.net 版本号不一样
        if RSPlatesDB["Version"] ~= rs.V.DefaultSetting["Version"] then
            RSPlatesDB, hasbeenForced = rs.GetMarginDB(RSPlatesDB)
            -- if not hasbeenForced then
            --     -- print (rs.L["UpdateInfo"])
            --     print ("|cffFFD700---RSPlates"..L["UpdateVersion"].."|r"..rs.tabDB[rs.iDBmark]["Version"] )
            -- else
            --     print(rs.L["UpdateForce"])
            --     print("|cffFFD700---RSPlates: "..L["UpdateVersion"].."|r"..rs.tabDB[rs.iDBmark]["Version"] )
            -- end
        end

        -- Charactor 版本号不一样
        if RSPlatesDBPer["Version"] ~= rs.V.DefaultSetting["Version"] then
            RSPlatesDBPer, hasbeenForced = rs.GetMarginDB(RSPlatesDBPer)
        end

        rs.tabDB = {RSPlatesDB, RSPlatesDBPer}

        if RSPlatesDB["ProfileByCharactor"] then
            rs.iDBmark = 2
        else
            rs.iDBmark = 1
        end

        rs.OnColCheck()
		rs.RSOn()
        rs.InitMinimapBtn()
        rs.GenerateSpellDescCacheAll()


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
        if string.match(unit, "nameplate") then 
            local frame = C_NamePlate.GetNamePlateForUnit(unit, false)
            if frame then
                rs.SetBloodText(frame.UnitFrame)
                rs.SetBarColor(frame.UnitFrame)
            end
        end

    elseif event == "UNIT_AURA" then
        -- local unit, isFullUpdate, updatedAuraInfos = ...
        -- if not string.match(unit, "nameplate") then return end
        -- rs:OnUnitAuraUpdateRS(unit, isFullUpdate, updatedAuraInfos)
        local unit, unitAuraUpdateInfo = ...
        if string.match(unit, "nameplate") then 
            local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)
            if npbase then
                rs.OnUnitAuraUpdateRSV(npbase.UnitFrame.BuffFrame, unit, unitAuraUpdateInfo)
                if unitAuraUpdateInfo == nil or unitAuraUpdateInfo.isFullUpdate then
                    rs.UpdateUnitAurasFull(unit, npbase.UnitFrame)
                else
                    rs.UpdateUnitAurasIncremental(unit, unitAuraUpdateInfo, npbase.UnitFrame)
                end
            end
        end


    elseif event == "UNIT_NAME_UPDATE" then 
        local unit = ...
        local frame = C_NamePlate.GetNamePlateForUnit(unit, false)
        if frame then 
            rs.SetNameMode(frame.UnitFrame)
        end

    elseif event == "PLAYER_FOCUS_CHANGED" then 
        for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
            local unitFrame = namePlate.UnitFrame
            rs.SetBarColor(unitFrame)
        end
        
    elseif event == "UNIT_TARGET" then
        -- local unit = ...
        -- if not string.match(unit, "nameplate") then return end
        -- local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)  -- safe,  no need to check
        -- if npbase then
        --     rs.RefCastingTarget(npbase.UnitFrame)
        -- end

    -- todo : 找出延迟的原因, UNIT_TARGET 可以解决部分但仍有少数情况失效，先延迟处理（逻辑上也更倾向于只判断初始阶段而非过程中UNIT_TARGET)
    elseif event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START" then
        if rs.tabDB[rs.iDBmark]["CastTarget"] or rs.tabDB[rs.iDBmark]["CastInterrupteIndicatorEnable"] then
            local unit, _, _ = ...
            if not string.match(unit, "nameplate") then return end
            local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)
            if npbase and rs.tabDB[rs.iDBmark]["CastTarget"] then
                C_Timer.After(0.1, function()
                    rs.RefCastingTarget(npbase.UnitFrame)
                end)
            end
            if npbase and rs.tabDB[rs.iDBmark]["CastInterrupteIndicatorEnable"] then
                rs.RefInterrupteIndicator(npbase.UnitFrame)
            end
        end

    elseif event == "UNIT_SPELLCAST_INTERRUPTED" then
        local unit, _, _ = ...
        if string.match(unit, "nameplate") then 
            local npbase = C_NamePlate.GetNamePlateForUnit(unit, false)
            if npbase then
                npbase.UnitFrame.CastingExpandFrame.CastingTarget:Hide()
                npbase.UnitFrame.CastingExpandFrame.InterrupteIndicator:Hide()
            end
        end


    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local timestamp, subevent, _, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()
        if subevent == "SPELL_INTERRUPT" then
            if not rs.tabDB[rs.iDBmark]["CastInterrupteFrom"] then return end
            for npUnit, npGUID in pairs(tabGUID2unit) do
                if npGUID == destGUID then
                    local npbase = C_NamePlate.GetNamePlateForUnit(npUnit)
                    if npbase then
                        -- npbase.UnitFrame.CastingExpandFrame.CastingTarget:Hide()
                        -- npbase.UnitFrame.CastingExpandFrame.InterrupteIndicator:Hide()
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

    elseif event == "PLAYER_REGEN_ENABLED" then
        if rs.inLock then
            rs.UpdateCvars()
            rs.inLock = false
        end

    -- elseif event == "CVAR_UPDATE" then 
    --     local cvar, data = ...
    --     if cvar == "NamePlateClassificationScale" then
    --         if data == "1.25" then
    --             -- print('开启大姓名板')
    --         elseif data == "1" then
    --             -- print('开启小姓名板')
    --         end
    --     end
    end
end


local UIObjectDriveFrame = CreateFrame("Frame", "RS_Plates", UIParent)
UIObjectDriveFrame:SetScript("OnEvent", UIObj_Event)
UIObjectDriveFrame:RegisterEvent("UNIT_HEALTH")
UIObjectDriveFrame:RegisterEvent("UNIT_AURA")
UIObjectDriveFrame:RegisterEvent("UNIT_NAME_UPDATE")
UIObjectDriveFrame:RegisterEvent("PLAYER_FOCUS_CHANGED")
UIObjectDriveFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
UIObjectDriveFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

-- UIObjectDriveFrame:RegisterEvent("UNIT_TARGET")
UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_START")
UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED")
--UIObjectDriveFrame:RegisterEvent("UNIT_SPELLCAST_FAILED")
UIObjectDriveFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

UIObjectDriveFrame:RegisterEvent("PLAYER_REGEN_ENABLED")


-- UIObjectDriveFrame:RegisterEvent("CVAR_UPDATE")



SLASH_TEST1 = "/rslog"
SlashCmdList.TEST = function()
    -- local order = "abcdefghi"
    


    -- SetCVar("NamePlateClassificationScale", 1.25) 
    -- SetCVar("NamePlateVerticalScale", 3) 
    -- SetCVar("NamePlateHorizontalScale", 1.4) 

    -- local tarnp = C_NamePlate.GetNamePlateForUnit("target", false)
    -- if tarnp then
    --     local unitframe = tarnp.UnitFrame
    --     print(unitframe.healthBar:GetHeight())
    -- end

    -- for i, k in pairs(tabGUID2unit) do
    --     print(i, k)
    -- end
end

SLASH_CONFIG1 = "/rs"
SlashCmdList.CONFIG = function() rs.SwitchConfigGUI() end


