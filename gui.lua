
-------SomePrepare Tools(Jobs) ---------

function table_copy(table)
	local NewTable = {}
	if table then
		for k, v in pairs(table) do
			NewTable[k] = v 
		end
	end
	return NewTable;
end

function table_same(table1, table2)
	local leng1, leng2 = table_leng(table1), table_leng(table2)
	if leng1 ~= leng2 then return false end 

	if table1 and table2 then
		for k, v in pairs(table1) do
			-- print '-----'
			-- print (table2[k])
			-- print (v)
			if not (table2[k] == v) then
				-- print '!!!!!!!!'
				-- print ("不符合的是"..v.."...."..table2[k])
				return false
			end
		end
	end
	return true
end

function table_keys(t)
	local tbKeys = {}
	local i = 1
	for k, v in pairs(t) do
		tbKeys[i] = k
		i = i + 1
	end	
	return tbKeys;
end

function table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;  --return int
end

function GetTrueNum(table)
	local i = 0
	for k, v in pairs(table) do 
		if v then 
			i = i + 1
		end 
	end 
	return i
end 

------------------
local myGUI = {}

-- local function OnOkay()
-- 	local GUIData = {}
-- 	GUIData["Version"] = SavedData["Version"]
-- 	GUIData["Flat"] = myGUI.frame1.pFlat:GetChecked()
-- 	GUIData["Detail"] = myGUI.frame1.pDetail:GetChecked()
-- 	GUIData["Omen3"] = myGUI.frame1.pOmen3:GetChecked()
-- 	GUIData["AuraOnlyMe"] = myGUI.frame2.pAuraOnlyMe:GetChecked()
-- 	GUIData["Select"] = tonumber(string.format("%.1f",myGUI.frame1.pSelectedScale:GetValue()))
-- 	GUIData["GlobalScale"] = tonumber(string.format("%.1f",myGUI.frame1.pGlobalScale:GetValue()))
-- 	GUIData["Alpha"] = tonumber(string.format("%.1f",myGUI.frame1.pAlpha:GetValue()))
-- 	GUIData["Distence"] = tonumber(string.format("%.0f",myGUI.frame1.pDistence:GetValue()))  
-- 	GUIData["KillPer"] = tonumber(string.format("%.0f",myGUI.frame1.pKillper:GetValue()))  
-- 	GUIData["KillRGBr"] = tonumber(string.format("%.2f",myGUI.frame1.fR))
-- 	GUIData["KillRGBg"] = tonumber(string.format("%.2f",myGUI.frame1.fG))
-- 	GUIData["KillRGBb"] = tonumber(string.format("%.2f",myGUI.frame1.fB))  
-- 	-----第二页
-- 	GUIData["AuraNum"] = tonumber(string.format("%.0f",myGUI.frame2.pAuraNum:GetValue()))  
-- 	GUIData["DctAura"] = myGUI.frame2.DctDisplay
-- 	-- GUIData["Distence"] = string.format("%.0f",frame.pDistence:GetValue()) 

-- 	DBcopy = table_copy(SavedData)
-- 	GUIcopy = table_copy(GUIData)

-- 	if (table_same(DBcopy["DctAura"],GUIData["DctAura"])) then   --光环相同
-- 		DBcopy["DctAura"] = nil
-- 		GUIData["DctAura"] = nil
-- 		if (table_same(DBcopy, GUIData)) then    --非光环相相同
-- 		else
-- 			SavedData = GUIcopy
-- 			ReloadUI()
-- 		end

-- 		--没做任何更改
-- 	else
-- 			SavedData = GUIcopy
-- 			ReloadUI()
-- 	end
-- end



myGUI.frame1 = CreateFrame("Frame", "MainGUI", InterfaceOptionsFrame)
myGUI.frame1.name = '|cff33FFFFRS_P|r 基础'





myGUI.frame2 = CreateFrame( "Frame", "AURAGUI", myGUI.frame1); 
myGUI.frame2.name = '|cff33FFFF|r       白名单'
myGUI.frame2.parent = myGUI.frame1.name


myGUI.frame1:SetScript("OnShow", function(frame)


	local version = SavedData["Version"]

	local PlateColor = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	PlateColor:SetPoint("TOPLEFT", 16, -16)
	PlateColor:SetText("RsPlates姓名板 - 基础设置")
	PlateColor:SetFont("fonts\\ARHei.ttf", 30, "OUTLINE")

	if not frame.sInfo then 
	frame.sInfo = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	end
	frame.sInfo:SetPoint("BOTTOMRIGHT", -10, 10)
	frame.sInfo:SetText("建议系统设置开启 “大姓名板”\r\r @版本号: "..version)
	frame.sInfo:SetJustifyH("RIGHT")



	local function newCheckbox(label, description)
		local check = CreateFrame("CheckButton", "PlateColorCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = description
		-- check.tooltipRequirement = description
		return check
	end

	local function newSlider(SliderName, x, y, minValue, maxValue, curValue, valueStep, lowText, highText, upText, tipText)
		local pSlider = CreateFrame("Slider", "Slider"..SliderName , frame, "OptionsSliderTemplate" );
		pSlider:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y);
		pSlider:SetMinMaxValues(minValue, maxValue);
		pSlider:SetValue(curValue);
		pSlider:SetValueStep(valueStep);
		pSlider:SetObeyStepOnDrag(true);
		pSlider.textLow = _G["Slider"..SliderName.."Low"]
		pSlider.textHigh = _G["Slider"..SliderName.."High"]
		pSlider.text = _G["Slider"..SliderName.."Text"]
		pSlider.textLow:SetText(lowText)
		pSlider.textHigh:SetText(highText)
		pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")

		pSlider:SetScript("OnValueChanged", 
		function(pSlider,event,arg1) 
			pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")
		end)
		pSlider.tooltipText = tipText
		-- body
		return pSlider
	end


	local bFlat, bDetail, bOmen3, fSelecte, fAlpha, fDistence = SavedData["Flat"], SavedData["Detail"], SavedData["Omen3"], SavedData["Select"], SavedData["Alpha"], SavedData["Distence"]
	frame.fR, frame.fG, frame.fB = SavedData["KillRGBr"], SavedData["KillRGBg"], SavedData["KillRGBb"]
	local iKillper = SavedData["KillPer"]
	local fGlobalScale = SavedData["GlobalScale"]



	-- 扁平材质
	if not frame.pOriBar then
		frame.pOriBar = newCheckbox("源生材质|cffFFC0CB(重载生效)|r","使用源生的血条材质，取消勾选则会使用一组扁平化材质")
		frame.pOriBar:SetPoint("TOPLEFT", 16, -80)
	end
	frame.pOriBar:SetChecked(SavedData["OriBar"])
	frame.pOriBar:HookScript("OnClick", function(self)
		SavedData["OriBar"] = self:GetChecked()
	end)

	-- 显示血量
	if not frame.pDetail then
		frame.pDetail = newCheckbox("显示血量与百分比|cffFFC0CB|r","进入战斗中的单位将会在血条内显示血量与百比分")
		frame.pDetail:SetPoint("TOPLEFT", 16, -120)
	end
	frame.pDetail:SetChecked(SavedData["Detail"])
	frame.pDetail:HookScript("OnClick", function(self)
		SavedData["Detail"] = self:GetChecked()
	end)

	-- 仇恨染色
	if not frame.pOmen3 then
		frame.pOmen3 = newCheckbox("开启仇恨染色|cffFFC0CB|r","根据单位与你的仇恨对血条进行染色：\n\n|cff1AB3E9蓝色|r：低仇恨，安全\n|cff661AE9紫色|r：高仇恨，即将OT\n|cffE91AE9红色|r：极高仇恨，已OT(获得仇恨)")
		frame.pOmen3:SetPoint("TOPLEFT", 16, -160)
	end
	frame.pOmen3:SetChecked(SavedData["Omen3"])
	frame.pOmen3:HookScript("OnClick", function(self)
		SavedData["Omen3"] = self:GetChecked()
	end)

	-- 选中缩放
	if not frame.pSelectedScale then
		frame.pSelectedScale = newSlider("SelectedScale", 16, -220, 1, 2, 1.2, 0.1, "不放大", "放大","选中缩放","选中单位的血条放大倍数")
	end
	frame.pSelectedScale:SetValue(fSelecte)
	frame.pSelectedScale:HookScript("OnValueChanged", function(self, value)
		SavedData["Select"] = tonumber(string.format("%.1f",self:GetValue()))
		SetCVar("nameplateSelectedScale", SavedData["Select"])
	end)


	-- 透明度
	if not frame.pAlpha then
		frame.pAlpha = newSlider("Alpha", 16, -280, 0.2, 1, 0.8, 0.1, "透明", "不透明", "透明度", "10码外非当前选中目标血条的透明度")
	end
	frame.pAlpha:SetValue(fAlpha)
	frame.pAlpha:HookScript("OnValueChanged", function(self, value)
		SavedData["Alpha"] = tonumber(string.format("%.1f",self:GetValue()))
		SetCVar("nameplateMinAlpha", SavedData["Alpha"])
	end)

	-- 血条距离
	if not frame.pDistence then
		frame.pDistence = newSlider ("Distence", 16, -340, 10, 60, 50, 1, "近", "远", "血条距离", "显示多少码数内的单位血条")
	end
	frame.pDistence:SetValue(fDistence)
	frame.pDistence:HookScript("OnValueChanged", function(self, value)
		SavedData["Distence"] = tonumber(string.format("%.0f",self:GetValue()))
		SetCVar("nameplateMaxDistance", SavedData["Distence"])
	end)

	-- 全局缩放
	if not frame.pGlobalScale then
		frame.pGlobalScale = newSlider("GlobalScale", 16, -400, 0.5, 2, 1, 0.1, "小", "大", "全局缩放", "姓名板大小全局缩放" )
	end
	frame.pGlobalScale:SetValue(fGlobalScale)
	frame.pGlobalScale:HookScript("OnValueChanged", function(self, value)
		SavedData["GlobalScale"] = tonumber(string.format("%.1f",self:GetValue()))
		SetCVar("nameplateGlobalScale", SavedData["GlobalScale"])
	end)

	-- 斩杀线
	if not frame.pKillper then
		frame.pKillper = newSlider("Killper", 16, -460, 0, 100, 0, 5, "关", "高血限", "斩杀线(%)", "设置斩杀线, 0 关闭斩杀染色")
	end
	frame.pKillper:SetValue(iKillper)
	frame.pKillper:HookScript("OnValueChanged", function(self, value)
		SavedData["KillPer"] = tonumber(string.format("%.0f",self:GetValue()))
	end)


	-- 斩杀text
	if not frame.AuraText then 
		frame.AuraText = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.AuraText:SetFontObject("GameFontHighlight");
	frame.AuraText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -520 );   
	-- frame.AuraText:SetParent(frame)    
	frame.AuraText:SetText("|cFFFFD700 斩杀颜色(点击选择)： |r");

	-- 色块
	if not frame.col then 
		frame.col = frame:CreateTexture(nil, "BACKGROUND")
		frame.col:SetPoint("TOPLEFT", frame, "TOPLEFT", 180, -520)
		frame.col:SetSize(70,15)
	end
	frame.col:SetColorTexture(frame.fR,frame.fG,frame.fB)

	-- 隐形btn
	frame.BtnCol = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
	frame.BtnCol:SetPoint("TOPLEFT", frame, "TOPLEFT", 180 , -520);  
	frame.BtnCol:SetSize(70,15);
	frame.BtnCol:SetAlpha(0)
	frame.BtnCol:SetNormalFontObject("GameFontNormalLarge");
	frame.BtnCol:SetHighlightFontObject("GameFontHighlightLarge");
	frame.BtnCol:SetScript("OnClick", function(self, button, down)

		ColorPickerFrame:SetColorRGB(frame.fR,frame.fG,frame.fB)
		ColorPickerFrame:Show()
		ColorPickerCancelButton:Hide()
		ColorPickerFrame.func = function(restore)
				local r,g,b = ColorPickerFrame:GetColorRGB();
				frame.col:SetColorTexture(r,g,b)  --同步色块颜色
				SavedData["KillRGBr"] = tonumber(string.format("%.2f",r))
				SavedData["KillRGBg"] = tonumber(string.format("%.2f",g))
				SavedData["KillRGBb"] = tonumber(string.format("%.2f",b))
				end
		end)


	-- 源生施法条
	if not frame.pOriCast then
		frame.pOriCast = newCheckbox("源生施法条|cffFFC0CB(重载生效)|r","开启源生施法条样式")
		frame.pOriCast:SetPoint("TOPLEFT", 260, -80)
	end
	frame.pOriCast:SetChecked(SavedData["OriCast"])
	frame.pOriCast:HookScript("OnClick", function(self)
		SavedData["OriCast"] = self:GetChecked()
	end)

	-- 源生精英图标
	if not frame.pOriElite then
		frame.pOriElite = newCheckbox("源生精英图标|cffFFC0CB(重载生效)|r","开启源生精英,银英生物图标")
		frame.pOriElite:SetPoint("TOPLEFT", 260, -120)
	end
	frame.pOriElite:SetChecked(SavedData["OriElite"])
	frame.pOriElite:HookScript("OnClick", function(self)
		SavedData["OriElite"] = self:GetChecked()
	end)

	-- text- 光环显示策略
	if not frame.AuraShow then 
		frame.AuraShow = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.AuraShow:SetFontObject("GameFontHighlight");
	frame.AuraShow:SetPoint("TOPLEFT", frame, "TOPLEFT", 260, -180);   
	frame.AuraShow:SetText("|cFFFFD700 选择需要显示的光环 (buff/debuff)： |r");

	-- btn 说明
	if not frame.BtnAuraHelp then 
		frame.BtnAuraHelp = CreateFrame("Button", nil, frame);
		frame.BtnAuraHelp:SetPoint("CENTER", frame, "TOPLEFT", 540 , -187);  
		frame.BtnAuraHelp:SetSize(35,35);
		frame.BtnAuraHelp:SetText(nil)
		frame.BtnAuraHelp:SetNormalTexture("Interface\\common\\help-i")
		frame.BtnAuraHelp:SetScript("OnEnter", function(self, button, down)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("系统默认指不开插件也会显示的光环 \n\n白名单指玩家单独配置的光环 \n\n各选项并不互斥，根据实际需要勾选\n\n注:白名单同样作用于个人资源条\n这意味着可以通过白名单来配置技能\n监视，一定程度上可替代Tmw/Wa等 ")
			GameTooltip:Show()
		end)
		frame.BtnAuraHelp:SetScript("OnLeave", function(self, button, down)
			GameTooltip:Hide()
		end)
	end

	-- check  默认
	if not frame.pDefaultBuff then
		frame.pDefaultBuff = newCheckbox("系统默认|r","游戏默认的光环显示策略")
		frame.pDefaultBuff:SetPoint("TOPLEFT", 260, -210)
	end
	frame.pDefaultBuff:SetChecked(SavedData["AuraDefault"])
	frame.pDefaultBuff:HookScript("OnClick", function(self)
		SavedData["AuraDefault"] = self:GetChecked()
	end)

	-- check  白名单
	if not frame.pWitheListBuff then
		frame.pWitheListBuff = newCheckbox("白名单|r","玩家手动配置的光环显示策略")
		frame.pWitheListBuff:SetPoint("TOPLEFT", 390, -210)
	end
	frame.pWitheListBuff:SetChecked(SavedData["AuraWhite"])
	frame.pWitheListBuff:HookScript("OnClick", function(self)
		SavedData["AuraWhite"] = self:GetChecked()
	end)

	if not frame.pOnlyMeBuff then
		frame.pOnlyMeBuff = newCheckbox("只检测我释放的|r","只检测来源于我和我的宠物的光环")
		frame.pOnlyMeBuff:SetPoint("TOPLEFT", 260, -240)
	end
	frame.pOnlyMeBuff:SetChecked(SavedData["AuraOnlyMe"])
	frame.pOnlyMeBuff:HookScript("OnClick", function(self)
		SavedData["AuraOnlyMe"] = self:GetChecked()
	end)

	-- text- 光环显示样式
	if not frame.AuraDetail then 
		frame.AuraDetail = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.AuraDetail:SetFontObject("GameFontHighlight");
	frame.AuraDetail:SetPoint("TOPLEFT", frame, "TOPLEFT", 260, -280);   
	frame.AuraDetail:SetText("|cFFFFD700 设置光环显示的样式： |r");

	-- slider 光环显示高度
	if not frame.pAuraHeight then
		frame.pAuraHeight = newSlider("AuraHeight", 260, -340, -30, 50, 20, 1, "低", "高", "光环高度", "光环图标相对于血条的高度" )
	end
	frame.pAuraHeight:SetValue(SavedData["AuraHeight"])
	frame.pAuraHeight:HookScript("OnValueChanged", function(self, value)
		SavedData["AuraHeight"] = tonumber(string.format("%.0f",self:GetValue()))
	end)

	-- slider 光环显示数量
	if not frame.pAuraNum then
		frame.pAuraNum = newSlider("pAuraNum", 440, -340, 0, 5, 0, 1, "不显示", "多", "光环数量", "最大光环显示数量" )
	end
	frame.pAuraNum:SetValue(SavedData["AuraNum"])
	frame.pAuraNum:HookScript("OnValueChanged", function(self, value)
		SavedData["AuraNum"] = tonumber(string.format("%.0f",self:GetValue()))
	end)

	-- check  默认光环样式
	if not frame.pOriBuffSize then
		frame.pOriBuffSize = newCheckbox("默认光环样式|r","使用源生光环样式，取消勾选以正方形效果显示光环")
		frame.pOriBuffSize:SetPoint("TOPLEFT", 260, -385)
	end
	frame.pOriBuffSize:SetChecked(SavedData["OriAuraSize"])
	frame.pOriBuffSize:HookScript("OnClick", function(self)
		SavedData["OriAuraSize"] = self:GetChecked()
		if self:GetChecked() then 
			frame.pAuraSize:Hide() 
		else 
			frame.pAuraSize:Show() end 
	end)

	-- slider 光环尺寸
	if not frame.pAuraSize then
		frame.pAuraSize = newSlider("pAuraSize", 440, -385, 15, 40, 20, 1, "小", "大", "光环大小", "光环图标缩放" )
	end
	frame.pAuraSize:SetValue(SavedData["AuraSize"])
	frame.pAuraSize:HookScript("OnValueChanged", function(self, value)
		SavedData["AuraSize"] = tonumber(string.format("%.0f",self:GetValue()))
	end)
	if frame.pOriBuffSize:GetChecked() then 
		frame.pAuraSize:Hide()
	end

	-- check  开启计时器
	if not frame.pAuraTimer then
		frame.pAuraTimer = newCheckbox("显示计时器|r","显示光环剩余时间计时器")
		frame.pAuraTimer:SetPoint("TOPLEFT", 260, -430)
	end
	frame.pAuraTimer:SetChecked(SavedData["AuraTimer"])
	frame.pAuraTimer:HookScript("OnClick", function(self)
		SavedData["AuraTimer"] = self:GetChecked()
	end)

	-- slider 计时器数字大小
	if not frame.pAuraNumSize then
		frame.pAuraNumSize = newSlider("pAuraNumSize", 440, -430, 7, 30, 13, 1, "小", "大", "计时器大小", "计时器数字缩放" )
	end
	frame.pAuraNumSize:SetValue(SavedData["AuraNumSize"])
	frame.pAuraNumSize:HookScript("OnValueChanged", function(self, value)
		SavedData["AuraNumSize"] = tonumber(string.format("%.0f",self:GetValue()))
	end)

end)


local dctTempIcon = {}
local dctTempInfo = {}

myGUI.frame2:SetScript("OnShow", function(frame)

	local PlateColor = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	PlateColor:SetPoint("TOPLEFT", 16, -16)
	PlateColor:SetText("编辑白名单")
	PlateColor:SetFont("fonts\\ARHei.ttf", 30, "OUTLINE")

	if not frame.SecondText then 
		frame.SecondText = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.SecondText:SetFontObject("GameFontHighlight");
	frame.SecondText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -50 );   
	-- frame.AuraText:SetParent(frame)    
	frame.SecondText:SetJustifyH("LEFT")
	-- frame.SecondText:SetJustifyH("LEFT")
	frame.SecondText:SetText("白名单不仅作用于单位血条上的光环显示，同样作用于个人资源条\n\n光环指来自技能, 饰品, 艾泽里特特质，场景等产生的buff/debuff");

	local DctSavedAura = SavedData["DctAura"]
	frame.DctDisplay = table_copy(DctSavedAura)

	local function newCheckbox(label, description)
		local check = CreateFrame("CheckButton", "PlateColorCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
		-- check:SetScript("OnClick", function(self)
		-- 	local tick = self:GetChecked()
		-- 	onClick(self, tick and true or false)
		-- end)
		check.label = _G[check:GetName() .. "Text"]
		check.label:SetText(label)
		check.tooltipText = description
		-- check.tooltipRequirement = description
		return check
	end


	local function newSlider(SliderName, x, y, minValue, maxValue, curValue, valueStep, lowText, highText, upText, tipText)
		local pSlider = CreateFrame("Slider", "Slider"..SliderName , frame, "OptionsSliderTemplate" );
		pSlider:SetPoint("TOPLEFT", frame, "TOPLEFT", x, y);
		pSlider:SetMinMaxValues(minValue, maxValue);
		pSlider:SetValue(curValue);
		pSlider:SetValueStep(valueStep);
		pSlider:SetObeyStepOnDrag(true);
		pSlider.textLow = _G["Slider"..SliderName.."Low"]
		pSlider.textHigh = _G["Slider"..SliderName.."High"]
		pSlider.text = _G["Slider"..SliderName.."Text"]
		pSlider.textLow:SetText(lowText)
		pSlider.textHigh:SetText(highText)
		pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")

		pSlider:SetScript("OnValueChanged", 
		function(pSlider,event,arg1) 
			pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")
		end)
		pSlider.tooltipText = tipText
		-- body
		return pSlider
	end

	if not frame.BtnHelp then 
		frame.BtnHelp = CreateFrame("Button", nil, frame);
		frame.BtnHelp:SetPoint("CENTER", frame, "TOPLEFT", 95 , -140);  
		frame.BtnHelp:SetSize(45,45);
		frame.BtnHelp:SetText(nil)
		frame.BtnHelp:SetNormalTexture("Interface\\common\\help-i")
		frame.BtnHelp:SetScript("OnEnter", function(self, button, down)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText("填写一个光环ID \n\n使用添加按钮将其加入右侧，移除按钮将其移除\n\n白名单目前支持最多20个光环")
			GameTooltip:Show()
		end)
		frame.BtnHelp:SetScript("OnLeave", function(self, button, down)
			GameTooltip:Hide()
		end)
	end

	if not frame.AuraText then 
		frame.AuraText = frame:CreateFontString(nil, "OVERLAY");
		frame.AuraText:SetFontObject("GameFontHighlight");
		frame.AuraText:SetPoint("TOPLEFT", frame, "TOPLEFT", 60, -200 );   
		frame.AuraText:SetParent(frame)    
		frame.AuraText:SetText("|cFFFFD700 光环ID |r");
	end

	local EditText = nil 
	if not frame.EditBox then 
		frame.EditBox = CreateFrame("EditBox", nil, frame, "InputBoxTemplate");
		frame.EditBox:SetPoint("TOPLEFT", frame, "TOPLEFT", 45 , -240);  
		frame.EditBox:SetSize(100,10);
		frame.EditBox:SetAutoFocus();
		frame.EditBox:SetMaxLetters(9);
		-- frame.EditBox:SetNumeric(true);
		--UIConfig.AuraEditBox:SetPassword(true);
		--UIConfig.EditBox1:Insert('Rgg'); 
		frame.EditBox:SetScript("OnEnterPressed", function(self)
			self:ClearFocus(); 
		    ChatFrame1EditBox:SetFocus(); 
			-- print (self:GetText());   --todo输出的位置在俩函数前面会出问题
		end);
		frame.EditBox:SetScript("OnChar", function (self, text)
			EditText = self:GetText()
		end);
	end


	local nilFrame = CreateFrame("Frame")

	local function ClearAuraPanel()
		if dctTempIcon then 
			for k, v in pairs(dctTempIcon) do
				v:Hide()
				dctTempIcon[k]:Hide()
				dctTempIcon[k]:SetParent(nilFrame)
				dctTempIcon[k] = nil 
			end
		end
		if dctTempInfo then
			for k, v in pairs(dctTempInfo) do
				v:Hide()
				dctTempInfo[k]:Hide()
				dctTempInfo[k]:SetParent(nilFrame)
				dctTempInfo[k] = nil 
			end
		end
	end

	if not frame.AuraAdd then 
		frame.AuraAdd = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
		frame.AuraAdd:SetPoint("TOPLEFT", frame, "TOPLEFT", 33 , -300);  
		frame.AuraAdd:SetSize(120,40);
		frame.AuraAdd:SetText("添加-->")
		frame.AuraAdd:SetNormalFontObject("GameFontNormalLarge");
		frame.AuraAdd:SetHighlightFontObject("GameFontHighlightLarge");
		-- frame.AuraAdd.parent = frame
		frame.AuraAdd:SetScript("OnClick", function(self, button, down)
			if GetTrueNum(frame.DctDisplay) >= 20 then return end 
			local SpellID = tonumber(EditText)
			if frame.DctDisplay[SpellID] then return end
			if not SpellID then return end 
			local SpellName, _ = GetSpellInfo(SpellID)
			if not SpellName then return end
			frame.DctDisplay[SpellID] = true
			SavedData["DctAura"] = frame.DctDisplay
			SetSpell(frame.DctDisplay)

			end)
	end

	if not frame.Auradel then 
		frame.Auradel = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
		frame.Auradel:SetPoint("TOPLEFT", frame, "TOPLEFT", 33 , -350);  
		frame.Auradel:SetSize(120,40);
		frame.Auradel:SetText("移除<--")
		frame.Auradel:SetNormalFontObject("GameFontNormalLarge");
		frame.Auradel:SetHighlightFontObject("GameFontHighlightLarge");
		frame.Auradel:SetScript("OnClick", function(self, button, down)
			local SpellID = tonumber(EditText)
			if not frame.DctDisplay[SpellID] then return end 
			frame.DctDisplay[SpellID] = false
			SavedData["DctAura"] = frame.DctDisplay
			SetSpell(frame.DctDisplay)
			end)
	end
		
	function SetSpell(dctTest)
		ClearAuraPanel()
		dctTempIcon = {}
		dctTempInfo = {}
		local dctKeys = table_keys(dctTest)
		local iLeng = table_leng(dctTest)
		local t = 1
		local hor = 1 
		
		for i=1 , iLeng do
			local iSpellID = dctKeys[i]  
			if dctTest[iSpellID] then
				--print ("创建第"..t.."个图标"..iSpellID)
				
				local name , _ , icon,_ ,_ ,_ ,_ = GetSpellInfo(iSpellID)
				
				if t >10 then
					hor = 2
					t = 1
				end
				frame.Spell = frame:CreateFontString('myarua', "OVERLAY");
				frame.Spell:SetFontObject("GameFontHighlight");
				frame.Spell:SetPoint("TOPLEFT", frame, "TOPLEFT", 200*hor, -40*t -90 );   --锚点, 位置, 偏移
				
				frame.Spell:SetParent(frame)    --todo 这写"SecondPage"和这个local 变量都可以,为什么在上面overlay后面写父会bug
				frame.Spell:SetText("|T"..icon ..":18|t "..name.." ");
				
				--------------------
				
				frame.SpellMouseInfo = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate");
				frame.SpellMouseInfo:SetPoint("TOPLEFT", frame, "TOPLEFT", 200*hor , -40*t - 90);  
				frame.SpellMouseInfo.ID = iSpellID
				
				t = t + 1;
				
				frame.SpellMouseInfo:SetSize(70,25);
				frame.SpellMouseInfo:SetText(nil)
				frame.SpellMouseInfo:SetAlpha(0);

				frame.SpellMouseInfo:SetScript("OnEnter", function(self, button, down)
					GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
					GameTooltip:SetText("光环ID:"..self.ID)
					GameTooltip:AddSpellByID(tonumber(self.ID))
					GameTooltip:Show()
				end)
				
				frame.SpellMouseInfo:SetScript("OnLeave", function(self, button, down)
					GameTooltip:Hide()
				end)
		

				dctTempIcon[i] = frame.Spell
				dctTempInfo[i] = frame.SpellMouseInfo
				-- table.insert(dctTempIcon, frame.Spell)
				-- table.insert(dctTempInfo, frame.SpellMouseInfo)
			end
		
		
		end

		--UIConfig.Spell1 = UIConfig:CreateFontString(nil, "OVERLAY");
		--UIConfig.Spell1:SetFontObject("GameFontHighlight");
		--UIConfig.Spell1:SetPoint("TOPLEFT", UIConfig, "TOPLEFT", 160, -40 );   --锚点, 位置, 偏移
		--UIConfig.Spell1:SetParent(UISecondPage)    --todo 这写"SecondPage"和这个local 变量都可以,为什么在上面overlay后面写父会bug
		--UIConfig.Spell1:SetText("|T236176:18|t 奇美拉射击");
	end

	SetSpell(frame.DctDisplay)

	if not frame.sInfo2 then 
	frame.sInfo2 = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	end
	frame.sInfo2:SetPoint("BOTTOMRIGHT", -10, 10)
	-- frame.sInfo2:SetText("修改光环后点确定会引起界面重载")
	frame.sInfo2:SetJustifyH("RIGHT")

end)
-- --這裡替重載介面指令寫一個確認框體 
-- StaticPopupDialogs.SET_UI = { 
--         text = "确定完成设置并重载界面", 
--         button1 = ACCEPT, 
--         button2 = CANCEL, 
--         OnAccept =  function() UIcfg() ReloadUI() end, 
--         timeout = 0, 
--         whileDead = 1, 
--         hideOnEscape = true, 
--         preferredIndex = 5, 
-- } 
-- SLASH_SETUI1 = "/setui" 
-- SLASH_SETUI2 = "/SETUI" 
-- SlashCmdList["SETUI"] = function() 
--         StaticPopup_Show("SET_UI") 
-- end





InterfaceOptions_AddCategory(myGUI.frame1)
InterfaceOptions_AddCategory(myGUI.frame2)
