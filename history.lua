
--[[     History Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_History then bcmDB.lines = nil return end

	if not bcmDB.lines then bcmDB.lines = {["ChatFrame1"] = 1000} end
	for k, v in pairs(bcmDB.lines) do
		local f, tbl = _G[k], {}

		for i = 1, f:GetNumMessages() do
			local text, accessID, lineID, extraData = f:GetMessageInfo(i)
			local cType = ChatHistory_GetChatType(extraData)
			local info = ChatTypeInfo[cType]
			if not info then -- Message was probably printed by an addon
				for i = select("#", f:GetRegions()), 1, -1 do
					local region = select(i, f:GetRegions())
					if region:GetObjectType() == "FontString" and text == region:GetText() then
						local r, g, b = region:GetTextColor()
						tbl[#tbl+1] = {text, r, g, b, lineID, false, accessID, extraData}
						break
					end
				end
				
			else -- Normal chat message
				tbl[#tbl+1] = {text, info.r, info.g, info.b, lineID, false, accessID, extraData}
			end
		end
		f:SetMaxLines(v) --Set the max lines (Also clears the Chat Frame).
		if k == "ChatFrame2" then
			COMBATLOG_MESSAGE_LIMIT = v -- Blizzard keeps changing the combat log max lines in Blizzard_CombatLog_Refilter... this better not taint.
		end

		--Restore all chat.
		for i = 1, #tbl do
			f:AddMessage(unpack(tbl[i]))
			wipe(tbl[i])
		end
		wipe(tbl)
		tbl=nil
	end
end

