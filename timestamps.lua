
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local hooks = {}
local _G = getfenv(0)
local date = _G.date
local fmt = _G.string.format
local f1 = _G.ChatFrame1.AddMessage

--[[		Stamp CF1		]]--
local msg = "|cff"..COLOR.."[%s]|r %s"
local function AddMessage(frame, text, ...)
	text = fmt(msg, date("%X"), text)

	return f1(frame, text, ...)
end
_G.ChatFrame1.AddMessage = AddMessage

--[[		Stamp CLog	 via Blizz		]]--
TEXT_MODE_A_STRING_TIMESTAMP = "$time"
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_,_,addon)
	if addon == "Blizzard_CombatLog" then
		local root = Blizzard_CombatLog_Filters.filters[Blizzard_CombatLog_Filters.currentFilter].settings
		root.timestampFormat = "|cff"..COLOR.."[%X]|r"
		root.timestamp = true
		frame:UnregisterEvent("ADDON_LOADED")
		root = nil frame = nil
	end
end)
