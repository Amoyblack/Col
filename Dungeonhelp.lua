local addon, rs  = ...

local function OnlyShowBall()
	local haskey = false

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
        if rs.IsExpBall(nil, namePlate.UnitFrame) then 
			haskey = true
		end
	end	

	-- 场上存在易爆球
	if haskey then 
            -- 隐藏球之外的血条框架
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
                local unitFrame = namePlate.UnitFrame
                if rs.IsExpBall(nil, namePlate.UnitFrame) then 
					unitFrame:Show()
                else
                    if not UnitIsUnit("player", unitFrame.unit) then 
					    unitFrame:Hide()
                    end
				end
			end
	else
            -- 显示所有血条框架
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
				local unitFrame = namePlate.UnitFrame
				unitFrame:Show()
			end		

	end
end

-- 每0.2秒执行一次 

local boomFrame, timei

function rs.BallScanner()
	if boomFrame then return end 
	boomFrame = CreateFrame("Frame")
	timei = 0 
	boomFrame:SetScript("OnUpdate", function (self, elasped)
        local activeKeystoneLevel, activeAffixIDs = C_ChallengeMode.GetActiveKeystoneInfo()
        if not activeAffixIDs or activeAffixIDs[3] ~= 13 then return end
		timei = timei + elasped
		if timei > 0.2 then
			OnlyShowBall()
			timei = 0
		end
	end)
end

function rs.IsExpBall(unit, unitFrame)
    if not unit then unit = unitFrame.unit end
    if not unit then return end 
    
    local GUID = UnitGUID(unit)
    local _, _, _, _, _, NpcID = strsplit("-", GUID or "") 
    if NpcID == "120651" then
        return true 
    else
        return false
    end
end


function rs.BallScannerPvP()
	if boomFrame then return end 
	boomFrame = CreateFrame("Frame")
	boomFrame:SetScript("OnUpdate", function (self, elasped)
		OnlyShowBall()
	end)
end


function rs.IsExpBallPvP(unit, unitFrame)
    if not unit then unit = unitFrame.unit end
    if not unit then return end

    local GUID = UnitGUID(unit)
    local _, _, _, _, _, NpcID = strsplit("-", GUID or "")

    if rs.V.pvpHideNpc[tonumber(NpcID)] then 
        return true 
    else
        return false
    end
end


-------------------------------------------------------
-------------------------------------------------------
---- PVP 自定义修改 起始点，分割线以上的代码不用动  -----------


rs.V.pvpHideNpc = {
    [119052] = true, -- 战旗
    [101398] = true, -- 灵能魔
    [179193] = true, -- 邪能方尖碑
    [114565] = true, -- 被遗忘的女王
    [5925] = true, -- 根基图腾
    [5913] = true, -- 战栗图腾
    [61245] = true, -- 电能图腾
    [105451] = true, -- 反击图腾
    [166523] = true, -- 暮钟图腾
    [179867] = true, -- 静电力场图腾
    [59764] = true, -- 治疗之潮图腾
    [10467] = true, -- 法力之潮图腾
    [53006] = true, -- 灵魂链接图腾
    [120651] = true, -- 易爆球
    [153285] = true, -- 奥格瑞玛61.47处的假人
}

-- 使用方法：开启易爆助手后，把下面2行代码 注释去掉（删除下面2行代码开始处的2个横杠 --)，即可生效
-- 即场上有上面表格中的NPC时，会立刻隐藏其余所有单位的血条，直到其消失为止。添加新NPC按上面格式即可，数字是NPC ID


-- rs.BallScanner = rs.BallScannerPvP
-- rs.IsExpBall = rs.IsExpBallPvP







