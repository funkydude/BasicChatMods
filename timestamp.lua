
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB
	bcmDB.stampbracket, bcmDB.BCM_TimestampCustomize = nil, nil --Temp
	if bcmDB.BCM_Timestamp then bcmDB.stampcolor = nil bcmDB.stampformat = nil return end

	SetCVar("showTimestamps", "none") CHAT_TIMESTAMP_FORMAT = nil --disable Blizz stamping as it doesn't stamp everything
	if not bcmDB.stampcolor or (bcmDB.stampcolor ~= "" and strlen(bcmDB.stampcolor) ~= 10) then bcmDB.stampcolor = "|cff777777" end --add a color if we lack one or the the current is invalid
	if not bcmDB.stampformat then bcmDB.stampformat = "[%I:%M:%S]" end --add a format if we lack one

	local time = time

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		text = BetterDate(bcmDB.stampcolor..bcmDB.stampformat.."|r ", time())..text
		return text
	end
end

