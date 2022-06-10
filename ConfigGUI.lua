local addon, rs = ...
local L = rs.L
local Spell = Spell

local ConfigFrameContainer
local MarginInfoFrame
local bugReportFrame

local AceGUI = LibStub("AceGUI-3.0")
local AceRegis = LibStub("AceConfigRegistry-3.0")
local AceConfigDialog = LibStub('AceConfigDialog-3.0')
local AceMap = LibStub("LibDBIcon-1.0")

local MapIconTexture  = "Interface\\AddOns\\RSPlates\\media\\rsicon"

local tabSpellDesc = {}
local tabSpellName = {
    "DctInterrupteSpell",
    "DctColorAura",
    "BlackList",
    "DctAura",
}

function rs.GenerateSpellDescCacheAll()
    for n,m in pairs(tabSpellName) do 
        for i,k in pairs(rs.tabDB[rs.iDBmark][m]) do 
            local reqSpell = Spell:CreateFromSpellID(i)
            reqSpell:ContinueOnSpellLoad(function()
                -- local name = reqSpell:GetSpellName()
                local desc = reqSpell:GetSpellDescription()
                tabSpellDesc[i] = desc
                -- print(desc)
            end)
        end
    end
end

local function GenerateSingleSpellDesc(iSpellID, cbFunc)
    local reqSpell = Spell:CreateFromSpellID(iSpellID)
    reqSpell:ContinueOnSpellLoad(function()
        -- local name = reqSpell:GetSpellName()
        local desc = reqSpell:GetSpellDescription()
        tabSpellDesc[iSpellID] = desc
        if cbFunc then 
            cbFunc()
        end
    end)
end

local options = {
    type = "group",
    name = "|cff00FF7FRS|rPlates",
    get = function (info) return rs.tabDB[rs.iDBmark][info[#info]] end,
    set = function (info, value) 
        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
            rs.tabDB[rs.iDBmark][info[#info]] = value 
        end 
    end,
            args = {
                reloadui = {
                    name = L["ReloadUI"],
                    type = 'execute',
                    disabled = false,
                    func = ReloadUI, 
                    width = 0.8,
                    order = 10,
                },
                ShowMiniMapBtn = {
                    name = L["MiniMapEnable"],
                    desc = L["MiniMapEnableTT"],
                    type = 'toggle',
                    order = 1,
                    set = function(info, value)
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        if value == true then 
                            AceMap:Show(addon)
                        else
                            AceMap:Hide(addon)
                        end
                    end,
                }
            }
}

options.args.basic = {
    name = L["MenuBasis"],
    type = 'group',
    order = 1,
    args = {
        div1 = {
            name = L["Title1"],
            type = 'group',
            inline = true,
            order = 2,
            args = {
                NarrowCast = {
                    name = L["NarrowCastBar"],
                    desc = L["NarrowCastBarTT"],
                    type = 'toggle',
                    order = 2,
                },
                EliteIcon = {
                    name = L["EliteIcon"],
                    desc = L["EliteIconTT"],
                    type = 'toggle',
                    order = 3,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end
                        rs.UpdateAllNameplatesOnce() 
                    end,
                },
                BarBgCol = {
                    name = L["BgCol"],
                    desc = L["BgColTT"],
                    type = 'toggle',
                    order = 4,
                },
                gap = {
                    name = "",
                    type = "description",
                    order = 5,
                },
                BarTexture = {
                    name = "|cffFFFFFF "..L["BarTexture"].."|r",
                    desc = L["BarTextureTT"],
                    order = 6,
                    width = 2,
                    type = "select",
                    get = function(info) return rs.tabDB[rs.iDBmark][info[#info]] end,
                    set = function(info, value) rs.tabDB[rs.iDBmark][info[#info]] = value rs.UpdateAllNameplatesOnce()  end, 
                    values = {
                        s1 = "|TInterface\\TargetingFrame\\UI-TargetingFrame-BarFill:10:150:0:0|t  "..L["BarTextureSource"],
                        s2 = "|TInterface\\AddOns\\RSPlates\\media\\bar_rs:10:150:0:0|t  rs",
                        s3 = "|TInterface\\AddOns\\RSPlates\\media\\bar_rs_bright:10:150:0:0|t  rs_L",
                        s4 = "|TInterface\\AddOns\\RSPlates\\media\\bar_raid:10:150:0:0|t  raid",
                        s5 = "|TInterface\\AddOns\\RSPlates\\media\\bar_raid_bright:10:150:0:0|t  raid_L",
                        s6 = "|TInterface\\AddOns\\RSPlates\\media\\bar_solid:10:150:0:0|t  solid",
                    }
                    
                }
            }
        },
        gap1 = {
            name = " ",
            type = "description",
            order = 3,
        },
        div2 = {
            name = L["Health"],
            type = "group",
            inline = true,
            order = 4,
            args = {
                DetailType = {
                    name = "",
                    type = "select",
                    desc = nil,
                    order = 1,
                    values = {
                        s1 = L["HealthNone"],
                        s2 = L["HealthPercentage"],
                        s3 = L["HealthValue"],
                        s4 = L["HealthBothShow"],
                    },
                    set = function (info, value)
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                    rs.UpdateAllNameplatesOnce()
                    end,
                    get = function (info) return rs.tabDB[rs.iDBmark][info[#info]] end

                },
                CenterDetail = {
                    name = L["CenterDetail"],
                    desc = L["CenterDetailTT"],
                    type = "toggle",
                    order = 2,
                },
                WesternDetail = {
                    name = L["WesternDetail"],
                    desc = L["WesternDetailTT"],
                    type = "toggle",
                    order = 3,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                }
            }
        },
        gap2 = {
            name = " ",
            type = "description",
            order = 5,
        },
        div3 = {
            name = L["Title4"],
            type = "group",
            inline = true,
            order = 6,
            args = {
                -- omen3colorlable = {
                --     name = "仇恨染色:",
                --     type = "description",
                --     order = 1,
                --     -- width = "full",
                -- },        
                ThreatColorEnable = {
                    name = L["Omen3"],
                    desc = L["Omen3TT"],
                    type = "toggle",
                    order = 2,
                    width = "full",
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                omen3colorgroup = {
                    name = " ",
                    type = "group",
                    inline = true, 
                    order = 3,
                    get = function(info)
                        return rs.tabDB[rs.iDBmark][info[#info]][1], rs.tabDB[rs.iDBmark][info[#info]][2], rs.tabDB[rs.iDBmark][info[#info]][3]
                    end,
                    set = function(info, r, g, b, a)
                        -- print({r-r%0.01, g-g%0.01, b-b%0.01})
                        rs.tabDB[rs.iDBmark][info[#info]] = {r-r%0.01, g-g%0.01, b-b%0.01}
                    end,
                    args = {
                        dpsSafeColor = {
                            name = L["dpsLowthreat"],
                            desc = L["dpsLowthreatTT"],
                            type = "color",
                            width = 1.3,
                            order = 3,
                        },
                        dpsOTColor = {
                            name = L["dpsGainthreat"],
                            desc = L["dpsGainthreatTT"],
                            type = "color",
                            order = 4,
                            width = 1.3,
                        },
                        gap = {
                            name = "",
                            type = "description",
                            order = 5,
                        },
                        TankLoseColor = {
                            name = L["Tanklosethreat"],
                            desc = L["TanklosethreatTT"],
                            type = "color",
                            width = 1.3,
                            order = 6,
                        },
                        TankSafeColor = {
                            name = L["Tankstablethreat"],
                            desc = L["TankstablethreatTT"],
                            type = "color",
                            order = 7,
                            width = 1.3,
                        },
                    }
                },
                SlayEnable = {
                    name = L["SlayColtext"],
                    type = "toggle",
                    order = 4,
                    width = "full",
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                slaygroup = {
                    name = " ",
                    type = "group",
                    inline = true,
                    order = 5, 
                    args = {
                        Slayline = {
                            name = L["SlayLine"],
                            type = "range",
                            order = 9,
                            min = 0,
                            max = 100,
                            step  = 1,
                        },
                        SlayColor = {
                            name = L["SlayColSelect"],
                            type = "color",
                            order = 10,
                            get = function(info)
                                return rs.tabDB[rs.iDBmark][info[#info]][1], rs.tabDB[rs.iDBmark][info[#info]][2], rs.tabDB[rs.iDBmark][info[#info]][3]
                            end,
                            set = function(info, r, g, b, a)
                                rs.tabDB[rs.iDBmark][info[#info]] = {r-r%0.01, g-g%0.01, b-b%0.01}
                            end,
                        },
                    }
                },

            }
        },
        gap3 = {
            name = " ",
            type = "description",
            order = 7,
        },
        div4 = {
            name = L["Title5"],
            type = "group",
            inline = true,
            order = 8,
            set = function (info, value) 
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end 
                rs.UpdateAllNameplatesOnce()
            end,
            args = {
                NameWhite = {
                    name = L["WhiteName"],
                    desc = L["WhiteNameTT"],
                    type = "toggle",
                    order = 10,
                },
                NameSizeEnable = {
                    name = L["ChangeNameSizeEnable"],
                    desc = L["ChangeNameSizeEnableTT"],
                    type = "toggle",
                    order = 11,
                },
                NameSize = {
                    name = L["NameSize"],
                    desc = L["NameSizeTT"],
                    type = "range",
                    order = 12,
                    min = 5,
                    max = 30,
                    step = 1,
                    disabled = function() return not rs.tabDB[rs.iDBmark]["NameSizeEnable"] end,
                },
            }
        },
        gap4 = {
            name = " ",
            type = "description",
            order = 9,
        },
        divFocus = {
            name = L["FocusTitle"],
            type = "group",
            order = 10,
            inline = true,
            args = {
                FocusColorEnable = {
                    name = L["FocusColorEnable"],
                    type = "toggle",
                    order = 1,
                    width = 1.05,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                FocusColor = {
                    name = L["FocusColor"],
                    type = "color",
                    order = 2,
                    get = function(info)
                        return rs.tabDB[rs.iDBmark][info[#info]][1], rs.tabDB[rs.iDBmark][info[#info]][2], rs.tabDB[rs.iDBmark][info[#info]][3]
                    end,
                    set = function(info, r, g, b, a)
                        rs.tabDB[rs.iDBmark][info[#info]] = {r-r%0.01, g-g%0.01, b-b%0.01}
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
            },
        },
        gapFocus = {
            name = " ",
            type = "description",
            order = 11,
        },
        div5 = {
            name = L["TargetGroup"],
            type = "group",
            inline = true,
            order = 20,
            args = {
                MouseoverGlow = {
                    name = L["MouseoverGlow"],
                    desc = L["MouseoverGlowTT"],
                    type = "toggle",
                    order = 1,
                    set = function(info, value) rs.tabDB[rs.iDBmark][info[#info]] = value 
                        for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
                            local unitFrame = namePlate.UnitFrame
                            rs.RegExtraUIEvent(unitFrame)
                        end	
                    end,
                },
                ShowArrow = {
                    name = L["Arrow"],
                    desc = L["ArrowTT"],
                    type = "toggle",
                    order = 2,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                UnSelectAlpha = {
                    name = L["UnSelectAlpha"],
                    desc = L["UnSelectAlphaTT"],
                    type = "range",
                    order = 3,
                    min = 0.1,
                    -- softmin =0,
                    max = 1,
                    -- softmax = 100,
                    step  = 0.1,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },     
                TargetColorGroup = {
                    name = " ",
                    type = "group",
                    inline = true, 
                    order = 4,
                    args = {
                        TargetColorEnable = {
                            name = L["TargetColorEnable"],
                            desc = L["TargetColorEnableTT"],
                            type = "toggle",
                            order = 1,
                            set = function (info, value) 
                                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                                end 
                                rs.UpdateAllNameplatesOnce()
                            end,
                        },
                        TargetColor = {
                            name = L["TargetColor"],
                            type = "color",
                            order = 2,
                            get = function(info)
                                return rs.tabDB[rs.iDBmark][info[#info]][1], rs.tabDB[rs.iDBmark][info[#info]][2], rs.tabDB[rs.iDBmark][info[#info]][3]
                            end,
                            set = function(info, r, g, b, a)
                                rs.tabDB[rs.iDBmark][info[#info]] = {r-r%0.01, g-g%0.01, b-b%0.01}
                                rs.UpdateAllNameplatesOnce()
                            end,
                        },
                    },
                },
            },
        },
        gap5 = {
            name = " ",
            type = "description",
            order = 21,
        },
        div6 = {
            name = L["CastingTitle"],
            type = "group",
            inline = true,
            order = 22,
            args = {
                CastTimer = {
                    name = L["CastTimer"],
                    desc = L["CastTimerTT"],
                    type = "toggle",
                    order = 1,
                    set = function(info, value) rs.tabDB[rs.iDBmark][info[#info]] = value 
                        for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
                            local unitFrame = namePlate.UnitFrame
                            rs.RegExtraUIEvent(unitFrame)
                        end	
                    end,
                },
                CastTarget = {
                    name = L["CastTarget"],
                    desc = L["CastTargetTT"],
                    type = "toggle",
                    order = 3,
                    set = function(info, value) rs.tabDB[rs.iDBmark][info[#info]] = value 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                CastInterrupteFrom = {
                    name = L["CastInterrupteFrom"],
                    desc = L["CastInterrupteFromTT"],
                    type = "toggle",
                    order = 5,
                },
                InterrupteGroup = {
                    name = " ",
                    type = "group",
                    inline = true,
                    order = 7,
                    args = {
                        CastInterrupteIndicatorEnable = {
                            name = L["CastInterrupteIndicatorEnable"],
                            desc = L["CastInterrupteIndicatorEnableTT"],
                            type = "toggle",
                            order = 1,
                            set = function(info, value) rs.tabDB[rs.iDBmark][info[#info]] = value 
                                for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
                                    -- will not get forbidden unitframe
                                    local unitFrame = namePlate.UnitFrame
                                    rs.RegExtraUIEvent(unitFrame)
                                    rs.On_NpRefreshOnce(unitFrame)
                                end	
                            end,
                        },
                        gap0 = {
                            name = "",
                            type = "description",
                            order = 2,
                        },
                        InterrupteSpellInput = {
                            name = L["InterrupteSpellInput"],
                            desc = L["InterrupteSpellInputTT"],
                            type = "input",
                            order = 3,
                            width = "full",
                            set = function(info, value)
                                local iSpellID = tonumber(value)
                                if not iSpellID then 
                                    print(L["InterrupteSpellIDInputError"])
                                elseif iSpellID/1000000000 >= 1 then 
                                    print(L["InterrupteSpellIDInputError"])
                                else
                                    local name, rank, icon, castTime, minRange, maxRange, spellID = GetSpellInfo(iSpellID)
                                    if not rs.tabDB[rs.iDBmark]["DctInterrupteSpell"][iSpellID] and name then
                                        rs.tabDB[rs.iDBmark]["DctInterrupteSpell"][iSpellID] = true
                                        print(L["InterrupteSpellIDAdded"]..name)
                                        GenerateSingleSpellDesc(iSpellID)
                                        rs.RefInterrupteSpellPanel()
                                    else
                                        print(L["InterrupteSpellIDInputError"])
                                    end
                                end
                            end,
                        },
                        InterrupteSepllGroup = {
                            name = "",
                            type = "group",
                            order = 4,
                            args = {
                            },
                        },
                    },
                },
            },
        },
        gap6 = {
            name = " ",
            type = "description",
            order = 23,
        },
        div7 = {
            name = L["Title8"],
            type = "group",
            inline = true,
            order = 24,
            args = {
                ShowQuestIcon = {
                    name = L["QuestIcon"],
                    desc = L["QuestIconTT"],
                    type = "toggle",
                    order = 1,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
                ShowStolenBuff = {
                    name = L["StolenBuff"],
                    desc = L["StolenBuffTT"],
                    type = "toggle",
                    width = 1.3,
                    order = 3,
                },     
                -- gap = {
                --     name = " ",
                --     type = "description",
                --     order = 4,
                -- },
                LockPlayerColor = {
                    name = L["LockPlayerColor"],
                    desc = L["LockPlayerColorTT"],
                    type = "toggle",
                    width = 1,
                    order = 4,
                },
                CastHeight = {
                    name = L["CastHeight"],
                    desc = L["CastHeightTT"],
                    type = "range",
                    order = 5,
                    min = 5,
                    -- softmin =0,
                    max = 20,
                    -- softmax = 100,
                    step  = 1,
                    set = function (info, value) 
                        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                            rs.tabDB[rs.iDBmark][info[#info]] = value 
                        end 
                        rs.UpdateAllNameplatesOnce()
                    end,
                },
            },
        },
        gap7 = {
            name = " ",
            type = "description",
            order = 25,
        },
        div10 = {
            name = L["Title10"],
            type = "group",
            inline = true,
            order = 26,
            args = {
                ProfileByCharactor = {
                    name = L["ProfileByCharactor"],
                    desc = L["ProfileByCharactorTT"],
                    order = 1,
                    type = "toggle",
                    width = 1.5,
                    get = function(info) return RSPlatesDB[info[#info]] end,
                    set = function(info, value)
                        local dialog = StaticPopup_Show("SetProfileSecondCheck")
                        if dialog then
                            dialog.data = {info[#info], value}
                        end
                        C_Timer.After(0, rs.SwitchConfigGUI)
                    end,
                },
                ResetAddonSetting = {
                    name = L["ResetAddonSetting"],
                    desc = L["ResetAddonSettingTT"],
                    order = 2,
                    type = "execute",
                    func = function(info, value) 
                        local dialog = StaticPopup_Show("ResetAddonSetting")
                        C_Timer.After(0, rs.SwitchConfigGUI)
                    end,
                }
            },
        },
    },
}

options.args.dungeon = {
    name = L["Title7"],
    type = "group",
    order = 2,
    args = {
        ExpballHelper = {
            order = 10,
            name = L["Exp"],
            desc = L["ExpTT"]..L["needReload"],
            type = "toggle",
        },

        NpcGroup = {
            name = " ",
            order = 12,
            type = "group",
            inline = true,
            args = {
                NpcColorEnable = {
                    order = 12,
                    name = L["NpcCOlorTitle"],
                    type = "description",
                    width = "full",
                },
                NpcInput = {
                    order = 13, 
                    name = L["NpcInput"],
                    desc = L["NpcInputTT"],
                    type = "input",
                    width = "full",
                    set = function(info, value)
                        local iNpcID = tonumber(value)
                        if not iNpcID then 
                            print(L["NpcIDInputError"])
                        elseif iNpcID/1000000000 >= 1 then 
                            print(L["NpcIDInputError"])
                        else
                            local sNpcname = rs.GetNameByNpcID(iNpcID)
                            if not rs.tabDB[rs.iDBmark]["DctColorNpc"][iNpcID] and sNpcname then 
                                rs.tabDB[rs.iDBmark]["DctColorNpc"][iNpcID] = {0, 0, 1}
                                print(L["NpcIDAdded"]..sNpcname)
                                rs.RefDungeonNPCPanel()
                                rs.UpdateAllNameplatesOnce()
                            else
                                print(L["NpcIDInputError"])
                            end
                        end
                    end,
                },
                NpcColorGroup = {
                    order = 14,
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {

                    },
                },
            },
        },
        
        AuraGroup = {
            name = " ",
            order = 14,
            type = "group",
            inline = true,
            args = {
                AuraColorEnable = {
                    order = 15,
                    name = L["NpcAuraTitle"],
                    type = "description",
                    width = "full",
                },
                NpcAuraInput = {
                    order = 16, 
                    name = L["NpcAuraInput"],
                    desc = L["NpcAuraInputTT"],
                    type = "input",
                    width = "full",
                    set = function(info, value)
                        local iAuraId = tonumber(value)
                        if not iAuraId then 
                            print(L["NpcAuraInputError"])
                        elseif iAuraId/1000000000 >= 1 then 
                            print(L["NpcAuraInputError"])
                        else
                            local auraName = GetSpellInfo(iAuraId)
                            if not rs.tabDB[rs.iDBmark]["DctColorAura"][iAuraId] and auraName then 
                                rs.tabDB[rs.iDBmark]["DctColorAura"][iAuraId] = {0, 0, 1}
                                print(L["NpcAuraAdded"]..auraName)
                                GenerateSingleSpellDesc(iAuraId)
                                rs.RefDungeonAuraPanel()
                            else
                                print(L["NpcAuraInputError"])
                            end
                        end
                    end,
        
                },
                AuraColorGroup = {
                    order = 17,
                    name = " ",
                    type = "group",
                    inline = true,
                    args = {
                    },
                },
            }
        }

    }
}


options.args.cvars = {
    name = L["Title2"],
    type = "group",
    order = 3,
    args = {
        EnableCvar = {
            order= 0,
            name = L["CvarEnable"],
            desc = L["CvarEnableTT"],
            type = "toggle",
            get = function (info) return rs.tabDB[rs.iDBmark][info[#info]] end,
            set = function(info, value)
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end 
                if value == true then
                    rs.UpdateCvars()
                end
            end

        },
        CvarExtraLink = {
            order = 10,
            name = L["CVarExtraLink"],
            type = "description",
        },
        CvarsSliderGroup = {
            name = "CVars",
            order = 5,
            type = "group",
            inline = true,
            disabled = function(info) return not rs.tabDB[rs.iDBmark]["EnableCvar"] end,
            get = function(info) return tonumber(GetCVar(info[#info])) end,
            set = function (info, value) 
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end 
                rs.UpdateCvars()
            end,
            args = {
                nameplateSelectedScale = {
                    name = L["SelectScale"],
                    desc = L["SelectScaleTT"],
                    type = "range",
                    order = 11,
                    min = 1,
                    max = 2,
                    step  = 0.1,
                },    
                nameplateGlobalScale = {
                    name = L["GlobalScale"],
                    desc = L["GlobalScaleTT"],
                    type = "range",
                    order = 12,
                    min = 0.5,
                    max = 2,
                    step  = 0.1,
                }, 
                nameplateOtherTopInset = {
                    name = L["nameplateOtherTopInset"],
                    desc = L["nameplateOtherTopInsetTT"],
                    type = "range",
                    order = 13,
                    min = 0.01,
                    max = 0.15,
                    step  = 0.01,
                }, 
                nameplateOverlapV = {
                    name = L["OverlapV"],
                    desc = L["OverlapVTT"],
                    type = "range",
                    order = 14,
                    min = 0.2,
                    max = 1.5,
                    step  = 0.1,
                }, 
                nameplateOverlapH = {
                    name = L["OverlapH"],
                    desc = L["OverlapHTT"],
                    type = "range",
                    order = 15,
                    min = 0.2,
                    max = 1.5,
                    step  = 0.1,
                }, 
                nameplateOccludedAlphaMult = {
                    name = L["nameplateOccludedAlphaMult"],
                    type = "range",
                    order = 16,
                    min = 0.1,
                    max = 1,
                    step  = 0.1,                
                },
                cvargap1 = {
                    order = 20,
                    name = " \n ",
                    type = "description",
                },
                nameplateShowAll = {
                    order = 21,
                    name = L["ShowAllNP"],
                    desc = L["ShowAllNPTT"],
                    type = "toggle",
                    get = function(info) if tonumber(GetCVar(info[#info])) == 1 then return true else return false end end,
                    set = function(info, value) if value == true then rs.tabDB[rs.iDBmark][info[#info]] = 1 else rs.tabDB[rs.iDBmark][info[#info]] = 0 end rs.UpdateCvars() end,
                },
        
                nameplateShowFriendlyNPCs = {
                    order = 22,
                    name = L["ShowNpcNP"],
                    desc = L["ShowNpcNPTT"],
                    type = "toggle",
                    get = function(info) if tonumber(GetCVar(info[#info])) == 1 then return true else return false end end,
                    set = function(info, value) if value == true then rs.tabDB[rs.iDBmark][info[#info]] = 1 else rs.tabDB[rs.iDBmark][info[#info]] = 0 end rs.UpdateCvars() end,
                },
                cvargap2 = {
                    order = 23,
                    name = " \n ",
                    type = "description",
                },
                PlayerselfGroup = {
                    order = 30,
                    type = "group",
                    inline = true,
                    name = L["WhenselfShow"],
                    args = {
                        NameplatePersonalShowAlways ={
                            name = L["NameplatePersonalShowAlways"],
                            type = "toggle",
                            order = 1,
                            get = function(info) if tonumber(GetCVar(info[#info])) == 1 then return true else return false end end,
                            set = function(info, value) if value == true then rs.tabDB[rs.iDBmark][info[#info]] = 1 else rs.tabDB[rs.iDBmark][info[#info]] = 0 end rs.UpdateCvars() end,
                        },
                        NameplatePersonalShowInCombat ={
                            name = L["NameplatePersonalShowInCombat"],
                            type = "toggle",
                            order = 2,
                            get = function(info) if tonumber(GetCVar(info[#info])) == 1 then return true else return false end end,
                            set = function(info, value) if value == true then rs.tabDB[rs.iDBmark][info[#info]] = 1 else rs.tabDB[rs.iDBmark][info[#info]] = 0 end rs.UpdateCvars() end,
                        },
                        NameplatePersonalShowWithTarget ={
                            name = L["NameplatePersonalShowWithTarget"],
                            type = "toggle",
                            order = 3,
                            get = function(info) if tonumber(GetCVar(info[#info])) == 2 then return true else return false end end,
                            set = function(info, value) if value == true then rs.tabDB[rs.iDBmark][info[#info]] = 2 else rs.tabDB[rs.iDBmark][info[#info]] = 0 end rs.UpdateCvars() end,
                        },
                        gap = {
                            name = "",
                            type = "description",
                            order =4,
                        },
                        NameplatePersonalHideDelaySeconds ={
                            name = L["NameplatePersonalHideDelaySeconds"],
                            type = "range",
                            order = 5,
                            min = 0.3,
                            max = 5,
                            step  = 0.1,    
                        },
                    },
                },
            },
        },

    },
}

options.args.namemode = {
    order = 5,
    name = L["Title9"],
    desc = L["Title9TT"],
    type = "group",
    set = function (info, value) 
        if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
            rs.tabDB[rs.iDBmark][info[#info]] = value 
        end
        rs.UpdateAllNameplatesOnce() 
    end,
    args = {
        EnableNamemode = {
            name = L["EnableNamemode"],
            desc = L["EnableNamemodeTT"],
            order = 1,
            type = "toggle",
        },
        NamemodeGroup = {
            name = L["NamemodeGroupTitle"],
            order = 2,
            type = "group",
            inline = true,
            disabled = function() return not rs.tabDB[rs.iDBmark]["EnableNamemode"] end,
            args = {
                NameModeFriendlyPlayer = {
                    order = 1,
                    name = L["FriendlyPlayer"],
                    type = "toggle",
                },
                NameModeFriendlyPlayerSize = {
                    disabled = function() return not (rs.tabDB[rs.iDBmark]["NameModeFriendlyPlayer"] and rs.tabDB[rs.iDBmark]["EnableNamemode"]) end,
                    order = 2,
                    name = L["NameModeNameSize"],
                    type = "range",
                    min = 8,
                    max = 25,
                    step = 1,
                },
                NameModePlayerOffY = {
                    disabled = function() return not (rs.tabDB[rs.iDBmark]["NameModeFriendlyPlayer"] and rs.tabDB[rs.iDBmark]["EnableNamemode"])end,
                    order = 3,
                    name = L["NameModeHeightOffset"],
                    type = "range",
                    min = -50,
                    max = 50,
                    step = 1,
                },
                NameModeGap1 = {
                    order = 4,
                    name = " ",
                    type = "description",
                },
                NameModeFriendlyNpc = {
                    order = 5,
                    name = L["FriendlyNpc"],
                    desc = L["FriendlyNpcTT"],
                    type = "toggle",
                },
                NameModeFriendlyNPCSize = {
                    disabled = function() return not (rs.tabDB[rs.iDBmark]["NameModeFriendlyNpc"] and rs.tabDB[rs.iDBmark]["EnableNamemode"]) end,
                    order = 6,
                    name = L["NameModeNameSize"],
                    type = "range",
                    min = 8,
                    max = 25,
                    step = 1,
                },
                NameModeNpcOffY = {
                    disabled = function() return not (rs.tabDB[rs.iDBmark]["NameModeFriendlyNpc"] and rs.tabDB[rs.iDBmark]["EnableNamemode"]) end,
                    order = 7,
                    name = L["NameModeHeightOffset"],
                    type = "range",
                    min = -50,
                    max = 50,
                    step = 1,
                },

                NameModeGap2 = {
                    order = 10,
                    name = " ",
                    type = "description",
                },
                NameModeNameType = {
                    name = L["NameModeNameType"],
                    type = "select",
                    desc = nil,
                    order = 11,
                    values = {
                        s1 = L["NameModeNameTypeNIL"],
                        s2 = L["NameModeNameTypeOUTLINE"],
                        s3 = L["NameModeNameTypeTHICKOUTLINE"],
                    },
                    set = function (info, value)
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                    rs.UpdateAllNameplatesOnce()
                    end,
                    get = function (info) return rs.tabDB[rs.iDBmark][info[#info]] end

                },
                NameModeImitateOverlap = {
                    name = L["NameModeImitateOverlap"],
                    desc = L["NameModeImitateOverlapTT"],
                    order = 15,
                    type = "toggle",
                    width = 1.5,
                    set = function (info, value)
                    rs.tabDB[rs.iDBmark][info[#info]] = value
                    rs.UpdateCvars()
                    end,
                }
            }
        }

    }
}

options.args.auras = {
    name = L["Title6"],
    desc = "Buff / Debuff",
    type = "group",
    order = 6,
    args = {
        auraglobalheader = {
            name = L["AuraTitleGlobal"],
            desc = "xxxx",
            type = "header",
            order = 0,
        },
        auragap0 = {
            name = " ",
            type = "description",
            order = 1,
        },
        AuraNum = {
            name = L["AuraNum"],
            desc = L["AuraNumTT"],
            type = "range",
            order = 2,
            min = 0,
            max = 10,
            step  = 1,
        },    
        auragap1 = {
            name = " \n ",
            type = "description",
            order = 3,
        },
        aurastyle = {
            name = L["AuraText2"],
            type = "group",
            inline = true,
            order = 4,
            set = function (info, value) 
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end
                rs.RefBuffFrameDisplay() 
            end,
            args = {
                DynamicHeightOffSet = {
                    name = L["DynamicHeightOffSet"],
                    desc = L["DynamicHeightOffSetTT"],
                    type = "toggle",
                    order = 1,
                },
                gapDynamic = {
                    name = " ",
                    type = "description",
                    order = 2,
                },
                AuraHeight = {
                    name = L["AuraHeight"],
                    desc = L["AuraHeightTT"],
                    type = "range",
                    order = 3,
                    min = -70,
                    max = 70,
                    step  = 1,
                },  
                SelfAuraHeight = {
                    name = L["SelfAuraHeight"],
                    desc = L["SelfAuraHeightTT"],
                    type = "range",
                    order = 5,
                    min = -70,
                    max = 70,
                    step  = 1,
                },  
                gapline1 = {
                    order = 7,
                    type = "description",
                    name = "",
                    -- width = "full",
                },
                SquareAura = {
                    name = L["SquareAura"],
                    desc = L["needReload"],
                    type = "toggle",
                    order = 9,
                },
                AuraSize = {
                    name = L["AuraSize"],
                    desc = L["AuraSizeTT"]..L["needReload"],
                    type = "range",
                    order = 11,
                    min = 15,
                    max = 40,
                    step  = 1,
                    disabled = function(info) return not rs.tabDB[rs.iDBmark]["SquareAura"] end
                },   
                gapline2 = {
                    order = 13,
                    type = "description",
                    name = "",
                    -- width = "full",
                },
                AuraTimer = {
                    name = L["Counter"],
                    desc = L["CounterTT"],
                    type = "toggle",
                    order = 15,
                },
                AuraTimerSize = {
                    name = L["CounterSize"],
                    type = "range",
                    order = 17,
                    min = 8,
                    max = 30,
                    step  = 1,
                    disabled = function(info) return not rs.tabDB[rs.iDBmark]["AuraTimer"] end
                },   
            }
        },
        auragap2 = {
            name = " \n ",
            type = "description",
            order = 5,
        },
        aurahelpheader = {
            name = L["AuraFilterTitle"],
            type = "header",
            order = 6,
        },
        aurahelpbtn = {
            name = " ",
            desc = L["AuraFilterHelpBtnTT"],
            type = "execute",
            image = "Interface\\common\\help-i",
            order = 7,
            width = "full",
        },
        personalNp = {
            name = L["AuraFilterPersonalTitle"],
            type = "group",
            inline = true, 
            order = 8,
            set = function (info, value) 
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end 
                rs.UpdateAllNameplatesOnce()
            end,
            args = {
                personalNpBuffEnable = {
                    name = L["AuraFilterEnableBuff"],
                    type = "toggle",
                    order= 1,
                },
                personalNpdeBuffEnable = {
                    name = L["AuraFilterEnableDeBuff"],
                    type = "toggle",
                    order= 2,
                },
                personalNpBuffFilter = {
                    name = "BUFF",
                    type = "group",
                    inline = true,
                    order = 3,
                    args ={
                        personalNpBuffFilterAll = {
                            name = L["AuraFilterAll"],
                            desc = L["AuraFilterAllTT"],
                            type = "toggle",
                            order = 1,
                            width = 0.7,
                        },
                        personalNpBuffFilterBlizzard = {
                            name = L["AuraFilterBlizzard"],
                            desc = L["AuraFilterBlizzardTT"],
                            type = "toggle",
                            order = 3,
                            width = 0.7,
                        },
                        personalNpBuffFilterWatchList = {
                            name = L["AuraFilterWhiteList"],
                            desc = L["AuraFilterWhiteListTT"],
                            type = "toggle",
                            order = 2,
                            width = 0.7,
                        },
                        personalNpBuffFilterLessMinite= {
                            name = L["AuraFilterLessMinite"],
                            desc = L["AuraFilterLessMiniteTT"],
                            type = "toggle",
                            order = 4,
                            width = 0.7,
                        },
                    }
                },
                personalNpdeBuffFilter = {
                    name = "DEBUFF",
                    type = "group",
                    inline = true,
                    order = 4,
                    args ={
                        personalNpdeBuffFilterAll = {
                            name = L["AuraFilterAll"],
                            desc = L["AuraFilterAllTT"],
                            type = "toggle",
                            order = 1,
                            width = 0.7,
                        },
                        personalNpdeBuffFilterWatchList = {
                            name = L["AuraFilterWhiteList"],
                            desc = L["AuraFilterWhiteListTT"],
                            type = "toggle",
                            order = 3,
                            width = 0.7,
                        },
                        personalNpdeBuffFilterLessMinite= {
                            name = L["AuraFilterLessMinite"],
                            desc = L["AuraFilterLessMiniteTT"],
                            type = "toggle",
                            order = 4,
                            width = 0.7,
                        },
                    }
                },
            }
        },
        auragap3 = {
            name = " \n ",
            type = "description",
            order = 9,
        },
        otherNp = {
            name = L["AuraFilterOtherTitle"],
            type = "group",
            inline = true, 
            order = 10,
            set = function (info, value) 
                if rs.tabDB[rs.iDBmark][info[#info]] ~= nil then 
                    rs.tabDB[rs.iDBmark][info[#info]] = value 
                end 
                rs.UpdateAllNameplatesOnce()
            end,
            args = {
                otherNpBuffEnable = {
                    name = L["AuraFilterEnableBuff"],
                    type = "toggle",
                    order= 1,
                },
                otherNpdeBuffEnable = {
                    name = L["AuraFilterEnableDeBuff"],
                    type = "toggle",
                    order= 2,
                },
                otherNpBuffFilter = {
                    name = "BUFF",
                    type = "group",
                    inline = true,
                    order = 3,
                    args ={
                        otherNpBuffFilterAll = {
                            name = L["AuraFilterAll"],
                            desc = L["AuraFilterAllTT"],
                            type = "toggle",
                            order = 1,
                            width = 0.7,
                        },
                        otherNpBuffFilterWatchList = {
                            name = L["AuraFilterWhiteList"],
                            desc = L["AuraFilterWhiteListTT"],
                            type = "toggle",
                            order = 3,
                            width = 0.7,
                        },
                        otherNpBuffFilterLessMinite= {
                            name = L["AuraFilterLessMinite"],
                            desc = L["AuraFilterLessMiniteTT"],
                            type = "toggle",
                            order = 4,
                            width = 0.7,
                        },
                    }
                },
                otherNpdeBuffFilter = {
                    name = "DEBUFF",
                    type = "group",
                    inline = true,
                    order = 4,
                    args ={
                        otherNpdeBuffFilterAll = {
                            name = L["AuraFilterAll"],
                            desc = L["AuraFilterAllTT"],
                            type = "toggle",
                            order = 1,
                            width = 0.7,
                        },
                        otherNpdeBuffFilterBlizzard = {
                            name = L["AuraFilterBlizzard"],
                            desc = L["AuraFilterBlizzardTT"],
                            type = "toggle",
                            order = 3,
                            width = 0.7,
                        },
                        otherNpdeBuffFilterWatchList = {
                            name = L["AuraFilterWhiteList"],
                            desc = L["AuraFilterWhiteListTT"],
                            type = "toggle",
                            order = 2,
                            width = 0.7,
                        },
                        otherNpdeBuffFilterLessMinite = {
                            name = L["AuraFilterLessMinite"],
                            desc = L["AuraFilterLessMiniteTT"],
                            type = "toggle",
                            order = 4,
                            width = 0.7,
                        },
                        otherNpdeBuffFilterOnlyMe = {
                            name = L["AuraFilterOnlyMe"],
                            desc = L["AuraFilterOnlyMeTT"],
                            type = "toggle",
                            order = 5,
                            width = 0.7,
                        },
                    }
                },
            }
        },
    }
}

options.args.auras.args.whitelist = {
    name = L["MenuWhiteList"],
    type = "group",
    order = 8,
    args = {
        whitelistDesc = {
            name = L["WhiteListDesc"],
            type = "description",
            order = 1,
        },

        inputAura = {
            name = L["WhiteListInput"],
            desc = L["WhiteListInputTT"],
            width = "full",
            type = "input",
            order = 10,
            -- validate = function(info, value) print(value) return "" end,
            set = function(info, value)
                local iAuraId = tonumber(value)
                if not iAuraId then 
                    print(L["WhiteListInputError"])
                elseif iAuraId/1000000000 >= 1 then 
                    print(L["WhiteListInputError"])
                else
                    local iconname = GetSpellInfo(iAuraId)
                    if not rs.tabDB[rs.iDBmark]["DctAura"][iAuraId] and iconname then 
                        rs.tabDB[rs.iDBmark]["DctAura"][iAuraId] = true
                        print(L["WhiteListAdd"]..iconname)
                        GenerateSingleSpellDesc(iAuraId)
                        rs.RefWhitelistAuraPanel()
                    else
                        print(L["WhiteListInputError"])
                    end
                end
            end
        },
        whitelisticongroup = {
            order = 11,
            name = L["MenuWhiteList"],
            type = "group",
            inline = true, 
            args = {
                
            }
        }
    }
}

options.args.auras.args.blacklist = {
    name = L["MenuBlackList"],
    type = "group",
    order = 9,
    args = {
        blacklistDesc = {
            name = L["BlacklistDesc"],
            type = "description",
            order = 1,
        },

        blackinputAura = {
            name = L["BlackListInput"],
            desc = L["BlackListInputTT"],
            width = "full",
            type = "input",
            order = 10,
            -- validate = function(info, value) print(value) return "" end,
            set = function(info, value)
                local iAuraId = tonumber(value)
                if not iAuraId then 
                    print(L["BlackListInputError"])
                elseif iAuraId/1000000000 >= 1 then 
                    print(L["BlackListInputError"])
                else
                    local iconname = GetSpellInfo(iAuraId)
                    if not rs.tabDB[rs.iDBmark]["BlackList"][iAuraId] and iconname then 
                        rs.tabDB[rs.iDBmark]["BlackList"][iAuraId] = true
                        print(L["BlackListAdd"]..iconname)
                        GenerateSingleSpellDesc(iAuraId)
                        rs.RefBlacklistAuraPanel()
                    else
                        print(L["BlackListInputError"])
                    end
                end
            end
        },
        blacklisticongroup = {
            order = 11,
            name = L["MenuBlackList"],
            type = "group",
            inline = true, 
            args = {
                
            }
        }
    }
}

function rs.InitMinimapBtn()
    local savedVarTable = {
        hide = not rs.tabDB[rs.iDBmark]["ShowMiniMapBtn"],
        minimapPos = 130,
        -- radius = 1,
    }
    local tabobj = {
            icon = MapIconTexture,
            OnClick = function(self, button) 
                if button == "RightButton" then 
                    rs.SwitchBugReportWindow()
                    -- ReloadUI()
                else
                    if IsShiftKeyDown() then
                        rs.SwitchConfigGUI()
                    else 
                        rs.SwitchConfigGUI()
                    end
                end
            end,
            OnTooltipShow = function(tooltip)
                tooltip:AddLine("|cff00FF7FRS|rPlates")
                tooltip:AddLine(" ")
                tooltip:AddLine(L["MiniMapLeftBtn"])
                tooltip:AddLine(L["MiniMapRightBtn"])
            end
        }
    AceMap:Register(addon, tabobj, savedVarTable)
end


AceRegis:RegisterOptionsTable(addon, options, false)
AceRegis:NotifyChange(addon);



function rs.SwitchConfigGUI(page)
    if not page then page = "basic" end 
    if ConfigFrameContainer and ConfigFrameContainer:IsShown() then 
        ConfigFrameContainer:Release()
    else
        -- if not ConfigFrameContainer then 
            ConfigFrameContainer = AceGUI: Create("Frame")
            -- ConfigFrameContainer:SetTitle("RSPsss")
            ConfigFrameContainer:SetStatusText(format("%s%s",L["UpdateVersion"], rs.tabDB[rs.iDBmark]["Version"]))
            ConfigFrameContainer:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
        -- end
        rs.RefInterrupteSpellPanel()
        rs.RefWhitelistAuraPanel()
        rs.RefBlacklistAuraPanel()
        rs.RefDungeonNPCPanel()
        rs.RefDungeonAuraPanel()
        AceConfigDialog:SetDefaultSize(addon, 800, 600)
        -- AceConfigDialog:SelectGroup(addon, "whitelist")
        AceConfigDialog:SelectGroup(addon, page)
        AceConfigDialog:Open(addon, ConfigFrameContainer)
        -- AceConfigDialog:CloseAll()
            
        -- AceConfigDialog: AddToBlizOptions(addon)
    end
end


local RSNpcIDTooltip
RSNpcIDTooltip = CreateFrame("GameTooltip", "RSNPCID", UIParent, "GameTooltipTemplate")
RSNpcIDTooltip:SetOwner(UIParent, "ANCHOR_NONE")

function rs.GetNameByNpcID(iNpcID)
    -- SetOwer May Release once 
    RSNpcIDTooltip:SetOwner(UIParent, "ANCHOR_NONE")
    RSNpcIDTooltip:SetHyperlink(format("unit:Creature-0-0-0-0-%d", iNpcID))

    if RSNPCIDTextLeft1 and RSNPCIDTextLeft1.GetText then 
        local name = RSNPCIDTextLeft1:GetText()
        return name
    end
end


-- Npc ID
function rs.RefDungeonNPCPanel()
    local node = options.args.dungeon.args.NpcGroup.args.NpcColorGroup
    local v = 1
    node.args = {}
    for i, k in pairs(rs.tabDB[rs.iDBmark]["DctColorNpc"]) do 
        local sNpcName = rs.GetNameByNpcID(i)
        local sNpcID = tostring(i)
        if sNpcName then
            node.args[sNpcID.."DungeonNPCPanelName"] = {
                type = "toggle",
                width = "double",
                order = v,
                name = format("NpcID: %s  [ %s ]",sNpcID,sNpcName),
                desc = L["RemoveCheckBoxTT"],
                set = function(info,value) rs.tabDB[rs.iDBmark]["DctColorNpc"][i] = nil rs.RefDungeonNPCPanel() 
                    print(L["NpcIDDeled"]..sNpcName)
                    rs.UpdateAllNameplatesOnce()
                end 
            }
            v = v + 1
            node.args[sNpcID.."DungeonNPCPanelColor"] = {
                type = "color",
                name = L["NpcbarColor"],
                desc = L["NpcIDColorSelectTT"],
                width = "half",
                order = v,
                get = function(info) return rs.tabDB[rs.iDBmark]["DctColorNpc"][i][1], rs.tabDB[rs.iDBmark]["DctColorNpc"][i][2], rs.tabDB[rs.iDBmark]["DctColorNpc"][i][3] end,
                set = function(info,r,g,b,a) rs.tabDB[rs.iDBmark]["DctColorNpc"][i] = {r-r%0.01, g-g%0.01, b-b%0.01} end,
            }
            v = v + 1
            node.args[sNpcID.."DungeonNPCPanelgapline"] = {
                type = "description",
                name = " ",
                order = v,
            }
        end
    end
end


-- Npc光环
function rs.RefDungeonAuraPanel()
    local node = options.args.dungeon.args.AuraGroup.args.AuraColorGroup
    node.args = {}
    for i, k in pairs(rs.tabDB[rs.iDBmark]["DctColorAura"]) do 
            local sAuraID = tostring(i)
            local iconname, _, icon = GetSpellInfo(i)
            node.args["group"..sAuraID] = {
                type = "group",
                name = "",
                inline = true,
                args = {

                }
            }
            node.args["group"..sAuraID].args[sAuraID.."DungeonAuraPanelName"] = {
                type = "toggle",
                desc = function()
                    local spellDes = tabSpellDesc[i]
                    if not spellDes or spellDes == "" then
                        spellDes = L["GetSpellDesFailInfo"]
                    end
                    local des = format("AuraID: %s\n\n%s", sAuraID, spellDes)
                    return format("%s\n\n%s", des, L["RemoveCheckBoxTT"])
                end,
                -- desc = format("%s\n\n%s", des, L["RemoveCheckBoxTT"]),
                width = "double",
                name = iconname,
                image = icon,
                order = 1,
                set = function(info,value) rs.tabDB[rs.iDBmark]["DctColorAura"][i] = nil rs.RefDungeonAuraPanel() 
                    print(L["NpcAuraDeled"]..iconname)
                end 
            }
            node.args["group"..sAuraID].args[sAuraID.."DungeonAuraPanelColor"] = {
                type = "color",
                name = L["NpcbarColor"],
                order = 2,
                desc = L["NpcAuraColorSelectTT"],
                width = "half",
                get = function(info) return rs.tabDB[rs.iDBmark]["DctColorAura"][i][1], rs.tabDB[rs.iDBmark]["DctColorAura"][i][2], rs.tabDB[rs.iDBmark]["DctColorAura"][i][3] end,
                set = function(info,r,g,b,a) rs.tabDB[rs.iDBmark]["DctColorAura"][i] = {r-r%0.01, g-g%0.01, b-b%0.01} end,
            }
    end

end


-- 白名单
function rs.RefWhitelistAuraPanel()
    local node = options.args.auras.args.whitelist.args.whitelisticongroup 
    node.args = {} 
    for i, v in pairs(rs.tabDB[rs.iDBmark]["DctAura"]) do 
        local sAuraID = tostring(i)
        local iconname, _, icon = GetSpellInfo(i)

        -- tode node.args. sAuraID  not work
        node.args[sAuraID.."WhitelistAuraPanel"] = {
            name = iconname,
            type = "toggle",
            image = icon,
            desc = function()
                local spellDes = tabSpellDesc[i]
                if not spellDes or spellDes == "" then
                    spellDes = L["GetSpellDesFailInfo"]
                end
                local des = format("AuraID: %s\n\n%s", sAuraID, spellDes)
                return format("%s\n\n%s", des, L["RemoveCheckBoxTT"])
            end,
            -- desc = format("%s\n\n%s", des, L["RemoveCheckBoxTT"]),
            set = function(info, value)
                if rs.tabDB[rs.iDBmark]["DctAura"][i] then 
                    rs.tabDB[rs.iDBmark]["DctAura"][i] = nil
                    print(L["WhiteListRemove"]..iconname)
                end
                rs.RefWhitelistAuraPanel()
            end
        }
    end
end

-- 黑名单
function rs.RefBlacklistAuraPanel()
    local node = options.args.auras.args.blacklist.args.blacklisticongroup 
    node.args = {} 
    for i, v in pairs(rs.tabDB[rs.iDBmark]["BlackList"]) do 
        local sAuraID = tostring(i)
        local iconname, _, icon = GetSpellInfo(i)

        -- tode node.args. sAuraID  not work
        node.args[sAuraID.."BlacklistAuraPanel"] = {
            name = iconname,
            type = "toggle",
            image = icon,
            desc = function()
                local spellDes = tabSpellDesc[i]
                if not spellDes or spellDes == "" then
                    spellDes = L["GetSpellDesFailInfo"]
                end
                local des = format("AuraID: %s\n\n%s", sAuraID, spellDes)
                return format("%s\n\n%s", des, L["RemoveCheckBoxTT"])
            end,
            -- desc = format("%s\n\n%s", des, L["RemoveCheckBoxTT"]),
            set = function(info, value)
                if rs.tabDB[rs.iDBmark]["BlackList"][i] then 
                    rs.tabDB[rs.iDBmark]["BlackList"][i] = nil
                    print(L["BlackListRemove"]..iconname)
                end
                rs.RefBlacklistAuraPanel()
            end
        }
    end
end

-- 打断指示器 技能
function rs.RefInterrupteSpellPanel()
    local t = 1
    local node = options.args.basic.args.div6.args.InterrupteGroup.args.InterrupteSepllGroup
    node.args = {}
    for i, v in pairs(rs.tabDB[rs.iDBmark]["DctInterrupteSpell"]) do
        local sSpell = tostring(i)
        local iconname, _, icon = GetSpellInfo(i)

        node.args[sSpell.."Interrupte"] = {
            name = " ",
            type = "toggle",
            image = icon,
            width = 0.3,
            order = t,
            desc = function()
                local spellDes = tabSpellDesc[i]
                if not spellDes or spellDes == "" then
                    spellDes = L["GetSpellDesFailInfo"]
                end
                local des = format("SpellID: %s\n\n%s", sSpell, spellDes)
                return format("|cffFFD700%s|r\n\n%s\n\n%s",iconname, des, L["RemoveCheckBoxTT"])
            end,
            -- desc = format("|cffFFD700%s|r\n\n%s\n\n%s",iconname, des, L["RemoveCheckBoxTT"]),
            set = function(info, value)
                if rs.tabDB[rs.iDBmark]["DctInterrupteSpell"][i] then 
                    rs.tabDB[rs.iDBmark]["DctInterrupteSpell"][i] = nil
                    print(L["InterrupteSpellIDRemoved"]..iconname)
                end
                rs.RefInterrupteSpellPanel()
            end
        }
        t = t + 1
    end
end

local function CreateBlizzardOptionPanel(frame)
    if not frame.openConfigGuiBtn then 
        frame.title = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        frame.title:SetPoint("LEFT", frame, "TOPLEFT", 20, -30);  
        frame.title:SetText("|cff00FF7FRS|rPlates")
        frame.title:SetFont(STANDARD_TEXT_FONT, 30)

        frame.info = frame:CreateFontString(nil, "OVERLAY")
        frame.info:SetFontObject("GameFontHighlight");
        frame.info:SetPoint("LEFT", frame, "TOPLEFT", 20, -70);  
        frame.info:SetText(L["BlizzardPanelInfo"])

        frame.msg = frame:CreateFontString(nil, "OVERLAY")
        frame.msg:SetPoint("LEFT", frame, "TOPLEFT", 20, -100);  
        frame.msg:SetFontObject("GameFontHighlight");
        frame.msg:SetText(L["BlizzardPanelReportInfo"])

        -- frame.openConfigGuiBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
        -- frame.openConfigGuiBtn:SetPoint("LEFT", frame, "TOPLEFT", 20 , -130);  
        -- frame.openConfigGuiBtn:SetSize(120,25);
        -- frame.openConfigGuiBtn:SetText(L["BlizzardPanelSettingBtn"])
        -- frame.openConfigGuiBtn:SetScript("OnClick", function()
            -- while CloseWindows() do end
            -- rs.SwitchConfigGUI()
        -- end)

        frame.version = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
        frame.version:SetPoint("LEFT", frame, "TOPLEFT", 20, -200);  
        frame.version:SetText(L["Version"] .. rs.tabDB[rs.iDBmark]["Version"])
        frame.version:SetFont(STANDARD_TEXT_FONT, 20)

        frame.largeStyleInfo = frame:CreateFontString(nil, "OVERLAY")
        frame.largeStyleInfo:SetPoint("LEFT", frame, "TOPLEFT", 20, -230);  
        frame.largeStyleInfo:SetFontObject("GameFontHighlight");
        frame.largeStyleInfo:SetText(L["BlizzardPanelLargeInfo"])

    end
end

local BlizzardOptionRSFrame = CreateFrame("Frame", "RSPBlizzardOption", InterfaceOptionsFrame)
BlizzardOptionRSFrame.name = '|cff00FF7FRS|rPlates'
BlizzardOptionRSFrame:SetScript("OnShow", function(frame)
    CreateBlizzardOptionPanel(frame)
end)
InterfaceOptions_AddCategory(BlizzardOptionRSFrame)



function rs.SwitchColMarginInfoWindow()
    if MarginInfoFrame and MarginInfoFrame:IsShown() then 
        MarginInfoFrame:Release()
    else
        MarginInfoFrame = AceGUI:Create("Frame")
        MarginInfoFrame:SetTitle("|cff00FF7FRS|rPlates")
        MarginInfoFrame:SetWidth(600)
        MarginInfoFrame:SetHeight(250)
        MarginInfoFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
        MarginInfoFrame:SetLayout("Flow")
    
        local Info1 = AceGUI:Create("Label")
        Info1:SetText(L["MarginCol1"])
        Info1:SetFullWidth(true)
        MarginInfoFrame:AddChild(Info1)
    
        local Info2 = AceGUI:Create("Label")
        Info2:SetText(L["MarginCol2"])
        Info2:SetFullWidth(true)
        MarginInfoFrame:AddChild(Info2)
    
        local Info3 = AceGUI:Create("Label")
        Info3:SetText(L["MarginCol3"])
        Info3:SetFullWidth(true)
        MarginInfoFrame:AddChild(Info3)
    
        local Info4 = AceGUI:Create("Label")
        Info4:SetText(L["MarginCol4"])
        Info4:SetFullWidth(true)
        MarginInfoFrame:AddChild(Info4)
    end
end



function rs.SwitchBugReportWindow()
    if bugReportFrame and bugReportFrame:IsShown() then 
        bugReportFrame:Release()
    else
        bugReportFrame = AceGUI:Create("Frame")
        bugReportFrame:SetTitle("|cff00FF7FRS|rPlates - Bug Report")
        bugReportFrame:SetWidth(450)
        bugReportFrame:SetHeight(180)
        bugReportFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
        bugReportFrame:SetLayout("Flow")

        local Info2 = AceGUI:Create("Label")
        Info2:SetText("Curseforge")
        bugReportFrame:AddChild(Info2)
    
        local Input2 = AceGUI:Create("EditBox")
        Input2:SetText("https://www.curseforge.com/wow/addons/rsplates")
        Input2:SetRelativeWidth(1)
        bugReportFrame:AddChild(Input2)

        local Info3 = AceGUI:Create("Label")
        Info3:SetText("中文社区")
        bugReportFrame:AddChild(Info3)
    
        local Input3 = AceGUI:Create("EditBox")
        Input3:SetText("https://bbs.nga.cn/read.php?tid=16229958")
        Input3:SetRelativeWidth(1)
        bugReportFrame:AddChild(Input3)

    end
end


StaticPopupDialogs.SetProfileSecondCheck = { 
    text = L["ProfileByCharactorCheckTip"],
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept =  function(self, data)
        local ProfileIndexName = data[1]
        local flag = data[2]
        RSPlatesDB[ProfileIndexName] = flag
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
    preferredIndex = 1,
} 

StaticPopupDialogs.ResetAddonSetting = {
    text = L["ProfileByCharactorCheckTip"],
    button1 = ACCEPT,
    button2 = CANCEL,
    OnAccept =  function(self, data)
        RSPlatesDB = rs.V.DefaultSetting
        RSPlatesDBPer = rs.V.DefaultSetting
        ReloadUI()
    end,
    timeout = 0,
    whileDead = 1,
    hideOnEscape = true,
    preferredIndex = 1,
}



---- 不产生任何新逻辑   仅刷新界面----

function rs.UpdateAllNameplatesOnce()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		rs.On_NpRefreshOnce(unitFrame)
        rs.ThinCastBar(unitFrame.castBar)
        if unitFrame.name then 
            if rs.tabDB[rs.iDBmark]["NameWhite"] then 
                unitFrame.name:SetVertexColor(1, 1, 1)
            end
            if rs.tabDB[rs.iDBmark]["NameSizeEnable"] then 
                unitFrame.name:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["NameSize"], nil)
            end
        end
	end	
end

function rs.RefBuffFrameDisplay()
	for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
		local unitFrame = namePlate.UnitFrame
		unitFrame.BuffFrame:UpdateAnchor()
		if unitFrame.unit then 
			local self = unitFrame.BuffFrame
            local buffid 
			for i = 1, BUFF_MAX_DISPLAY do
				if self.buffList[i] then 
					--计时器
					self.buffList[i].Cooldown:SetHideCountdownNumbers(not rs.tabDB[rs.iDBmark]["AuraTimer"])
					--计时器大小
                    local regon = self.buffList[i].Cooldown:GetRegions()
                    if regon.GetText then 
                        regon:SetFont(STANDARD_TEXT_FONT, rs.tabDB[rs.iDBmark]["AuraTimerSize"], nil)  --Default : 15 "OUTLINE"
                    end			
				end
			end
		end
	end	
end


