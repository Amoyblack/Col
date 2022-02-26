
local _, rs = ...



rs.V.zhtw = {
    ReloadUI = "重載界面",

	MenuBasis = "選項",
	MenuWhiteList = "白名單",
	Version = "版本 - ",

    Title1 = "風格",
    Title2 = "CVars",
    Title4 = "血量條染色",
    Title5 = "字型",
    Title6 = "光環",
    Title7 = "地城助手",
    Title8 = "其他",

    FlatBarTexture = "扁平化材質",
    FlatBarTextureTT = "使用扁平化材質而非源生材質，|cff66CCFF重載介面後生效|r。",

    NarrowCastBar = "窄施法條",
    NarrowCastBarTT = "使用窄施法條樣式而非源生樣式，（建議搭配扁平材質獲得更好的顯示效果)|cff66CCFF重載介面後生效|r。",

    EliteIcon = "精英圖標",
    EliteIconTT = "顯示精英圖標",

    BgCol = "渲染血量條底色",
    BgColTT = "渲染血量條本身的顏色作為背景（空血的部分）的底色，而非純黑色。",

    Omen3 = "開啟威脅值染色",
    Omen3TT = "根據單位與你的仇恨對血量條進行染色",

    dpsLowthreat = "DPS低威脅",
    dpsGainthreat = "DPS即將獲得威脅(即將ot)",
    Tankstablethreat = "T威脅穩定",
    Tanklosethreat = "T即將丟失威脅",

    Health = "血量",
    HealthValue = "數值",
    HealthPercentage = "百分比",
    HealthBothShow = "數值／百分比",
    HealthNone = "不顯示",

    CvarEnable = "啟用",
    CvarEnableTT = "CVar可以理解為存在暴雪服務器上的一些設置\n\nRSPlates可以讓你方便的修改它們中的一些\n\n但這同時也意味著即使你禁用或刪除該插件，CVar設置仍會繼續生效",

    SelectScale = "目標縮放",
    SelectScaleTT = "當前目標的放大倍率。",


    Distance = "顯示距離",
    DistanceTT = "顯示多少碼以內的名條。",

    GlobalScale = "全局縮放",
    GlobalScaleTT = "名條的全局縮放大小。",

    OverlapV = "垂直間距",
    OverlapVTT = "多個名條之間的垂直間距。",

    OverlapH = "水平間距",
    OverlapHTT = "多個名條之間的水平間距。",

    SlayLine = "斬殺百分比",

    SlayColtext = "開啟斬殺染色",
    SlayColSelect = "斬殺顏色",


    WhiteName = "全局白色名字",
    WhiteNameTT = "推薦將全局名字顯示為白色，以便在顯示的名條增多後，保持界面的統一與清爽 ，|cff66CCFF關閉時需要重載介面後生效|r。",

    ChangeNameSizeEnable = "調整名字大小",
    ChangeNameSizeEnableTT = "關閉時需要重載界面生效",

    NameSize = "名字大小",
    NameSizeTT = "關閉時需要重載界面生效",

    AuraText1 = "需要顯示的光環",

    AuraDeault = "系統預設",
    AuraDeaultTT = "暴雪預設的光環白名單。",

    AuraWL = "自訂白名單",
    AuraWLTT = "白名單中配置的|cff00FF7F<Debuff>|r會顯示在玩家之外的姓名版上，|cff00FF7F<Buff>|r會顯示在玩家個人資源條上，善加利用可以監控自己的法術/物品觸發,增益覆蓋等",

    AuraOnlyMe = "只檢測我施放的",
    AuraOnlyMeTT = "只檢測來源於我和我的寵物的光環。",

    AuraText2 = "光環樣式",

    AuraHeight = "框體間距",
    AuraHeightTT = "光環圖示的框體與血量條的距離。",

    AuraNum = "光環顯示數量",
    AuraNumTT = "0：不顯示",

    SquareAura = "正方形光環圖標",


    AuraSize = "圖示大小",
    AuraSizeTT = "光環圖示縮放（開啟暴雪光環樣式時，此項不生效）。",

    Counter = "顯示計時器",
    CounterTT = "顯示光環剩餘時間計時器，需要打開遊戲內置的顯示冷卻時間 (esc - 界面 - 動作條 - 顯示冷卻時間)，當開啟其它CD顯示插件如OmniCC時可關閉該選項",

    CounterSize = "計時器字型大小",


    Exp = "火爆詞綴助手",
    ExpTT = "場上有炸藥小球時，自動隱藏其他所有單位的名條，直到場上沒有球為止",

    CastHeight = "施法條寬度",
    CastHeightTT = "使用暴雪施法條樣式時，此項不生效。",

    UnSelectAlpha = "透明度",
    UnSelectAlphaTT = "非當前目標的名條透明度",

    CenterDetail = "血量文字置中",
    CenterDetailTT = "置中顯示血量文字，|cff66CCFF重載介面生效|r。",

    WesternDetail = "西方單位",
    WesternDetailTT = "使用k,m血量單位",

    Arrow = "目標箭頭",
    ArrowTT = "在目標的名條右側顯示一個箭頭。",

    StolenBuff = "額外顯示可驅散/偷取BUFF",
    StolenBuffTT = "在單位血條右側高亮顯示可偷取或驅散的BUFF",

    QuestIcon = "任務標記",
    QuestIconTT = "在任務單位血條上顯示標記圖標",

    UpdateForce = "|cffFFD700---RSPlates: 已檢測到版本更新,該版本需要重置設置,現已將設置初始化|r",
    UpdateInfo = "|cffFFD700---RSPlates: 已檢測到版本更新|r",
    UpdateVersion = "當前版本:  ",

    WhiteListInput = "輸入光環ID",
    WhiteListInputTT = "輸入光環ID添加進白名單，點擊圖標移除出白名單",
    WhiteListInputError = "|cffFFD700---RSPlates:|r 請輸入正確的光環ID",
    WhiteListAdd = "|cffFFD700---RSPlates:|r 白名單成功添加 ",
    WhiteListRemove = "|cffFFD700---RSPlates:|r 白名单成功刪除 ",

    BlizzardPanelInfo = "|cffFFD700/rs|r 打開設置",
    BlizzardPanelReportInfo = "問題/Bug反饋: https://www.curseforge.com/wow/addons/rsplates",
    BlizzardPanelSettingBtn = "設置",



    BlizzardPanelLargeInfo = "RSPlates基於大姓名版風格製作，推薦開啟 '大姓名板' 選項",

    needReload = "|cff66CCFF >> 重載介面後生效<< |r",

    NpcCOlorTitle = "|cffFFD700- 對指定NPC血條染色|r",
    NpcInput = "添加NPC",
    NpcInputTT = "輸入NPC ID添加, 點擊NPC移除",
    NpcIDInputError = "|cffFFD700---RSPlates:|r 請輸入正確的NPC ID",
    NpcIDAdded = "|cffFFD700---RSPlates:|r NPC 成功添加 ",
    NpcIDDeled = "|cffFFD700---RSPlates:|r NPC 成功刪除 ",
    NpcIDColorSelectTT = "選擇該NPC的血條顏色",

    NpcAuraTitle = "|cffFFD700- 對攜帶指定光環(Buff 或 Debuff)的NPC血條染色|r",
    NpcAuraInput = "添加光環",
    NpcAuraInputTT = "輸入光環 ID添加, 點擊光環圖標移除",
    NpcAuraInputError = "|cffFFD700---RSPlates:|r 請輸入正確的光環ID",
    NpcAuraAdded = "|cffFFD700---RSPlates:|r 光環成功添加 ",
    NpcAuraDeled = "|cffFFD700---RSPlates:|r 光環成功刪除 ",
    NpcAuraColorSelectTT = "選擇攜帶該光環的NPC血條顏色",

    NpcbarColor = "血條顏色",
    RemoveCheckBoxTT = "|cff00FF7F--- 點擊移除 ---|r",

    MarginCol1 = "\n由於新版本RSP對性能和結構做了重構優化，需要手動刪除一次舊版本插件目錄",
    MarginCol2 = "\n已檢測到當前存在舊版本插件目錄",
    MarginCol3 = "\n位置於 .../_retail_/Interface/AddOns/Col，刪除Col文件夾即可",
    MarginCol4 = "\n刪除舊版本插件目錄後此提示將自動關閉, 新舊共存會引發衝突與bug",

    MiniMapLeftBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:3:512:720:12:66:311:422|t : 打開設置界面",
    MiniMapRightBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t : Bug反饋",

    MiniMapEnable = "顯示小地圖按鈕",
    MiniMapEnableTT = "在使用MinimapButtonBag類地圖按鈕整合插件時可能需要重載才會生效",


    Title9 = "名字模式",
    Title9TT = "使用名字替代血條顯示",

    EnableNamemode = "啟用",
    EnableNamemodeTT = "對選中的單位 使用名字替代血條顯示 (由於暴雪的限制，友方類型單位在副本中不生效)",

    NamemodeGroupTitle = "單位類型",

    FriendlyPlayer = "友方玩家",

    FriendlyNpc = "友方NPC",
    FriendlyNpcTT = "可以同時打開 CVAR選項裡 <始終顯示姓名板> 和 <顯示友方NPC姓名板> 使周圍的NPC的名字醒目顯示",

    NameModeNameType = "字體描邊",
    NameModeNameTypeNIL = "不描邊",
    NameModeNameTypeOUTLINE = "細邊",
    NameModeNameTypeTHICKOUTLINE = "粗邊",

    NameModeHeightOffset = "高度偏移",

    GetSpellDesFailInfo = "該技能沒有描述  或  服務器延遲導致插件未接收到，如是後者重新打開設置界面即可正常顯示",

    ShowAllNP = "總是顯示名稱",
    ShowAllNPTT = "關閉時只在戰鬥中顯示姓名板(或 在名字模式下的名字)，開啟後會始終顯示。與暴雪界面設置裡的 <總是顯示名稱> 是同一個選項",

    ShowNpcNP = "顯示友方NPC姓名板",
    ShowNpcNPTT = "顯示友方NPC的姓名板（或 名字模式下的名字），需開啟 友方玩家姓名板，初始快捷鍵 Shift + V",

    NameModeNameSize = "名字大小",

    nameplateOccludedAlphaMult = "被遮擋單位透明度",

    WhenselfShow = "何時顯示個人資源條",
    NameplatePersonalShowAlways = "總是顯示",
    NameplatePersonalShowInCombat = "戰鬥中顯示",
    NameplatePersonalShowWithTarget = "有目標時顯示",

    CVarExtraLink = "|cffFFD700更多完整的CVar文檔手冊可以在這裡查閱:  https://wowpedia.fandom.com/wiki/Console_variables/Complete_list |r",
}