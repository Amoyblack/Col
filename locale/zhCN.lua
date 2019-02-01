
local _, ns = ...

if (GetLocale() ~= "zhCN") then return end

ns.L = {
	MenuBasis = "基础",
	MenuWhiteList = "白名单",
	TitleBasis = "RsPlates姓名板 - 基础设置",
	TitleWhiteList = "编辑白名单",
	Version = "版本 - ",

    Title1 = "风格",
    Title2 = "CVars",
    Title3 = "血量",
    Title4 = "血条染色",
    Title5 = "姓名",
    Title6 = "光环",
    Title7 = "地下城助手",
    Title8 = "其他",

    OriBarTexture = "源生材质",
    OriBarTextureTT = "启用源生的血条材质   |cff66CCFF重载生效|r",

    OriCastBar = "源生施法条",
    OriCastBarTT = "启用源生施法条样式   |cff66CCFF重载生效|r",

    OriEliteIcon = "源生精英图标",
    OriEliteIconTT = "启用源生精英,银英生物图标   |cff66CCFF重载生效|r",

    BgCol = "渲染血条背景色",
    BgColTT = "用血条自身的颜色渲染背景 (空血的部分), 而非黑色",

    Omen3text = "仇恨染色 :",
    Omen3 = "开启仇恨染色",
    Omen3TT = "根据单位与你的仇恨对血条进行染色：\n\n|cff1AB3E9蓝色|r：低仇恨，安全\n|cff661AE9紫色|r：高仇恨，即将OT\n|cffE91AE9红色|r：极高仇恨，已OT(获得仇恨)",

    Health = "血量 : ",
    HealthValue = "数值",
    HealthPercentage = "百分比",
    HealthBothShow = "数值/百分比",
    HealthNone = "不显示",

    CvarHelp = "CVar可以理解为存在暴雪服务器上的一些设置\n\n这意味着即使你禁用该插件，如下CVar设置仍会继续生效",

    SelectScale = "选中缩放",
    SelectScale0 = "不放大",
    SelectScale1 = "放大",
    SelectScaleTT = "选中单位的放大倍数",

    Alpha = "透明度",
    Alpha0 = "透明",
    Alpha1 = "不透明",
    AlphaTT = "10码外非当前选中目标姓名板的透明度",

    Distance = "显示距离",
    Distance0 = "近",
    Distance1 = "远",
    DistanceTT = "显示多少码数内的姓名板",

    GlobalScale = "全局缩放",
    GlobalScale0 = "小",
    GlobalScale1 = "大",
    GlobalScaleTT = "姓名板大小全局缩放",

    OverlapV = "垂直间距",
    OverlapV0 = "近",
    OverlapV1 = "远",
    OverlapVTT = "多个血条之间的垂直间距",

    OverlapH = "水平间距",
    OverlapH0 = "近",
    OverlapH1 = "远",
    OverlapHTT = "多个血条之间的水平间距",

    SlayLine = "斩杀线(%)",
    SlayLine0 = "关",
    SlayLine1 = "高血限",
    SlayLineTT = "设置斩杀线, 0 关闭斩杀染色",

    SlayColtext = "斩杀染色 :",
    SlayColSelect = "颜色: ",
    SlayCol = "|cFFFFD700 斩杀颜色(点击选择)： |r",

    OriName = "源生姓名样式",
    OriNameTT = "姓名颜色与字体大小均采用暴雪源生样式",

    WhiteName = "全局白色姓名",
    WhiteNameTT = "当血条颜色增多后, 推荐使用白色显示全局姓名以保持界面统一与清爽 (开启源生样式时此项不生效)",

    NameSize = "字体大小",
    NameSize0 = "小",
    NameSize1 = "大",
    NameSizeTT = "血条名字的字体大小 (开启源生样式时此项不生效)",

    AuraText1 = "需要显示的光环 :",
    AuraHelpBtn1 = "白名单配置的光环也会显示在个人资源条上\n\n善加利用可以监视 技能Buff/物品之类的 触发\n\n如法师的冰刺层数；嗜血持续时间；饰品触发等",

    AuraDeault = "系统默认",
    AuraDeaultTT = "暴雪默认显示的一些光环",

    AuraWL = "白名单",
    AuraWLTT = "手动配置在白名单中的光环",

    AuraOnlyMe = "只检测我释放的",
    AuraOnlyMeTT = "只检测来源于我和我的宠物的光环",

    AuraText2 = "光环样式 :",

    AuraHeight = "光环高度",
    AuraHeight0 = "低",
    AuraHeight1 = "高",
    AuraHeightTT = "光环图标相对于血条的高度",

    AuraNum = "光环数量",
    AuraNum0 = "不显示",
    AuraNum1 = "多",
    AuraNumTT = "最大光环显示数量",

    OriAura = "源生光环样式",
    OriAuraTT = "使用源生光环样式，取消勾选以正方形效果显示  |cff66CCFF重载生效|r",

    AuraSize = "光环大小",
    AuraSize0 = "小",
    AuraSize1 = "大",
    AuraSizeTT = "光环图标缩放 (不会改变源生样式的光环图标大小)",

    Counter = "显示计时器",
    CounterTT = "显示光环剩余时间计时器",

    CounterSize = "计时器大小",
    CounterSize0 = "小",
    CounterSize1 = "大",
    CounterSizeTT = "计时器数字缩放",

    AuraInfo = "白名单不仅作用于单位血条上的光环显示，同样作用于个人资源条\n\n光环指来自技能, 饰品, 艾泽里特特质，场景等产生的buff/debuff",
    AuraHelpBtn2 = "填写一个光环ID \n\n使用添加按钮将其加入右侧，移除按钮将其移除\n\n白名单目前支持最多20个光环",
    AuraID = "|cFFFFD700 光环ID |r",
    AuraIDTT = "光环ID:",
    AddBtn = "添加-->",
    RemoveBtn = "移除<--",

    Exp = "易爆球助手",
    ExpTT = "场上有易爆球时会自动隐藏其他所有单位的血条,直到场上没有易爆球为止",
    ExpHelpBtn = "稍高cpu占用,不用时建议关闭",

    CastHeight = "施法条宽度",
    CastHeight0 = "窄" ,
    CastHeight1 = "宽",
    CastHeightTT = "开启源生施法条时该项不生效",

    SelectAlpha = "透明度",
    SelectAlpha0 = "透明" ,
    SelectAlpha1 = "不透明",
    SelectAlphaTT = "非当前目标的血条透明度",

    UpdateInfo = "检测到你已更新版本，所有设置已还原为预设值",
    UpdateVersion = "当前版本",
}
