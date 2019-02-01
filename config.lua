local _, ns = ...

ns.C = {}

local C = ns.C

C.NameFont = STANDARD_TEXT_FONT		--名字字体 NameFont
C.CenterDetail = false              --居中显示血量与百分比  Percentage/Value shows on the center of blood bars

-- 仇恨颜色  Threat Color
-- 参数 r,g,b  格式: (255,0,255) --> (1,0,1)

C.StableCol = {.9, .1, .4}  		--Tank稳定仇恨 / 默认暗粉色		Tank stable threat 
C.GainCol = {.9, .1, .9}			--Tank即将丢失仇恨 / 默认亮粉色	Tank unstable threat (lose threat soon)
C.HighCol = {.4, .1, .9}			--dps高仇恨（即将OT) / 默认紫色	Dps high threat (OT soon)
C.LowCol = {.1, .7, .9}				--dps低仇恨 (安全)/ 默认蓝色	Dps low threat (dps safe)





