
--[[     GMOTD Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if not IsInGuild() or bcmDB.BCM_GMOTD then return end

	BCM.Events.t = GetTime()
	BCM.Events.count = 0
	BCM.Events:SetScript("OnUpdate", function(frame)
		if (GetTime() - frame.t) > 10 then
			local gmotd = GetGuildRosterMOTD()
			if gmotd == "" then
				if frame.count > 2 then
					frame.t = nil
					frame.count = nil
					frame:SetScript("OnUpdate", nil)
				else
					frame.t = GetTime() - 7
					frame.count = frame.count + 1
				end
			else
				local info = ChatTypeInfo.GUILD
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(GetGuildRosterMOTD()), info.r, info.g, info.b)
				frame.t = nil
				frame.count = nil
				frame:SetScript("OnUpdate", nil)
			end
		end
	end)
end

