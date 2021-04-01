
--[[     GMOTD Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_GMOTD or not IsInGuild() then return end

	BCM.Events.LOADING_SCREEN_DISABLED = function()
		BCM.Events:UnregisterEvent("LOADING_SCREEN_DISABLED")
		BCM.Events.LOADING_SCREEN_DISABLED = nil
		C_Timer.After(0, function() -- Timers become functional 1 frame after the loading screen is done
			C_Timer.After(2, function()
				local gmotd = GetGuildRosterMOTD()
				if gmotd == "" or gmotd:find("^ +$") then return end
				local info = ChatTypeInfo.GUILD
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(gmotd), info.r, info.g, info.b)
			end)
		end)
	end
	BCM.Events:RegisterEvent("LOADING_SCREEN_DISABLED")
end

