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


local pvpHideNpc = {
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
}



-- // 如果需要把易爆球的功能扩展到一些PVP中的特殊单位上，即让场上有上表中的单位时就隐藏其他血条
-- // 只需把下面这个rs.IsExpBallPvP 改名为 rs.IsExpBall, 上面的rs.IsExpBall随意改成其他名字即可
-- // 表中的NPC可以按上面格式自己添加，数字是NPC ID

function rs.IsExpBallPvP(unit, unitFrame)
    if not unit then unit = unitFrame.unit end
    if not unit then return end

    local GUID = UnitGUID(unit)
    local _, _, _, _, _, NpcID = strsplit("-", GUID or "")

    if pvpHideNpc[NpcID] then 
        return true 
    else
        return false
    end
end
