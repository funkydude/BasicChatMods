
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB

	if bcmDB.BCM_Timestamp then bcmDB.stampcol = nil bcmDB.stampfmt = nil return end

	if GetCVar("showTimestamps") ~= "none" then
		SetCVar("showTimestamps", "none")
		CHAT_TIMESTAMP_FORMAT = nil -- Disable Blizz stamping as it doesn't stamp everything
	end
	if not bcmDB.stampcol or (bcmDB.stampcol ~= "" and strlen(bcmDB.stampcol) ~= 6) then bcmDB.stampcol = "777777" end -- Add a color if we lack one or the the current is invalid
	if not bcmDB.stampfmt then bcmDB.stampfmt = "[%I:%M:%S] " end --add a format if we lack one

	local time = time
	local format = format
	local num = 0

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text, frame)
		local stamp = BetterDate(bcmDB.stampfmt, time())
		local id = frame:GetID()
		num = num + 1
		if bcmDB.stampcol == "" then
			text = format("|HBCMt:%d:%d|h%s|h%s", num, id, stamp, text)
		else
			text = format("|cFF%s|HBCMt:%d:%d|h%s|h|r%s", bcmDB.stampcol, num, id, stamp, text)
		end
		return text
	end

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		local prefix, id = link:match("(BCMt:%d+:)(%d+)")
		if prefix then
			local cf = _G[format("ChatFrame%d", id)]
			for i = cf:GetNumMessages(), 1, -1 do
				local text = cf:GetMessageInfo(i)
				if text:find(prefix, nil, true) then
					text = text:gsub("|T[^\\]+\\[^\\]+\\[Uu][Ii]%-[Rr][Aa][Ii][Dd][Tt][Aa][Rr][Gg][Ee][Tt][Ii][Nn][Gg][Ii][Cc][Oo][Nn]_(%d)[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
					text = text:gsub("|T13700([1-8])[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
					text = text:gsub("|T[^|]+|t", "") -- Remove any other icons to prevent copying issues
					BCM:Popup(text)
					break
				end
			end
		else
			SetHyperlink(self, link, ...)
		end
	end
end

