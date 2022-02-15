local addon, rs = ...


-- 不要无感修改任何CVars，最多只初始化修改第一次
function rs.SetCVarOnFirstTime()
    -- 堆叠1 重叠 0 
    SetCVar("nameplateMotion", 1) 

    -- 不随距离变化更改透明度
    SetCVar("nameplateMinAlpha", 1) 

    --     -- V所开启的姓名版类型
    -- SetCVar("nameplateShowAll", 1)   --显示所有
    -- SetCVar("nameplateShowEnemies", 1)   --敌对单位
    -- SetCVar("nameplateShowEnemyMinions", 1)   --仆从
    -- SetCVar("nameplateShowEnemyMinus", 1)   --杂兵

    -- -- 遮挡姓名版透明度与  个人资源条 显示逻辑
    -- SetCVar("NameplatePersonalShowInCombat", 1)
    -- SetCVar("NameplatePersonalShowWithTarget", 1)
    -- SetCVar("nameplateOccludedAlphaMult", 0.2)
end



function rs.UpdateCvars()
    if RSPlatesDB["EnableCvar"] then 
        SetCVar("nameplateSelectedScale", RSPlatesDB["nameplateSelectedScale"])
        SetCVar("nameplateGlobalScale", RSPlatesDB["nameplateGlobalScale"])
        SetCVar("nameplateMaxDistance", RSPlatesDB["nameplateMaxDistance"])
        SetCVar("nameplateOverlapV", RSPlatesDB["nameplateOverlapV"])
        SetCVar("nameplateOverlapH", RSPlatesDB["nameplateOverlapH"])

        SetCVar("nameplateShowAll", RSPlatesDB["nameplateShowAll"]) 
        SetCVar("nameplateShowFriendlyNPCs", RSPlatesDB["nameplateShowFriendlyNPCs"]) 

        --不让血条随距离改变而变小,预设Min 0.8
        SetCVar("namePlateMinScale", 1) 
        SetCVar("namePlateMaxScale", 1) 
    end
end


-- /dump GetCVar("nameplateShowFriendlyNPCs")
-- /run SetCVar("nameplateShowFriendlyNPCs", 0) 

