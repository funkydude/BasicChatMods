
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local date = _G.date
local hooks = {}
local h = nil

local function AddMessage(frame, text, ...)
	text = "|cff"..COLOR.."["..date("%X").."]|r "..text
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
TEXT_MODE_A_STRING_TIMESTAMP = "|cff"..COLOR.."[$time]|r"
