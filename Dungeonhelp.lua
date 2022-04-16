local addon, rs  = ...




-- C_NP.GetNamePlates效率很高，否则这种处理可以以空间换时间，优化一倍的效率
-- 但要注意内存回收
local function OnlyShowBall()
    local NpCache = {}
    local flag = false
    for i, namePlate in pairs(C_NamePlate.GetNamePlates()) do
        if rs.IsExpBall(nil, namePlate.UnitFrame) then
            NpCache[namePlate.UnitFrame] = true
            flag = true
        else
            NpCache[namePlate.UnitFrame] = false
        end
    end

    if flag then 
        for np, mark in pairs(NpCache) do 
            if mark then  
                np:Show()
            else
                if not UnitIsUnit(np.unit, "player") then
                    np:Hide()
                end
            end
        end
    else
        for np, _ in pairs(NpCache) do
            if not np.hasShownAsName then
                np:Show()
            end
        end
    end
end


-- local function OnlyShowBall()
-- 	local haskey = false

-- 	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
--         if rs.IsExpBall(nil, namePlate.UnitFrame) then 
-- 			haskey = true
-- 		end
-- 	end	

-- 	-- 场上存在易爆球
-- 	if haskey then 
--             -- 隐藏球之外的血条框架
-- 			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
--                 local unitFrame = namePlate.UnitFrame
--                 if rs.IsExpBall(nil, namePlate.UnitFrame) then 
-- 					unitFrame:Show()
--                 else
--                     if not UnitIsUnit("player", unitFrame.unit) then 
-- 					    unitFrame:Hide()
--                     end
-- 				end
-- 			end
-- 	else
--             -- 显示所有血条框架
-- 			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
-- 				local unitFrame = namePlate.UnitFrame
-- 				unitFrame:Show()
-- 			end		

-- 	end
-- end


-- 每0.2秒执行一次 

local boomFrame, timei

-- 仅易爆周检测，检测频率0.2s
function rs.BallScanner()
	if boomFrame then return end 
	boomFrame = CreateFrame("Frame")
	timei = 0 
	boomFrame:SetScript("OnUpdate", function (self, elasped)
		timei = timei + elasped
		if timei > 0.2 then
            local activeKeystoneLevel, activeAffixIDs = C_ChallengeMode.GetActiveKeystoneInfo()
            if not activeAffixIDs or activeAffixIDs[3] ~= 13 then return end
			OnlyShowBall()
			timei = 0
		end
	end)
end

-- 没限制，任何时候都检测，检测频率0.2s
function rs.BallScannerAnyWhere()
    if boomFrame then return end 
    boomFrame = CreateFrame("Frame")
    timei = 0 
    boomFrame:SetScript("OnUpdate", function (self, elasped)
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

    if rs.V.pvpHideNpc[tonumber(NpcID)] then
        return true
    else
        return false
    end
end








-------------------------------------------------------
-------------------------------------------------------
---- PVP 自定义修改 起始点，分割线以上的代码不用动  -----------



-- [119052] = true, -- 战旗
-- [101398] = true, -- 灵能魔
-- [179193] = true, -- 邪能方尖碑
-- [114565] = true, -- 被遗忘的女王
-- [5925] = true, -- 根基图腾
-- [5913] = true, -- 战栗图腾
-- [61245] = true, -- 电能图腾
-- [105451] = true, -- 反击图腾
-- [166523] = true, -- 暮钟图腾
-- [179867] = true, -- 静电力场图腾
-- [59764] = true, -- 治疗之潮图腾
-- [10467] = true, -- 法力之潮图腾
-- [53006] = true, -- 灵魂链接图腾
-- [153285] = true, -- 奥格瑞玛61.47处的假人


rs.V.pvpHideNpc = {
    [120651] = true, -- 易爆球
}


-- 使用方法：开启易爆助手后，把下面这一行代码 注释去掉（删除开始的两个横杠 --)，然后即可生效
-- 即场上有上面表格(rs.V.pvpHideNpc)中的NPC时，会立刻隐藏其余所有单位的血条，直到其消失为止
-- 目前表上只加了易爆球，需要加其他的按格式加进去即可，上面已经列了一些pvp单位，数字是NPC ID


rs.BallScanner = rs.BallScannerAnyWhere






