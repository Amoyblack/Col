local _, rs = ...




rs.V.DefaultSetting = {
	["Version"] = "10.0.04",
    ["ForceUpdate"] = false,
    ["ShowMiniMapBtn"] = true,
    ["BarTexture"] = "s3",
	["NarrowCast"] = false,
	["BarBgCol"] = false,
    ["EliteIcon"] = true,

	["DetailType"] = "s1",
	["CenterDetail"] = false,
	["WesternDetail"] = false,

    ["EnableCvar"] = false,
	["nameplateSelectedScale"] = 1,
	["nameplateGlobalScale"] = 1.0,
	["nameplateMaxDistance"] = 45,
	["nameplateOtherTopInset"] = 0.08,
	["nameplateOverlapV"] = 0.6,
	["nameplateOverlapH"] = 0.6,
    ["nameplateOccludedAlphaMult"] = 0.4,

    ["nameplateShowAll"] = 1,
    ["nameplateShowFriendlyNPCs"] = 0,

    ["NameplatePersonalShowAlways"] = 0,
    ["NameplatePersonalShowInCombat"] = 1,
    ["NameplatePersonalShowWithTarget"] = 0,
    ["NameplatePersonalHideDelaySeconds"] = 0.7,

    ["ThreatColorEnable"] = false,      -- 参数 r,g,b  格式: (255,0,255) --> (1,0,1)
    ["dpsSafeColor"] = {.1, .7, .9},    --dps低仇恨 (安全)/ 默认蓝色	Dps low threat (dps safe)
    ["dpsOTColor"] = {.4, .1, .9},      --dps高仇恨（即将OT) / 默认紫色	Dps high threat (OT soon)
    ["TankLoseColor"] = {.9, .1, .9},   --Tank即将丢失仇恨 / 默认亮粉色	Tank unstable threat (lose threat soon)
    ["TankSafeColor"] = {.9, .1, .4},   --Tank稳定仇恨 / 默认暗粉色		Tank stable threat 

    ["SlayEnable"] = false,
	["Slayline"] = 0,
	["SlayColor"] = {1, .73, .41},

	["NameWhite"] = false,
    ["NameSizeEnable"] = false,
    ["NameSize"] = 12,

    ["FocusColorEnable"] = false,
    ["FocusColor"] = {.74, 1 ,.82},

    ["EnableNamemode"] = false,
    ["NameModeFriendlyPlayer"] = false,
    ["NameModeFriendlyNpc"] = false,
    ["NameModeFriendlyPlayerSize"] = 12,
    ["NameModeFriendlyNPCSize"] = 12,
    ["NameModeNameType"] = "s2",
    ["NameModeNpcOffY"] = 0,
    ["NameModePlayerOffY"] = 0,
    ["NameModeImitateOverlap"] = false,

	["AuraNum"] = 5,
	["AuraDefault"] = true,
	["AuraWhite"] = true,
	["AuraOnlyMe"] = false,

    ["DynamicHeightOffSet"] = false,
	["AuraHeight"] = 0,
    ["SelfAuraHeight"] = 0,
    ["SquareAura"] = false,
	["AuraSize"] = 22, 
	["AuraTimer"] = false,
	["AuraTimerSize"] = 10,

    ["personalNpBuffEnable"] = true,
    ["personalNpdeBuffEnable"] = false,

    ["personalNpBuffFilterAll"] = false,
    ["personalNpBuffFilterBlizzard"] = true,
    ["personalNpBuffFilterWatchList"] = true,
    ["personalNpBuffFilterLessMinite"] = false,

    ["personalNpdeBuffFilterAll"] = false,
    ["personalNpdeBuffFilterWatchList"] = true,
    ["personalNpdeBuffFilterLessMinite"] = false,


    ["otherNpBuffEnable"] = false,
    ["otherNpdeBuffEnable"] = true,
    
    ["otherNpBuffFilterAll"] = false,
    ["otherNpBuffFilterWatchList"] = true,
    ["otherNpBuffFilterLessMinite"] = false,

    ["otherNpdeBuffFilterAll"] = false,
    ["otherNpdeBuffFilterBlizzard"] = true,
    ["otherNpdeBuffFilterWatchList"] = true,
    ["otherNpdeBuffFilterLessMinite"] = false,
    ["otherNpdeBuffFilterOnlyMe"] = false,


	["CastHeight"] = 8,
	["UnSelectAlpha"] = 1.0,

	["ShowArrow"] = false,
    ["TargetColorEnable"] = false,
    ["TargetColor"] = {1, 1, 1},
    ["MouseoverGlow"] = false,
	["ShowStolenBuff"] = true,
	["ShowQuestIcon"] = true,
    ["LockPlayerColor"] = true,
    
    ["ProfileByCharactor"] = false,

    ["CastTimer"] = false,
    ["CastTarget"] = false,
    ["CastInterrupteFrom"] = true,
    ["CastInterrupteIndicatorEnable"] = false,

	["ExpballHelper"] = false,

	["DctAura"] = {	
        -- [3355] = true,	--冰冻陷阱
        -- [51514]	= true, --妖术
        -- [118]	= true, --羊
        -- [710]	= true, -- 放逐
        -- [30283]	= true, --暗怒
        -- [2094]	= true, -- 致盲
        -- [6770]	= true, -- 闷棍
        -- [853]	= true, --制裁
        -- [115078]= true, --点穴
        -- [221562]= true, --窒息
        -- [132168]= true, --震荡波
        -- [179057]= true, --混沌
        -- [217832]= true, --dh禁锢
        -- [102359]= true, --群缠绕
        -- [12472]= true, --冰冷血脉
        [190446]= true, --冰冷智慧
        [44544]= true, --寒冰指
        -- [102342]= true, --树皮术
        -- [107574]= true, --天神下凡
        [336892]= true, --无懈警戒4套装
        [193530]= true, --绿叶
        -- [19574]= true, --红人
        -- [31884]= true, --翅膀
        -- [642]= true, --无敌
        [226512] = true,  -- 血池，鲜血脓液
        [226510] = true,  -- 血池，鲜血脓液
        [228318] = true,  -- 暴怒
        [209859] = true,  -- 激励
        [243237] = true,  -- 崩裂
	},

    ["BlackList"] = {
        [363544] = true, -- 冰法四件套
        [270339] = true, -- 蓝炸弹
        [271049] = true, -- 绿炸弹
        [270343] = true, -- 内出血
        [259277] = true, -- 杀戮命令
    },
    ["DctColorNpc"] = {
        [120651] = {0.2, 1, 0.2},   --易爆球
        [174773] = {0, 0, 1},   -- 怨毒影魔
        -- [185685] = {0, 0, 1},   -- U型圣物
        -- [184911] = {0, 0, 1},   -- U大怪
    }, 
    ["DctColorAura"] = {
        [343502] = {0, 0, 1},   --鼓舞光环
    },
    ["DctNeedColorAura"] = {
        [343502] = {{0, 0, 1}, false},  --鼓舞光环
        [217200] = {{0, 0, 1}, true},  --倒刺射击
    },
    
    ["DctInterrupteSpell"] = {
        [147362] = true,    --LR:反制射击
        [187707] = true,    --LR:压制(生存)

        [2139] = true,      --FS:法术反制

        [6552] = true,      --ZS:拳击

        [106839] = true,    --XD:迎头痛击(熊,猫)
        [78675] = true,     --XD:日光(鹌鹑)

        [96231] = true,     --QS:责难(CJ,FQ)

        [1766] = true,      --DZ:脚踢

        [183752] = true,    --DH:瓦解
    }
}

rs.updateInfo = {
    "\n|cffFFD70010.0.04|r\n",
    "添加更新日志和赞助页签",
    "修改自定义材质的存放路径",
    "为小姓名板适配窄施法条样式",
    "为可偷取/驱散光环添加层数显示",
    "插件目录下添加config.lua，可用来配置一些额外功能选项（如染色优先级等）",
    "\n|cffFFD70010.0.03|r\n",
    "血量数值现改为垂直居中",
    "修复一个和Quartz使用时产生异常的问题",
    "地下城助手中的指定光环染色现在添加了<只来源于我>过滤器",
    "\n|cffFFD70010.0.02|r\n",
    "修复一个光环过滤器失效的问题",
    "\n|cffFFD70010.0.01|r\n",
    "调整所有非源生材质的施法条样式与行为表现（包括7.0LEG源生），使其与10.0之前的版本保持一致",
    "\n|cffFFD70010.0.00|r\n",
    "适配10.0客户端",
}

rs.updateInfoEN = {
    "\n|cffFFD70010.0.04|r\n",
    "Add changelog and sponsor tab",
    "Change the storage path of custom texture",
    "Adaptive narrow castbar style for small-style-nameplates",
    "Add stack display for stealable/purgable auras",
    "Add config.lua to the addon directory, which can be used to configure some additional function options (such as color priority, etc.)",
    "\n|cffFFD70010.0.03|r\n",
    "Health values are now vertically centered",
    "Fix a bug that caused an issue when used with Quartz",
    "Specified aura color in Dungeon Helper now add the <Only From Me> filter",
    "\n|cffFFD70010.0.02|r\n",
    "Fix an issue that a aura filter would not work",
    "\n|cffFFD70010.0.01|r\n",
    "Adjust cast bar style and behavior for all non-source textures (including 7.0LEG Source) to be consistent with pre-10.0 versions",
    "\n|cffFFD70010.0.00|r\n",
    "Adapt to 10.0 client",
}


