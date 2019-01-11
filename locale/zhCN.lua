
local _, ns = ...

if (GetLocale() ~= "zhCN") then return end

ns.L = {
	MenuBasis = "基础",
	MenuWhiteList = "白名单",
	TitleBasis = "RsPlates姓名板 - 基础设置",
	TitleWhiteList = "编辑白名单",
	Version = "版本 - ",

    OriBarTexture = "源生材质|cffFFC0CB(重载生效)|r",
    OriBarTextureTT = "使用源生的血条材质，取消勾选则会使用一组扁平化材质",

    OriCastBar = "源生施法条|cffFFC0CB(重载生效)|r",
    OriCastBarTT = "开启源生施法条样式",

    OriEliteIcon = "源生精英图标|cffFFC0CB(重载生效)|r",
    OriEliteIconTT = "开启源生精英,银英生物图标",

    Omen3 = "开启仇恨染色",
    Omen3TT = "根据单位与你的仇恨对血条进行染色：\n\n|cff1AB3E9蓝色|r：低仇恨，安全\n|cff661AE9紫色|r：高仇恨，即将OT\n|cffE91AE9红色|r：极高仇恨，已OT(获得仇恨)",

    Health = "血量 : ",
    HealthValue = "数值",
    HealthPercentage = "百分比",
    HealthBothShow = "数值/百分比",
    HealthNone = "不显示",

    SelectScale = "选中缩放",
    SelectScale0 = "不放大",
    SelectScale1 = "放大",
    SelectScaleTT = "选中单位的血条放大倍数",

    Alpha = "透明度",
    Alpha0 = "透明",
    Alpha1 = "不透明",
    AlphaTT = "10码外非当前选中目标血条的透明度",

    Distance = "血条距离",
    Distance0 = "近",
    Distance1 = "远",
    DistanceTT = "显示多少码数内的单位血条",

    GlobalScale = "全局缩放",
    GlobalScale0 = "小",
    GlobalScale1 = "大",
    GlobalScaleTT = "姓名板大小全局缩放",

    SlayLine = "斩杀线(%)",
    SlayLine0 = "关",
    SlayLine1 = "高血限",
    SlayLineTT = "设置斩杀线, 0 关闭斩杀染色",

    SlayCol = "|cFFFFD700 斩杀颜色(点击选择)： |r",

    AuraText1 = "|cFFFFD700 选择需要显示的光环 (buff/debuff)： |r",
    AuraHelpBtn1 = "系统默认指不开插件也会显示的光环 \n\n白名单指玩家单独配置的光环 \n\n各选项并不互斥，根据实际需要勾选\n\n注:白名单同样作用于个人资源条\n这意味着可以通过白名单来配置技能\n监视，一定程度上可替代Tmw/Wa等",

    AuraDeault = "系统默认",
    AuraDeaultTT = "游戏默认的光环显示策略",

    AuraWL = "白名单",
    AuraWLTT = "玩家手动配置的光环显示策略",

    AuraOnlyMe = "只检测我释放的",
    AuraOnlyMeTT = "只检测来源于我和我的宠物的光环",

    AuraText2 = "|cFFFFD700 设置光环显示的样式： |r",

    AuraHeight = "光环高度",
    AuraHeight0 = "低",
    AuraHeight1 = "高",
    AuraHeightTT = "光环图标相对于血条的高度",

    AuraNum = "光环数量",
    AuraNum0 = "不显示",
    AuraNum1 = "多",
    AuraNumTT = "最大光环显示数量",

    OriAura = "默认光环样式",
    OriAuraTT = "使用源生光环样式，取消勾选以正方形效果显示光环",

    AuraSize = "光环大小",
    AuraSize0 = "小",
    AuraSize1 = "大",
    AuraSizeTT = "光环图标缩放",

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

    UpdateInfo = "检测到你已更新版本，所有设置已还原为预设值",
    UpdateVersion = "当前版本",
}
