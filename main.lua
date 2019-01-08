-- 层级关系
-- NamePlates1UnitFrame
-- NamePlates1UnitFrame.BuffFrame
-- NamePlates1UnitFrame.castBar
-- NamePlates1UnitFrame.healthBar
-- NamePlates1UnitFrame.name
-- NamePlates1UnitFrame.unit
-- NamePlates1UnitFrame. etc

local _, ns = ...

local C = ns.C


DefaultData = {
	["Version"] = "8.1.012",
	["OriBar"] = false,
	["OriCast"] = false,
	["OriElite"] = false,
	["DetailType"] = 3,
	["Omen3"] = true,
	["Select"] = 1,
	["GlobalScale"] = 1.0,
	["Alpha"] = 0.8,
	["Distence"] = 50,
	["KillPer"] = 0,
	["KillRGBr"] = 1,
	["KillRGBg"] = 0.75,
	["KillRGBb"] = 0.15,

	["AuraDefault"] = true,
	["AuraWhite"] = true,
	["AuraOnlyMe"] = false,
	["AuraHeight"] = 20,
	["AuraNum"] = 5,
	["OriAuraSize"] = true,
	["AuraSize"] = 25, 
	["AuraTimer"] = false,
	["AuraNumSize"] = 13,

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
		fCur = string.format("%.1f",CurHealth/10000).."W"
	else
		fCur = tostring(CurHealth)
	end

	local iType = SavedData["DetailType"]

	if iType == 1 then  --不显示
		return ""

	elseif iType == 2 then  --百分比
		return fPer

	elseif iType == 3 then --数值
		return fCur

	elseif iType == 4 then --数值/百分比
		return fCur.."/"..fPer
	end

end

local function IsOnKillHealth(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)
	return ((CurHealth/MaxHealth) < SavedData["KillPer"]/100);	
	-- body
end

-- Highlight / 高亮
local function SetSelectionHighlight(unitFrame)
	local unit = unitFrame.unit
	if UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player") then
		unitFrame.Tarlight:Show()
		unitFrame.selectionHighlight:Show()
		unitFrame.selectionHighlight:SetVertexColor(1,1,1)
		unitFrame.name:SetText(GetUnitName(unitFrame.unit))
	else
		unitFrame.Tarlight:Hide()
		unitFrame.selectionHighlight:Hide()
	end
end

local function SetCastbar(frame)
	-- if frame.castBar then
		if not SavedData["OriCast"] then 
			frame.castBar:SetHeight(C.CastbarHeight)
			frame.castBar.Icon:SetSize(C.CastBarIconSize, C.CastBarIconSize)
			frame.castBar.Icon:SetPoint("BOTTOMRIGHT", frame.castBar, "BOTTOMLEFT", -2, 0)
			frame.castBar.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
			frame.castBar.Icon:Show()
			frame.castBar.BorderShield:SetAtlas("nameplates-InterruptShield")
			frame.castBar.BorderShield:SetSize(13, 15)
			frame.castBar.BorderShield:SetPoint("CENTER", frame.castBar, "LEFT", 5,-0)
		end
	-- end
end

-- elseif only patch one
function SetBarColor(frame)

	local unit = frame.unit
	local guid = UnitGUID(frame.unit)
	local _, _, _, _, _, id = strsplit("-", guid or "") 
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
	elseif (id == "141851") then  
		r, g, b, a = 0, 0, 1, .8

	-- 易爆球
	elseif (id == "120651") then 
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

	frame.healthBar:SetStatusBarColor(r, g, b, 1)

end

-- hooksecurefunc("CompactUnitFrame_OnUpdate", function(frame)
-- 	print 'gui'
-- end) 


---手动设置一次需要设置的
local function On_NpRefreshOnce(unitFrame)

	SetSelectionHighlight(unitFrame)

	SetCastbar(unitFrame)

	unitFrame.healthBar.border:SetVertexColor(0,0,0,.8)
	
	if not SavedData["OriBar"] then 
		unitFrame.healthBar:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_knp")
		unitFrame.castBar:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_knp")
		ClassNameplateManaBarFrame:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_knp")
		-- ClassNameplateManaBarFrame:SetStatusBarColor(1,1,1)
		-- unitFrame.powerBar:SetStatusBarTexture("Interface\\AddOns\\Col\\rsbar")
	end

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

	-- if ( event == "UNIT_AURA" ) then
	-- 	SetAura(self)

	-- 仇恨 -----------------------------------------------------------------------
	if (event == "UNIT_THREAT_LIST_UPDATE") then 
		if IsOnThreatList(self.displayedUnit) then 
			self.healthBar.value:Show()
			self.healthBar.value:SetText(GetDetailText(unit))
		else
			self.healthBar.value:Hide()
		end
		
		SetBarColor(self)

	-- 血量  -----------------------------------------------------------------------
	elseif (event == "UNIT_HEALTH_FREQUENT") then
		local CurHealth = UnitHealth(unit)
		local MaxHealth = UnitHealthMax(unit)
		self.healthBar:SetMinMaxValues(0,1)
		self.healthBar:SetValue(CurHealth/MaxHealth)
		self.healthBar.value:SetText(GetDetailText(unit))

		if SavedData["KillPer"] ~= 0 then  -- 检查斩杀线
			SetBarColor(self)
		end

	-- 切目标  -----------------------------------------------------------------------
	elseif (event == "PLAYER_TARGET_CHANGED") then 
		SetSelectionHighlight(self)
	end
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", Event_NamePlatesFrame)
	unitFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	-- unitFrame:RegisterEvent("UNIT_HEALTH")
	unitFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	-- unitFrame:RegisterEvent("UNIT_AURA")
end


-- 文本
local createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(STANDARD_TEXT_FONT, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end


local function UpdateBuffs(self, unit, filter, showAll)

	if not self.isActive then
		for i = 1, BUFF_MAX_DISPLAY do
			if (self.buffList[i]) then
				self.buffList[i]:Hide();
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
		for i = 1, BUFF_MAX_DISPLAY do
			if buffIndex <= SavedData["AuraNum"] then 
				local name, texture, count, debuffType, duration, expirationTime, caster, canStealOrPurge, nameplateShowPersonal, spellId, _, _, _, nameplateShowAll = UnitAura(unit, i,filter);
				if name then 
					-- print (caster, spellId, name, count, canStealOrPurge)

				-----------------------------------------------------------
				local flag = false
				-- 默认过滤器
				if SavedData["AuraDefault"] then 
					flag = self:ShouldShowBuff(name, caster, nameplateShowPersonal, nameplateShowAll or showAll, duration) 
				end

				-- 白名单
				if SavedData["AuraWhite"] then 
					if SavedData["DctAura"][spellId] then 
						flag = true end 
				end

				-- 只显示我
				if SavedData["AuraOnlyMe"] then 
					if not (caster == "player" or caster == "pet") then 
						flag = false
					end
				end
				-----------------------------------------------------------
				if (flag) then
					if (not self.buffList[buffIndex]) then
						self.buffList[buffIndex] = CreateFrame("Frame", self:GetParent():GetName() .. "Buff" .. buffIndex, self, "NameplateBuffButtonTemplate");
						self.buffList[buffIndex]:SetMouseClickEnabled(false);
						self.buffList[buffIndex].layoutIndex = buffIndex;
						self.buffList[buffIndex].align = "right"
					end
					local buff = self.buffList[buffIndex];
					buff:SetID(i);
					if not SavedData["OriAuraSize"] then 
						buff:SetSize(SavedData["AuraSize"],SavedData["AuraSize"])
						buff.Icon:SetPoint("TOPLEFT",buff,"TOPLEFT", 1, -1)
						buff.Icon:SetPoint("BOTTOMRIGHT",buff,"BOTTOMRIGHT", -1, 1)
						buff.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
					end
					buff.Icon:SetTexture(texture);

					-- 层数 
					if (count > 1) then
						buff.CountFrame.Count:SetText(count);
						buff.CountFrame.Count:Show();
					else
						buff.CountFrame.Count:Hide();
					end

					CooldownFrame_Set(buff.Cooldown, expirationTime - duration, duration, duration > 0, true);
					buff.Cooldown:SetHideCountdownNumbers(not SavedData["AuraTimer"])

					local regon = buff.Cooldown:GetRegions()
					if regon.GetText then 
						regon:SetFont(C.NameFont, SavedData["AuraNumSize"], nil)  --Default : 15 "OUTLINE"
					end

					buff:Show();
					buffIndex = buffIndex + 1;
				end
			end
		end

		for i = buffIndex, BUFF_MAX_DISPLAY do
			if (self.buffList[i]) then
				self.buffList[i]:Hide();
			end
		end
	end
	self:Layout();
end
end


-- 纯色背景
local function CreateBG(frame)
	local f = frame
	if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	local bg = f:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", frame, -1, 1)
	bg:SetPoint("BOTTOMRIGHT", frame, 1, -1)
	bg:SetTexture("Interface\\Buttons\\WHITE8x8")
	bg:SetVertexColor(0, 0, 0)

	return bg
end

-- 带毛框幕布背景
local function CreateBackDrop(parent, anchor, a)
    local frame = CreateFrame("Frame", nil, parent)

	local flvl = parent:GetFrameLevel()
	if flvl - 1 >= 0 then frame:SetFrameLevel(flvl-1) end

	frame:ClearAllPoints()
    frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -3, 3)
    frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", 3, -3)

    frame:SetBackdrop(
    	{
    edgeFile = "Interface\\AddOns\\Col\\media\\glow", edgeSize = 3,  --外材宽度
    bgFile = "Interface\\Buttons\\WHITE8x8",
    insets = {left = 3, right = 3, top = 3, bottom = 3}	--内材与外材插入空隙
		}
	)
	if a then
		frame:SetBackdropColor(.2, .2, .2, 1)  --内材颜色
		frame:SetBackdropBorderColor(0, 0, 0)  --外材颜色
	end

    return frame
end



local function On_NpCreate(namePlate)

	local NF = namePlate.UnitFrame	

	-- 接管buff模块
	NF.BuffFrame.UpdateBuffs = UpdateBuffs;

	-- buff位置
	function NF.BuffFrame:UpdateAnchor()
		self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, SavedData["AuraHeight"]);
	end

	if not SavedData["OriCast"] then 	
		NF.castBar:HookScript('OnShow', function ( ... )
			SetCastbar(NF)
		end)
		NF.castBar:HookScript('OnSizeChanged', function ( ... )
			SetCastbar(NF)
		end) 
		NF.castBar:HookScript("OnUpdate", function ( ... )
			if not NF.castBar.Icon:IsShown() then 
				NF.castBar.Icon:Show()
			end
		end)
	end

	if not SavedData["OriElite"] then 
		NF.ClassificationFrame:Hide()
	end

	-- 描边
	NF.healthBar.border:SetVertexColor(0,0,0,.8)

	-- 名字
	NF.name:SetFont(C.NameFont, C.NameTextSize, nil)
	NF.name:SetTextColor(1,1,1)
	NF.name:SetShadowColor(0,0,0,1)
	NF.name:SetShadowOffset(.5,-.5)

	-- 血量
	NF.healthBar.value = createtext(NF.healthBar, "OVERLAY", 10, nil, "CENTER")
	NF.healthBar.value:SetShadowColor(0,0,0,1)
	NF.healthBar.value:SetShadowOffset(.5,-.5)
	NF.healthBar.value:SetTextColor(1,1,1)
	NF.healthBar.value:Hide()
	if C.CenterDetail then
		NF.healthBar.value:SetPoint("BOTTOM", NF.healthBar, "CENTER", 0, -4)
	else
		NF.healthBar.value:SetPoint("BOTTOMRIGHT", NF.healthBar, "RIGHT", 0, -4)
	end

	-- 施法条
	CreateBackDrop(NF.castBar, NF.castBar, 1) 
	if not SavedData["OriCast"] then 
	NF.castBar.Icon.iconborder = CreateBG(NF.castBar.Icon)
	NF.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)  -- IconLayer = 1
	end 

	-- 选中高亮
	NF.Tarlight = NF:CreateTexture("targethighlight", "BACKGROUND", nil, -1)
	NF.Tarlight:SetTexture("Interface\\AddOns\\Col\\media\\light")
	NF.Tarlight:SetPoint("BOTTOMLEFT", NF.healthBar, "LEFT", 7, 6)
	NF.Tarlight:SetPoint("BOTTOMRIGHT", NF.healthBar, "RIGHT", -7, 13)
	NF.Tarlight:SetVertexColor(0, 0.65, 1, 0.9)
	NF.Tarlight:SetTexCoord(0, 1, 1, 0)
	NF.Tarlight:SetBlendMode("ADD")
	NF.Tarlight:Hide()
end





local function UnregisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", nil)
end

local function SetUnit(unitFrame, unit)
	-- print (UnitName(unit, false))
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

local function UpdateAllNameplates()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		On_NpRefreshOnce(unitFrame)
	end	
end

local function NamePlates_OnEvent(self, event, ...)


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

	elseif ( event == "VARIABLES_LOADED" ) then
		SetCVar("NamePlateHorizontalScale", 1.4);
		SetCVar("NamePlateVerticalScale", 2.7);
		
	elseif ( event == "DISPLAY_SIZE_CHANGED" ) then  -- 窗口大小改变
		UpdateAllNameplates()
		

	elseif ( event == "NAME_PLATE_UNIT_REMOVED" ) then
		local unit = ...
		On_NpRemoved(unit)

	-- elseif event == "RAID_TARGET_UPDATE" then

	elseif ( event == "UNIT_FACTION" ) then   --载入后第一次
		UpdateAllNameplates()

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		InterfaceOptionsNamesPanelUnitNameplatesMakeLarger:SetValue(1)
		-- 强制大姓名板, todo 这里可取消esc变色
		local checkBox = InterfaceOptionsNamesPanelUnitNameplatesMakeLarger
		function checkBox.setFunc(value)
			-- NamePlates_UpdateNamePlateOptions()
		end

		-- local dropdown = InterfaceOptionsNPCNamesDropDown_OnClick
		-- function dropdown.SetValue(value)
		-- 	-- body
		-- end

		-- Show All Name
		SetCVar("UnitNameNPC", "1");
		SetCVar("UnitNameFriendlySpecialNPCName", "0");
		SetCVar("UnitNameHostleNPC", "0");
		SetCVar("UnitNameInteractiveNPC", "0");
		SetCVar("ShowQuestUnitCircles", "1");

		-- Large NamePlate 
		-- SetCVar("NamePlateHorizontalScale", 1.4);
		-- SetCVar("NamePlateVerticalScale", 2.7);
		-- NamePlateDriverFrame:UpdateNamePlateOptions();   --变红

		SetCVar("nameplateMaxDistance", G_Distence)
		SetCVar("nameplateSelectedScale", G_Select)
		SetCVar("nameplateMinAlpha", G_Alpha)
		SetCVar("nameplateGlobalScale", G_GlobalScale)

		if G_InitFirstLoadedOption then
			SetCVar("nameplateShowAll", 1)   --显示所有
			SetCVar("nameplateShowEnemies", 1)   --敌对单位
			SetCVar("nameplateShowEnemyMinions", 1)   --仆从
			SetCVar("nameplateShowEnemyMinus", 1)   --杂兵

			-- 堆叠 1 重叠 0
			SetCVar("nameplateMotion", 1) 

			--不让血条随距离改变而变小,预设Min 0.8
			SetCVar("namePlateMinScale", 1) 
			SetCVar("namePlateMaxScale", 1) 

			-- 血条水平堆叠 预设：0.8
			SetCVar("nameplateOverlapH",  0.6) 
			-- 血条垂直堆叠 预设 1.1
			SetCVar("nameplateOverlapV",  0.9) 
		end
	end

end


local NamePlatesFrame = CreateFrame("Frame", "NamePlatesFrame", UIParent)
NamePlatesFrame:SetScript("OnEvent", NamePlates_OnEvent)
NamePlatesFrame:RegisterEvent("VARIABLES_LOADED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_CREATED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")
NamePlatesFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
-- NamePlatesFrame:RegisterEvent("CVAR_UPDATE")
NamePlatesFrame:RegisterEvent("DISPLAY_SIZE_CHANGED")
-- NamePlatesFrame:RegisterEvent("RAID_TARGET_UPDATE")
NamePlatesFrame:RegisterEvent("UNIT_FACTION")
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

