bcmChannelnames = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")
local bcmChannelnames = bcmChannelnames

BCM_CHANNELNAMES_REGEXPS = {
	["%[Guild%]"] = "[G]",
	["%[Party%]"] = "[P]",
	["%[Raid%]"] = "[R]",
	["%[Raid Leader%]"] = "|cffff3399[|rRL|cffff3399]|r",
	["%[Raid Warning%]"] = "|cffff0000[|rRW|cffff0000]|r",
	["%[Officer%]"] = "[O]",
	["%[%d+%. WorldDefense%]"] = "|cff990066[|rWD|cff990066]|r",
	["%[%d+%. LookingForGroup%]"] = "[LFG]",
	["%[%d+%. General%]"] = "|cff990066[|rGEN|cff990066]|r",
	["%[%d+%. LocalDefense%]"] = "|cff990066[|rLD|cff990066]|r",
	["%[%d+%. Trade%]"] = "|cff990066[|rT|cff990066]|r",
	["%[%d+%. GuildRecruitment %- .*%]"] = "|cff990066[|rGR|cff990066]|r",
	["%[Battleground%]"] = "|cffff3399[|rBG|cffff3399]|r",
	["%[Battleground Leader%]"] = "|cffff0000[|rBGL|cffff0000]|r",
}

local customChannels = {
	["%[(%w+)%.%s(%w*)%]"] = "[%1]", --%2 for channel names instead of numbers
}

function bcmChannelnames:OnEnable()
	local _G = getfenv(0)
	self:Hook(_G["ChatFrame1"], "AddMessage", true)
end

function bcmChannelnames:AddMessage(frame, text, r, g, b, id)
	if type(text) == "string" then
		for k, v in pairs(BCM_CHANNELNAMES_REGEXPS) do
			text = text:gsub(k, v)
		end
		for k, v in pairs(customChannels) do
			text = text:gsub(k, v)
		end
	end
	return self.hooks[frame].AddMessage(frame, text, r, g, b, id)
end

