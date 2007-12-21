
--[[		Channel Name Module		]]--
local bcmChannelNames = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")
local gsub = string.gsub
local pairs = pairs

--[[		Replacements		]]--
local BCM_CHANNELS = {
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
	--custom channels replaced below
	["%[(%w+)%.%s(%w*)%]"] = "|cffff0000[|r%1|cffff0000]", --%2 for channel name replacement instead of channel number
}

--[[
	We enable replacements for ChatFrame1 only.
	To enable it for more chatframes add the lines in OnEnable()
	An example is already added of how to enable it for ChatFrame3
	but commented out.
]]--

function bcmChannelNames:OnEnable()
	local _G = getfenv(0)
	self:Hook(_G["ChatFrame1"], "AddMessage", true)
	--self:Hook(_G["ChatFrame3"], "AddMessage", true)
end

function bcmChannelNames:AddMessage(frame, text, r, g, b, id)
	for k, v in pairs(BCM_CHANNELS) do
		text = gsub(text, k, v)
	end
	return self.hooks[frame].AddMessage(frame, text, r, g, b, id)
end

