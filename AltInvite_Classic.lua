
--[[     Alt Invite Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_AltInvite then return end
	local InviteUnit = InviteUnit
	local BNGetFriendInfoByID = BNGetFriendInfoByID
	local BNInviteFriend = BNInviteFriend

	hooksecurefunc("SetItemRef", function(link)
		if IsAltKeyDown() then
			-- Normal chat: player:<name>:<lineId>:WHISPER:<name>
			-- BNet chat: BNplayer:<bNetName>:<bNetGameAccountID>:<lineId>:BN_WHISPER:<bNetName>
			local player = link:match("^player:([^:]+)")
			if player then
				InviteUnit(player)
				-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
				ChatEdit_OnEscapePressed(ChatFrame1EditBox)
			else
				local bnetAccountID = link:match("^BNplayer:[^:]+:([^:]+)")
				if bnetAccountID then
					local _, _, _, _, _, gameAccountId = BNGetFriendInfoByID(bnetAccountID)
					if gameAccountId then
						BNInviteFriend(gameAccountId)
						-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
						ChatEdit_OnEscapePressed(ChatFrame1EditBox)
					end
				end
			end
		end
	end)
end

