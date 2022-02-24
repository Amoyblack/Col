


local ADDONName, rs = ...
local L = rs.L

local NpDriveEvent

local barTexture = "Interface\\AddOns\\RSPlates\\media\\bar_rs"
local arrorTexture = "Interface\\AddOns\\RSPlates\\media\\arrorH"
local questTexture = "Interface\\AddOns\\RSPlates\\media\\questQuestion"

-------------------------------------------------
function rs.RSOn()
	rs.HookBlizzedFunc()
	if RSPlatesDB["ExpballHelper"] then 
		rs.BallScanner()
	end
end
-------------------------------------------------



function rs.On_Np_Add(self, unitToken)
	local namePlateFrameBase = C_NamePlate.GetNamePlateForUnit(unitToken, issecure())
	local unitFrame = namePlateFrameBase.UnitFrame
    unitFrame.healthBar.AuraR, unitFrame.healthBar.AuraG, unitFrame.healthBar.AuraB = nil, nil, nil
    rs.CreateUIObj(unitFrame)
	rs.On_NpRefreshOnce(unitFrame)
end


function rs.On_Np_Create(self, namePlateFrameBase)
    print (self.healthBar, namePlateFrameBase, namePlateFrameBase.healthBar)
end



---------------------------------------------------

function rs.CreateUIObj(unitFrame)

    local unit = unitFrame.unit 
    if not unit then return end

    local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
    if not namePlate then return end 

	unitFrame.BuffFrame.UpdateBuffs = rs.UpdateBuffsOri
	unitFrame.BuffFrame.UpdateAnchor = rs.UpdateAnchor

	if not unitFrame.rsed then 

		-- 施法条毛玻璃边 
		unitFrame.castBar.castBG = rs.CreateBackDrop(unitFrame.castBar, unitFrame.castBar, 1) 

		-- 施法图标 黑边
		unitFrame.castBar.Icon.iconborder = rs.CreateBG(unitFrame.castBar.Icon)
		unitFrame.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)  -- IconLayer = 1

		if not RSPlatesDB["NarrowCast"] then 
			unitFrame.castBar.Icon.iconborder:Hide()
			unitFrame.castBar.castBG:Hide()
        else
            unitFrame.RaidTargetFrame:SetPoint("RIGHT", -170, -10)
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

		unitFrame.rsed = true
	end
end


---- Method 
--------------------------------------

--血条数值
function rs.SetBloodText(unitFrame)
    if not unitFrame.unit then return end 
	if UnitIsUnit("player", unitFrame.unit) then 
		unitFrame.healthBar.value:Hide()
		return 
	end

	unitFrame.healthBar.value:Show()
	unitFrame.healthBar.value:SetText(rs.GetDetailText(unitFrame.unit))
end


-- a test function 
function rs.NpUnderProtection(unitframe, whocall)
    if not unitframe then return end 
    local unit = unitframe.unit 
    local reaction = UnitReaction("player", unit)
    
    -- print(reaction, UnitName(unit), " canAttack:", UnitCanAttack("player", unit)," canAssist:", UnitCanAssist("player", unit)," IsFriend:",  UnitIsFriend("player", unit), " IsEnemy:", UnitIsEnemy("player", unit), "Call Method:", whocall, "Protect Mode: ")
end

function rs.SetBarColor(frame)
	local unit = frame.unit
    if not unit then return end 
    if not rs.IsNameplateUnit(frame) then return end 
    if frame:IsForbidden() then return end

	local r, g, b, a
	local guid = UnitGUID(frame.unit)
	local _, _, _, _, _, id = strsplit("-", guid or "") 
	local _, threatStatus = UnitDetailedThreatSituation("player", unit)
    local NpcColor = RSPlatesDB["DctColorNpc"][tonumber(id)]
    
    -- 资源条不染色
    if UnitIsUnit("player", unit) then 
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


function rs.SetName(frame) 
    if not rs.IsNameplateUnit(frame) then return end 
    if frame:IsForbidden() then return end 
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


function rs.ThinCastBar(self)
    if not self.unit then return end 
    local np = C_NamePlate.GetNamePlateForUnit(self.unit)
    if not np then return end 
    unitFrame = np.UnitFrame
    if unitFrame:IsForbidden() then return end 
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
			fCur = string.format("%.1fW", CurHealth/10000)
		elseif CurHealth > 100000000 then
			fCur = string.format("%.1fY", CurHealth/100000000)
		else
			fCur = tostring(CurHealth)
		end
	end


	if iType == "s2" then  --百分比
		return fPer

	elseif iType == "s3" then --数值
		return fCur

	elseif iType == "s4" then --数值/百分比
        return format("%s / %s",fCur, fPer)
	end
end

function rs.IsNameplateUnit(Frame)
    local unit = Frame.unit
    if not unit then return end 
    if string.match(unit, "nameplate") == "nameplate" then 
        return true
    else
        return false
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


-- 安全 
function rs.SetSelectionHighlight(unitFrame)
	if not unitFrame.healthBar.curTarget then return end
	local unit = unitFrame.unit
	if UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player") then
		if RSPlatesDB["ShowArrow"] then 
			unitFrame.healthBar.curTarget:Show()
		else
			unitFrame.healthBar.curTarget:Hide()
		end

		unitFrame:SetAlpha(1)
		-- unitFrame.castBar.Icon:SetAlpha(1)
	else
		unitFrame.healthBar.curTarget:Hide()
		if UnitIsUnit(unit, "player") then 
			unitFrame:SetAlpha(1)
		else
			unitFrame:SetAlpha(RSPlatesDB["UnSelectAlpha"])
            -- unitFrame.castBar.Icon:SetAlpha(RSPlatesDB["UnSelectAlpha"])
		end
	end
end


function rs.SetUnitQuestState(unitFrame)
	local unit = unitFrame.unit
	local inInstance, instanceType = IsInInstance()
	if not inInstance and rs.IsQuestUnit(unit) and RSPlatesDB["ShowQuestIcon"] then
		unitFrame.healthBar.questIcon:Show()
		return
	end	
	unitFrame.healthBar.questIcon:Hide()
end



--血条材质
function rs.SetBarTexture(unitFrame)
	if RSPlatesDB["FlatBar"] then 
		unitFrame.healthBar:SetStatusBarTexture(barTexture)
		unitFrame.castBar:SetStatusBarTexture(barTexture)	
		ClassNameplateManaBarFrame:SetStatusBarTexture(barTexture)		
	end
end

-- rs:()和rs.()调用的区别,前者把自己rs当第一个参数发出去
-- function rs:xx 和 rs.xx 区别： 调用前者时,第一个传入参数永远赋给self（变量接收位置可不声明self)
-- 综上：二者适合配合使用  rs:()配合 function rs:xx()  分开使用会比较混乱


---手动设置一次需要设置的
function rs.On_NpRefreshOnce(unitFrame)
	rs.SetBarTexture(unitFrame)

	rs.SetBloodText(unitFrame)
	
	rs.SetSelectionHighlight(unitFrame)

	rs.SetBarColor(unitFrame)

	rs.SetUnitQuestState(unitFrame)

	rs.RefAuraForOneNp(unitFrame)

    rs.SetNameMode(unitFrame)
end


function rs.RefAuraForOneNp(unitFrame)
	local unit = unitFrame.unit
	if not unit then return end
	NamePlateDriverFrame:OnUnitAuraUpdate(unit)
end




--- Hook Part
------------------------------------------------


function rs.HookBlizzedFunc()
    -- print ('hoooookkkkk')
    hooksecurefunc(NamePlateDriverFrame, "OnNamePlateAdded", rs.On_Np_Add)

    if RSPlatesDB["NarrowCast"]then
        hooksecurefunc("CastingBarFrame_OnEvent", function(self, event, ...)
            rs.ThinCastBar(self)
        end)
        -- hooksecurefunc("CastingBarFrame_OnShow", function(self)
        -- 	ThinCastBar(self)
        -- end)

    end

    -- 名字
    hooksecurefunc("CompactUnitFrame_UpdateName", function(frame)
        rs.SetName(frame)
    end)

    -- 血量
    hooksecurefunc("CompactUnitFrame_UpdateHealth", function(frame)
        if not rs.IsNameplateUnit(frame) then return end 
        if frame.healthBar.value then
            rs.SetBloodText(frame)
            if RSPlatesDB["SlayEnable"] then  -- 检查斩杀线
                rs.SetBarColor(frame)
            end
        end
    end)

    -- 血条颜色
    hooksecurefunc("CompactUnitFrame_UpdateHealthColor", function(frame)
        rs.SetBarColor(frame)
    end)

    -- 目标选择
    hooksecurefunc("CompactUnitFrame_UpdateHealthBorder", function(frame)
        if not rs.IsNameplateUnit(frame) then return end 
        rs.SetSelectionHighlight(frame)
        if RSPlatesDB["NarrowCast"] then  -- 隐藏精英图标
            if frame:IsForbidden() then return end 
            if frame.ClassificationFrame then
                frame.ClassificationFrame:Hide()
            end
        end
    end)
end



----------ONLOAD EVENT---------

-- todo: 更新逻辑重做,抽一个单独模块解耦

local loadFrame = CreateFrame("FRAME"); 
loadFrame:RegisterEvent("ADDON_LOADED"); 
-- loadFrame:RegisterEvent("PLAYER_LOGOUT"); 
loadFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

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
    elseif event == "PLAYER_ENTERING_WORLD" then 
        rs.UpdateCvars()
        if rs.V.AddonFirstLoad then 
            rs.SetCVarOnFirstTime()
        end
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

-- SLASH_RELOADUI1 = "/rl"
-- SlashCmdList.RELOADUI = ReloadUI

SLASH_CONFIG1 = "/rs"
SlashCmdList.CONFIG = function() rs.SwitchConfigGUI() end