
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
    SelectScale0 = "Disable scale",
    SelectScale1 = "Enable scale",
    SelectScaleTT = "Scale targeting Nameplate.",

    Alpha = "Fade out",
    Alpha0 = "Enable fade out",
    Alpha1 = "Disable fade out",
    AlphaTT = "Fade out Nameplates outside more then 10 yards.",

    Distance = "Display Range",
    Distance0 = "close",
    Distance1 = "far",
    DistanceTT = "How many yards to show Nameplates.",

    GlobalScale = "Global Scale",
    GlobalScale0 = "smaller",
    GlobalScale1 = "bigger",
    GlobalScaleTT = "The Global Scale of Nameplates",

    OverlapV = "Vertical Overlap",
    OverlapV0 = "close",
    OverlapV1 = "far",
    OverlapVTT = "Vertical overlap between multiple Nameplates",

    OverlapH = "Horizontal Overlap",
    OverlapH0 = "close",
    OverlapH1 = "far",
    OverlapHTT = "Horizontal overlap between multiple Nameplates",

    SlayLine = "Execute (%)",
    SlayLine0 = "close",
    SlayLine1 = "high Execute",
    SlayLineTT = "Set a Execute value, 0 means Disable",

    SlayColtext = "Execute Color:",
    SlayColSelect = "Color: ",
    SlayCol = "|cFFFFD700 Click choose: |r",

    OriName = "Source Name Style",
    OriNameTT = "Use Blizzard's source Name color and font size style.",

    WhiteName = "White Name",
    WhiteNameTT = "When the color of the bloodbar is increased, it is recommended to use white to display the global name to keep the interface neat and tidy. (does not take effect when the source name style is turned on.)",

    NameSize = "NameFont Size",
    NameSize0 = "small",
    NameSize1 = "large",
    NameSizeTT = "The name font size (does not take effect when the source name style is turned on.)",

    AuraText1 = "Auras need to show:",
    AuraHelpBtn1 = "The auras of the whitelist will also be displayed on the personal resource bar\n\nTake advantage of it that can monitor Skill Buffs/Items etc..\n\nSuch as the number of Mage's icicles stored ; Bloodlust duration; Trinket trigger, etc.",

    AuraDeault = "BlzDefault",
    AuraDeaultTT = "Auras that Blizzard default displaying",

    AuraWL = "WhiteList",
    AuraWLTT = "Auras setted by the WhiteList",

    AuraOnlyMe = "My Auras Only",
    AuraOnlyMeTT = "Show the auras from me and my pet only ",

    AuraText2 = "Auras Style: ",

    AuraHeight = "AuraHeight",
    AuraHeight0 = "low",
    AuraHeight1 = "high",
    AuraHeightTT = "The height between the bloodbar and the auras",

    AuraNum = "AuraNumber",
    AuraNum0 = "Don't Show",
    AuraNum1 = "many",
    AuraNumTT = "Max number of the auras can display",

    OriAura = "SourceAuraStyle",
    OriAuraTT = "Use Blizzard default auras's style rather than a customizable square icon style   |cff66CCFFtake affect after /reload|r",

    AuraSize = "AuraSize",
    AuraSize0 = "small",
    AuraSize1 = "big",
    AuraSizeTT = "Aura icons Zooming (Not change Blizzard default auras' style icon size)",

    Counter = "Turn on Timer",
    CounterTT = "Show auras's timer",

    CounterSize = "Timer Size",
    CounterSize0 = "small",
    CounterSize1 = "big",
    CounterSizeTT = "Zooming of the timer counter",

    AuraInfo = "Whitelist not only affects the auras on blood bars, but also personal resourse bar \n\nAuras means the debuff/buff from Skill, Item, Azerit, Scenes ..etc",
    AuraHelpBtn2 = "Input an aura ID \n\nAdd button can add it to Whitelist, Remove button can remove it from Whitelist\n\nCurrently supports up to 20 auras",
    AuraID = "|cFFFFD700 Aura ID |r",
    AuraIDTT = "Aura ID:",
    AddBtn = "Add-->",
    RemoveBtn = "Remove<--",

    Exp = "Explosive Helper",
    ExpTT = "When there are explosive balls on the field, the bloodbar of all other units will be automatically hidden until there is no explosive ball on the field.",
    ExpHelpBtn = "it's'recommended to close when you don't use it",

    CastHeight = "Castbar Width",
    CastHeight0 = "narrow" ,
    CastHeight1 = "wide",
    CastHeightTT = "This item does not take effect when the Source Castbar is turned on.",

    SelectAlpha = "Transparency",
    SelectAlpha0 = "transparency" ,
    SelectAlpha1 = "opaque",
    SelectAlphaTT = "Transparency of non-current target's Nameplate",

    CenterDetail = "Center Blood Value",
    CenterDetailTT = "Percentage/Value shows on the center of blood bars   |cff66CCFFtake effect after /reload|r",

    Arrow = "Selected Arrow",
    ArrowTT = "Display an arrow to the right of the blood bar of the selected unit",

    UpdateInfo = "Detected that you have updated the version, all settings have been reset to default values",
    UpdateVersion = "Current Version",
}

if (GetLocale() ~= "enUS") then return end

ns.L = dctLanguageDefault
