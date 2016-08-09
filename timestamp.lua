
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
	if not bcmDB.stampcol or (bcmDB.stampcol ~= "" and strlen(bcmDB.stampcol) ~= 6) then bcmDB.stampcol = "777777" end -- Add a color if we lack one or the the current is invalid
	if not bcmDB.stampfmt then bcmDB.stampfmt = "[%I:%M:%S] " end --add a format if we lack one

	local time = time
	local format = format

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text, frame)
		local stamp = BetterDate(bcmDB.stampfmt, time())
		local num = frame:GetNumMessages() + 1
		local id = frame:GetID()
		if bcmDB.stampcol == "" then
			text = format("|HBCMt:%d:%d|h%s|h%s", num, id, stamp, text)
		else
			text = format("|cFF%s|HBCMt:%d:%d|h%s|h|r%s", bcmDB.stampcol, num, id, stamp, text)
		end
		return text
	end

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		local num, id = link:match("BCMt:(%d+):(%d+)")
		if num then
			local text = _G[format("ChatFrame%d", id)]:GetMessageInfo(num)
			text = (text):gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
			text = (text):gsub("|[Tt]13700([1-8]):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
			BCM:Popup(text)
		else
			SetHyperlink(self, link, ...)
		end
	end
end

