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
                if not rs.IsExpBall(nil, namePlate.UnitFrame) then 
					unitFrame:Hide()
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

-- 每0.25秒执行一次 

local boomFrame, timei

function rs.BallScanner()
	if boomFrame then return end 
	boomFrame = CreateFrame("Frame")
	timei = 0 
	boomFrame:SetScript("OnUpdate", function (self, elasped)
        local activeKeystoneLevel, activeAffixIDs = C_ChallengeMode.GetActiveKeystoneInfo()
        if not activeAffixIDs or activeAffixIDs[3] ~= 13 then return end
		timei = timei + elasped
		if timei > 0.25 then
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