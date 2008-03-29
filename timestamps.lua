
--[[		Timestamp Color		]]--
local COLOR = "777777"

--[[		Timestamp Module		]]--
local hooks = {}
local date = date
local h = nil
local fmt = string.format
local _G = getfenv(0)

local msg = "|cff"..COLOR.."[%s]|r %s"
local function AddMessage(frame, text, ...)
	text = fmt(msg, date("%X"), text)

	return hooks[frame](frame, text, ...)
end

h = _G["ChatFrame1"]
hooks[h] = h.AddMessage
h.AddMessage = AddMessage

TEXT_MODE_A_STRING_TIMESTAMP = "$time"
Blizzard_CombatLog_Filters.filters[Blizzard_CombatLog_Filters.currentFilter].settings.timestamp = true
Blizzard_CombatLog_Filters.filters[Blizzard_CombatLog_Filters.currentFilter].settings.timestampFormat = "|cff"..COLOR.."[%X]|r"
