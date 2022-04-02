local addon, rs = ...


local dctCVar = {
    "nameplateSelectedScale",
    "nameplateGlobalScale",
    "nameplateMaxDistance",
    "nameplateOverlapV",
    "nameplateOverlapH",
    "nameplateOccludedAlphaMult",

    "nameplateShowAll",
    "nameplateShowFriendlyNPCs",

    "NameplatePersonalShowAlways",
    "NameplatePersonalShowInCombat",
    "NameplatePersonalShowWithTarget",
    "NameplatePersonalHideDelaySeconds",
}

-- 留着备用 引导界面使用
function rs.SetCVarOnFirstTime()
    -- 堆叠1 重叠 0 
    -- SetCVar("nameplateMotion", 1) 

    -- 不随距离变化更改透明度
    -- SetCVar("nameplateMinAlpha", 1) 
    -- nameplateOtherTopInset,  0.05   default 0.08
end


function rs.UpdateCvars()
    if RSPlatesDB["EnableCvar"] then 
        for _, k in pairs(dctCVar) do 
            SetCVar(k, RSPlatesDB[k])
        end

        --不让血条随距离改变而改变大小和透明度,fix blizzard perfomance issue
        SetCVar("nameplateMinScale", 1) 
        SetCVar("nameplateMaxScale", 1) 
        SetCVar("nameplateMinAlpha", 1) 
        SetCVar("nameplateShowOnlyNames", 0) 
        -- SetCVar("nameplateOtherTopInset", 0.05) 
    end
end

-- 用服务器数据覆盖本地数据
-- function rs.GenerateLocalCVar()
--     for _, k in pairs(dctCVar) do 
--         print(k, GetCVar(k))
--         RSPlatesDB[k] = tonumber(GetCVar(k))
--     end
-- end


-- /dump GetCVar("nameplateMinScale")
-- /run SetCVar("nameplateMinScale", 1)

-- GetCVarBool()
-- tonumber(GetCVar())

