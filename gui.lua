
local addon, ns = ...

local L = ns.L



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



myGUI.frame1 = CreateFrame("Frame", "MainGUI", InterfaceOptionsFrame)
myGUI.frame1.name = '|cff00FF7FRS P|r '..L["MenuBasis"]





myGUI.frame2 = CreateFrame( "Frame", "AURAGUI", myGUI.frame1); 
myGUI.frame2.name = '|cff33FFFF|r       '..L["MenuWhiteList"]
myGUI.frame2.parent = myGUI.frame1.name

local function newFont(offx, offy, createframe, anchora, anchroframe, anchorb, text, fontsize)
	local font = createframe:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	font:SetPoint(anchora, anchroframe, anchorb, offx, offy)
	font:SetText(text)
	font:SetFont("fonts\\ARHei.ttf", fontsize, "OUTLINE")	
	return font
end

local function newFontSmall(x, y, createframe, anchroframe, text)
	local font = createframe:CreateFontString(nil, "OVERLAY");
	font:SetFontObject("GameFontHighlight");
	font:SetPoint("TOPLEFT", anchroframe, "TOPLEFT", x, y);   
	font:SetText(text);
	return font
end


local function newLine(createframe, anchroframe, offx, offy)
	local line = createframe:CreateTexture(nil, "BACKGROUND")
	line:SetColorTexture(.4,.4,.4,.8);
	line:SetSize(570, 1.5)
	line:SetPoint("BOTTOMLEFT", anchroframe, "BOTTOMLEFT", offx, offy)
	return line
end

local function newCheckbox(x, y, fatherframe, label, description, anchroframe, varname)
	local check = CreateFrame("CheckButton", "PlateColorCheck" .. label, fatherframe, "InterfaceOptionsCheckButtonTemplate")
	check:SetPoint("BOTTOMLEFT", anchroframe, "BOTTOMLEFT", x, y)
	check.label = _G[check:GetName() .. "Text"]
	check.label:SetText(label)
	check.tooltipText = description

	
	local CheckStatus = SavedData[varname]
	check:SetChecked(CheckStatus)

	check:SetScript("OnClick", function ( ... )
		SavedData[varname] = check:GetChecked()
	end)
	-- check.tooltipRequirement = description
	return check
end

local function newSlider(x, y, SliderName, minValue, maxValue, curValue, valueStep, lowText, highText, upText, tipText, anchroframe, fatherframe, varname, varformat, Cvar)
	local pSlider = CreateFrame("Slider", "Slider"..SliderName , fatherframe, "OptionsSliderTemplate" );
	pSlider:SetPoint("TOPLEFT", anchroframe, "TOPLEFT", x, y);
	pSlider:SetMinMaxValues(minValue, maxValue);
	pSlider:SetValue(curValue);
	pSlider:SetValueStep(valueStep);
	pSlider:SetObeyStepOnDrag(true);
	pSlider.textLow = _G["Slider"..SliderName.."Low"]
	pSlider.textHigh = _G["Slider"..SliderName.."High"]
	pSlider.text = _G["Slider"..SliderName.."Text"]
	pSlider.textLow:SetText(lowText)
	pSlider.textHigh:SetText(highText)
	if varname then 
		pSlider:SetValue(SavedData[varname])
	end
	pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")

	pSlider:SetScript("OnValueChanged", function(pSlider,event,arg1) 
		pSlider.text:SetText("|cffFFD700"..upText.." :  "..string.format("%.1f",pSlider:GetValue()).."|r")
		if varname then 
			SavedData[varname] = tonumber(string.format(varformat,pSlider:GetValue()))
		end
		if Cvar then
			SetCVar(Cvar, SavedData[varname])
		end
	end)
	pSlider.tooltipText = tipText
	-- body
	return pSlider
end

local function CreateHealthValueDropDown(fatherframe, anchroframe, x, y)
	local dctMenu = {
		[1] = L["HealthNone"];
		[2] = L["HealthPercentage"];
		[3] = L["HealthValue"];
		[4] = L["HealthBothShow"]
 	}
	
	function WPDropDownDemo_Menu(self, level, menuList)
	 local info = UIDropDownMenu_CreateInfo()
	 local DetailType = SavedData["DetailType"]
	 info.func = self.SetValue

	 info.text, info.checked, info.arg1, info.arg2 = L["HealthNone"], DetailType == 1, 1, dctMenu[1]
	 UIDropDownMenu_AddButton(info)
	 info.text, info.checked, info.arg1, info.arg2 = L["HealthPercentage"], DetailType == 2, 2, dctMenu[2]
	 UIDropDownMenu_AddButton(info)
	 info.text, info.checked, info.arg1, info.arg2 = L["HealthValue"], DetailType == 3, 3, dctMenu[3]
	 UIDropDownMenu_AddButton(info)
	 info.text, info.checked, info.arg1, info.arg2 = L["HealthBothShow"], DetailType == 4, 4, dctMenu[4]
	 UIDropDownMenu_AddButton(info)
	end

	if not fatherframe.dropDown then 
		fatherframe.dropDown = CreateFrame("Frame", "WPDemoDropDown", fatherframe, "UIDropDownMenuTemplate")
		fatherframe.dropDown:SetPoint("TOPLEFT", anchroframe, "TOPLEFT", x, y)
		UIDropDownMenu_SetWidth(fatherframe.dropDown, 180) -- Use in place of dropDown:SetWidth
		-- Bind an initializer function to the dropdown; see previous sections for initializer function examples.
		UIDropDownMenu_SetText(fatherframe.dropDown, L["Health"]..dctMenu[SavedData["DetailType"]])
		UIDropDownMenu_Initialize(fatherframe.dropDown, WPDropDownDemo_Menu)

		function fatherframe.dropDown:SetValue(var1, var2, checked)
			SavedData["DetailType"] = var1
			UIDropDownMenu_SetText(fatherframe.dropDown, L["Health"]..var2)
		 	CloseDropDownMenus()
		 	UpdateAllNameplates()
		end	
	end
end

local function CreaeteColBlock(fatherframe, anchorframe, x, y)
	fatherframe.col = fatherframe:CreateTexture(nil, "BACKGROUND")
	fatherframe.col:SetPoint("TOPLEFT", anchorframe, "TOPLEFT", x, y)
	fatherframe.col:SetSize(70,15)
	fatherframe.col:SetColorTexture(fatherframe.fR,fatherframe.fG,fatherframe.fB)

	-- 隐形btn
	fatherframe.BtnCol = CreateFrame("Button", nil, fatherframe, "GameMenuButtonTemplate");
	fatherframe.BtnCol:SetPoint("TOPLEFT", anchorframe, "TOPLEFT", x , y);  
	fatherframe.BtnCol:SetSize(70,15);
	fatherframe.BtnCol:SetAlpha(0)
	fatherframe.BtnCol:SetNormalFontObject("GameFontNormalLarge");
	fatherframe.BtnCol:SetHighlightFontObject("GameFontHighlightLarge");
	fatherframe.BtnCol:SetScript("OnClick", function(self, button, down)

	ColorPickerFrame:SetColorRGB(fatherframe.fR,fatherframe.fG,fatherframe.fB)
	ColorPickerFrame:Show()
	ColorPickerCancelButton:Hide()
	ColorPickerFrame.func = function(restore)
			local r,g,b = ColorPickerFrame:GetColorRGB();
			fatherframe.col:SetColorTexture(r,g,b)  --同步色块颜色
			SavedData["KillRGBr"] = tonumber(string.format("%.2f",r))
			SavedData["KillRGBg"] = tonumber(string.format("%.2f",g))
			SavedData["KillRGBb"] = tonumber(string.format("%.2f",b))
			end
	end)
end

local function newHelpBtn(x, y, fatherframe, anchorframe, text)
	local helpbtn = CreateFrame("Button", nil, fatherframe);
	helpbtn:SetPoint("CENTER", anchorframe, "TOPLEFT", x , y);  
	helpbtn:SetSize(35,35);
	helpbtn:SetText(nil)
	helpbtn:SetNormalTexture("Interface\\common\\help-i")
	helpbtn:SetScript("OnEnter", function(self, button, down)
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
		GameTooltip:SetText(text)
		GameTooltip:Show()
	end)
	helpbtn:SetScript("OnLeave", function(self, button, down)
		GameTooltip:Hide()
	end)
	return helpbtn
end

local function CreatePanel(frame)
	if not frame.ScrollFrame then
		frame.ScrollFrame = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate");
		frame.ScrollFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 4, -4);
		frame.ScrollFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -4, 4);

		frame.ScrollFrame:SetClipsChildren(true);
		frame.ScrollFrame.ScrollBar:ClearAllPoints();
		frame.ScrollFrame.ScrollBar:SetPoint("TOPRIGHT", frame.ScrollFrame, "TOPRIGHT", 0, -16);
		frame.ScrollFrame.ScrollBar:SetPoint("BOTTOMRIGHT", frame.ScrollFrame, "BOTTOMRIGHT", 0, 16);

		child = CreateFrame("Frame", nil, frame.ScrollFrame);
		child:SetSize(595, 1400);

		child.bg = child:CreateTexture(nil, "BACKGROUND");
		child.bg:SetAllPoints(true);
		child.bg:SetColorTexture(0, 0, 0, .4);

		frame.ScrollFrame:SetScrollChild(child);

		local version = SavedData["Version"]
		child.fR, child.fG, child.fB = SavedData["KillRGBr"], SavedData["KillRGBg"], SavedData["KillRGBb"]
		
		child.Pagename = newFont(16, -16, child, "TOPLEFT", child, "TOPLEFT", L["TitleBasis"], 30)
		
		--风格
		child.Gap1 = newFont(0, -60 , child, "TOPLEFT", child.Pagename, "TOPLEFT", L["Title1"], 22)
		child.Line1 = newLine(child, child.Gap1, 0, -4)
		child.OriTexture = newCheckbox(0, -40, child, L["OriBarTexture"], L["OriBarTextureTT"], child.Line1, "OriBar")
		child.OriCast = newCheckbox(180, -40, child, L["OriCastBar"], L["OriCastBarTT"], child.Line1, "OriCast")
		child.OriElite = newCheckbox(360, -40, child, L["OriEliteIcon"], L["OriEliteIconTT"], child.Line1, "OriElite")
		child.BgCol = newCheckbox(0, -80, child, L["BgCol"], L["BgColTT"], child.Line1, "BarBgCol")

		--Cvars
		child.Gap2 = newFont(0, -130 , child, "TOPLEFT", child.Gap1, "TOPLEFT", L["Title2"], 22) 
		child.Line2 = newLine(child, child.Gap2, 0, -4)
		child.CvarHelp = newHelpBtn(100, 15, child, child.Line2, L["CvarHelp"])
		child.Select = newSlider(10, -30, "SelectedScale", 1, 2, 1.2, 0.1, L["SelectScale0"], L["SelectScale1"],L["SelectScale"],L["SelectScaleTT"], child.Line2, child, "Select", "%.1f", "nameplateSelectedScale")
		child.Global = newSlider(200, -30, "GlobalScale", 0.5, 2, 1, 0.1, L["GlobalScale0"], L["GlobalScale1"], L["GlobalScale"], L["GlobalScaleTT"], child.Line2, child, "GlobalScale", "%.1f", "nameplateGlobalScale" )
		child.Distance = newSlider (390, -30, "Distence", 10, 60, 50, 1, L["Distance0"], L["Distance1"], L["Distance"], L["DistanceTT"], child.Line2, child, "Distence", "%.0f", "nameplateMaxDistance")
		-- child.Alpha = newSlider(10, -80, "Alpha", 0.2, 1, 0.8, 0.1, L["Alpha0"], L["Alpha1"], L["Alpha"], L["AlphaTT"], child.Line2, child, "Alpha", "%.1f", "nameplateMinAlpha")
		child.OverlapV = newSlider(10, -80, "OverlapV", 0.4, 1.2, 0.8, 0.1, L["OverlapV0"], L["OverlapV1"], L["OverlapV"], L["OverlapVTT"], child.Line2, child, "GapV", "%.1f", "nameplateOverlapV")
		child.OverlapH = newSlider(200, -80, "OverlapH", 0.4, 1.2, 0.8, 0.1, L["OverlapH0"], L["OverlapH1"], L["OverlapH"], L["OverlapHTT"], child.Line2, child, "GapH", "%.1f", "nameplateOverlapH")

		--血量
		child.Gap3 = newFont(0, -163 , child, "TOPLEFT", child.Gap2, "TOPLEFT", L["Title3"], 22) 
		child.Line3 = newLine(child, child.Gap3, 0, -4)
		CreateHealthValueDropDown(child, child.Line3, 0, -10)
		child.CenterDetail = newCheckbox(250, -35, child, L["CenterDetail"], L["CenterDetailTT"], child.Line3, "CenterDetail")
		child.EastenDetail = newCheckbox(390, -35, child, L["EastenDetail"], L["EastenDetailTT"], child.Line3, "EastenDetail")
		child.EastenDetail:HookScript("OnClick", function ( ... ) UpdateAllNameplates() end)
		
		--血条染色
		child.Gap4 = newFont(0, -90 , child, "TOPLEFT", child.Gap3, "TOPLEFT", L["Title4"], 22) 
		child.Line4 = newLine(child, child.Gap4, 0, -4)
		child.Omen3text = newFontSmall(0, -20, child, child.Line4, L["Omen3text"])
		child.Omen3 = newCheckbox(90, -40, child, L["Omen3"], L["Omen3TT"], child.Line4, "Omen3")
		child.Killtext = newFontSmall(0, -70, child, child.Line4, L["SlayColtext"])
		child.Kill = newSlider(90, -70, "Killper", 0, 100, 0, 5, L["SlayLine0"], L["SlayLine1"], L["SlayLine"], L["SlayLineTT"], child.Line4, child, "KillPer", "%.0f")
		child.KillColText = newFontSmall(280, -70, child, child.Line4, L["SlayColSelect"])
		CreaeteColBlock(child, child.Line4, 370, -70)

		--姓名
		child.Gap5 = newFont(0, -160 , child, "TOPLEFT", child.Gap4, "TOPLEFT", L["Title5"], 22)
		child.Line5 = newLine(child, child.Gap5, 0, -4)
		child.OriName = newCheckbox(0, -40, child, L["OriName"], L["OriNameTT"], child.Line5, "OriName")
		child.OriName:HookScript("OnClick", function ( ... ) UpdateAllNameplates() end)
		child.NameWhite = newCheckbox(0, -80, child, L["WhiteName"], L["WhiteNameTT"], child.Line5, "NameWhite")
		child.NameWhite:HookScript("OnClick", function ( ... ) UpdateAllNameplates() end)
		child.NameSize = newSlider(160, -60, "NameSize", 5, 30, 12, 1, L["NameSize0"], L["NameSize1"], L["NameSize"], L["NameSizeTT"], child.Line5, child, "NameSize", "%.0f")
		child.NameSize:HookScript("OnValueChanged", function ( ... ) UpdateAllNameplates() end)

		--光环
		child.Gap6 = newFont(0, -140 , child, "TOPLEFT", child.Gap5, "TOPLEFT", L["Title6"], 22) 
		child.Line6 = newLine(child, child.Gap6, 0, -4)
		child.Aurashowtext = newFontSmall(0, -20, child, child.Line6, L["AuraText1"])
		child.AuraDefault = newCheckbox(130, -40, child, L["AuraDeault"], L["AuraDeaultTT"], child.Line6, "AuraDefault")
		child.AuraWL = newCheckbox(230, -40, child, L["AuraWL"],L["AuraWLTT"], child.Line6, "AuraWhite")
		child.AuraMe = newCheckbox(330, -40, child, L["AuraOnlyMe"],L["AuraOnlyMeTT"], child.Line6, "AuraOnlyMe")
		child.AuraHelp = newHelpBtn(550, -25, child, child.Line6, L["AuraHelpBtn1"])
		child.Aurastyletext = newFontSmall(0, -80, child, child.Line6, L["AuraText2"])
		child.AuraHeight = newSlider(100, -80, "AuraHeight", -30, 50, 20, 1, L["AuraHeight0"], L["AuraHeight1"], L["AuraHeight"], L["AuraHeightTT"], child.Line6, child, "AuraHeight", "%.0f" )
		child.AuraHeight:HookScript("OnValueChanged", function ( ... ) RefBuff() end)
		child.AuraNumber = newSlider(280, -80, "pAuraNum", 0, 5, 0, 1, L["AuraNum0"], L["AuraNum1"], L["AuraNum"], L["AuraNumTT"], child.Line6, child, "AuraNum", "%.0f" )
		child.AuraStyle = newCheckbox(100, -160, child, L["OriAura"],L["OriAuraTT"], child.Line6, "OriAuraSize")
		child.AuraSize = newSlider(280, -140, "pAuraSize", 15, 40, 20, 1, L["AuraSize0"], L["AuraSize1"], L["AuraSize"], L["AuraSizeTT"], child.Line6, child, "AuraSize", "%.0f" )
		child.AuraSize:HookScript("OnValueChanged", function ( ... ) RefBuff() end)
		child.AuraTimer = newCheckbox(100, -220, child, L["Counter"],L["CounterTT"], child.Line6, "AuraTimer")
		child.AuraTimer:HookScript("OnClick", function ( ... ) RefBuff() end)
		child.AuraTimerSize = newSlider(280, -200, "pAuraNumSize", 7, 30, 13, 1, L["CounterSize0"], L["CounterSize1"], L["CounterSize"], L["CounterSizeTT"], child.Line6, child, "AuraNumSize", "%.0f" )
		child.AuraTimerSize:HookScript("OnValueChanged", function ( ... ) RefBuff() end)

		--地下城助手
		child.Gap7 = newFont(0, -300 , child, "TOPLEFT", child.Gap6, "TOPLEFT", L["Title7"], 22) 
		child.Line7 = newLine(child, child.Gap7, 0, -4)
		child.expball = newCheckbox(0, -40, child, L["Exp"], L["ExpTT"], child.Line7, "Expball")
		child.expballhelp = newHelpBtn(150, -26, child, child.Line7, L["ExpHelpBtn"])

		--其他
		child.Gap8 = newFont(0, -100 , child, "TOPLEFT", child.Gap7, "TOPLEFT", L["Title8"], 22) 
		child.Line8 = newLine(child, child.Gap8, 0, -4)
		child.CastHeight = newSlider(0, -40, "pCastHeight", 5, 12, 5, 1, L["CastHeight0"], L["CastHeight1"], L["CastHeight"], L["CastHeightTT"], child.Line8, child, "CastHeight", "%.0f" )
		child.SelectAlpha = newSlider(200, -40, "pSelectAlpha", 0.2, 1.0, 1.0, 0.1, L["UnSelectAlpha0"], L["UnSelectAlpha1"], L["UnSelectAlpha"], L["UnSelectAlphaTT"], child.Line8, child, "UnSelectAlpha", "%.1f" )
		child.SelectAlpha:HookScript("OnValueChanged", function ( ... ) UpdateAllNameplates() end)
		child.Arrow = newCheckbox(400, -60, child, L["Arrow"], L["ArrowTT"], child.Line8, "ShowArrow")
		child.Arrow:HookScript("OnClick", function ( ... ) UpdateAllNameplates() end)
		
		child.StolenBuff = newCheckbox(0, -120, child, L["StolenBuff"], L["StolenBuffTT"], child.Line8, "ShowStolenBuff")
		child.QuestIcon = newCheckbox(200, -120, child, L["QuestIcon"], L["QuestIconTT"], child.Line8, "ShowQuestIcon")

		child.Version = newFont(-20, 20 , child, "BOTTOMRIGHT", child, "BOTTOMRIGHT", L["Version"]..version, 20) 
	end		
end


myGUI.frame1:SetScript("OnShow", function(frame)
	CreatePanel(frame)
end)


local dctTempIcon = {}
local dctTempInfo = {}

myGUI.frame2:SetScript("OnShow", function(frame)

	local PlateColor = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	PlateColor:SetPoint("TOPLEFT", 16, -16)
	PlateColor:SetText(L["TitleWhiteList"])
	PlateColor:SetFont("fonts\\ARHei.ttf", 30, "OUTLINE")

	if not frame.SecondText then 
		frame.SecondText = frame:CreateFontString(nil, "OVERLAY");
	end
	frame.SecondText:SetFontObject("GameFontHighlight");
	frame.SecondText:SetPoint("TOPLEFT", frame, "TOPLEFT", 16, -50 );   
	-- frame.AuraText:SetParent(frame)    
	frame.SecondText:SetJustifyH("LEFT")
	-- frame.SecondText:SetJustifyH("LEFT")
	frame.SecondText:SetText(L["AuraInfo"]);

	local DctSavedAura = SavedData["DctAura"]
	frame.DctDisplay = table_copy(DctSavedAura)

	if not frame.BtnHelp then 
		frame.BtnHelp = CreateFrame("Button", nil, frame);
		frame.BtnHelp:SetPoint("CENTER", frame, "TOPLEFT", 95 , -140);  
		frame.BtnHelp:SetSize(45,45);
		frame.BtnHelp:SetText(nil)
		frame.BtnHelp:SetNormalTexture("Interface\\common\\help-i")
		frame.BtnHelp:SetScript("OnEnter", function(self, button, down)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(L["AuraHelpBtn2"])
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
		frame.AuraText:SetText(L["AuraID"]);
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
		frame.AuraAdd:SetText(L["AddBtn"])
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
		frame.Auradel:SetText(L["RemoveBtn"])
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
				frame.Spell:SetText("|T"..icon ..":18|t "..name);
				
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
					-- GameTooltip:AddDoubleLine(L["AuraIDTT"], tostring(iSpellID), 1, 1, 0, 1 ,1, 1);
					GameTooltip:SetSpellByID(iSpellID)
					GameTooltip:AppendText("   ".."|cff00FF7F"..L["AuraIDTT"]..tostring(iSpellID).."|r")
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


--這裡替重載介面指令寫一個確認框體 
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
-- 		StaticPopup_Show("SET_UI") 
-- end

-- SLASH_BES1 = "/cc"
-- SlashCmdList.BES = function()
-- end



InterfaceOptions_AddCategory(myGUI.frame1)
InterfaceOptions_AddCategory(myGUI.frame2)



