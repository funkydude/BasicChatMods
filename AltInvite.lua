
--[[     Alt Invite Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	bcmDB.BCM_InviteLinks = nil -- XXX temp, old invite links module was removed so lets remove the DB entry

	if bcmDB.BCM_AltInvite then return end

	hooksecurefunc("SetItemRef", function(link)
		if IsAltKeyDown() then
			local player = link:match("^player:([^:]+)")
			InviteToGroup(player)
			-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
			ChatEdit_OnEscapePressed(ChatFrame1EditBox)
		end
	end)
end

