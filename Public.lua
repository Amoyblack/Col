
local ADDONName, rs = ...

rs.V = {}



-- 职业颜色
if IsAddOnLoaded("!ClassColors") and CUSTOM_CLASS_COLORS then
	rs.V.Ccolors = CUSTOM_CLASS_COLORS
else
	rs.V.Ccolors = RAID_CLASS_COLORS
end

-- 文本
function rs.createtext(f, layer, fontsize, flag, justifyh)
	local text = f:CreateFontString(nil, layer)
	text:SetFont(STANDARD_TEXT_FONT, fontsize, flag)
	text:SetJustifyH(justifyh)
	return text
end


-- 纯色背景
function rs.CreateBG(frame)
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
function rs.CreateBackDrop(parent, anchor, a, offsize, extra)
	-- 模拟默认参数
	if offsize == nil then
		offsize = 3
	end

    local frame = CreateFrame("Frame", nil, parent, "BackdropTemplate")

	local flvl = parent:GetFrameLevel()
	if flvl - 1 >= 0 then frame:SetFrameLevel(flvl-1) end

	frame:ClearAllPoints()
    if not extra then
        frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -offsize, offsize)
        frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", offsize, -offsize)
    else
        frame:SetPoint("TOPLEFT", anchor, "TOPLEFT", -offsize, 2)
        frame:SetPoint("BOTTOMRIGHT", anchor, "BOTTOMRIGHT", offsize, -offsize)
    end

    frame:SetBackdrop(
    	{
    edgeFile = "Interface\\AddOns\\RSPlates\\media\\glow", edgeSize = 3,  --外材宽度
    bgFile = "Interface\\Buttons\\WHITE8x8",
    insets = {left = 3, right = 3, top = 3, bottom = 3}	--内材与外材插入空隙
		}
	)
	if a == 1 then
		frame:SetBackdropColor(.2, .2, .2, 1)  --内材颜色
		frame:SetBackdropBorderColor(0, 0, 0)  --外材颜色
	elseif a == 2 then 
		frame:SetBackdropColor(.5, .5, .5, 1)  --内材颜色
		frame:SetBackdropBorderColor(1, 1, 1)  --外材颜色
	end

    return frame
end




-------SomePrepare Tools(Jobs) ---------

function rs.table_copy(table)
	local NewTable = {}
	if table then
		for k, v in pairs(table) do
			NewTable[k] = v 
		end
	end
	return NewTable;
end

function rs.table_same(table1, table2)
	local leng1, leng2 = rs.table_leng(table1), rs.table_leng(table2)
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

function rs.table_keys(t)
	local tbKeys = {}
	local i = 1
	for k, v in pairs(t) do
		tbKeys[i] = k
		i = i + 1
	end	
	return tbKeys;
end

function rs.table_leng(t)
  local leng=0
  for k, v in pairs(t) do
    leng=leng+1
  end
  return leng;  --return int
end

function rs.GetTrueNum(table)
	local i = 0
	for k, v in pairs(table) do 
		if v then 
			i = i + 1
		end 
	end 
	return i
end 

function rs.GetMarginDB(OldDB)
    local NewDB = rs.table_copy(rs.V.DefaultSetting)
    if rs.V.DefaultSetting["ForceUpdate"] then 
        return NewDB, true
    else
        for k, v in pairs(NewDB) do 
            if OldDB[k] then 
                NewDB[k] = OldDB[k]
            end
        end
        NewDB["Version"] = rs.V.DefaultSetting["Version"]
        return NewDB, false
    end
end