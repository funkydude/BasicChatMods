
--[[     Timestamp Customize Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB
	bcmDB.stampbracket, bcmDB.BCM_TimestampCustomize = nil, nil --reset defunct variables, REMOVE ME eventually
	if bcmDB.BCM_Timestamp then bcmDB.stampcolor = nil bcmDB.stampformat = nil return end

	SetCVar("showTimestamps", "none") CHAT_TIMESTAMP_FORMAT = nil --disable Blizz stamping as it doesn't stamp everything
	if not bcmDB.stampcolor or (bcmDB.stampcolor ~= "" and strlen(bcmDB.stampcolor) ~= 10) then bcmDB.stampcolor = "|cff777777" end --add a color if we lack one or the the current is invalid
	if not bcmDB.stampformat then bcmDB.stampformat = "[%I:%M:%S]" end --add a format if we lack one

	local time = time
	local newAddMsg = {}

	local AddMessage = function(frame, text, ...)
		text = BetterDate(bcmDB.stampcolor..bcmDB.stampformat.."|r ", time())..text
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 and #cF.messageTypeList > 0 then
			newAddMsg[format("%s%d", "ChatFrame", i)] = cF.AddMessage
			cF.AddMessage = AddMessage
		end
	end
end

