-- 层级关系
-- NamePlates1UnitFrame
-- NamePlates1UnitFrame.BuffFrame
-- NamePlates1UnitFrame.castBar
-- NamePlates1UnitFrame.healthBar
-- NamePlates1UnitFrame.name
-- NamePlates1UnitFrame.unit
-- NamePlates1UnitFrame. etc
-- CVars
-- /dump GetCVar("NamePlateHorizontalScale")
-- /dump GetCVar("NamePlateVerticalScale")
-- /dump GetCVar("nameplateOverlapH")
-- /dump GetCVar("nameplateOverlapV")
-- /dump GetCVar("namePlateMinScale")
-- /dump GetCVar("namePlateMaxScale")

local _, ns = ...

local C = ns.C
local L = ns.L

DefaultData = {
	["Version"] = "8.3.001",
	["OriBar"] = true,
	["OriCast"] = true,
	["OriElite"] = true,
	["BarBgCol"] = false,

	["DetailType"] = 1,
	["Omen3"] = false,
	["Select"] = 1,
	["GlobalScale"] = 1.0,
	["Alpha"] = 0.8,
	["Distence"] = 45,
	["GapV"] = 0.8,
	["GapH"] = 0.6,

	["KillPer"] = 0,
	["KillRGBr"] = 1,
	["KillRGBg"] = 0.75,
	["KillRGBb"] = 0.15,

	["OriName"] = true,
	["NameWhite"] = true,
	["NameSize"] = 15,

	["AuraDefault"] = true,
	["AuraWhite"] = true,
	["AuraOnlyMe"] = false,
	["AuraHeight"] = 30,
	["AuraNum"] = 2,
	["OriAuraSize"] = false,
	["AuraSize"] = 22, 
	["AuraTimer"] = false,
	["AuraNumSize"] = 13,

	["CastHeight"] = 8,
	["SelectAlpha"] = 1.0,
	["CenterDetail"] = true,
	["ShowArrow"] = false,

	["Expball"] = false,

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
			G_InitFirstLoadedOption = true
			print ("|cffFFD700---RsPlates : "..L["UpdateInfo"].." |r")
			print ("|cffFFD700---".. L["UpdateVersion"]..": |r"..SavedData["Version"] ) 
		-- 长度一样，但版本号不同

		elseif SavedData["Version"] ~= DefaultData["Version"] then 
			SavedData = DefaultData
			G_InitFirstLoadedOption = true
			print ("|cffFFD700---RsPlates : "..L["UpdateInfo"].." |r")	
			print ("|cffFFD700---".. L["UpdateVersion"]..": |r"..SavedData["Version"] ) 		
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

-- 文本
local createtext = function(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(STANDARD_TEXT_FONT, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
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

--灰名
local function IsTapDenied(unitFrame)
	return UnitIsTapDenied(unitFrame.unit) and not UnitPlayerControlled(unitFrame.unit)
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
	local iType = SavedData["DetailType"]
	if iType == 1 then return "" end
	
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)

	local fPer = string.format("%.0f",(CurHealth/MaxHealth*100)).."%"
	local fCur = nil 
	if CurHealth > 10000 then
		fCur = string.format("%.1f",CurHealth/10000).."W"
	else
		fCur = tostring(CurHealth)
	end

	if iType == 2 then  --百分比
		return fPer

	elseif iType == 3 then --数值
		return fCur

	elseif iType == 4 then --数值/百分比
		return fCur.." / "..fPer
	end

end


local function IsOnKillHealth(unit)
	local CurHealth = UnitHealth(unit)
	local MaxHealth = UnitHealthMax(unit)
	return ((CurHealth/MaxHealth) < SavedData["KillPer"]/100);	
end


local function IsPlayerself(unitFrame)
	local unit = unitFrame.unit
	if unit then 
		if (UnitIsPlayer(unit) and (GetUnitName(unit) == UnitName("player"))) then
			return true
		end
	end
	return false
end


-- elseif only patch one
local function SetBarColor(frame)

	local unit = frame.unit
	local guid = UnitGUID(frame.unit)
	local _, _, _, _, _, id = strsplit("-", guid or "") 
	local r, g, b, a = 0, 1, 0, .8

	if IsPlayerself(frame) then return end
	-- 玩家
	if UnitIsPlayer(unit) then
		local _, englishClass = UnitClass(unit)
		local classColor = Ccolors[englishClass]
		r, g, b, a = classColor.r , classColor.g, classColor.b, 1

	-- 灰名
	elseif IsTapDenied(frame) then
		r, g, b, a = .8, .8, .8 , 1

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
	if SavedData["BarBgCol"] then 
		frame.healthBar.background:SetColorTexture(2*r/5, 2*g/5, 2*b/5, .8)
	end
end



local function SetUnitQuestState(unitFrame)
	local unit = unitFrame.unit
	local inInstance, instanceType = IsInInstance()
	if not inInstance then
		if IsQuestUnit(unit) then
			unitFrame.healthBar.questIcon:Show()
			return
		end	
	end
	unitFrame.healthBar.questIcon:Hide()
end

local function UpdateAllUnitQuestState()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		SetUnitQuestState(unitFrame)
	end
end

-- Highlight / 高亮
local function SetSelectionHighlight(unitFrame)
	local unit = unitFrame.unit
	if UnitIsUnit(unit, "target") and not UnitIsUnit(unit, "player") then
		if SavedData["ShowArrow"] then 
			unitFrame.healthBar.curTarget:Show()
		else
			unitFrame.healthBar.curTarget:Hide()
		end
		-- 中央高光
		--print (UnitName(unit))  name-server
		unitFrame.selectionHighlight:Show()
		unitFrame.selectionHighlight:SetVertexColor(1,1,1)
		-- unitFrame.name:Show()
		-- unitFrame.name:SetText(GetUnitName(unitFrame.unit))
		-- 边框
		unitFrame.healthBar.border:SetVertexColor(1,1,1,.6)

		unitFrame:SetAlpha(1)
		unitFrame.castBar.Icon:SetAlpha(1)
	else
		unitFrame.healthBar.curTarget:Hide()
		unitFrame.selectionHighlight:Hide()
		-- 边框
		unitFrame.healthBar.border:SetVertexColor(0,0,0,.6)
		if UnitIsUnit(unit, "player") then 
			unitFrame:SetAlpha(1)
		else
			unitFrame:SetAlpha(SavedData["SelectAlpha"])
		end
		unitFrame.castBar.Icon:SetAlpha(SavedData["SelectAlpha"])
	end
end


--血条数值
local function SetBloodText(unitFrame)
	if IsPlayerself(unitFrame) then 
		unitFrame.healthBar.value:Hide()
		return 
	end

	unitFrame.healthBar.value:Show()
	unitFrame.healthBar.value:SetText(GetDetailText(unitFrame.unit))
end





--  不是一个对象  所以self.Icon 并没拿到对应的姓名版对象
-- local function CastbarEvent(self, ...)
-- 	self.Icon:SetShown(true)
-- 	print '111111'
-- 	-- body
-- end
-- CastingBarFrame:SetScript("OnEvent", CastbarEvent)
-- CastingBarFrame:RegisterEvent("UNIT_SPELLCAST_START")

-- 窄施法条
local function SetThinCastingBar(self, unitFrame)
	if not SavedData["OriCast"] then

		-- self.iconWhenNoninterruptible = false    ---Dont do this, TAINT!!!
		-- self.Icon:SetShown(true)
		if not self.ThinCast then 
				self.Icon.iconborder:Show()
				self.around:Show()
				self:SetHeight(SavedData["CastHeight"])
				self.Icon:SetSize(SavedData["CastHeight"] + 13, SavedData["CastHeight"] + 13)
				self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -2, 0)
				self.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
				self.BorderShield:SetAtlas("nameplates-InterruptShield")
				self.BorderShield:SetSize(13, 15)
				self.BorderShield:SetPoint("CENTER", self, "LEFT", 5,-0)

				self:HookScript("OnEvent", function (self, event,  ... )
					if UnitIsUnit(unitFrame.unit, "target") and not UnitIsUnit(unitFrame.unit, "player") then  
						self.Icon:SetAlpha(1)
					else
						self.Icon:SetAlpha(SavedData["SelectAlpha"])
					end

					if event == "UNIT_SPELLCAST_START" then
						self.Icon:SetShown(true)
					end
				end)
				
				self:SetScript("OnSizeChanged", function ( ... )
					self.Icon.iconborder:Show()
					self.around:Show()
					self:SetHeight(SavedData["CastHeight"])
					self.Icon:SetSize(SavedData["CastHeight"] + 13, SavedData["CastHeight"] + 13)
					self.Icon:SetPoint("BOTTOMRIGHT", self, "BOTTOMLEFT", -2, 0)
					self.Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
					self.BorderShield:SetAtlas("nameplates-InterruptShield")
					self.BorderShield:SetSize(13, 15)
					self.BorderShield:SetPoint("CENTER", self, "LEFT", 5,-0)			
				end)

				self.ThinCast = true
		end
	end
end


--血条材质
local function SetBarTexture(unitFrame)
	if not SavedData["OriBar"] then 
		unitFrame.healthBar:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_rs")
		unitFrame.castBar:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_rs")	
		ClassNameplateManaBarFrame:SetStatusBarTexture("Interface\\AddOns\\Col\\media\\bar_rs")		
	end
end


--名字
local function SetBarName(unitFrame)
	local r,g,b,a = 1,1,1,1
	if IsTapDenied(unitFrame) then --灰名
		r, g, b, a = .6, .6, .6, 1
	elseif UnitReaction(unitFrame.unit, "player") == 4 then --中立
		r, g, b, a = 1, 1, 0, 1
	elseif UnitReaction(unitFrame.unit, "player") <= 3 then  --敌对
		r, g, b, a = 1, 0, 0, 1	
	end

	unitFrame.name:SetTextColor(r, g, b, a)
	unitFrame.name:SetFont(C.NameFont, 15, nil)

	local name, server =  UnitName(unitFrame.unit)
	if server then 
		unitFrame.name:SetText(name.."-"..server)
	else
		unitFrame.name:SetText(name)
	end

	if not SavedData["OriName"] then 
		if SavedData["NameWhite"] then 
			unitFrame.name:SetTextColor(1,1,1)
		end
		unitFrame.name:SetFont(C.NameFont, SavedData["NameSize"], nil)
	end
end

---手动设置一次需要设置的
local function On_NpRefreshOnce(unitFrame)
	SetBarTexture(unitFrame)

	SetThinCastingBar(unitFrame.castBar, unitFrame)

	SetBloodText(unitFrame)
	
	SetSelectionHighlight(unitFrame)

	SetBarColor(unitFrame)

	SetBarName(unitFrame)

	SetUnitQuestState(unitFrame)
end


local function NamePlate_OnEvent(self, event, ...)
	-- print (event)


	local arg1 = ...
	-- 光环  -----------------------------------------------------------------------

	-- if ( event == "UNIT_AURA" ) then
	-- 	SetAura(self)

	-- 仇恨 -----------------------------------------------------------------------
	if (event == "PLAYER_TARGET_CHANGED") then 		
		SetSelectionHighlight(self)
	end

	if (event == "UNIT_ABSORB_AMOUNT_CHANGED") then 	
		CompactUnitFrame_UpdateHealPrediction(self)
	end

	-- if (event == "UNIT_HEAL_ABSORB_AMOUNT_CHANGED") then 	
	-- 	CompactUnitFrame_UpdateHealPrediction(self)
	-- end

	-- if (event == "UNIT_HEAL_PREDICTION") then 	
	-- 	CompactUnitFrame_UpdateHealPrediction(self)
	-- end


	if (arg1 == self.unit or arg1 == self.displayedUnit) then 
	-- 血量  -----------------------------------------------------------------------
		if (event == "UNIT_HEALTH_FREQUENT") then
			CompactUnitFrame_UpdateHealPrediction(self)
			local CurHealth = UnitHealth(arg1)
			-- local MaxHealth = UnitHealthMax(arg1)
			-- self.healthBar:SetMinMaxValues(0,1)
			-- self.healthBar:SetValue(CurHealth/MaxHealth)
			self.healthBar:SetValue(CurHealth)
			SetBloodText(self)

			if SavedData["KillPer"] ~= 0 then  -- 检查斩杀线
				SetBarColor(self)
			end

		-- 切目标  -----------------------------------------------------------------------
		elseif (event == "UNIT_THREAT_LIST_UPDATE") then 
			SetBarColor(self)
		elseif (event == "UNIT_NAME_UPDATE") then
			SetBarName(self)
		elseif (event == "UNIT_MAXHEALTH") then
			local CurHealth = UnitHealth(arg1)
			local MaxHealth = UnitHealthMax(arg1)
			self.healthBar:SetMinMaxValues(0, MaxHealth)
			self.healthBar:SetValue(CurHealth)
			SetBloodText(self)			
			CompactUnitFrame_UpdateHealPrediction(self)
		end
	end
end

local function RegisterNamePlateEvents(unitFrame)
	unitFrame:RegisterEvent("UNIT_THREAT_LIST_UPDATE")
	unitFrame:RegisterEvent("UNIT_HEALTH_FREQUENT")
	unitFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	unitFrame:RegisterEvent("UNIT_NAME_UPDATE")
	unitFrame:RegisterEvent("UNIT_ABSORB_AMOUNT_CHANGED")

	unitFrame:RegisterEvent("UNIT_MAXHEALTH")

	-- unitFrame:RegisterEvent("UNIT_HEAL_ABSORB_AMOUNT_CHANGED")
	-- unitFrame:RegisterEvent("UNIT_HEAL_PREDICTION")
	unitFrame:SetScript("OnEvent", NamePlate_OnEvent)
	-- unitFrame:RegisterEvent("UNIT_AURA")
	-- unitFrame:RegisterEvent("UNIT_HEALTH")
end

local function UpdateBuffsRS(self, unit, filter, showAll)
	if SavedData["AuraNum"] == 0 then return end
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
							self.buffList[buffIndex].align = "right";
							if not SavedData["OriAuraSize"] then 
								self.buffList[buffIndex]:SetSize(SavedData["AuraSize"],SavedData["AuraSize"])
								self.buffList[buffIndex].Icon:SetPoint("TOPLEFT",self.buffList[buffIndex],"TOPLEFT", 1, -1)
								self.buffList[buffIndex].Icon:SetPoint("BOTTOMRIGHT",self.buffList[buffIndex],"BOTTOMRIGHT", -1, 1)
								self.buffList[buffIndex].Icon:SetTexCoord(0.1, 0.9,0.1 , 0.9)
							end
							self.buffList[buffIndex].Cooldown:SetHideCountdownNumbers(not SavedData["AuraTimer"])
							local regon = self.buffList[buffIndex].Cooldown:GetRegions()
							if regon.GetText then 
								regon:SetFont(C.NameFont, SavedData["AuraNumSize"], nil)  --Default : 15 "OUTLINE"
							end
						end

						local buff = self.buffList[buffIndex];

						buff:SetID(i);
						buff.Icon:SetTexture(texture);

						-- 层数 
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



local function On_NpCreate(namePlate)
	local NF = namePlate.UnitFrame	

	-- -- 接管buff模块
	NF.BuffFrame.UpdateBuffs = UpdateBuffsRS

	-- buff位置
	function NF.BuffFrame:UpdateAnchor()
		self:SetPoint("BOTTOM", self:GetParent().healthBar, "TOP", 0, SavedData["AuraHeight"]);
	end

	if not SavedData["OriElite"] then 
		NF.ClassificationFrame:Hide()
	end

	-- todo 吸收模块暂做屏蔽
	-- NF.healthBar.totalAbsorbOverlay:SetAlpha(0)
	-- NF.healthBar.totalAbsorb:SetAlpha(0)
	-- NF.healthBar.myHealAbsorb:SetAlpha(0)
	-- NF.healthBar.myHealPrediction:SetAlpha(0)
	-- NF.healthBar.otherHealPrediction:SetAlpha(0)
	-- NF.healthBar.overAbsorbGlow:SetAlpha(0)
	-- NF.healthBar.overHealAbsorbGlow:SetAlpha(0)

	-- 描边
	NF.healthBar.border:SetVertexColor(0,0,0,.6)

	NF.castBar.around = CreateBackDrop(NF.castBar, NF.castBar, 1) 
	NF.castBar.Icon.iconborder = CreateBG(NF.castBar.Icon)
	NF.castBar.Icon.iconborder:SetDrawLayer("OVERLAY", -1)  -- IconLayer = 1
	NF.castBar.Icon.iconborder:Hide()
	NF.castBar.around:Hide()
	-- NF.castBar.iconWhenNoninterruptible = true           --- cause TAINT !!

	NF.healthBar.questIcon = NF.healthBar:CreateTexture("QuestIcon", "OVERLAY")
	NF.healthBar.questIcon:SetSize(30, 30)
	NF.healthBar.questIcon:SetTexture("Interface\\AddOns\\Col\\media\\questQuestion")
	NF.healthBar.questIcon:SetPoint("CENTER", NF.healthBar, "CENTER", 0, 45)
	NF.healthBar.questIcon:SetVertexColor(.96, .85 , .1)
	NF.healthBar.questIcon:Hide()
	-- 名字
	-- NF.name:SetFont(C.NameFont, C.NameTextSize, nil)
	-- NF.name:SetTextColor(1,1,1)
	-- NF.name:SetShadowColor(0,0,0,1)
	-- NF.name:SetShadowOffset(.5,-.5)

	-- 血量
	NF.healthBar.value = createtext(NF.healthBar, "OVERLAY", 10, nil, "CENTER")
	NF.healthBar.value:SetShadowColor(0,0,0,1)
	NF.healthBar.value:SetShadowOffset(.5,-.5)
	NF.healthBar.value:SetTextColor(1,1,1)
	NF.healthBar.value:Hide()
	if SavedData["CenterDetail"] then
		NF.healthBar.value:SetPoint("BOTTOM", NF.healthBar, "CENTER", 0, -4)
	else
		NF.healthBar.value:SetPoint("BOTTOMRIGHT", NF.healthBar, "RIGHT", 0, -4)
	end

	-- 箭头
	NF.healthBar.curTarget = NF.healthBar:CreateTexture("ArrowH", "OVERLAY")
	NF.healthBar.curTarget:SetSize(50, 50)
	NF.healthBar.curTarget:SetTexture("Interface\\AddOns\\Col\\media\\arrorH")
	NF.healthBar.curTarget:SetPoint("LEFT", NF.healthBar, "RIGHT", 0, 0)
	NF.healthBar.curTarget:Hide()
end

local function UnregisterNamePlateEvents(unitFrame)
	unitFrame:UnregisterAllEvents()
	unitFrame:SetScript("OnEvent", nil)
end

local function SetUnit(unitFrame, unit)
	unitFrame.unit = unit                 --todo: Dont do this !! for now, find another way 
	unitFrame.displayedUnit = unit	 -- For vehicles
	-- unitFrame.inVehicle = false
	if ( unit ) then
		RegisterNamePlateEvents(unitFrame)
	else
		UnregisterNamePlateEvents(unitFrame)
	end
end

local function On_NpAdd(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	local unitFrame = namePlate.UnitFrame
	SetUnit(unitFrame, unit)
	On_NpRefreshOnce(unitFrame)
end

local function On_NpRemoved(unit)
	local namePlate = C_NamePlate.GetNamePlateForUnit(unit)
	SetUnit(namePlate.UnitFrame, nil)
	CastingBarFrame_SetUnit(namePlate.UnitFrame.castBar, nil, false, true)
end

function UpdateAllNameplates()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		On_NpRefreshOnce(unitFrame)
	end	
end

local function InitAndCvar()
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
	-- SetCVar("nameplateMinAlpha", G_Alpha)
	SetCVar("nameplateGlobalScale", G_GlobalScale)

	-- 血条水平堆叠 预设：0.8
	SetCVar("nameplateOverlapH",  SavedData["GapH"]) 
	-- 血条垂直堆叠 预设 1.1
	SetCVar("nameplateOverlapV",  SavedData["GapV"]) 

	--不让血条随距离改变而变小,预设Min 0.8
	SetCVar("namePlateMinScale", 1) 
	SetCVar("namePlateMaxScale", 1) 
		
	-- 首次使用或更新后的首次登陆加载
	if G_InitFirstLoadedOption then
		-- V所开启的姓名版类型
		SetCVar("nameplateShowAll", 1)   --显示所有
		SetCVar("nameplateShowEnemies", 1)   --敌对单位
		SetCVar("nameplateShowEnemyMinions", 1)   --仆从
		SetCVar("nameplateShowEnemyMinus", 1)   --杂兵

		-- 堆叠 1 重叠 0
		SetCVar("nameplateMotion", 1) 

		-- 遮挡姓名版透明度与  个人资源条 显示逻辑
		SetCVar("NameplatePersonalShowInCombat", 1)
		SetCVar("NameplatePersonalShowWithTarget", 1)
		SetCVar("nameplateOccludedAlphaMult", 0.2)
	end	
end

local function NamePlates_OnEvent(self, event, ...)
	if ( event == "NAME_PLATE_CREATED" ) then
		On_NpCreate(...)		

	elseif ( event == "NAME_PLATE_UNIT_ADDED" ) then
		On_NpAdd(...)

	elseif ( event == "VARIABLES_LOADED" ) then
		SetCVar("NamePlateHorizontalScale", 1.4);
		SetCVar("NamePlateVerticalScale", 2.7);
		
	elseif ( event == "DISPLAY_SIZE_CHANGED" ) then  -- 窗口大小改变
		UpdateAllNameplates()

	elseif ( event == "NAME_PLATE_UNIT_REMOVED" ) then
		On_NpRemoved(...)

	-- elseif event == "RAID_TARGET_UPDATE" then

	elseif ( event == "UNIT_FACTION" ) then   --载入后第一次
		UpdateAllNameplates()

	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		InitAndCvar()
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
	
-- SLASH_FRAMESTK1 = "/fs"	
-- SlashCmdList.FRAMESTK = function()
-- 	LoadAddOn('Blizzard_DebugTools')
-- 	FrameStackTooltip_Toggle()
	-- RefBuff()
-- end

-- SLASH_CPU1 = "/cpu"
-- SlashCmdList.CPU = function()
-- 	local cpu = GetAddOnCPUUsage("Col")
-- 	print("CPU占用:    ", cpu-cpu%0.01)
-- 	local Memory = GetAddOnMemoryUsage("Col")
-- 	print("内存使用:   ", Memory-Memory%0.01, "  KB")
-- end


local function BoomBall()
	local haskey = false

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		local guid = UnitGUID(unitFrame.unit)
		local _, _, _, _, _, id = strsplit("-", guid or "") 
		if id == "120651" then
			haskey = true
		end
	end	

	-- 场上存在易爆球
	if haskey then 
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
				local unitFrame = namePlate.UnitFrame
				local guid = UnitGUID(unitFrame.unit)
				local _, _, _, _, _, id = strsplit("-", guid or "") 
				if id ~= "120651" then
					unitFrame:Hide()
				end
			end
	else
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
				local unitFrame = namePlate.UnitFrame
				unitFrame:Show()
			end		

	end
end

local boomFrame = CreateFrame("Frame")
local timei = 0 
boomFrame:SetScript("OnUpdate", function (self, elasped)
	if not SavedData["Expball"] then return end
	timei = timei + elasped
	if timei > 0.2 then
		BoomBall()
		timei = 0
	end
end)


--配合gui部分做的界面刷新,不产生任何新逻辑
------------------------------------------------
function RefBuff()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		unitFrame.BuffFrame:UpdateAnchor()
		if unitFrame.unit then 
			local buff = unitFrame.BuffFrame
			for i = 1, BUFF_MAX_DISPLAY do
				if buff.buffList[i] then 
					--光环大小
					buff.buffList[i]:SetSize(SavedData["AuraSize"], SavedData["AuraSize"])
					--计时器
					buff.buffList[i].Cooldown:SetHideCountdownNumbers(not SavedData["AuraTimer"])
					--计时器大小
					local regon = buff.buffList[i].Cooldown:GetRegions()
					if regon.GetText then 
						regon:SetFont(C.NameFont, SavedData["AuraNumSize"], nil)  --Default : 15 "OUTLINE"
					end					
				end
			end
		end
	end	
end




----------------------------------------------------
---- Quest Function Copied From TPTP(Threat Plates)
----------------------------------------------------

local QUEST_OBJECTIVE_PARSER_LEFT = function(text)
  local current, goal, objective_name = string.match(text,"^(%d+)/(%d+)( .*)$")
  return objective_name, current, goal
end

local QUEST_OBJECTIVE_PARSER_RIGHT = function(text)
  return string.match(text,"^(.*: )(%d+)/(%d+)$")
end

local PARSER_QUEST_OBJECTIVE_BACKUP = function(text)
  local current, goal, objective_name = string.match(text,"^(%d+)/(%d+)( .*)$")

  if not objective_name then
    objective_name, current, goal = string.match(text,"^(.*: )(%d+)/(%d+)$")
  end

  return objective_name, current, goal
end

local STANDARD_QUEST_OBJECTIVE_PARSER = {
  -- x/y Objective
  enUS = QUEST_OBJECTIVE_PARSER_LEFT,
  -- enGB = enGB clients return enUS
  esMX = QUEST_OBJECTIVE_PARSER_LEFT,
  ptBR = QUEST_OBJECTIVE_PARSER_LEFT,
  itIT = QUEST_OBJECTIVE_PARSER_LEFT,
  koKR = QUEST_OBJECTIVE_PARSER_LEFT,
  zhTW = QUEST_OBJECTIVE_PARSER_LEFT,
  zhCN = QUEST_OBJECTIVE_PARSER_LEFT,

  -- Objective: x/y
  deDE = QUEST_OBJECTIVE_PARSER_RIGHT,
  frFR = QUEST_OBJECTIVE_PARSER_RIGHT,
  esES = QUEST_OBJECTIVE_PARSER_RIGHT,
  ruRU = QUEST_OBJECTIVE_PARSER_RIGHT,
}

local QuestObjectiveParser = STANDARD_QUEST_OBJECTIVE_PARSER[GetLocale()] or PARSER_QUEST_OBJECTIVE_BACKUP

local _G, WorldFrame = _G, WorldFrame
local TooltipFrame = CreateFrame("GameTooltip", "ThreatPlates_Tooltip", nil, "GameTooltipTemplate")

local QuestList, QuestIDs, QuestsToUpdate = {}, {}, {}


function IsQuestUnit(unit, create_watcher)
  if not unit then return false, false, nil end

  local unitGUID = UnitGUID(unit)
  local quest_title
  -- local unit_name
  local quest_player = true
  local quest_progress = false

  -- Read quest information from tooltip. Thanks to Kib: QuestMobs AddOn by Tosaido.
  TooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE")
  --TooltipFrame:SetUnit(unitid)
  TooltipFrame:SetHyperlink("unit:" .. unitGUID)

  for i = 3, TooltipFrame:NumLines() do
    local line = _G["ThreatPlates_TooltipTextLeft" .. i]  --obj
    local text = line:GetText()
    -- print (text)
    local text_r, text_g, text_b = line:GetTextColor()


    -- print ("Line: |" .. text .. "|")
    -- print ("  => ", text_r, text_g, text_b)
    if text_r > 0.99 and text_g > 0.82 and text_b == 0 then
      -- A line with this color is either the quest title or a player name (if on a group quest, but always after the quest title)
      if quest_title then
        quest_player = (text == PlayerName)
        -- unit_name = text
      else
        quest_title = text

      end
    elseif quest_title and quest_player then
      local objective_name, current, goal
      local objective_type = false

      -- Set quest_title to false again, otherwise a second quest in the tooltip will not be found (first if statement will
      -- check for quest_player only as quest_title is still set to the first quest
      quest_title = false

      -- Check if area / progress quest
      if string.find(text, "%%") then
        objective_name, current, goal = string.match(text, "^(.*) %(?(%d+)%%%)?$")
        objective_type = "area"
        --print (unit_name, "=> ", "Area: |" .. text .. "|", objective_name, current, goal)
      else
        -- Standard x/y /pe quest
        objective_name, current, goal = QuestObjectiveParser(text)
        --print (unit_name, "=> ", "Standard: |" .. text .. "|", objective_name, current, goal, "|")
      end

      if objective_name then
        current = tonumber(current)

        if objective_type then
          goal = 100
        else
          goal = tonumber(goal)
        end

        -- Note: "progressbar" type quest (area quest) progress cannot get via the API, so for this tooltips
        -- must be used. That's also the reason why their progress is not cached.

        -- local Quests = QuestList
        -- if Quests[quest_title] then
        --   local quest_objective = Quests[quest_title].objectives[objective_name]
        --   if quest_objective then
        --     current = quest_objective.current
        --     goal = quest_objective.goal
        --     objective_type = quest_objective.type
        --   end
        -- end

        -- A unit may be target of more than one quest, the quest indicator should be show if at least one quest is not completed.
        if current and goal then
        	-- print (current, goal, objective_name)
          if (current ~= goal) then
            return true, 1, { current = current, goal = goal, type = objective_type }
          end
        else
          -- Line after quest title with quest information, so we can stop here
          return false
        end
      end
    end
  end

  return false
end

local function Quest_Event(self, event, ...)	-- self <--QuestEventFrame 
	local arg = ...
	if event == "UNIT_QUEST_LOG_CHANGED" then
		local inInstance, instanceType = IsInInstance()
		if not inInstance then 
			UpdateAllUnitQuestState()
		end
	end
end

local QuestEventFrame = CreateFrame("Frame")
QuestEventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
QuestEventFrame:SetScript("OnEvent", Quest_Event)