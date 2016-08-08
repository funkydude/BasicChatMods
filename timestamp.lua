
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB

	-- XXX temp since 7.0.3
	if bcmDB.stampcolor then
		bcmDB.stampcol = bcmDB.stampcolor:sub(5)
	end
	bcmDB.stampcolor = nil
	if bcmDB.stampformat then
		bcmDB.stampfmt = bcmDB.stampformat.. " "
	end
	bcmDB.stampformat = nil
	-- XXX end temp

	if bcmDB.BCM_Timestamp then bcmDB.stampcol = nil bcmDB.stampfmt = nil return end

	if GetCVar("showTimestamps") ~= "none" then
		SetCVar("showTimestamps", "none")
		CHAT_TIMESTAMP_FORMAT = nil -- Disable Blizz stamping as it doesn't stamp everything
	end
	if not bcmDB.stampcol or (bcmDB.stampcol ~= "" and strlen(bcmDB.stampcol) ~= 10) then bcmDB.stampcol = "777777" end -- Add a color if we lack one or the the current is invalid
	if not bcmDB.stampfmt then bcmDB.stampfmt = "[%I:%M:%S] " end --add a format if we lack one

	local time = time
	local gsub = gsub

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		text = gsub(text, "|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = gsub(text, "|[Tt]13700(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = gsub(text, "|[Tt][^|]+|[Tt]", "") -- Remove any other icons to prevent copying issues
		local stamp = BetterDate(bcmDB.stampfmt, time())
		if bcmDB.stampcol == "" then
			text = "|HBCMlinecopy:".. gsub(stamp..text, "|", "#^V^V#") ..":BCMlinecopy|h".. stamp .. "|h"..text
		else
			text = "|cff".. bcmDB.stampcol .."|HBCMlinecopy:".. gsub(stamp..text, "|", "#^V^V#") ..":BCMlinecopy|h".. stamp .. "|h|r"..text
		end
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

