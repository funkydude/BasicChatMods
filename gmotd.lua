
--[[     GMOTD Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_GMOTD or not IsInGuild() then return end

	BCM.Events.t = GetTime()
	BCM.Events.count = 1
	BCM.Events:SetScript("OnUpdate", function(frame)
		if (GetTime() - frame.t) > 10 then
			local gmotd = GetGuildRosterMOTD()
			--Sometimes the GMOTD isn't available at login/reload due to lag.
			--We delay printing until it is available, but we can't assume that
			--no GMOTD means it isn't available, it might mean no GMOTD was set.
			--If it's still blank after 5 attempts, there probably isn't one set.
			if gmotd == "" or gmotd:find("^ +$") then
				if frame.count > 4 then
					frame.t = nil
					frame.count = nil
					frame:SetScript("OnUpdate", nil)
				else
					frame.t = GetTime() - 7
					frame.count = frame.count + 1
				end
			else
				local info = ChatTypeInfo.GUILD
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(gmotd), info.r, info.g, info.b)
				frame.t = nil
				frame.count = nil
				frame:SetScript("OnUpdate", nil)
			end
		end
	end)
end

