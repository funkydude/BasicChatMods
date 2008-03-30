
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local _G = getfenv(0)
local date = _G.date
local f1 = _G.ChatFrame1.AddMessage

--[[		Stamp CF1		]]--
local function AddMessage(frame, text, ...)
	text = "|cff"..COLOR.."["..date("%X").."]|r "..text

	return f1(frame, text, ...)
end
_G.ChatFrame1.AddMessage = AddMessage

--[[		Stamp CLog	 via Blizz		]]--
TEXT_MODE_A_STRING_TIMESTAMP = "|cff"..COLOR.."[$time]|r"
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_,_,addon)
	if addon == "Blizzard_CombatLog" then
		local root = Blizzard_CombatLog_Filters.filters[Blizzard_CombatLog_Filters.currentFilter].settings
		root.timestampFormat = "%H:%M:%S" --remove sometime
		root.timestamp = true
		frame:UnregisterAllEvents()
		root = nil frame = nil
	end
end)
