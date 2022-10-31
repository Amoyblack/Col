local addon, rs = ...

----------------------------------------------------
---- Quest Function Copied From TPTP(Threat Plates)
----------------------------------------------------

local QUEST_OBJECTIVE_PARSER_LEFT = function(text)
    local current, goal, objective_name = string.match(text, "^(%d+)/(%d+)( .*)$")
    return objective_name, current, goal
end

local QUEST_OBJECTIVE_PARSER_RIGHT = function(text)
    return string.match(text, "^(.*: )(%d+)/(%d+)$")
end

local PARSER_QUEST_OBJECTIVE_BACKUP = function(text)
    local current, goal, objective_name = string.match(text, "^(%d+)/(%d+)( .*)$")

    if not objective_name then
        objective_name, current, goal = string.match(text, "^(.*: )(%d+)/(%d+)$")
    end

    return objective_name, current, goal
end

local STANDARD_QUEST_OBJECTIVE_PARSER = {
    -- x/y Objective
    enUS = QUEST_OBJECTIVE_PARSER_LEFT,
    -- enGB = enGB clients return enUS
    esMX = QUEST_OBJECTIVE_PARSER_LEFT,
    ptBR = QUEST_OBJECTIVE_PARSER_LEFT,
    itIT = QUEST_OBJECTIVE_PARSER_LEFT,
    koKR = QUEST_OBJECTIVE_PARSER_LEFT,
    zhTW = QUEST_OBJECTIVE_PARSER_LEFT,
    zhCN = QUEST_OBJECTIVE_PARSER_LEFT,

    -- Objective: x/y
    deDE = QUEST_OBJECTIVE_PARSER_RIGHT,
    frFR = QUEST_OBJECTIVE_PARSER_RIGHT,
    esES = QUEST_OBJECTIVE_PARSER_RIGHT,
    ruRU = QUEST_OBJECTIVE_PARSER_RIGHT
}

local QuestObjectiveParser = STANDARD_QUEST_OBJECTIVE_PARSER[GetLocale()] or PARSER_QUEST_OBJECTIVE_BACKUP

local _G, WorldFrame = _G, WorldFrame
local TooltipFrame = CreateFrame("GameTooltip", "ThreatPlates_Tooltip", nil, "GameTooltipTemplate")

local QuestList, QuestIDs, QuestsToUpdate = {}, {}, {}
local PlayerName = UnitName("player")

function rs.IsQuestUnit(unit, create_watcher)
    if not unit then
        return false, false, nil
    end

    local unitGUID = UnitGUID(unit)
    local quest_title
    -- local unit_name
    local quest_player = true
    local quest_progress = false

    -- Read quest information from tooltip. Thanks to Kib: QuestMobs AddOn by Tosaido.
    TooltipFrame:SetOwner(WorldFrame, "ANCHOR_NONE")
    -- TooltipFrame:SetUnit(unitid)
    TooltipFrame:SetHyperlink("unit:" .. unitGUID)

    for i = 3, TooltipFrame:NumLines() do
        local line = _G["ThreatPlates_TooltipTextLeft" .. i] -- obj
        local text = line:GetText()
        -- print (i, text)
        local text_r, text_g, text_b = line:GetTextColor()

        -- print ("Line: |" .. text .. "|")
        -- print ("  => ", text_r, text_g, text_b)
        if text_r > 0.99 and text_g > 0.81 and text_b == 0 then
            -- A line with this color is either the quest title or a player name (if on a group quest, but always after the quest title)
            if quest_title then
                quest_player = (text == PlayerName)
                -- unit_name = text
            else
                quest_title = text

            end
        elseif quest_title and quest_player then
            local objective_name, current, goal
            local objective_type = false

            -- Set quest_title to false again, otherwise a second quest in the tooltip will not be found (first if statement will
            -- check for quest_player only as quest_title is still set to the first quest
            quest_title = false

            -- Check if area / progress quest
            if string.find(text, "%%") then
                objective_name, current, goal = string.match(text, "^(.*) %(?(%d+)%%%)?$")
                objective_type = "area"
                -- print (unit_name, "=> ", "Area: |" .. text .. "|", objective_name, current, goal)
            else
                -- Standard x/y /pe quest
                objective_name, current, goal = QuestObjectiveParser(text)
                -- print (unit_name, "=> ", "Standard: |" .. text .. "|", objective_name, current, goal, "|")
            end

            if objective_name then
                current = tonumber(current)

                if objective_type then
                    goal = 100
                else
                    goal = tonumber(goal)
                end

                -- Note: "progressbar" type quest (area quest) progress cannot get via the API, so for this tooltips
                -- must be used. That's also the reason why their progress is not cached.

                -- local Quests = QuestList
                -- if Quests[quest_title] then
                --   local quest_objective = Quests[quest_title].objectives[objective_name]
                --   if quest_objective then
                --     current = quest_objective.current
                --     goal = quest_objective.goal
                --     objective_type = quest_objective.type
                --   end
                -- end

                -- A unit may be target of more than one quest, the quest indicator should be show if at least one quest is not completed.
                if current and goal then
                    -- print (current, goal, objective_name)
                    if (current ~= goal) then
                        return true, 1, {
                            current = current,
                            goal = goal,
                            type = objective_type
                        }
                    end
                else
                    -- Line after quest title with quest information, so we can stop here
                    return false
                end
            end
        end
    end

    return false
end

local function UpdateAllUnitQuestState()
    for i, namePlate in ipairs(C_NamePlate.GetNamePlates()) do
        local unitFrame = namePlate.UnitFrame
        rs.SetUnitQuestState(unitFrame)
    end
end

local function Quest_Event(self, event, ...) -- self <--QuestEventFrame 
    local arg = ...
    if event == "UNIT_QUEST_LOG_CHANGED" then
        local inInstance, instanceType = IsInInstance()
        if not inInstance then
            UpdateAllUnitQuestState()
        end
    end
end

local QuestEventFrame = CreateFrame("Frame")
QuestEventFrame:RegisterEvent("UNIT_QUEST_LOG_CHANGED")
QuestEventFrame:SetScript("OnEvent", Quest_Event)
