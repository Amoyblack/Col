local addon, rs  = ...

local function OnlyShowBall()
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
            -- 隐藏球之外的血条框架
			for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
				local unitFrame = namePlate.UnitFrame
				local guid = UnitGUID(unitFrame.unit)
				local _, _, _, _, _, id = strsplit("-", guid or "") 
				if id ~= "120651" then
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
		if timei > 0.25 then
			OnlyShowBall()
			timei = 0
		end
	end)
end