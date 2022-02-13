
local _, rs = ...



rs.V.enus = {
    ReloadUI = "Reload UI",

    MenuBasis = "General",
    MenuWhiteList = "WhiteList",
    Version = "Version - ",

    Title1 = "Style",
    Title2 = "CVars",
    Title4 = "Colors",
    Title5 = "Name",
    Title6 = "Auras",
    Title7 = "Dungeon Helper",
    Title8 = "Others",

    FlatBarTexture = "Flat Bar Texture",
    FlatBarTextureTT = "Use flattened bartexture instead of blizzard source texture |cff66CCFFNeed /reload.|r",

    NarrowCastBar = "Narrow CastBar",
    NarrowCastBarTT = "Use narrow castbar style instead of blizzard source style. (It's recommended to use this with Flat texture the same time for better display effect) |cff66CCFFNeed /reload.|r",


    BgCol = "HealthBar Background Color",
    BgColTT = "Draw HealthBar background (health loss part) as a multiplier color which basic on HealthBar color, instead black background.",

    Omen3 = "Threat Color Enable",
    Omen3TT = "Show threat Status as different bar color",

    dpsLowthreat = "DPS Low Threat",
    dpsGainthreat = "DPS High Threat(OT Soon)",
    Tankstablethreat = "Tank Stable Threat",
    Tanklosethreat = "Tank Lose Threat Soon",

    Health = "Health Text",
    HealthValue = "Value",
    HealthPercentage = "Percent",
    HealthBothShow = "Value/Percent",
    HealthNone = "Hide",

    CvarEnable = "Enable",
    CvarEnableTT = "CVar can be understood as some settings on the Blizzard server\n\nRSPlates allows you to easily modify some of them\n\nBut it also means that even if you disable or delete the plugin, the CVar settings will continue to take effect",

    SelectScale = "Select Scale",
    SelectScaleTT = "Scale Selected Nameplate.",


    Distance = "Display Range",
    DistanceTT = "How many yards far away to show Nameplates.",

    GlobalScale = "Global Scale",
    GlobalScaleTT = "The Global Scale for Nameplates",

    OverlapV = "Vertical Overlap",
    OverlapVTT = "Vertical overlap between multiple Nameplates",

    OverlapH = "Horizontal Overlap",
    OverlapHTT = "Horizontal overlap between multiple Nameplates",

    SlayLine = "Execute line(%)",

    SlayColtext = "Execute Color Enable",
    SlayColSelect = "Execute Color",


    WhiteName = "White Colored Name",
    WhiteNameTT = "Colored all nameplate's name as white, it will make nameplates neat when the color of the blood bar becomes more . |cff66CCFFNeed to reload UI to take effect when you disable it|r",

    ChangeNameSizeEnable = "Name Size Enable",
    ChangeNameSizeEnableTT = "Need to reload UI to take effect when you disable it",

    NameSize = "Name Size",
    NameSizeTT = "Need to reload UI to take effect when you disable it",

    AuraText1 = "Auras need to show",

    AuraDeault = "Default list",
    AuraDeaultTT = "Default aura whitelist by Blizzard.",

    AuraWL = "WhiteList",
    AuraWLTT = "The |cff00FF7F<Debuff>|r configured in the whitelist will be displayed on the nameplates other than the player-self, and the |cff00FF7F<Buff>|r will be displayed on the player-self's personal resource bar, which can be used to monitor spells/items's trigger  , buff coverage, etc.",

    AuraOnlyMe = "Self Only",
    AuraOnlyMeTT = "Show only auras cast by self or pets.",

    AuraText2 = "Auras Style",

    AuraHeight = "Aura space",
    AuraHeightTT = "The space between Health bar and aura frame",

    AuraNum = "Aura Number",
    AuraNumTT = "How many aura display. 0: not display",

    SquareAura = "Square Aura Icon",


    AuraSize = "Icon Size",
    AuraSizeTT = "Aura icons size (Won't enable when you're using Source Icon style).",

    Counter = "Enable Timer",
    CounterTT = "Show aura timer, you need to open the Blizzard built-in display cooldown setting (esc - interface - action bar - display cooldown time), you can turn off this option when you enable other CoolDown plug-ins such as OmniCC",

    CounterSize = "Timer Text Size",


    Exp = "Explosive Helper",
    ExpTT = "When Explosives spawn, all of other nameplates will be hidden until there is no more Explosives alive",

    CastHeight = "Castbar Width",
    CastHeightTT = "Won't enable when you're using Source Castbar style.",

    UnSelectAlpha = "Transparency",
    UnSelectAlphaTT = "Transparency of non-current target's Nameplates.",

    CenterDetail = "Text in Center",
    CenterDetailTT = "Show health value in nameplate center. |cff66CCFFNeed /reload.|r",

    WesternDetail = "Western Unit",
    WesternDetailTT = "K/M unit for 1000/100000 health value",

    Arrow = "Selected Arrow",
    ArrowTT = "Display an arrow at nameplate right on target unit.",

    StolenBuff = "Extra display canStealOrPurge BUFF",
    StolenBuffTT = "Highlight the buff that can be stolen or purged on the right side of the unit health bar",

    QuestIcon = "QuestMarker",
    QuestIconTT = "Show a mark on the top of the Quest Unit",

    UpdateInfo = "Have detected that you've updated to newest version, all settings have been reset to default values.",
    UpdateVersion = "Current Version:  ",

    WhiteListInput = "Enter  Aura ID",
    WhiteListInputTT = "Enter Aura id to add it to the whitelist, click the aura icon to remove it from the whitelist",
    WhiteListInputError = "|cffFFD700---RSPlates:|r Please enter the correct AuraID",
    WhiteListAdd = "|cffFFD700---RSPlates:|r Whitelist added successfully ",
    WhiteListRemove = "|cffFFD700---RSPlates:|r Whitelist deleted successfully ",

    BlizzardPanelInfo = "|cffFFD700/rs|r   Open Config",
    BlizzardPanelReportInfo = "Advice/Bug Report: https://www.curseforge.com/wow/addons/rsplates",
    BlizzardPanelSettingBtn = "Config",



    BlizzardPanelLargeInfo = "RSPlates is made based on the style of blizzard <Larger Nameplates>\n It's strongly recommended to enable it by [esc - interface - Names - Larger Nameplates]",

    needReload = "|cff66CCFF >> Take effect after reload UI<< |r",

    NpcCOlorTitle = "|cffFFD700- Dye the color of the specified NPC's healthbar|r",
    NpcInput = "Add NPC",
    NpcInputTT = "Input <NPC ID> to add, click <NPC> to remove itself",
    NpcIDInputError = "|cffFFD700---RSPlates:|r Please enter the correct NPC ID",
    NpcIDAdded = "|cffFFD700---RSPlates:|r NPC successfully added ",
    NpcIDDeled = "|cffFFD700---RSPlates:|r NPC successfully removed ",
    NpcIDColorSelectTT = "Choose the color of this kinds of NPC's healthbar",

    NpcAuraTitle = "|cffFFD700- Dye the color of the NPC's healthbar that has specified Aura(buff or debuff) |r",
    NpcAuraInput = "Add Aura",
    NpcAuraInputTT = "Input Aura ID to add, click aura icon to remove itself",
    NpcAuraInputError = "|cffFFD700---RSPlates:|r Please enter the correct Aura ID",
    NpcAuraAdded = "|cffFFD700---RSPlates:|r Aura successfully added ",
    NpcAuraDeled = "|cffFFD700---RSPlates:|r Aura successfully added ",
    NpcAuraColorSelectTT = "Choose the color of the NPC's healthbar that has the aura",

    NpcbarColor = "Healthbar Color",
    RemoveCheckBoxTT = "|cff00FF7F--- Click to remove ---|r",

    MarginCol1 = "\nSince the new version of RSP has refactored and optimized the performance and structure, you need to manually delete the plugin directory of the old version once",
    MarginCol2 = "\nDetected that an old version plugin directory currently exists",
    MarginCol3 = "\nlocated at .../_retail_/Interface/AddOns/Col，Just delete the <Col> folder",
    MarginCol4 = "\nAfter deleting the plugin directory of the old version, this prompt will be automatically closed, and the coexistence of the old and new versions will cause conflicts and bugs",

    MiniMapLeftBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:3:512:720:12:66:311:422|t : Open Config",
    MiniMapRightBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t : Bug Report",

    MiniMapEnable = "Minimap Button Enable",
    MiniMapEnableTT = "It may need to ReloadUI to take effect When using MinimapButtonBag or this type of minimap-button-Integrate addons",
}
