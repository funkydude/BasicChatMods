
--[[     GMOTD Module     ]]--

local _, BCM = ...
BCM.earlyModules[#BCM.earlyModules+1] = function()
	if bcmDB.BCM_GMOTD then return end

	local gmotd = C_GuildInfo and C_GuildInfo.GetMOTD and C_GuildInfo.GetMOTD() or GetGuildRosterMOTD()
	BCM.Events.LOADING_SCREEN_DISABLED = function()
		BCM.Events:UnregisterEvent("LOADING_SCREEN_DISABLED")
		BCM.Events.LOADING_SCREEN_DISABLED = nil
		BCM.Events:UnregisterEvent("GUILD_MOTD")
		BCM.Events.GUILD_MOTD = nil

		C_Timer.After(0, function() -- Timers become functional 1 frame after the loading screen is done
			C_Timer.After(2, function()
				if not gmotd or gmotd == "" or gmotd:find("^ +$") then return end
				local info = ChatTypeInfo.GUILD
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(gmotd), info.r, info.g, info.b)
			end)
		end)
	end
	BCM.Events:RegisterEvent("LOADING_SCREEN_DISABLED")
	BCM.Events.GUILD_MOTD = function(_, msg)
		gmotd = msg
	end
	BCM.Events:RegisterEvent("GUILD_MOTD")
end

