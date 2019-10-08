
--[[     Alt Invite Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_AltInvite then return end
	local InviteUnit = C_PartyInfo.InviteUnit

	hooksecurefunc("SetItemRef", function(link)
		if IsAltKeyDown() then
			local player = link:match("^player:([^:]+)")
			InviteUnit(player)
			-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
			ChatEdit_OnEscapePressed(ChatFrame1EditBox)
		end
	end)
end

