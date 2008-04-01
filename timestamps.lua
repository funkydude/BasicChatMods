
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local _G = getfenv(0)
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
		h = _G[("%s%d"):format("ChatFrame", i)]
		hooks[h] = h.AddMessage
		h.AddMessage = AddMessage
	end
end

--[[		Stamp CLog	 via Blizz		]]--
TEXT_MODE_A_STRING_TIMESTAMP = "|cff"..COLOR.."[$time]|r"
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_,_,addon)
	if addon == "Blizzard_CombatLog" then
		local root = Blizzard_CombatLog_Filters.filters[Blizzard_CombatLog_Filters.currentFilter].settings
		root.timestampFormat = "%H:%M:%S" --remove sometime, DO NOT EDIT!
		root.timestamp = true
		frame:UnregisterAllEvents()
		root = nil frame = nil
	end
end)
