local addon, rs  = ...


function rs.OnlyShowBall()
    if (not rs.curDungeonData or rs.curDungeonData[3] ~= 13) and rs.ExpBallMode then return end
    print('检测易爆球中')
	local haskey = false

	for i, namePlate in ipairs(C_NamePlate.GetNamePlates(false)) do
        if rs.IsExpBall(nil, namePlate.UnitFrame) then 
			haskey = true
		end
	end	

	-- 场上存在易爆球
	if haskey then 
        -- 隐藏球之外的血条
        for i, namePlate in ipairs(C_NamePlate.GetNamePlates(false)) do
            local unitFrame = namePlate.UnitFrame
            if rs.IsExpBall(nil, namePlate.UnitFrame) then 
                unitFrame.shouldHide = false
                unitFrame:Show()
            else
                if not UnitIsUnit("player", unitFrame.unit) then 
                    unitFrame.shouldHide = true
                    unitFrame:Hide()
                end
            end
        end
	else
        -- 显示所有血条
        for i, namePlate in ipairs(C_NamePlate.GetNamePlates(false)) do
            local unitFrame = namePlate.UnitFrame
            unitFrame.shouldHide = false
            unitFrame:Show()
        end		
	end
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

rs.ExpBallMode = true

-- pvp助手使用方法：
-- 1. 上面的 rs.ExpBallMode 值 改为 false
-- 2. 上面的 rs.V.pvpHideNpc 添加你需要的NPC ID，即场上有表(rs.V.pvpHideNpc)中的NPC时，会立刻隐藏其余所有单位的血条，上面列出了些常用pvp npc，如有用可以从里面直接复制
-- 3. 最后，游戏内插件设置里 开启 易爆球助手，即可生效