
--[[     GMOTD Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_GMOTD then return end

	if IsInGuild() then
		f.fire.t = GetTime()
		f.fire:SetScript("OnUpdate", function(frame)
			if (GetTime() - frame.t) > 10 then
				local info = ChatTypeInfo.GUILD
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(GetGuildRosterMOTD()), info.r, info.g, info.b)
				frame.t = nil
				frame:SetScript("OnUpdate", nil)
			end
		end)
	end
end

