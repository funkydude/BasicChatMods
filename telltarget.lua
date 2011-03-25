
--[[    Tell Target Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_TellTarget then return end

	SlashCmdList["TELLTARGET"] = function(msg)
		if UnitIsPlayer("target") and UnitIsFriend("player", "target") and msg and msg:len() > 0 then
			local name, realm = UnitName("target")
			if realm then
				name = name.."-"..realm
			end
			SendChatMessage(msg, "WHISPER", nil, name)
		end
	end
	SLASH_TELLTARGET1 = "/tt"
	SLASH_TELLTARGET2 = "/wt"
end

