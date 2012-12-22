
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB
	if bcmDB.BCM_Timestamp then bcmDB.stampcolor = nil bcmDB.stampformat = nil return end

	if GetCVar("showTimestamps") ~= "none" then
		SetCVar("showTimestamps", "none")
		CHAT_TIMESTAMP_FORMAT = nil --disable Blizz stamping as it doesn't stamp everything
	end
	if not bcmDB.stampcolor or (bcmDB.stampcolor ~= "" and strlen(bcmDB.stampcolor) ~= 10) then bcmDB.stampcolor = "|cff777777" end --add a color if we lack one or the the current is invalid
	if not bcmDB.stampformat then bcmDB.stampformat = "[%I:%M:%S]" end --add a format if we lack one

	local time = time
	local gsub = gsub

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		local data = gsub(text, "|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		data = gsub(data, "|[Tt][^|]+|[Tt]", "") -- Remove any other icons to prevent copying issues
		local stamp = BetterDate(bcmDB.stampformat, time())
		text = bcmDB.stampcolor.."|HBCMlinecopy:"..stamp.." "..gsub(data, "|", "#^V^V#")..":BCMlinecopy|h".. stamp .. "|h|r "..text
		return text
	end

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		local msg = link:match("BCMlinecopy:(.+):BCMlinecopy")
		if msg then
			BCM:Popup(gsub(msg, "#%^V%^V#", "|"))
		else
			SetHyperlink(self, link, ...)
		end
	end
end

