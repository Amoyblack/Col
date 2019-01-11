
local _, ns = ...

if (GetLocale() ~= "enUS") then return end

ns.L = {
    MenuBasis = "Basis",
    MenuWhiteList = "WhiteList",
    TitleBasis = "RsPlates Nameplate - Basis Options",
    TitleWhiteList = "Edit WhiteList",
    Version = "Version - ",

    OriBarTexture = "SourceBarTexture|cffFFC0CB(need /reload)|r",
    OriBarTextureTT = "Use BlizzardDefault Bloodbar Texture",

    OriCastBar = "SourceCastBar |cffFFC0CB(need /reload)|r",
    OriCastBarTT = "Use BlizzardDefault Castbar Style",

    OriEliteIcon = "SourceEliteNpcIcon |cffFFC0CB(need /reload)|r",
    OriEliteIconTT = "Use BlizzardDefault Icon for Elite Npc",

    Omen3 = "Turn on ThreatColor",
    Omen3TT = "Different threat will change the color of blood bars:\n\n|cff1AB3E9blue|r:low threat, safe \n|cff661AE9purple|r:high threat,OT soon\n|cffE91AE9red|r:extre high threat, already OT(gain threat)",

    Health = "Health : ",
    HealthValue = "Value",
    HealthPercentage = "Percentage",
    HealthBothShow = "Value/Percentage",
    HealthNone = "Hide",

    SelectScale = "SelectScale",
    SelectScale0 = "Not zooming",
    SelectScale1 = "big",
    SelectScaleTT = "Zooming of the selected blood bar",

    Alpha = "Transparent",
    Alpha0 = "Transparent",
    Alpha1 = "opaque",
    AlphaTT = "Transparent of the unselected blood bars outside the 10 yards range",

    Distance = "Display Range",
    Distance0 = "close",
    Distance1 = "far",
    DistanceTT = "The range(yards) that blood bars should show",

    GlobalScale = "GlobalScale",
    GlobalScale0 = "small",
    GlobalScale1 = "big",
    GlobalScaleTT = "The GlobalScale of the blood bars",

    SlayLine = "Slayline(%)",
    SlayLine0 = "close",
    SlayLine1 = "high slayline",
    SlayLineTT = "Set a slayline, 0 means close SlayColor",

    SlayCol = "|cFFFFD700 SlayColor(Click choose): |r",

    AuraText1 = "|cFFFFD700 The Auras (buff/debuff) Need To Show :  |r",
    AuraHelpBtn1 = "BlizzardDefault means the auras show even without this addon \n\nWhitelist means the auras you set in the WhiteList Page \n\nThe options are not mutually exclusive, select as needed\n\nbtw:Whitelists also affect personal resourse bar's auras\nIt means you can oversee auras by add it into WhiteList\nSometimes it can replace TMW/WA in the aspect of Auras Oversee",

    AuraDeault = "BlizzardDefault",
    AuraDeaultTT = "Auras that Blizzard default displaying",

    AuraWL = "WhiteList",
    AuraWLTT = "Auras setted by user through the WhiteList",

    AuraOnlyMe = "My Auras Only",
    AuraOnlyMeTT = "Show the auras from me and my pet only ",

    AuraText2 = "|cFFFFD700 Set Auras Style: |r",

    AuraHeight = "AuraHeight",
    AuraHeight0 = "low",
    AuraHeight1 = "high",
    AuraHeightTT = "The height between the bloodbar and the auras",

    AuraNum = "AuraNumber",
    AuraNum0 = "Don't Show",
    AuraNum1 = "many",
    AuraNumTT = "Max number of the auras can display",

    OriAura = "SourceAuraStyle",
    OriAuraTT = "Use Blizzard default auras's style rather than a customizable square icon style",

    AuraSize = "AuraSize",
    AuraSize0 = "small",
    AuraSize1 = "big",
    AuraSizeTT = "Aura icons Zooming",

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

    UpdateInfo = "Detected that you have updated the version, all settings have been reset to default values",
    UpdateVersion = "Current Version",
}
