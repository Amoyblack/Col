local addon, rs  = ...


function rs.OnlyShowBall()
    if (not rs.curDungeonData or rs.curDungeonData[3] ~= 13) and rs.ExtraConfig.ExplosiveHelperAffixDetection then return end
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

    if rs.ExtraConfig.ExplosiveHelperScanList[tonumber(NpcID)] then
        return true
    else
        return false
    end
end