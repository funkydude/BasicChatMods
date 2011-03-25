
--[[     Sticky Channels Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Sticky then bcmDB.sticky = nil return end

	if not bcmDB.sticky then 
		bcmDB.sticky = {}
		bcmDB.sticky.EMOTE = 1
		bcmDB.sticky.YELL = 1
		bcmDB.sticky.RAID_WARNING = 1
	end

	for k, v in pairs(bcmDB.sticky) do
		if ChatTypeInfo[k].sticky == v then
			bcmDB.sticky[k] = nil --remove entries that are blizz defaults
		else
			ChatTypeInfo[k].sticky = v
		end
	end
end

