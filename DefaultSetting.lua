local _, rs = ...




rs.V.DefaultSetting = {
	["Version"] = "9.2.04",
    ["ForceUpdate"] = false,
    ["ShowMiniMapBtn"] = true,
	["FlatBar"] = false,
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
	["nameplateOverlapV"] = 0.8,
	["nameplateOverlapH"] = 0.6,
    ["nameplateOccludedAlphaMult"] = 0.4,

    ["nameplateShowAll"] = 1,
    ["nameplateShowFriendlyNPCs"] = 0,

    ["NameplatePersonalShowAlways"] = 0,
    ["NameplatePersonalShowInCombat"] = 1,
    ["NameplatePersonalShowWithTarget"] = 0,

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

    ["EnableNamemode"] = false,
    ["NameModeFriendlyPlayer"] = false,
    ["NameModeFriendlyNpc"] = false,
    ["NameModeFriendlyPlayerSize"] = 12,
    ["NameModeFriendlyNPCSize"] = 12,
    ["NameModeNameType"] = "s2",
    ["NameModeNpcOffY"] = 0,
    ["NameModePlayerOffY"] = 0,

	["AuraNum"] = 3,
	["AuraDefault"] = true,
	["AuraWhite"] = true,
	["AuraOnlyMe"] = false,

	["AuraHeight"] = 25,
    ["SelfAuraHeight"] = 20,
    ["SquareAura"] = true,
	["AuraSize"] = 22, 
	["AuraTimer"] = false,
	["AuraTimerSize"] = 10,

	["CastHeight"] = 8,
	["UnSelectAlpha"] = 1.0,

	["ShowArrow"] = false,
	["ShowStolenBuff"] = true,
	["ShowQuestIcon"] = true,

	["ExpballHelper"] = false,

	["DctAura"] = {	
        [3355] = true,	--冰冻陷阱
        [51514]	= true, --妖术
        [118]	= true, --羊
        [710]	= true, -- 放逐
        [30283]	= true, --暗怒
        [2094]	= true, -- 致盲
        [6770]	= true, -- 闷棍
        [853]	= true, --制裁
        [115078]= true, --点穴
        [221562]= true, --窒息
        [132168]= true, --震荡波
        [179057]= true, --混沌
        [217832]= true, --dh禁锢
        [102359]= true, --群缠绕
        [12472]= true, --冰冷血脉
        [190446]= true, --冰冷智慧
        [44544]= true, --寒冰指
        [102342]= true, --树皮术
        [107574]= true, --天神下凡
        [193530]= true, --绿叶
        [19574]= true, --红人
        [31884]= true, --翅膀
        [642]= true, --无敌
	},
    ["DctColorNpc"] = {
        [120651] = {0.2, 1, 0.2},   --易爆球
        [174773] = {0, 0, 1},   -- 怨毒影魔
        [185680] = {0, 0, 1},   -- 维型圣物
    }, 
    ["DctColorAura"] = {
        [343502] = {0, 0, 1},   --鼓舞光环
    }
}




