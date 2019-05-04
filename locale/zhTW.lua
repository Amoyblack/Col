
local _, ns = ...

if (GetLocale() ~= "zhTW") then return end

ns.L = {
	MenuBasis = "一般",
	MenuWhiteList = "白名單",
	TitleBasis = "RsPlates姓名板 - 一般設定",
	TitleWhiteList = "編輯白名單",
	Version = "版本 - ",

    Title1 = "風格",
    Title2 = "CVars",
    Title3 = "血量",
    Title4 = "血量條染色",
    Title5 = "字型",
    Title6 = "光環",
    Title7 = "地城助手",
    Title8 = "其他",

    OriBarTexture = "暴雪材質",
    OriBarTextureTT = "使用暴雪預設的血量條材質   |cff66CCFF重載介面方可生效|r",

    OriCastBar = "暴雪施法條樣式",
    OriCastBarTT = "啟用暴雪預設的施法條樣式   |cff66CCFF重載介面方可生效|r",

    OriEliteIcon = "暴雪精英圖示",
    OriEliteIconTT = "啟用暴雪預設的精英、稀有生物圖示   |cff66CCFF重載介面方可生效|r",

    BgCol = "渲染血量條背景色",
    BgColTT = "渲染血量條本身的顏色作為背景（空血的部分），而非黑色背景",

    Omen3text = "仇恨染色 :",
    Omen3 = "開啟仇恨染色",
    Omen3TT = "根據單位與你的仇恨對血量條進行染色：\n\n|cff1AB3E9藍色|r：低仇恨，安全\n|cff661AE9紫色|r：高仇恨，即將OT\n|cffE91AE9紅色|r：極高仇恨，已OT（獲得仇恨）",

    Health = "血量 : ",
    HealthValue = "數值",
    HealthPercentage = "百分比",
    HealthBothShow = "數值／百分比",
    HealthNone = "不顯示",

    CvarHelp = "CVar可以理解為儲存在暴雪伺服器上的一些設定\n\n這意味著即使你禁用本插件，如下CVar設定仍會繼續生效",

    SelectScale = "選中縮放",
    SelectScale0 = "不放大",
    SelectScale1 = "放大",
    SelectScaleTT = "放大倍率",

    Alpha = "透明度",
    Alpha0 = "透明",
    Alpha1 = "不透明",
    AlphaTT = "十碼外非當前目標的名條透明度",

    Distance = "顯示距離",
    Distance0 = "近",
    Distance1 = "遠",
    DistanceTT = "顯示多少碼以內的名條",

    GlobalScale = "全局縮放",
    GlobalScale0 = "小",
    GlobalScale1 = "大",
    GlobalScaleTT = "名條的全局縮放大小",

    OverlapV = "垂直間距",
    OverlapV0 = "近",
    OverlapV1 = "遠",
    OverlapVTT = "多個名條之間的垂直間距",

    OverlapH = "水平間距",
    OverlapH0 = "近",
    OverlapH1 = "遠",
    OverlapHTT = "多個名條之間的水平間距",

    SlayLine = "斬殺線（%）",
    SlayLine0 = "關",
    SlayLine1 = "高血限",
    SlayLineTT = "設置斬殺線，如設為0則關閉斬殺染色",

    SlayColtext = "斬殺染色 :",
    SlayColSelect = "顏色: ",
    SlayCol = "|cFFFFD700 斬殺顏色（點擊選擇）： |r",

    OriName = "暴雪名字樣式",
    OriNameTT = "名字的顏色與字型大小均採用暴雪原始樣式",

    WhiteName = "全局白色字",
    WhiteNameTT = "推薦將全局名字顯示為白色，以便在顯示的名條增多後，保持界面的統一與清爽（使用暴雪名字樣式時，此項不生效）",

    NameSize = "字型大小",
    NameSize0 = "小",
    NameSize1 = "大",
    NameSizeTT = "名條名字的字型大小（使用暴雪名字樣式時，此項不生效）",

    AuraText1 = "需要顯示的光環 :",
    AuraHelpBtn1 = "白名單列表的光環也會顯示在個人資源條上\n\n如善加利用可以監視的技能增益效果或物品觸發特效\n\n例如法師的冰刺層數、嗜血持續時間、飾品觸發等等",

    AuraDeault = "系統預設",
    AuraDeaultTT = "暴雪預設白名單所顯示的光環",

    AuraWL = "白名單",
    AuraWLTT = "手動添加光環至白名單",

    AuraOnlyMe = "只檢測我施放的",
    AuraOnlyMeTT = "只檢測來源於我和我的寵物的光環",

    AuraText2 = "光環樣式 :",

    AuraHeight = "光環高度",
    AuraHeight0 = "低",
    AuraHeight1 = "高",
    AuraHeightTT = "光環圖示相對於名條的高度",

    AuraNum = "光環數量",
    AuraNum0 = "不顯示",
    AuraNum1 = "多",
    AuraNumTT = "最大光環顯示數量",

    OriAura = "暴雪光環樣式",
    OriAuraTT = "使用暴雪的長方形光環樣式；若取消勾選，則以正方形效果顯示  |cff66CCFF重載介面方可生效|r",

    AuraSize = "光環大小",
    AuraSize0 = "小",
    AuraSize1 = "大",
    AuraSizeTT = "光環圖示縮放（開啟暴雪光環樣式時，此項不生效）",

    Counter = "顯示計時器",
    CounterTT = "顯示光環剩餘時間計時器",

    CounterSize = "計時器大小",
    CounterSize0 = "小",
    CounterSize1 = "大",
    CounterSizeTT = "計時器數字縮放",

    AuraInfo = "白名單不僅作用於單位名條上的光環顯示，同樣作用於個人資源條\n\n光環指來自技能、飾品、艾澤里特特質，場景等產生的增減益效果",
    AuraHelpBtn2 = "填寫一個光環ID \n\n輸入後按下添加按鈕，將其加入右側，按下移除按鈕則將其移除\n\n白名單目前可顯示最多20個光環",
    AuraID = "|cFFFFD700 光環ID |r",
    AuraIDTT = "光環ID:",
    AddBtn = "添加-->",
    RemoveBtn = "移除<--",

    Exp = "火爆詞綴助手",
    ExpTT = "場上有炸藥小球時會自動隱藏其他所有單位的名條，直到場上沒有球為止",
    ExpHelpBtn = "不使用時，建議關閉",

    CastHeight = "施法條寬度",
    CastHeight0 = "窄" ,
    CastHeight1 = "寬",
    CastHeightTT = "使用暴雪施法條樣式時，此項不生效",

    SelectAlpha = "透明度",
    SelectAlpha0 = "透明" ,
    SelectAlpha1 = "不透明",
    SelectAlphaTT = "非當前目標的名條透明度",

    CenterDetail = "血量置中",
    CenterDetailTT = "置中血量文字   |cff66CCFF重載介面生效|r",

    Arrow = "選中箭頭",
    ArrowTT = "在選中單位的名條右側顯示一個箭頭",

    UpdateInfo = "檢測到你已更新版本，所有設定已還原為預設值",
    UpdateVersion = "目前版本",
}
