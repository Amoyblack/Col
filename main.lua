-- 层级关系
-- NamePlates1UnitFrame
-- NamePlates1UnitFrame.BuffFrame
-- NamePlates1UnitFrame.castBar
-- NamePlates1UnitFrame.healthBar
-- NamePlates1UnitFrame.name
-- NamePlates1UnitFrame.unit
-- NamePlates1UnitFrame. etc




DefaultData = {
	["Version"] = "8.0.017",
	["OriBar"] = false,
	["OriCast"] = true,
	["OriElite"] = true,
	["OriBuff"] = true,
	["Detail"] = true,
	["Omen3"] = true,
	["Select"] = 1,
	["GlobalScale"] = 1.0,
	["Alpha"] = 0.8,
	["Distence"] = 50,
	["KillPer"] = 0,
	["KillRGBr"] = 1,
	["KillRGBg"] = 0.75,
	["KillRGBb"] = 0.15,
	["AuraNum"] = 0,
	["AuraOnlyMe"] = false,
	["DctAura"] = {	
	[3355] = true,	--冰冻陷阱
	[51514]	= true, --妖术
	[118]	= true, --羊
	[710]	= true, -- 放逐
	[30283]	= true, --暗怒
	[2094]	= true, -- 致盲
	[6770]	= true, -- 闷棍
	[853]	= true, --制裁
	[115078]= true, --点穴
	[221562]= true, --窒息
	[132168]= true, --震荡波
	[179057]= true, --混沌
	[217832]= true, --dh禁锢
	[102359]= true, --群缠绕
}
}


----------ONLOAD EVENT---------
local loadFrame = CreateFrame("FRAME"); 
loadFrame:RegisterEvent("ADDON_LOADED"); 
loadFrame:RegisterEvent("PLAYER_LOGOUT"); 

function loadFrame:OnEvent(event, arg1)

 if event == "ADDON_LOADED" and arg1 == "Col" then
	if not SavedData then 
		G_InitFirstLoadedOption = true
		SavedData = DefaultData
	else
		G_InitFirstLoadedOption = false
		-- 代码库与玩家存储的配置长度不一样时，直接更新
		if (table_leng(SavedData) ~= table_leng(DefaultData)) then 
			SavedData = DefaultData
			print "|cffFFD700---RsPlates : 检测到您已更新版本，所有设定已重置为预设值 |r"
			print ("|cffFFD700---当前版本： |r"..SavedData["Version"] ) 
		-- 长度一样，但版本号不同

		elseif SavedData["Version"] ~= DefaultData["Version"] then 
			SavedData = DefaultData
			print "|cffFFD700---RsPlates : 检测到您已更新版本，所有设定已重置为预设值 |r"	
			print ("|cffFFD700---当前版本： |r"..SavedData["Version"] ) 		
		end
 	end
	-- G_Flat = SavedData["OriBar"]
	-- G_Detail = SavedData["Detail"]
	-- G_Omen3 = SavedData["Omen3"]
	G_Select = SavedData["Select"]
	G_GlobalScale = SavedData["GlobalScale"]
	G_Alpha = SavedData["Alpha"]
	G_Distence = SavedData["Distence"]
	-- G_KillPer = SavedData["KillPer"]
	-- G_KillR = SavedData["KillRGBr"]
	-- G_KillG = SavedData["KillRGBg"]
	-- G_KillB = SavedData["KillRGBb"]
	-- G_Whitelist = SavedData["DctAura"]
	-- G_MaxAura = SavedData["AuraNum"]
	-- G_OnlyMe = SavedData["AuraOnlyMe"]

 end
end
loadFrame:SetScript("OnEvent", loadFrame.OnEvent);
----------------------------------


-- 职业颜色
local Ccolors = {}
if IsAddOnLoaded("!ClassColors") and CUSTOM_CLASS_COLORS then
	Ccolors = CUSTOM_CLASS_COLORS
else
	Ccolors = RAID_CLASS_COLORS
end


local function IsTapDenied(unitFrame)
	return UnitIsTapDenied(unitFrame.unit) and not UnitPlayerControlled(unitFrame.unit)
end


function IsGhn(frame)
	for i = 1, 20 do 
		local dname, _, _, _, dduration, _, dcaster, _, _, dspellid = UnitAura(frame.unit, i, "HELPFUL")
		if dspellid == 277242 then
			return true
		end
	end	
	return false
end

local function IsOnThreatList(unit)
	local _, threatStatus = UnitDetailedThreatSituation("player", unit)
	if threatStatus == 3 then  --穩定仇恨，當前坦克/securely tanking, highest threat
		return C.StableCol[1], C.StableCol[2], C.StableCol[3]
		-- return .9, .1, .4  --紅色/red
	elseif threatStatus == 2 then  --非當前仇恨，當前坦克(已OT或坦克正在丟失仇恨)/insecurely tanking, another unit have higher threat but not tanking.
		return C.GainCol[1], C.GainCol[2], C.GainCol[3]
		-- return .9, .1, .9  --粉色/pink
	elseif threatStatus == 1 then  --當前仇恨，非當前坦克(非坦克高仇恨或坦克正在獲得仇恨)/not tanking, higher threat than tank.
		return C.HighCol[1], C.HighCol[2], C.HighCol[3]
		-- return .4, .1, .9  --紫色/purple
	elseif threatStatus == 0 then  --低仇恨，安全/not tanking, lower threat than tank.
		return C.LowCol[1], C.LowCol[2], C.LowCol[3]
		-- return .1, .7, .9  --藍色/blue
	end
end

local function GetDetailText(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)

	local fPer = string.format("%.0f",(CurHealth/MaxHealth*100)).."%"
	local fCur = nil 
	if CurHealth > 10000 then
		fCur = string.format("%.1f",CurHealth/10000).."w"
	else
		fCur = tostring(CurHealth)
	end

	return fCur.."/"..fPer
end

local function IsOnKillHealth(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)
	return ((CurHealth/MaxHealth) < SavedData["KillPer"]/100);	
	-- body
end

local function SetCastbar(frame)
	if frame.castBar then
		frame.castBar:SetHeight(C.CastbarHeight)
		frame.castBar.Icon:SetSize(C.CastBarIconSize, C.CastBarIconSize)
		frame.castBar.Icon:SetPoint("BOTTOMRIGHT", frame.castBar, "BOTTOMLEFT", -2,-0)
		frame.castBar.Icon:Show()
		frame.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
		frame.castBar.BorderShield:SetSize(13, 15)
		frame.castBar.BorderShield:SetPoint("CENTER", frame.castBar, "LEFT", 5,-0)
	end
end

local function SetOneAura(frame, index, icon, lasttime, endtime, spellid)
	local timeNow = GetTime()
	frame.Auras[index].cd:SetCooldown(timeNow - (lasttime - (endtime - timeNow)), lasttime + 0.2)
	frame.Auras[index].icon:SetTexture(icon)
	frame.Auras[index]:Show()
	-- body
end

local function CreateAura(parent, index, icon, lasttime, endtime, spellid)
	local aura = CreateFrame("Frame", nil , parent)  -- 不继承V 关闭血条后该对象仍然没法释放
	aura:SetSize(C.iAuraWidth, C.iAuraHeight) 
	aura:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", (C.iAuraWidth+5) *(index-1), 0)  -- 没这个不显示

	aura.icon = aura:CreateTexture(nil, "OVERLAY", nil)
	aura.icon:SetPoint("TOPLEFT",aura,"TOPLEFT", 1, -1)
	aura.icon:SetPoint("BOTTOMRIGHT",aura,"BOTTOMRIGHT",-1, 1)
	-- aura.icon:SetTexture(icon)
	aura.icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)

	-- 可以在NF.Auras 区域染色
	aura.board = aura:CreateTexture(nil, "ARTWORK", nil)
	aura.board:SetTexture("Interface\\Buttons\\WHITE8x8")
	aura.board:SetVertexColor(0, 0, 0)
	aura.board:SetAllPoints()
	-- aura.board:SetPoint("TOPLEFT",aura.icon,"TOPLEFT", -2, 2)
	-- aura.board:SetPoint("BOTTOMRIGHT",aura.icon,"BOTTOMRIGHT", 2, -2)

	-- aura.count = createtext(aura, "OVERLAY", 8, "OUTLINE", "CENTER") 
	-- aura.count:SetPoint("CENTER", aura.icon, "CENTER", 0, 0)
	-- aura.count:SetText("29")
	-- aura.count:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")

	aura.cd = CreateFrame("Cooldown", nil , aura, "CooldownFrameTemplate")  --不继承全屏幕CD.....
	-- aura.cd:SetCooldown(GetTime() - (lasttime - (endtime-GetTime())) ,lasttime+ .2)  --tode  anim末端截取
	aura.cd:SetAllPoints()
	aura.cd:SetReverse(true)
	aura.cd:SetDrawEdge(true)
	aura.cd:SetHideCountdownNumbers(C.HideCount)
	return aura
end

function SetBarColor(frame)

	unit = frame.unit
	local r, g, b, a = 0, 1, 0, .8

	-- 玩家
	if UnitIsPlayer(unit) then
		local _, englishClass = UnitClass(unit)
		local classColor = Ccolors[englishClass]
		r, g, b, a = classColor.r , classColor.g, classColor.b, 1

	-- 灰名
	elseif IsTapDenied(frame) then
		r, g, b, a = .5, .5, .5 , .8

	-- 共生
	elseif IsGhn(frame) then 
		r, g, b, a = 0, 0, 1, .8

	-- 共生子嗣
	elseif ((GetUnitName(unit, false)) == '戈霍恩之嗣') then 
		r, g, b, a = 0, 0, 1, .8

	-- 易爆球
	elseif ((GetUnitName(unit, false)) == '爆炸物') then 
		r, g, b, a = .2, 1, .2, 1

	-- 斩杀
	elseif IsOnKillHealth(unit) then
		r, g, b, a = SavedData["KillRGBr"], SavedData["KillRGBg"], SavedData["KillRGBb"], 1

	-- 仇恨
	elseif IsOnThreatList(frame.unit) and SavedData["Omen3"] then 
		r, g, b = IsOnThreatList(frame.unit)

	-- 黄名
	elseif UnitReaction(frame.unit, "player") == 4 then --中立
		r, g, b, a = 1, 1, 0, 1

	-- 红名
	elseif UnitReaction(frame.unit, "player") <= 3 then  --敌对
		r, g, b, a = 1, 0, 0, 1
	end

	frame.healthBar:SetStatusBarColor(r, g, b, a)

end


local function AuraFilter(name,comefrom, spellid)
	if not name then return end 
	-- 只检测我的
	if SavedData["AuraOnlyMe"] then 
		if not (comefrom == "player" or comefrom == "pet") then 
			return false
		end
	end

	-- 白名单
	if SavedData["DctAura"][spellid] then return true end
	return false

end


-- 每次从服务器拿到数据全部重刷就行
-- 清空
local function SetAura(unitframe)
	unit = unitframe.displayedUnit

	for i = 1, SavedData["AuraNum"] do 
		if unitframe.Auras[i] then 
			unitframe.Auras[i]:Hide()
			-- unitframe.Auras[i] = nil
		end
	end


	local curIcon, maxIcon = 1, SavedData["AuraNum"]

	for i = 1 , 15 do 
		if curIcon < maxIcon + 1 then 
			local name, icon, _, type, lasttime, endtime, comefrom, _, _, spellid= UnitAura(unit, i, "HARMFUL")
			if not name then return end
			if AuraFilter(name, comefrom, spellid) then 
				if not unitframe.Auras[curIcon] then 
					unitframe.Auras[curIcon] = CreateAura(unitframe.Auras, curIcon, icon, lasttime, endtime, spellid)
				end
				SetOneAura(unitframe, curIcon, icon, lasttime, endtime, spellid)
				curIcon = curIcon + 1
			end			
		end
	end

	for i = 1 , 15 do 
		if curIcon < maxIcon + 1 then 
			local name, icon, _, type, lasttime, endtime, comefrom, _, _, spellid= UnitAura(unit, i, "HELPFUL")
			if not name then return end
			if AuraFilter(name, comefrom, spellid) then 
				if not unitframe.Auras[curIcon] then 
					unitframe.Auras[curIcon] = CreateAura(unitframe.Auras, curIcon, icon, lasttime, endtime, spellid)
				end
				SetOneAura(unitframe, curIcon, icon, lasttime, endtime, spellid)
				curIcon = curIcon + 1
			end
		end
	end
end


-- hooksecurefunc("CompactUnitFrame_OnUpdate", function(frame)
-- 	print 'gui'
-- end) 

---手动设置一次需要设置的
local function On_NpRefreshOnce(unitFrame)

	if not SavedData["OriCast"] then 
		SetCastbar(unitFrame)
	end
	
	if not SavedData["OriBar"] then 
		unitFrame.healthBar:SetStatusBarTexture("Interface\\AddOns\\Col\\rsbar")
		unitFrame.castBar:SetStatusBarTexture("Interface\\AddOns\\Col\\rsbar")
		-- unitFrame.powerBar:SetStatusBarTexture("Interface\\AddOns\\Col\\rsbar")
	end

	SetAura(unitFrame)
	SetBarColor(unitFrame)
	unitFrame.name:SetTextColor(1,1,1)

	if not IsOnThreatList(unitFrame.displayedUnit) then
		unitFrame.healthBar.value:Hide()  --隐藏非仇恨单位的血量显示
	end

end


local function Event_NamePlatesFrame(self, event, ...)
	-- print (event)


	local unit = self.displayedUnit
	-- 光环  -----------------------------------------------------------------------

	if ( event == "UNIT_AURA" ) then
		SetAura(self)

	-- 仇恨 -----------------------------------------------------------------------
	elseif (event == "UNIT_THREAT_LIST_UPDATE") then 
		if IsOnThreatList(self.displayedUnit) then 
			if SavedData["Detail"] then
				self.healthBar.value:Show()
				self.healthBar.value:SetText(GetDetailText(unit))
			end
		else
			self.healthBar.value:Hide()
		end
		
		SetBarColor(self)


	-- 血量  -----------------------------------------------------------------------
	elseif (event == "UNIT_HEALTH") then
		local CurHealth = UnitHealth(unit)
		local MaxHealth = UnitHealthMax(unit)
		self.healthBar:SetMinMaxValues(0,1)
		self.healthBar:SetValue(CurHealth/MaxHealth)
		self.healthBar.value:SetText(GetDetailText(unit))

		SetBarColor(self)


	-- 切目标  -----------------------------------------------------------------------
	elseif (event == "PLAYER_TARGET_CHANGED") then 
		-- 当前目标
		if UnitIsUnit(self.unit, "target") and not UnitIsUnit(self.unit, "player") then
			self.selectionHighlight:Show()
			self.selectionHighlight:SetVertexColor(1,1,1)
			self.healthBar.border:SetVertexColor(1,1,1,.5)

			self.name:SetText(GetUnitName(self.unit))

			if (not self.name:IsShown()) then 
				self.name:Show()
			end
			-- print (UnitReaction(self.unit, "player"))    ----- 打印选中目标与玩家的Reaction类型
			-- local _, threatStatus = UnitDetailedThreatSituation("player", self.unit)
			-- print (threatStatus)		----- 打印选中目标与玩家的仇恨关系

		-- 非当前目标
		else
			self.selectionHighlight:Hide()
			self.healthBar.border:SetVertexColor(0,0,0,.6)
			-- if (UnitReaction(self.unit, "player") == 4) then
			-- 	self.name:Hide()
			-- end
		end

	end
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:SetScript("OnEvent", Event_NamePlatesFrame)
	unitFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	unitFrame:RegisterEvent("UNIT_HEALTH")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_AURA")
end


-- 文本
local createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(STANDARD_TEXT_FONT, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end


local function On_NpCreate(namePlate)

	local NF = namePlate.UnitFrame	

	if not SavedData["OriCast"] then 	
		NF.castBar:HookScript('OnUpdate', function ( ... )
			if not NF.castBar.Icon:IsShown() then 
				NF.castBar.Icon:Show()
			end
		end) 
	end

	if not SavedData["OriBuff"] then 
		NF.BuffFrame:Hide()  --隐藏默认光环
	end

	if not SavedData["OriElite"] then 
		NF.ClassificationFrame:Hide()
	end
	NF.name:SetFont(C.NameFont, C.NameTextSize, nil)

	-- 描边颜色 与 字体颜色
	NF.healthBar.border:SetVertexColor(0,0,0,.6)
	NF.name:SetTextColor(1,1,1)

	-- 创建血量百分比
	NF.healthBar.value = createtext(NF.healthBar, "OVERLAY", 8, "OUTLINE", "CENTER")
	if C.CenterDetail then
		NF.healthBar.value:SetPoint("BOTTOM", NF.healthBar, "CENTER", 0, -4)
	else
		NF.healthBar.value:SetPoint("BOTTOMRIGHT", NF.healthBar, "RIGHT", 0, -4)
	end
	NF.healthBar.value:SetTextColor(1,1,1)
	-- NF.healthBar.value:SetText("Value")
	NF.healthBar.value:Hide()

	-- 创建光环位置框架
	NF.Auras = CreateFrame("Frame", nil, NF)
	NF.Auras:SetPoint("BOTTOM", NF.name, "TOP", 0, 10)
	NF.Auras:SetWidth(140)
	NF.Auras:SetHeight(20)
	NF.Auras:SetFrameLevel(NF:GetFrameLevel() + 2)


end

local function UnregisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", nil)
end

local function SetUnit(unitFrame, unit)
	unitFrame.unit = unit
	unitFrame.displayedUnit = unit	 -- For vehicles
	unitFrame.inVehicle = false

	-- if UnitIsPlayer(unit) then return end

	if ( unit ) then
		RegisterNamePlateEvents(unitFrame)
	else
		UnregisterNamePlateEvents(unitFrame)
	end
end

local function On_NpAdd(unit)
	-- print ("添加的unit       "..unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	local unitFrame = namePlate.UnitFrame
	SetUnit(unitFrame, unit)
	On_NpRefreshOnce(unitFrame)
	-- 创建光环位置框架
end

local function On_NpRemoved(unit)
	-- print ("删除的unit      "..unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.UnitFrame, nil)
	CastingBarFrame_SetUnit(namePlate.UnitFrame.castBar, nil, false, true)
end



local function NamePlates_OnEvent(self, event, ...)

	-- if ( event == "VARIABLES_LOADED" ) then
		-- print ' ------ VARIABLES_LOADED'

	if ( event == "NAME_PLATE_CREATED" ) then
		local unit = ...
		On_NpCreate(unit)		
		-- print ' ------ NAME_PLATE_CREATED'

	elseif ( event == "NAME_PLATE_UNIT_ADDED" ) then
		local unit = ...
		On_NpAdd(unit)

		-- if not UnitIsPlayer(namePlate.UnitFrame.unit) then 
		-- 	RegisterNamePlateEvents(unitFrame)
		-- end
		

		

	elseif ( event == "NAME_PLATE_UNIT_REMOVED" ) then
		local unit = ...
		On_NpRemoved(unit)

	-- elseif event == "RAID_TARGET_UPDATE" then

	-- elseif event == "DISPLAY_SIZE_CHANGED" then

	-- elseif ( event == "UNIT_FACTION" ) then

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then

		SetCVar("nameplateMaxDistance", G_Distence)
		SetCVar("nameplateSelectedScale", G_Select)
		SetCVar("nameplateMinAlpha", G_Alpha)
		SetCVar("nameplateGlobalScale", G_GlobalScale)
		if G_InitFirstLoadedOption then
			SetCVar("nameplateShowAll", 1)   --显示所有
			SetCVar("nameplateShowEnemies", 1)   --敌对单位
			SetCVar("nameplateShowEnemyMinions", 1)   --仆从
			SetCVar("nameplateShowEnemyMinus", 1)   --杂兵


			-- No Use , Todo Find way to solve
			-- SetCVar("NamePlateHorizontalScale", 1.4) --大姓名版的数据
			-- SetCVar("NamePlateVerticalScale", 2.7)
		end
	end

end


local NamePlatesFrame = CreateFrame("Frame", "NamePlatesFrame", UIParent)
NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)
-- NamePlatesFrame:RegisterEvent("VARIABLES_LOADED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_CREATED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
-- NamePlatesFrame:RegisterEvent("CVAR_UPDATE")
-- NamePlatesFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
-- NamePlatesFrame:RegisterEvent("RAID_TARGET_UPDATE")
-- NamePlatesFrame:RegisterEvent("UNIT_FACTION")
-- NamePlatesFrame:RegisterEvent("UNIT_AURA")
NamePlatesFrame:RegisterEvent("PLAYER_ENTERING_WORLD")




SLASH_RELOADUI1 = "/rl"
SlashCmdList.RELOADUI = ReloadUI

SLASH_FRAMESTK1 = "/fs"
SlashCmdList.FRAMESTK = function()
	LoadAddOn('Blizzard_DebugTools')
	FrameStackTooltip_Toggle()
end

SLASH_CPU1 = "/cpu"
SlashCmdList.CPU = function()
	local cpu = GetAddOnCPUUsage("Col")
	print("CPU占用:    ", cpu-cpu%0.01)
	local Memory = GetAddOnMemoryUsage("Col")
	print("内存使用:   ", Memory-Memory%0.01, "  KB")
end



SLASH_REE1 = "/bian"
SlashCmdList.REE = function()
	print (SavedData["KillPer"])
end
-- local cpuFrame = CreateFrame("Frame") 
-- cpuFrame:SetScript("OnUpdate", function ( ... )
-- 	local cpu = GetAddOnCPUUsage("Col")
-- 	print("CPU占用:    ", cpu-cpu%0.01)
-- 	local Memory = GetAddOnMemoryUsage("Col")
-- 	print("内存使用:   ", Memory-Memory%0.01, "  KB")
-- 	-- body
-- end)

