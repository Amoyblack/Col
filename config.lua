
-- 我不想把插件的设置界面做成Plater那样十几个页签
-- 于是有了这个config.lua，把反馈较多但还没决定是否有必要放到设置界面里的选项都先放到这里

-- I don't want to make a dozen tabs for addon's setting interface like < Plater >
-- So with this config.lua, Before I decide whether it is necessary to put the configs that have more feedback in the addon settings interface, put them here first

-- 修改完参数后，保存该文件，游戏内重载界面/reload 即可生效
-- After modifying the parameters, save the file, and reload UI (/reload) will take effect

local addon, rs = ...
rs.ExtraConfig = {}
local config = rs.ExtraConfig

-------------------------------------------
------  不要改上面的 Dont touch above -------
-------------------------------------------

-- 血量字体大小 （health value size)
config.healthValueSize = 11

-- 任务标记大小 (Quest Mark Icon Size)  Default:30
config.questIconSize = 30

-- 可偷取/驱散Buff大小 (Stolen/Purgable Buff Size)  Default:25
config.stolenBuffSize = 25

-- 施法条施法时间数字大小 (CastBar Casting Timer Size)  Default:12
config.CastingTimerSize = 12

-- 施法条打断指示器大小 (CastBar Interrupte-Indicator Size)  Default:7
config.InterrupteIndicatorSize = 7

-- 染色优先级，当目标同时满足多个条件时，排在前面的覆盖后面的 
-- Color Priority, When the target meets multiple conditions at the same time, the one in front covers the one behind
-- A: 焦点颜色 (Focus Color)
-- B: 目标颜色 (Target Color)
-- C: 灰名无荣誉目标 (Tap Denied Color)
-- D: 自定义NpcID (Custom NPCID Color)
-- E: 携带自定义光环 (Has the Custom aura Color)
-- F: 斩杀颜色 (Execution Color)
-- G: 仇恨颜色 (Threat Color)
-- 举例：默认的优先级是 "ABCDEFG"，如果你想让斩杀颜色优先级最高，改为 "FABCDEG"
-- Example: The default priority is "ABCDEFG", if you want the Execution Color to have the highest priority, change it to "FABCDEG"
config.ColorOrder = "ABCDEFG"


