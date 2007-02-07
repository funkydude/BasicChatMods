scmChannelnames = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

local _G = getfenv(0)

SCM_CHANNELNAMES_REGEXPS = {
	["%[Guild%]"] = "(G)",
	["%[Party%]"] = "(P)",
	["%[Raid%]"] = "(R)",
	["%[Raid Leader%]"] = "|cffff3399(|rRL|cffff3399)|r",
	["%[Raid Warning%]"] = "|cffff0000(|rRW|cffff0000)|r",
	["%[Officer%]"] = "(O)",
	["%[%d+%. WorldDefense%]"] = "|cff990066(|rWD|cff990066)|r",
	["%[%d+%. General.-%]"] = "|cff990066(|rGEN|cff990066)|r",
	["%[%d+%. LocalDefense.-%]"] = "|cff990066(|rLD|cff990066)|r",
	["%[%d+%. Trade.-%]"] = "|cff990066(|rT|cff990066)|r",
	["%[Battleground%]"] = "|cffff3399(|rBG|cffff3399)|r",
	["%[Battleground Leader%]"] = "|cffff0000(|rBGL|cffff0000)|r",
	["%[%d+%.%s(.-)%]"] = "|cff990066(|r%1|cff990066)|r",
}

function scmChannelnames:OnEnable()
	for i = 1, 7 do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
end

function scmChannelnames:AddMessage(frame, text, r, g, b, id)
	if type(text) == "string" then
		for k, v in pairs(SCM_CHANNELNAMES_REGEXPS) do
			text = text:gsub(k, v)
		end
	end
	return self.hooks[frame].AddMessage(frame, text, r, g, b, id)
end

