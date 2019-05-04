
local _, ns = ...

dctLanguageDefault = {
    MenuBasis = "General",
    MenuWhiteList = "WhiteList",
    TitleBasis = "RsPlates Nameplate - General Options",
    TitleWhiteList = "WhiteList Editor",
    Version = "Version - ",

    Title1 = "Style",
    Title2 = "CVars",
    Title3 = "Health Text",
    Title4 = "Colors",
    Title5 = "Name",
    Title6 = "Auras",
    Title7 = "Dungeon Helper",
    Title8 = "Others",

    OriBarTexture = "Source StatusBar Texture",
    OriBarTextureTT = "Use Blizzard's Default StatusBar Texture.  |cff66CCFFNeed /reload|r",

    OriCastBar = "Source CastBar",
    OriCastBarTT = "Use Blizzard's Default Castbar Style.   |cff66CCFFNeed /reload|r",

    OriEliteIcon = "Source Elite NPC Icon",
    OriEliteIconTT = "Use Blizzard's Default Icon for Elite NPC.   |cff66CCFFNeed /reload|r",

    BgCol = "HealthBar Background Color",
    BgColTT = "Draw health bar background (loss health part) as a multiplier basic on health bar color, instead black background.",

    Omen3text = "Threat Color",
    Omen3 = "Enable Threat Color",
    Omen3TT = "Show threat Status as different color.\n\n|cff1AB3E9Blue|r: low threat, safe. \n|cff661AE9Purple|r: high threat, will OT soon. \n|cffE91AE9Red|r: high threat, gain threat/OT already.",

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

    SlayColtext = "Execute Color:",
    SlayColSelect = "Color: ",
    SlayCol = "|cFFFFD700 Click to choose: |r",

    OriName = "Source Name Style",
    OriNameTT = "Use Blizzard's source Name color and font size style.",

    WhiteName = "White Colored Name",
    WhiteNameTT = "Colored all nameplate's name as white, it will make nameplates neat, much better to see when many nameplates on the screen. (Won't enable when you're using Source Name Style)",

    NameSize = "Name Font Size",
    NameSize0 = "small",
    NameSize1 = "large",
    NameSizeTT = "Name font size. (Won't enable when you're using Source Name Style)",

    AuraText1 = "Auras need to show:",
    AuraHelpBtn1 = "Aura whitelist will also be displayed on Personal Resource Bar. \n\nCan monitor skill/item buff etc. if you wnat. \n\nSuch as Mage's icicles stored,Bloodlust duration and Trinket trigger.",

    AuraDeault = "Default list",
    AuraDeaultTT = "Default aura whitelist by Blizzard.",

    AuraWL = "WhiteList",
    AuraWLTT = "add spell by edit Whitelist.",

    AuraOnlyMe = "Self Only",
    AuraOnlyMeTT = "Show only auras cast by self or pets.",

    AuraText2 = "Auras Style: ",

    AuraHeight = "Aura space",
    AuraHeight0 = "tight",
    AuraHeight1 = "relax",
    AuraHeightTT = "The space between Health bar and aura frame",

    AuraNum = "Aura Number",
    AuraNum0 = "Hide",
    AuraNum1 = "max",
    AuraNumTT = "how many aura display.",

    OriAura = "Source Icon style",
    OriAuraTT = "Use rectangle icon style by Blizzard, instead a customizable square icon style.   |cff66CCFFNeed /reload|r",

    AuraSize = "Aura Size",
    AuraSize0 = "smaller",
    AuraSize1 = "bigger",
    AuraSizeTT = "Aura icons size (Won't enable when you're using Source Icon style)",

    Counter = "Enable Timer",
    CounterTT = "Show aura timer",

    CounterSize = "Timer Text Size",
    CounterSize0 = "small",
    CounterSize1 = "big",
    CounterSizeTT = "Aura timer counter text size",

    AuraInfo = "Whitelist dosn't only affects the auras on Nameplates, but also Personal Resourse Bar.",
    AuraHelpBtn2 = "Add an aura ID \n\n Remeber click Add button after you key-in an ID.\n\nCurrently supports up to 20 auras.",
    AuraID = "|cFFFFD700 Aura ID |r",
    AuraIDTT = "Aura ID:",
    AddBtn = "Add--> ",
    RemoveBtn = " Remove<--",

    Exp = "Explosive Helper",
    ExpTT = "When Explosives spawn, all of other nameplates will be hidden until there is no more Explosives alive.",
    ExpHelpBtn = "Suggest disable this option when you don't use it",

    CastHeight = "Castbar Width",
    CastHeight0 = "narrow" ,
    CastHeight1 = "wide",
    CastHeightTT = "Won't enable when you're using Source Castbar style",

    SelectAlpha = "Transparency",
    SelectAlpha0 = "transparency" ,
    SelectAlpha1 = "opaque",
    SelectAlphaTT = "Transparency of non-current target's Nameplate",

    CenterDetail = "Text in Center",
    CenterDetailTT = "Show health value in nameplate center.   |cff66CCFFNeed /reload|r",

    Arrow = "Selected Arrow",
    ArrowTT = "Display an arrow at nameplate right when you selected a unit",

    UpdateInfo = "Detected that you have updated to newest version, all settings have been reset to default values",
    UpdateVersion = "Current Version",
}

if (GetLocale() ~= "enUS") then return end

ns.L = dctLanguageDefault
