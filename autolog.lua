
--[[     Auto Log Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_AutoLog then bcmDB.logchat = nil bcmDB.logcombat = nil return end

	if bcmDB.logchat then
		print("|cFF33FF99BasicChatMods|r: ", CHATLOGENABLED)
		LoggingChat(true)
	end

	if bcmDB.logcombat then
		local isLoggingCombat = nil
		BCM.Events.ZONE_CHANGED_NEW_AREA = function()
			local _, type = GetInstanceInfo()
			if type == "raid" then
				if not isLoggingCombat then
					isLoggingCombat = true
					print("|cFF33FF99BasicChatMods|r: ", COMBATLOGENABLED)
					LoggingCombat(true)
				end
			else
				if isLoggingCombat then
					isLoggingCombat = nil
					print("|cFF33FF99BasicChatMods|r: ", COMBATLOGDISABLED)
					LoggingCombat(false)
				end
			end
		end
		BCM.Events:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		BCM.Events.ZONE_CHANGED_NEW_AREA()
	end
end

