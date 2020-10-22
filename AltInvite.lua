
--[[     Alt Invite Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_AltInvite then return end
	local InviteUnit = C_PartyInfo.InviteUnit

	hooksecurefunc("SetItemRef", function(link)
		if IsAltKeyDown() then
			-- Normal chat: player:<name>:<lineId>:WHISPER:<name>
			-- BNet chat: BNplayer:<bNetName>:<bNetGameAccountID>:<lineId>:BN_WHISPER:<bNetName>
			local player = link:match("^player:([^:]+)")
			if player then
				C_PartyInfo.InviteUnit(player)
				-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
				ChatEdit_OnEscapePressed(ChatFrame1EditBox)
			else
				local gameAccountID = link:match("^BNplayer:[^:]+:([^:]+)")
				if gameAccountID then
					local accountInfoTbl = C_BattleNet.GetAccountInfoByID(gameAccountID)
					if accountInfoTbl and accountInfoTbl.gameAccountInfo and accountInfoTbl.gameAccountInfo.gameAccountID then
						BNInviteFriend(accountInfoTbl.gameAccountInfo.gameAccountID)
						-- We use a secure hook to stay clean (avoid taint), but this means a whisper window will open, so we close it.
						ChatEdit_OnEscapePressed(ChatFrame1EditBox)
					end
				end
			end
		end
	end)
end

