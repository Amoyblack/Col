
local _, ns = ...

dctLanguageDefault = {
    MenuBasis = "General",
    MenuWhiteList = "WhiteList",
    TitleBasis = "RsPlates - General Options",
    TitleWhiteList = "WhiteList Spell Editor",
    Version = "Version - ",

    Title1 = "Style",
    Title2 = "CVars",
    Title3 = "Health Text",
    Title4 = "Colors",
    Title5 = "Name",
    Title6 = "Auras",
    Title7 = "Dungeon Helper",
    Title8 = "Others",

    OriBarTexture = "Source Bar Texture",
    OriBarTextureTT = "Use Default StatusBar Texture by Blizzard. |cff66CCFFNeed /reload.|r",

    OriCastBar = "Source CastBar",
    OriCastBarTT = "Use Default Castbar Style Blizzard. |cff66CCFFNeed /reload.|r",

    OriEliteIcon = "Source Elite NPC Icon",
    OriEliteIconTT = "Use Default Icon for Elite NPC by Blizzard. |cff66CCFFNeed /reload.|r",

    BgCol = "HealthBar Background Color",
    BgColTT = "Draw HealthBar background (health loss part) as a multiplier color which basic on HealthBar color, instead black background.",

    Omen3text = "Threat",
    Omen3 = "Enable Threat Color",
    Omen3TT = "Show threat Status as different color.\n\n|cff1AB3E9Blue|r: low threat, safe.\n|cff661AE9Purple|r: higher threat than tank but didn't aggro.\n|cffE91AE9Red|r: aggro.",

    Health = "Health Text",
    HealthValue = "Value",
    HealthPercentage = "Percent",
    HealthBothShow = "Value/Percent",
    HealthNone = "Hide",

    CvarHelp = "CVar can be understood as the presence of some settings on the Blizzard server. \n\nThis means that even you disable this addon, the following CVar settings will continue effect.",

    SelectScale = "Select Scale",
    SelectScale0 = "small",
    SelectScale1 = "big",
    SelectScaleTT = "Scale Selected Nameplate.",

    Alpha = "Fade out",
    Alpha0 = "Enable fade out",
    Alpha1 = "Disable fade out",
    AlphaTT = "Fade out Nameplates outside more then 10 yards.",

    Distance = "Display Range",
    Distance0 = "near",
    Distance1 = "far",
    DistanceTT = "How many yards far away to show Nameplates.",

    GlobalScale = "Global Scale",
    GlobalScale0 = "small",
    GlobalScale1 = "big",
    GlobalScaleTT = "The Global Scale for Nameplates",

    OverlapV = "Vertical Overlap",
    OverlapV0 = "tight",
    OverlapV1 = "relax",
    OverlapVTT = "Vertical overlap between multiple Nameplates",

    OverlapH = "Horizontal Overlap",
    OverlapH0 = "tight",
    OverlapH1 = "relax",
    OverlapHTT = "Horizontal overlap between multiple Nameplates",

    SlayLine = "Execute (%)",
    SlayLine0 = "Disable",
    SlayLine1 = "Max",
    SlayLineTT = "Set a Execute value, 0 means Disable",

    SlayColtext = "Execute",
    SlayColSelect = "Color: ",
    SlayCol = "|cFFFFD700 Click to choose: |r",

    OriName = "Source Name Style",
    OriNameTT = "Use source Name color and font size style by Blizzard. |cff66CCFFNeed /reload.|r",

    WhiteName = "White Colored Name",
    WhiteNameTT = "Colored all nameplate's name as white, it will make nameplates neat, much better to see when many nameplates on the screen. (Won't enable when you're using Source Name Style)",

    NameSize = "Name Font Size",
    NameSize0 = "small",
    NameSize1 = "large",
    NameSizeTT = "Name font size. (Won't enable when you're using Source Name Style)",

    AuraText1 = "Auras need to show:",
    AuraHelpBtn1 = "Aura whitelist will also be displayed on Personal Resource Bar. You can monitor skill/item buff etc if you need, such as Mage's icicles stored, Bloodlust duration, Trinket trigger or other else.",

    AuraDeault = "Default list",
    AuraDeaultTT = "Default aura whitelist by Blizzard.",

    AuraWL = "WhiteList",
    AuraWLTT = "Custom whitelist. Edit additional spell id in whitelist editor.",

    AuraOnlyMe = "Self Only",
    AuraOnlyMeTT = "Show only auras cast by self or pets.",

    AuraText2 = "Auras Style",

    AuraHeight = "Aura space",
    AuraHeight0 = "tight",
    AuraHeight1 = "relax",
    AuraHeightTT = "The space between Health bar and aura frame",

    AuraNum = "Aura Number",
    AuraNum0 = "Hide",
    AuraNum1 = "max",
    AuraNumTT = "How many aura display.",

    OriAura = "Source Icon style",
    OriAuraTT = "Use rectangle icon style by Blizzard, instead a custom square icon style. |cff66CCFFNeed /reload.|r",

    AuraSize = "Icon Size",
    AuraSize0 = "smaller",
    AuraSize1 = "bigger",
    AuraSizeTT = "Aura icons size (Won't enable when you're using Source Icon style).",

    Counter = "Enable Timer",
    CounterTT = "Show aura timer",

    CounterSize = "Timer Text Size",
    CounterSize0 = "small",
    CounterSize1 = "big",
    CounterSizeTT = "Aura timer text size",

    AuraInfo = "Whitelist won't only affects the auras on Nameplates, but also Personal Resourse Bar.",
    AuraHelpBtn2 = "Add Spell ID \n\nRemeber click Add button after you key-in.\n\nCurrently supports max to 20 auras.",
    AuraID = "|cFFFFD700Spell ID|r",
    AuraIDTT = "Spell ID:",
    AddBtn = "Add-->",
    RemoveBtn = "<--Remove",

    Exp = "Explosive Helper",
    ExpTT = "When Explosives spawn, all of other nameplates will be hidden until there is no more Explosives alive.",
    ExpHelpBtn = "Suggest disable this option when you don't use it.",

    CastHeight = "Castbar Width",
    CastHeight0 = "narrow" ,
    CastHeight1 = "wide",
    CastHeightTT = "Won't enable when you're using Source Castbar style.",

    UnSelectAlpha = "Transparency",
    UnSelectAlpha0 = "transparency" ,
    UnSelectAlpha1 = "opaque",
    UnSelectAlphaTT = "Transparency of non-current target's Nameplates.",

    CenterDetail = "Text in Center",
    CenterDetailTT = "Show health value in nameplate center. |cff66CCFFNeed /reload.|r",

    EastenDetail = "Easten Unit",
    EastenDetailTT = "K/M unit for 1000/100000 health value",

    Arrow = "Selected Arrow",
    ArrowTT = "Display an arrow at nameplate right on target unit.",

    StolenBuff = "Extra display canStealOrPurge BUFF",
    StolenBuffTT = "Highlight the buff that can be stolen or purged on the right side of the unit health bar",

    QuestIcon = "QuestMarker",
    QuestIconTT = "Show a mark on the top of the Quest Unit",

    UpdateInfo = "Have detected that you've updated to newest version, all settings have been reset to default values.",
    UpdateVersion = "Current Version",
}

if (GetLocale() ~= "enUS") then return end

ns.L = dctLanguageDefault
