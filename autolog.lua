
--[[     Auto Log Module     ]]--

local _, f = ...
f.modules[#f.modules+1] = function()
	if bcmDB.BCM_AutoLog then bcmDB.logchat = nil bcmDB.logcombat = nil return end

	if bcmDB.logchat then
		LoggingChat(true)
		print("|cFF33FF99BasicChatMods|r: ", CHATLOGENABLED)
	end

	if bcmDB.logcombat then
		local isLoggingCombat = nil
		local _, type = GetInstanceInfo()
		if type == "raid" then
			LoggingCombat(true)
			isLoggingCombat = true
			print("|cFF33FF99BasicChatMods|r: ", COMBATLOGENABLED)
		end

		local doLogCombat = CreateFrame("Frame")
		doLogCombat:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		doLogCombat:SetScript("OnEvent", function()
			local _, type = GetInstanceInfo()
			if type == "raid" then
				if not isLoggingCombat then
					LoggingCombat(true)
					isLoggingCombat = true
					print("|cFF33FF99BasicChatMods|r: ", COMBATLOGENABLED)
				end
			else
				if isLoggingCombat then
					LoggingCombat(false)
					isLoggingCombat = nil
					print("|cFF33FF99BasicChatMods|r: ", COMBATLOGDISABLED)
				end
			end
		end)
	end
end

