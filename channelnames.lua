
--[[		Channel Name Replacements Module		]]--

local gsub = _G.string.gsub
local time = _G.time
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
}

local function AddMessage(frame, text, ...)
	for k, v in pairs(channels) do
		text = gsub(text, k, v)
	end

	if CHAT_TIMESTAMP_FORMAT and not text:find("%d:%d") then
		text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
	end
	text = gsub(text, "%[(%d+)%. %w+%]", "[%1]") --custom channels
	return newAddMsg[frame:GetName()](frame, text, ...)
end

do
	for i = 1, 10 do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end

	--[[
		To customize what you want for channel names
		simply change the text in the brackets []
		this counts for different languages also
	]]
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h[BG]|h %s:\32"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h[BGL]|h %s:\32"
	CHAT_GUILD_GET = "|Hchannel:Guild|h[G]|h %s:\32"
	CHAT_PARTY_GET = "|Hchannel:Party|h[P]|h %s:\32"
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h[PL]|h %s:\32"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[PL]|h %s:\32"
	CHAT_OFFICER_GET = "|Hchannel:o|h[O]|h %s:\32"
	CHAT_RAID_GET = "|Hchannel:raid|h[R]|h %s:\32"
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h[RL]|h %s:\32"
	CHAT_RAID_WARNING_GET = "[RW] %s:\32"
end

