
local _, rs = ...



rs.V.zhcn = {
    ReloadUI = "重载界面",

	MenuBasis = "基础",
	MenuWhiteList = "白名单",
	Version = "版本 - ",

    Title1 = "风格",
    Title2 = "CVars",
    Title4 = "血条染色",
    Title5 = "姓名",
    Title6 = "光环",
    Title7 = "地下城助手",
    Title8 = "其它",

    FlatBarTexture = "扁平材质",
    FlatBarTextureTT = "使用扁平化材质而非源生材质   |cff66CCFF重载生效|r",

    NarrowCastBar = "窄施法条",
    NarrowCastBarTT = "使用窄施法条样式而非源生样式（建议搭配扁平材质获得更好的显示效果)   |cff66CCFF重载生效|r",


    BgCol = "渲染血条背景色",
    BgColTT = "用血条自身的颜色渲染背景 (空血的部分), 而非黑色",

    Omen3 = "启用仇恨染色",
    Omen3TT = "根据单位与你的仇恨对血条进行染色",

    dpsLowthreat = "DPS低仇恨",
    dpsGainthreat = "DPS即将获得仇恨(马上ot)",
    Tankstablethreat = "T仇恨稳定",
    Tanklosethreat = "T即将丢失仇恨",

    Health = "血量",
    HealthValue = "数值",
    HealthPercentage = "百分比",
    HealthBothShow = "数值/百分比",
    HealthNone = "不显示",

    CvarEnable = "启用",
    CvarEnableTT = "CVar可以理解为存在暴雪服务器上的一些设置\n\nRSPlates可以让你方便的修改它们中的一些\n\n但这同时也意味着即使你禁用或删除该插件，CVar设置仍会继续生效",

    SelectScale = "选中缩放",
    SelectScaleTT = "选中单位的放大倍数",


    Distance = "显示距离",
    DistanceTT = "显示多少码数内的姓名板",

    GlobalScale = "全局缩放",
    GlobalScaleTT = "姓名板大小全局缩放",

    OverlapV = "垂直间距",
    OverlapVTT = "多个血条之间的垂直间距",

    OverlapH = "水平间距",
    OverlapHTT = "多个血条之间的水平间距",

    SlayLine = "斩杀线(%)",

    SlayColtext = "启用斩杀染色",
    SlayColSelect = "斩杀颜色",


    WhiteName = "全局白色姓名",
    WhiteNameTT = "当血条颜色增多后, 推荐使用白色显示全局姓名以保持界面整洁   |cff66CCFF关闭时需要重载界面生效|r",

    ChangeNameSizeEnable = "调整名字大小",
    ChangeNameSizeEnableTT = "关闭时需要重载界面生效",

    NameSize = "名字大小",
    NameSizeTT = "关闭时需要重载界面生效",

    AuraText1 = "需要显示的光环",

    AuraDeault = "系统默认",
    AuraDeaultTT = "暴雪默认显示的一些光环",

    AuraWL = "白名单",
    AuraWLTT = "白名单中配置的|cff00FF7F<Debuff>|r会显示在玩家之外的姓名版上，|cff00FF7F<Buff>|r会显示在玩家个人资源条上，善加利用可以监控自己的法术/物品触发,增益覆盖等",

    AuraOnlyMe = "只来源于我的",
    AuraOnlyMeTT = "只检测来源于我和我的宠物的光环",

    AuraText2 = "光环样式",

    AuraHeight = "光环高度",
    AuraHeightTT = "光环图标相对于血条的高度",

    AuraNum = "光环显示数量",
    AuraNumTT = "0: 不显示",

    SquareAura = "正方形光环图标",


    AuraSize = "光环大小",
    AuraSizeTT = "光环图标缩放 (不会改变源生样式的光环图标大小)",

    Counter = "显示计时器",
    CounterTT = "显示光环剩余时间计时器，需要打开游戏内置的显示冷却时间 (esc - 界面 - 动作条 - 显示冷却时间)，当开启其它CD显示插件如OmniCC时可关闭该选项",

    CounterSize = "计时器数字大小",


    Exp = "易爆球助手",
    ExpTT = "场上有易爆球时会自动隐藏其他所有单位的血条,直到场上没有易爆球为止",

    CastHeight = "施法条宽度",
    CastHeightTT = "开启源生施法条时该项不生效",

    UnSelectAlpha = "非当前目标透明度",
    UnSelectAlphaTT = "非当前目标的血条框架透明度",

    CenterDetail = "血量居中",
    CenterDetailTT = "居中显示血量   |cff66CCFF重载生效|r",

    WesternDetail = "西方单位",
    WesternDetailTT = "使用k,m血量单位",

    Arrow = "选中箭头",
    ArrowTT = "在选中单位的血条右侧显示一个箭头",

    StolenBuff = "显示可驱散/偷取BUFF",
    StolenBuffTT = "在单位血条右侧高亮显示可偷取或驱散的BUFF",

    QuestIcon = "任务标记",
    QuestIconTT = "在任务单位血条上显示标记图标",

    UpdateInfo = "检测到你已更新版本，所有设置已还原为预设值",
    UpdateVersion = "当前版本:  ",

    WhiteListInput = "输入光环ID",
    WhiteListInputTT = "输入光环ID添加进白名单，点击图标移除出白名单",
    WhiteListInputError = "|cffFFD700---RSPlates:|r 请输入正确的光环ID",
    WhiteListAdd = "|cffFFD700---RSPlates:|r 白名单成功添加 ",
    WhiteListRemove = "|cffFFD700---RSPlates:|r 白名单成功删除 ",

    BlizzardPanelInfo = "|cffFFD700/rs|r 打开设置",
    BlizzardPanelReportInfo = "问题/Bug反馈: https://www.curseforge.com/wow/addons/rsplates",
    BlizzardPanelSettingBtn = "设置",




    BlizzardPanelLargeInfo = "RSPlates基于大姓名版风格制作，推荐开启 '大姓名板' 选项",

    needReload = "|cff66CCFF >> 重载后生效<< |r",

    NpcCOlorTitle = "|cffFFD700- 对指定NPC血条染色|r",
    NpcInput = "添加NPC",
    NpcInputTT = "输入NPC ID添加, 点击NPC移除",
    NpcIDInputError = "|cffFFD700---RSPlates:|r 请输入正确的NPC ID",
    NpcIDAdded = "|cffFFD700---RSPlates:|r NPC 成功添加 ",
    NpcIDDeled = "|cffFFD700---RSPlates:|r NPC 成功删除 ",
    NpcIDColorSelectTT = "选择该NPC的血条颜色",

    NpcAuraTitle = "|cffFFD700- 对携带指定光环(Buff 或 Debuff)的NPC血条染色|r",
    NpcAuraInput = "添加光环",
    NpcAuraInputTT = "输入光环 ID添加, 点击光环图标移除",
    NpcAuraInputError = "|cffFFD700---RSPlates:|r 请输入正确的光环ID",
    NpcAuraAdded = "|cffFFD700---RSPlates:|r 光环成功添加 ",
    NpcAuraDeled = "|cffFFD700---RSPlates:|r 光环成功删除 ",
    NpcAuraColorSelectTT = "选择携带该光环的NPC血条颜色",

    NpcbarColor = "血条颜色",
    RemoveCheckBoxTT = "|cff00FF7F--- 点击移除 ---|r",

    MarginCol1 = "\n由于新版本RSP对性能和结构做了重构优化，需要手动删除一次旧版本插件目录",
    MarginCol2 = "\n已检测到当前存在旧版本插件目录",
    MarginCol3 = "\n位置于 .../_retail_/Interface/AddOns/Col，删除Col文件夹即可",
    MarginCol4 = "\n删除旧版本插件目录后此提示将自动关闭, 新旧共存会引发冲突与bug",

    MiniMapLeftBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:3:512:720:12:66:311:422|t : 打开设置界面",
    MiniMapRightBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t : Bug反馈",

    MiniMapEnable = "显示小地图按钮",
    MiniMapEnableTT = "在使用MinimapButtonBag等地图按钮整合插件时可能需要重载才会生效",

}
