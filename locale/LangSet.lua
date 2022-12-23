
local _, rs = ...


local clientlang = GetLocale()

if clientlang == "enUS" then 
	rs.L = rs.V.enus
elseif clientlang == "zhCN" then 
	rs.L = rs.V.zhcn
elseif clientlang == "zhTW" then 
	rs.L = rs.V.zhtw 
-- elseif clientlang == "ruRU" then 
-- 	rs.L = rs.V.ruru
else
	rs.L = rs.V.enus
	-- print "|cffFFD700---RSPlates:|r The addon can't adapt for your client language (It will display in English). If you would like to help support your language localization, please let me know on the Addon Page : curseforge.com/wow/addons/rsplates OR github.com/Amoyblack/Col"
end