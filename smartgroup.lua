
--[[    Smart Group Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--if bcmDB.BCM_SmartGroup then return end -- XXX add config

	SlashCmdList["SMARTGROUP"] = function(msg)
		if msg and msg:len() > 0 then
			SendChatMessage(msg, (IsInGroup(2) and "INSTANCE_CHAT") or (IsInRaid() and "RAID") or (IsInGroup() and "PARTY") or "SAY")
		end
	end
	SLASH_SMARTGROUP1 = "/gr"
	SLASH_SMARTGROUP2 = "/group"
end

