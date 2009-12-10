
--[[		Settings		]]--
--Timestamp coloring, http://www.december.com/html/spec/colorcodes.html
local COLOR = "777777"
--Formats decide what time format you want http://www.lua.org/pil/22.1.html
--You can also mix in symbols like %I.%M or or %x:%X
local tformat = "%X"
--Left and right bracket, change to what you want, or make blank "" (Keep the |r)
local lbrack, rbrack = "[", "]"


local gsub = _G.string.gsub
local date = _G.date
local pairs = _G.pairs
local newAddMsg = {}

--[[		Replacements		]]--
local channels = {
	["%[%d+%. WorldDefense%]"] = "[WD]",
	["%[%d+%. LookingForGroup%]"] = "[LFG]",
	["%[%d+%. General%]"] = "[GEN]",
	["%[%d+%. LocalDefense%]"] = "[LD]",
	["%[%d+%. Trade%]"] = "[T]",
	["%[%d+%. GuildRecruitment %- .*%]"] = "[GR]",
	["%[(%d+)%. %w+%]"] = "[%1]", --custom chans
}

local function AddMessage(frame, text, ...)
	for k, v in pairs(channels) do
		text = gsub(text, k, v)
	end

	text = "|cff"..COLOR..lbrack..date(tformat)..rbrack.."|r "..text
	return newAddMsg[frame](frame, text, ...)
end

do
	for i = 1, NUM_CHAT_WINDOWS do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[f] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end

	--[[
		To customize what you want for channel names
		simply change the text in the brackets []
		this counts for different languages also
	]]
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h[BG]|h %s:\32"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h[BGL]|h %s:\32";
	CHAT_GUILD_GET = "|Hchannel:Guild|h[G]|h %s:\32";
	CHAT_PARTY_GET = "|Hchannel:Party|h[P]|h %s:\32";
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h[PL]|h %s:\32";
	CHAT_OFFICER_GET = "|Hchannel:o|h[O]|h %s:\32";
	CHAT_RAID_GET = "|Hchannel:raid|h[R]|h %s:\32";
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h[RL]|h %s:\32";
	CHAT_RAID_WARNING_GET = "[RW] %s:\32"

	--TEXT_MODE_A_STRING_TIMESTAMP = "|cff"..COLOR.."[%s]|r %s"
end

