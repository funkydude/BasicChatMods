
--[[		Settings		]]--
--Timestamp coloring, http://www.december.com/html/spec/colorcodes.html
local COLOR = "777777"
--Formats decide what time format you want http://www.lua.org/pil/22.1.html
--You can also mix in symbols like %I.%M or or %x:%X
local tformat = "%X"
--Left and right bracket, change to what you want, or make blank "" (Keep the |r)
local lbrack, rbrack = "[", "]|r "


--[[		Timestamp Module		]]--
local date = _G.date
local hooks = {}
local h = nil
local start = "|cff"
local function AddMessage(frame, text, ...)
	text = start..COLOR..lbrack..date(tformat)..rbrack..text
	return hooks[frame](frame, text, ...)
end

--[[			Stamp CF 1 to 7, skip 2		]]--
for i = 1, NUM_CHAT_WINDOWS do
	if i ~= 2 then -- skip combatlog
		h = _G[format("%s%d", "ChatFrame", i)]
		hooks[h] = h.AddMessage
		h.AddMessage = AddMessage
	end
end

--[[
	Stamp Combatlog
	You will need to turn timestamps on
	youself in the combatlog settings
]]--
_G.TEXT_MODE_A_STRING_TIMESTAMP = "|cff"..COLOR.."[%s]|r %s"
