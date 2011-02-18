
--[[		Timestamp Customize Module		]]

local _, f = ...
f.functions[#f.functions+1] = function()
--[[
	Color codes ---> http://www.december.com/html/spec/colorcodes.html
]]--

	local bcmDB = bcmDB
	if bcmDB.BCM_TimestampCustomize then bcmDB.stampcolor = nil bcmDB.stampbracket = nil return end
	if not bcmDB.stampcolor then bcmDB.stampcolor = "|cff777777" bcmDB.stampbracket = "[%s]" end

	TIMESTAMP_FORMAT_HHMM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M").."|r "
	TIMESTAMP_FORMAT_HHMM_24HR = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%H:%M").."|r "
	TIMESTAMP_FORMAT_HHMM_AMPM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M %p").."|r "

	TIMESTAMP_FORMAT_HHMMSS = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M:%S").."|r "
	TIMESTAMP_FORMAT_HHMMSS_24HR = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%H:%M:%S").."|r "
	TIMESTAMP_FORMAT_HHMMSS_AMPM = "|r"..bcmDB.stampcolor..(bcmDB.stampbracket):format("%I:%M:%S %p").."|r "
end

