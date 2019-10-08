
--[[     History Module     ]]--

local _, BCM = ...
BCM.earlyModules[#BCM.earlyModules+1] = function()
	if bcmDB.BCM_History then bcmDB.lines, bcmDB.savedChat = nil, nil end

	if not bcmDB.lines then bcmDB.lines = {["ChatFrame1"] = 1000} end
	for k, v in next, bcmDB.lines do
		local f = _G[k]
		f.historyBuffer.maxElements = v
		if k == "ChatFrame2" then
			COMBATLOG_MESSAGE_LIMIT = v -- Blizzard keeps changing the combat log max lines in Blizzard_CombatLog_Refilter... this better not cause taint issues.
		end
	end

	if true and bcmDB.savedChat then
		for k, v in next, bcmDB.savedChat do
			local cF = _G[k]
			if cF then
				local buffer = cF.historyBuffer
				local num = buffer.headIndex
				local prevElements = buffer.elements
				local curTime = GetTime()
				local restore = {
					{message = "|cFF33FF99BasicChatMods|r: ---Begin chat restore---", timestamp = curTime},
				}
				for i = 1, #v do
					local tbl = v[i]
					tbl.timestamp = curTime -- Update timestamp on restored chat. If it's really old, it will show as hidden after the reload.
					restore[#restore+1] = tbl
				end
				restore[#restore+1] = {message = "|cFF33FF99BasicChatMods|r: ---Chat restored from reload---", timestamp = curTime}

				for i = 1, num do -- Restore any early chat we removed (usually addon prints)
					local element = prevElements[i]
					if element then -- Safety
						element.timestamp = curTime
						restore[#restore+1] = element
					end
				end

				buffer.headIndex = #restore
				for i = 1, #restore do
					prevElements[i] = restore[i]
					restore[i] = nil
				end
			end
		end
	end
	bcmDB.savedChat = nil

	if true then -- XXX add an option
		local isReloadingUI = 0

		BCM.Events.PLAYER_LOGOUT = function()
			if (GetTime() - isReloadingUI) > 2 then return end

			bcmDB.savedChat = {}
			for cfNum = 1, BCM.chatFrames do
				if cfNum ~= 2 then -- No combat log
					local name = ("ChatFrame%d"):format(cfNum)
					local cf = _G[name]
					if cf then
						local tbl = {1, 2, 3, 4, 5}
						local num = cf.historyBuffer.headIndex
						local tblCount = 5
						for i = num, -10, -1 do
							if i > 0 then
								if type(cf.historyBuffer.elements[i]) == "table" and cf.historyBuffer.elements[i].message then -- Compensate for nil entries
									tbl[tblCount] = cf.historyBuffer.elements[i]
									tblCount = tblCount - 1
									if tblCount == 0 then
										break
									end
								end
							else -- Compensate for less than 5 lines of history
								if tblCount > 0 then
									tremove(tbl, tblCount)
									tblCount = tblCount - 1
								else
									break
								end
							end
						end
						if #tbl > 0 then
							bcmDB.savedChat[name] = tbl
						end
					end
				end
			end
		end
		BCM.Events:RegisterEvent("PLAYER_LOGOUT")

		BCM.Events.LOADING_SCREEN_ENABLED = function()
			isReloadingUI = GetTime()
		end
		BCM.Events:RegisterEvent("LOADING_SCREEN_ENABLED")
	end
end
