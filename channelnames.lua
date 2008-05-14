
--[[		Channel Name Module		]]--
local gsub = _G.string.gsub
local pairs = _G.pairs
local hooks = {}
local h = nil

--[[		Replacements		]]--
local channels = {
	--standard channels replaced below
	["%[Guild%]"] = "|cffff3399[|rG|cffff3399]|r",
	["%[Party%]"] = "|cffff3399[|rP|cffff3399]|r",
	["%[Raid%]"] = "|cffff3399[|rR|cffff3399]|r",
	["%[Raid Leader%]"] = "|cffff3399[|rRL|cffff3399]|r",
	["%[Raid Warning%]"] = "|cffff0000[|rRW|cffff0000]|r",
	["%[Officer%]"] = "|cffff0000[|rO|cffff0000]|r",
	["%[%d+%. WorldDefense%]"] = "|cff990066[|rWD|cff990066]|r",
	["%[%d+%. LookingForGroup%]"] = "|cff990066[|rLFG|cff990066]|r",
	["%[%d+%. General%]"] = "|cff990066[|rGEN|cff990066]|r",
	["%[%d+%. LocalDefense%]"] = "|cff990066[|rLD|cff990066]|r",
	["%[%d+%. Trade%]"] = "|cff990066[|rT|cff990066]|r",
	["%[%d+%. GuildRecruitment %- .*%]"] = "|cff990066[|rGR|cff990066]|r",
	["%[Battleground%]"] = "|cffff3399[|rBG|cffff3399]|r",
	["%[Battleground Leader%]"] = "|cffff0000[|rBGL|cffff0000]|r",
}

local function AddMessage(frame, text, ...)
	for k, v in pairs(channels) do
		text = gsub(text, k, v)
	end
	--custom channels replaced below
	text = gsub(text, "%[(%w+)%.%s(%w*)%]", "|cffff0000[|r%1|cffff0000]|r") --%2 for channel name replacement instead of channel number
	return hooks[frame](frame, text, ...)
end

--[[
	We enable replacements for ChatFrame1 only.
	To enable it for more Chat Frames replace the
	3 lines below this comment with:

	for i = 1, x do
		h = _G[("%s%d"):format("ChatFrame", i)]
		hooks[h] = h.AddMessage
		h.AddMessage = AddMessage
	end

	Change for i = 1, x do
	x being the amount of chat frames you want to enable channel names for.
	The max chat frames is 7
	e.g.
	for i = 1, 7 do
]]--

h = _G["ChatFrame1"]
hooks[h] = h.AddMessage
h.AddMessage = AddMessage
