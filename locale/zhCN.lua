
local _, rs = ...



rs.V.zhcn = {
    ReloadUI = "重载界面",

	MenuBasis = "基础",
	MenuWhiteList = "白名单",
	Version = "版本 - ",

    Title1 = "风格",
    Title2 = "CVars",
    Title4 = "仇恨与斩杀",
    Title5 = "姓名",
    Title6 = "光环",
    Title7 = "地下城助手",
    Title8 = "其它",
    Title10 = "插件配置",

    BarTexture = "血条材质",
    BarTextureTT = "若需要自定义材质，将你的材质改名为UI-TargetingFrame-BarFill后放置于目录 [~/_retail_/Interface/TargetingFrame/你的材质], 然后选择源生即可",
    BarTextureSource = "源生",

    NarrowCastBar = "窄施法条",
    NarrowCastBarTT = "使用窄施法条样式而非源生样式（建议搭配扁平材质获得更好的显示效果)   |cff66CCFF重载生效|r",

    EliteIcon = "精英图标",
    EliteIconTT = "显示精英图标",

    BgCol = "渲染血条背景色",
    BgColTT = "用血条自身的颜色渲染背景 (空血的部分), 而非黑色。 |cff66CCFF关闭时需要重载界面生效|r",

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

    nameplateOtherTopInset = "最小顶部间距",
    nameplateOtherTopInsetTT = "姓名板和屏幕顶部的最小间距",

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

    SelfAuraHeight = "个人资源条光环高度",
    SelfAuraHeightTT = "光环图标相对于个人资源条的高度",

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
    CastHeightTT = "只对窄施法条生效",

    UnSelectAlpha = "非当前目标透明度",
    UnSelectAlphaTT = "非当前目标的血条框架透明度",

    CenterDetail = "血量居中",
    CenterDetailTT = "居中显示血量   |cff66CCFF重载生效|r",

    WesternDetail = "西方单位",
    WesternDetailTT = "使用k,m血量单位",

    TargetGroup = "目标指示器",

    MouseoverGlow = "鼠标指向高亮",
    MouseoverGlowTT = "高亮鼠标指向的单位(无需选中)",

    TargetColorEnable = "启用目标染色",
    TargetColorEnableTT = "对当前目标血条染色",

    TargetColor = "目标颜色",

    Arrow = "目标箭头",
    ArrowTT = "在选中单位的血条右侧显示一个箭头",

    CastingTitle = "施法指示器",
    CastTimer = "施法时间",
    CastTimerTT = "显示单位的施法时间",

    CastTarget = "施法目标",
    CastTargetTT = "显示单位的施法目标",

    CastInterrupteFrom = "打断来源",
    CastInterrupteFromTT = "当单位法术被打断时，在其施法条上显示打断者的名字",

    CastInterrupteIndicatorEnable = "打断指示器",
    CastInterrupteIndicatorEnableTT = "当敌方单位施放可打断法术时，若你拥有任何在下列监控列表中的技能且处于可用状态时，便会在该施法单位的姓名板上亮起一个绿色的打断指示器",

    InterrupteSpellInput = "向打断指示器中添加监控技能，输入技能ID (SpellID)添加",
    InterrupteSpellInputTT = "输入技能ID (SpellID)添加，点击技能图标移除",

    InterrupteSpellIDInputError = "|cffFFD700---RSPlates:|r 请输入正确的法术ID",
    InterrupteSpellIDAdded = "|cffFFD700---RSPlates:|r 法术成功添加 ",
    InterrupteSpellIDRemoved = "|cffFFD700---RSPlates:|r 法术成功删除 ",
    
    StolenBuff = "显示可驱散/偷取BUFF",
    StolenBuffTT = "在单位血条右侧高亮显示可偷取或驱散的BUFF",

    QuestIcon = "任务标记",
    QuestIconTT = "在任务单位血条上显示标记图标",

    LockPlayerColor = "锁定玩家颜色",
    LockPlayerColorTT = "不对玩家及玩家控制的单位血条染色",

    ProfileByCharactor = "按角色保存独立配置",
    ProfileByCharactorTT = "按角色保存独立配置，而非战网账号下共用配置",
    ProfileByCharactorCheckTip = "修改此选项时需要重载界面，确定修改并现在重载界面吗",

    UpdateForce = "|cffFFD700---RSPlates: 已检测到版本更新,该版本需要重置设置,现已将设置初始化|r",
    UpdateInfo = "|cffFFD700---RSPlates: 已检测到版本更新|r",
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




    Title9 = "名字模式",
    Title9TT = "使用名字替代血条显示",

    EnableNamemode = "启用",
    EnableNamemodeTT = "对选中的单位 使用名字替代血条显示 (由于暴雪的限制，友方类型单位在副本中不生效)",

    NamemodeGroupTitle = "单位类型",

    FriendlyPlayer = "友方玩家",

    FriendlyNpc = "友方NPC",
    FriendlyNpcTT = "可以同时打开 CVAR选项里 <始终显示姓名板> 和 <显示友方NPC姓名板> 使周围的NPC的名字醒目显示",

    NameModeNameType = "字体描边",
    NameModeNameTypeNIL = "不描边",
    NameModeNameTypeOUTLINE = "细边",
    NameModeNameTypeTHICKOUTLINE = "粗边",

    NameModeImitateOverlap = "模拟友方姓名板重叠",
    NameModeImitateOverlapTT = "让友方单位的名字始终紧贴着单位头顶，而不会因开启姓名板堆叠导致多个单位名字之间的间隔过大或视角移动时发生的跳跃现象。(这是通过改变友方姓名板大小与可点击区域大小实现的，若你需要看友方单位的血条而非名字时请不要开启）。 |cff66CCFF关闭时需要重载界面生效|r",

    NameModeHeightOffset = "高度偏移",

    GetSpellDesFailInfo = "该技能没有描述  或  服务器延迟导致插件未接收到，如是后者重新打开设置界面即可正常显示",

    ShowAllNP = "始终显示姓名板",
    ShowAllNPTT = "关闭时只在战斗中显示姓名板(或 在名字模式下的名字)，开启后会始终显示。  与暴雪界面设置里的 <显示所有姓名板> 是同一个选项",

    ShowNpcNP = "显示友方NPC姓名板",
    ShowNpcNPTT = "显示友方NPC的姓名板（或 名字模式下的名字），需开启 友方玩家姓名板，初始快捷键 Shift + V",

    NameModeNameSize = "名字大小",

    nameplateOccludedAlphaMult = "被遮挡单位透明度",

    WhenselfShow = "何时显示个人资源条",
    NameplatePersonalShowAlways = "总是显示",
    NameplatePersonalShowInCombat = "战斗中显示",
    NameplatePersonalShowWithTarget = "有目标时显示",
    NameplatePersonalHideDelaySeconds = "渐隐时间（秒）",

    CVarExtraLink = "|cffFFD700更多完整的CVar文档手册可以在这里查阅:  https://wowpedia.fandom.com/wiki/Console_variables/Complete_list |r",
}
