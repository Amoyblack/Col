-- 有太多的反馈让加各种各样的设置
-- 我不想把插件的设置界面做成Plater那样十几个页签
-- 我希望用最简洁的界面和理解成本，解决80%的问题，这是RSPlates的初衷与核心
-- 于是有了这个config.lua，把没决定是否有必要放到设置界面里的选项都先放到这里

-- There is too much feedback for me to add various settings
-- I don't want to make the addon's setting interface into a dozen tabs like the Plater
-- I hope to solve 80% of the problems with the most concise interface and understanding cost which is the original intention and core of RSPlates
-- So with this config.lua, Before I decide whether it is necessary to put the config in the addon settings interface, put them here first

local addon, rs = ...
rs.ExtraConfig = {}
local config = rs.ExtraConfig


-- 修改完参数后，保存该文件，游戏内重载界面/reload 即可生效
-- After modifying the parameters, save the file, and reload UI (/reload) will take effect



-- 任务标记大小 (Quest Mark Icon Size)
config.questIconSize = 30

-- 可偷取/驱散Buff大小 (Stolen/Purgable Buff Size)
config.stolenBuffSize = 25

-- 染色优先级，当目标同时满足多个条件时，排在前面的覆盖后面的 
-- Color Priority, When the target meets multiple conditions at the same time, the one in front covers the one behind
-- A: 焦点颜色 (Focus Color)
-- B: 目标颜色 (Target Color)
-- C: 灰名无荣誉目标 (Tap Denied Color)
-- D: 自定义NpcID (Custom NPCID Color)
-- E: 携带自定义光环 (Has a custom aura Color)
-- F: 斩杀颜色 (Execution Color)
-- G: 仇恨颜色 (Threat Color)

-- 举例：默认的优先级是 ABCDEFG，如果你想让斩杀颜色优先级最高，改为 FABCDEG
-- Example: The default priority is ABCDEFG, if you want the Execution Color to have the highest priority, change it to FABCDEG
config.ColorOrder = "ABCDEFG"


