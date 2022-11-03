
local _, rs = ...



rs.V.enus = {
    ReloadUI = "Reload UI",

    MenuBasis = "General",
    MenuWhiteList = "WhiteList",
    MenuBlackList = "BlackList",
    Version = "Version - ",

    Title1 = "Style",
    Title2 = "CVars",
    Title4 = "Threat and Execute",
    Title5 = "Name",
    Title6 = "Auras",
    Title7 = "Dungeon Helper",
    Title8 = "Others",
    Title10 = "Profile",

    BarTexture = "Texture",
    BarTextureTT = "|cffFFD700source|r Current Version(10.0 DF)Blizzard default texture  \n\n|cffFFD7007.0 LEG source|r 7.0 LEG ~ 9.0 SL Version Blizzard default texture \n\n|cffFFD700Customize|r If you need a custom texture, rename your texture file to <myrstexture>, store it in ~/_retail_/Interface/AddOns/RSPlates/media/myrstexture, and select this option \n\n|cff66CCFFWhen select the first option - <source>, you may need to reload UI to take effect|r",
    BarTextureSource = "source",

    NarrowCastBar = "Narrow CastBar",
    NarrowCastBarTT = "Use narrow castbar style instead of blizzard source style. (It's recommended to use this with Flat texture the same time for better display effect) |cff66CCFFNeed /reload.|r",

    EliteIcon = "Elite Icon",
    EliteIconTT = "Show Elite Icon",

    BgCol = "HealthBar Background Color",
    BgColTT = "Draw HealthBar background (health loss part) as a multiplier color which basic on HealthBar color, instead black background.  |cff66CCFFNeed to reload UI to take effect when you disable it|r",

    Omen3 = "Threat Color Enable",
    Omen3TT = "Show threat Status as different bar color",

    dpsLowthreat = "Low Threat",
    dpsLowthreatTT = "|cffFFD700DPS|r  Safe Low Threat \n|cffFFD700TANK|r  Total loss of Threat",
    dpsGainthreat = "High Threat(threshold)",
    dpsGainthreatTT = "|cffFFD700DPS|r  The OT threshold has been reached, but the unit's target has not yet switched to you \n|cffFFD700TANK|r  The threshold for losing threat has been reached, but the unit's target is still you",
    Tankstablethreat = "High Threat(Stablize)",
    TankstablethreatTT = "|cffFFD700DPS|r  Already OT \n|cffFFD700TANK|r  Steady high threat, leading the second by a wide margin",
    Tanklosethreat = "High Threat(over threshold)",
    TanklosethreatTT = "|cffFFD700DPS|r  Already OT, the unit starts to switch targets to attack you \n|cffFFD700TANK|r  Lost threat, units switch targets from you",

    Health = "Health Text",
    HealthValue = "Value",
    HealthPercentage = "Percent",
    HealthBothShow = "Value/Percent",
    HealthNone = "Hide",

    CvarEnable = "Enable",
    CvarEnableTT = "CVar can be understood as some settings on the Blizzard server\n\nRSPlates allows you to easily modify some of them\n\nBut it also means that even if you disable or delete the plugin, the CVar settings will continue to take effect",

    SelectScale = "Select Scale",
    SelectScaleTT = "Scale Selected Nameplate.",

    nameplateOtherTopInset = "Minimum Top Spacing",
    nameplateOtherTopInsetTT = "Minimum spacing between the nameplates and the top of the screen",

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

    FocusTitle = "Focus",
    FocusColorEnable = "Focus Color Enable",
    FocusColor = "Focus Color",

    AuraText1 = "Auras need to show",

    AuraDeault = "Default list",
    AuraDeaultTT = "Default aura whitelist by Blizzard.",

    AuraWL = "WhiteList",
    AuraWLTT = "The |cff00FF7F<Debuff>|r configured in the whitelist will be displayed on the nameplates other than the player-self, and the |cff00FF7F<Buff>|r will be displayed on the player-self's personal resource bar, which can be used to monitor spells/items's trigger  , buff coverage, etc.",

    AuraOnlyMe = "Self Only",
    AuraOnlyMeTT = "Show only auras cast by self or pets.",

    AuraTitleGlobal = "Global",
    AuraText2 = "Auras Style",

    DynamicHeightOffSet = "Dynamic Aura Space",
    DynamicHeightOffSetTT = "On the nameplates with the name hidden, the Aura will dynamically float down to occupy the space of the name to try to stick to the health bar, which is the way of the Blizzard Source Nameplates. Uncheck to fix space |cff66CCFF Take effect after reload|r",

    AuraHeight = "Nameplates Aura Space",
    AuraHeightTT = "The space between Nameplates and aura frame",

    SelfAuraHeight = "Personal resource bar Aura Space",
    SelfAuraHeightTT = "The space between Personal resource bar and aura frame",

    AuraNum = "Aura Numbers",
    AuraNumTT = "Maximum number of auras displayed on Nameplates (including personal resource bar)",

    SquareAura = "Square Aura Icon",


    AuraSize = "Icon Size",
    AuraSizeTT = "Aura icons size (Won't enable when you're using Source Icon style).",

    Counter = "Enable Timer",
    CounterTT = "Show aura timer, you need to open the Blizzard built-in display cooldown setting (esc - interface - action bar - display cooldown time), you can turn off this option when you enable other CoolDown plug-ins such as OmniCC",

    CounterSize = "Timer Text Size",

    AuraFilterTitle = "Buff & Debuff Filter",
    AuraFilterHelpBtnTT = "|cff00FF7FBy default, Blizzard only shows buffs on the personal resource bar, and only debuffs on the rest of the nameplates.|r \n\nRSPlates allows you to define more freely how and where to display them. \n\nFor example, If you need to pay attention to hostiles unit's buffs such as |TInterface\\ICONS\\Spell_shadow_bloodboil:0:1:0:1|tSanguine/|TInterface\\ICONS\\Ability_warrior_focusedrage:0:1:0:1|tRaging/|TInterface\\ICONS\\Ability_socererking_arcanefortification:0:1:0:1|tBolster, etc., please turn on the buff switch in |cffFFD700Nameplates|r filter and configure it.\n\nFor example,If you need to pay attention to your own debuffs such as |TInterface\\ICONS\\Ability_ironmaidens_whirlofblood:0:1:0:1|tBursting, etc., please turn on the debuff switch in |cffFFD700Personal Resource Bar|r filter and configure it \n\nThe auras that example listed above are all written into the addon's initialization whitelist. If you don't have them, you can reset the addon's configuration or add them manually.",
    AuraFilterPersonalTitle = "- Personal Resource Bar",
    AuraFilterOtherTitle = "- Nameplates",
    AuraFilterEnableBuff = "Show BUFF",
    AuraFilterEnableDeBuff = "Show DEBUFF",
    AuraFilterAll = "All",
    AuraFilterAllTT = "Show All",
    AuraFilterBlizzard = "Blizzard Default",
    AuraFilterBlizzardTT = "the aura that Blizzard default to show",
    AuraFilterWhiteList = "Whitelist",
    AuraFilterWhiteListTT = "Show the aura in the whitelist",
    AuraFilterLessMinite = "Less One Min",
    AuraFilterLessMiniteTT = "Only show auras with less than 1 minute remaining",
    AuraFilterOnlyMe = "Only From Me",
    AuraFilterOnlyMeTT = "Only show auras from me and my pets",

    Exp = "Explosive Helper",
    ExpTT = "When Explosives spawn, all of other nameplates will be hidden until there is no more Explosives alive",

    CastHeight = "Castbar Width",
    CastHeightTT = "Only works in narrow castbar style",

    UnSelectAlpha = "Transparency",
    UnSelectAlphaTT = "Transparency of non-current target's Nameplates.",

    CenterDetail = "Text in Center",
    CenterDetailTT = "Show health value in nameplate center. |cff66CCFFNeed /reload.|r",

    WesternDetail = "Western Unit",
    WesternDetailTT = "K/M unit for 1000/100000 health value",

    TargetGroup = "Target Indicator",

    MouseoverGlow = "Mouseover Highlight",
    MouseoverGlowTT = "Hightlight the mouseover unit(no need to select)",

    TargetColorEnable = "Enable Target Color",
    TargetColorEnableTT = "Color the current target's health bar",

    TargetColor = "Target Color",

    Arrow = "Selected Arrow",
    ArrowTT = "Display an arrow at nameplate right on target unit.",

    CastingTitle = "Spell Casting Indicator",
    CastTimer = "Cast Time",
    CastTimerTT = "Shows the unit's cast time",

    CastTarget = "Cast Target",
    CastTargetTT = "Shows the unit's cast target",

    CastInterrupteFrom = "Interrupt Source",
    CastInterrupteFromTT = "When a unit spell is interrupted,display the interrupter's name on its cast bar",

    CastInterrupteIndicatorEnable = "Interrupt Indicator",
    CastInterrupteIndicatorEnableTT = "When an enemy unit casts an interruptible spell, a green interrupt indicator will light up on the spellcasting unit's nameplate if you have any of the skills on the watch list below and are available(not in CD)",

    InterrupteSpellInput = "Add monitoring spell to Interrupt Indicator, enter Spell ID to add",
    InterrupteSpellInputTT = "Enter the Spell ID to add, click the spell icon to remove",

    InterrupteSpellIDInputError = "|cffFFD700---RSPlates:|r Please enter the correct Spell ID",
    InterrupteSpellIDAdded = "|cffFFD700---RSPlates:|r Spell added successfully ",
    InterrupteSpellIDRemoved = "|cffFFD700---RSPlates:|r Spell successfully removed ",
    
    StolenBuff = "Extra display canStealOrPurge BUFF",
    StolenBuffTT = "Highlight the buff that can be stolen or purged on the right side of the unit health bar (It will only be displayed when your current character has the corresponding dispel/steal ability)",

    QuestIcon = "QuestMarker",
    QuestIconTT = "Show a mark on the top of the Quest Unit",

    LockPlayerColor = "Lock Player BarColor",
    LockPlayerColorTT = "Do not color the healthbar of the player and player-controlled units",

    ProfileByCharactor = "Profile Per Charactor",
    ProfileByCharactorTT = "Save Addon Profile by Charactor, not shared Profile under Battle.net account",
    ProfileByCharactorCheckTip = "This operation needs to reload UI. Are you sure to reload UI now?",

    ResetAddonSetting = "Initialize Addon Settings",
    ResetAddonSettingTT = "Initialize the addon configuration of the current login charactor and the configuration shared by current Battle.net account ",

    UpdateForce = "|cffFFD700---RSPlates: Version update has been detected, this version needs to reset the settings, the settings are now initialized|r",
    UpdateInfo = "|cffFFD700---RSPlates: Version update has been detected|r",
    UpdateVersion = "Current Version:  ",

    WhiteListDesc = "Buffs and debuffs can be configured in the whitelist, and they will be displayed on the corresponding nameplates (including the personal resource bar) according to the filter range you configure.",
    WhiteListInput = "Enter  Aura ID",
    WhiteListInputTT = "Enter Aura id to add it to the whitelist, click the aura icon to remove it from the whitelist",
    WhiteListInputError = "|cffFFD700---RSPlates:|r Please enter the correct AuraID",
    WhiteListAdd = "|cffFFD700---RSPlates:|r Whitelist added successfully ",
    WhiteListRemove = "|cffFFD700---RSPlates:|r Whitelist deleted successfully ",

    BlacklistDesc = "Buffs and debuffs can be configured in the blacklist, they will not be displayed on any nameplates (including the personal resource bar)",
    BlackListInput = "Enter  Aura ID",
    BlackListInputTT = "Enter Aura id to add it to the blacklist, click the aura icon to remove it from the blacklist",
    BlackListInputError = "|cffFFD700---RSPlates:|r Please enter the correct AuraID",
    BlackListAdd = "|cffFFD700---RSPlates:|r Blacklist added successfully ",
    BlackListRemove = "|cffFFD700---RSPlates:|r Blacklist deleted successfully ",

    BlizzardPanelInfo = "|cffFFD700/rs|r   Open Config",
    BlizzardPanelReportInfo = "Advice/Bug Report: https://www.curseforge.com/wow/addons/rsplates",
    BlizzardPanelSettingBtn = "Config",



    BlizzardPanelLargeInfo = "RSPlates is made based on the style of blizzard <Larger Nameplates>\n It's recommended to enable it by [esc - interface - Names - Larger Nameplates]",

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

    NpcAuraColorOnlyMe = "Only From Me",
    NpcAuraColorOnlyMeTT = "Only color aura that from my pet or myself",

    NpcbarColor = "Healthbar Color",
    RemoveCheckBoxTT = "|cff00FF7F--- Click to remove ---|r",

    MarginCol1 = "\nSince the new version of RSP has refactored and optimized the performance and structure, you need to manually delete the plugin directory of the old version once",
    MarginCol2 = "\nDetected that an old version plugin directory currently exists",
    MarginCol3 = "\nlocated at .../_retail_/Interface/AddOns/Col,Just delete the <Col> folder",
    MarginCol4 = "\nAfter deleting the plugin directory of the old version, this prompt will be automatically closed, and the coexistence of the old and new versions will cause conflicts and bugs",

    MiniMapLeftBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:3:512:720:12:66:311:422|t : Open Config",
    MiniMapRightBtn = "|TInterface\\TUTORIALFRAME\\UI-TUTORIAL-FRAME:13:11:0:-1:512:512:12:66:333:411|t : Bug Report",

    MiniMapEnable = "Minimap Button Enable",
    MiniMapEnableTT = "It may need to ReloadUI to take effect When using MinimapButtonBag or this type of minimap-button-Integrate addons",


    Title9 = "Name Mode",
    Title9TT = "Use Name instead of Healthbar to display",

    EnableNamemode = "Enable",
    EnableNamemodeTT = "Use Name instead of Healthbar display for the units below . (Due to Blizzard's restrictions, friendly units do not take effect in dungeon)",

    NamemodeGroupTitle = "Unit Type",

    FriendlyPlayer = "Friendly Player",

    FriendlyNpc = "Friendly NPC",
    FriendlyNpcTT = "You can turn on <Always Show Nameplates> and <Show Friendly NPC nameplates> in CVAR options at the same time to make the names of surrounding NPCs prominently displayed",

    NameModeNameType = "Font Stroke",
    NameModeNameTypeNIL = "NIL",
    NameModeNameTypeOUTLINE = "OUTLINE",
    NameModeNameTypeTHICKOUTLINE = "THICKOUTLINE",

    NameModeImitateOverlap = "Imitate Friendly Nameplates Overlaping",
    NameModeImitateOverlapTT = "Make the names of friendly units always close to the top of the unit, instead of causing the gap between multiple names to be too large that occurs when Stacking Nameplates is enable especially when the camera moves. (This is achieved by changing the size and clickable area of the friendly nameplates. If you need to see the healthbar of the friendly unit instead of the name, please do not enable this).  |cff66CCFFNeed to reload UI to take effect when you disable it|r",

    NameModeHeightOffset = "Height Offset",

    GetSpellDesFailInfo = "|cffFF0000The spell has no description Or the Addon is not received due to blizzard server delay. If the latter, Re-open the RSPlates settings interface, it can be displayed normally|r",

    ShowAllNP = "Always Show Nameplates",
    ShowAllNPTT = "When off it only shows the nameplates (or Name in name-mode) in battle, when on it will always show. Same option as <Always Show Nameplates> in Blizzard UI settings",

    ShowNpcNP = "Show Friendly NPC nameplates",
    ShowNpcNPTT = "Display the friendly NPC's nameplates (or name in name mode), you need to open <Friendly Players> in Blizzard UI settings , the initial shortcut key is Shift + V",

    NameModeNameSize = "Name Size",

    nameplateOccludedAlphaMult = "Occluded Unit Transparency",

    WhenselfShow = "When to show the personal resource bar",
    NameplatePersonalShowAlways = "Always",
    NameplatePersonalShowInCombat = "In battle",
    NameplatePersonalShowWithTarget = "Has a target",
    NameplatePersonalHideDelaySeconds = "HideDelay (sec)",

    CVarExtraLink = "|cffFFD700More complete CVar documentation can be found here:  https://wowpedia.fandom.com/wiki/Console_variables/Complete_list |r",
}