
--[[     History Module     ]]--

local _, BCM = ...
BCM.earlyModules[#BCM.earlyModules+1] = function()
	if bcmDB.BCM_History then bcmDB.lines, bcmDB.savedChat = nil, nil end

	if not bcmDB.lines then bcmDB.lines = {["ChatFrame1"] = 1000} end
	for k, v in next, bcmDB.lines do
		local f = _G[k]
		f:SetMaxLines(v)
		if k == "ChatFrame2" then
			COMBATLOG_MESSAGE_LIMIT = v -- Blizzard keeps changing the combat log max lines in Blizzard_CombatLog_Refilter... this better not taint.
		end
	end

	if true and bcmDB.savedChat then
		for k, v in next, bcmDB.savedChat do
			for i = 1, #v do
				local cF = _G[k]
				if cF then
					cF:AddMessage(unpack(v[i]))
				end
			end
		end
		print("|cFF33FF99BasicChatMods|r: ", "Chat restored from reload.")
	end
	bcmDB.savedChat = nil

	if true then -- XXX add an option
		local isReloadingUI = 0

		BCM.Events.PLAYER_LOGOUT = function()
			if (GetTime() - isReloadingUI) > 2 then return end

			bcmDB.savedChat = {}
			for i = 1, BCM.chatFrames do
				local name = ("ChatFrame%d"):format(i)
				local cf = _G[name]
				if cf:IsVisible() then
					local tbl = {}
					bcmDB.savedChat[name] = tbl
					local num = cf:GetNumMessages()
					local count = num > 5 and num - 5 or 1
					local timestampNum = 1
					for i = count, num do
						tbl[#tbl+1] = {cf:GetMessageInfo(i)}
						-- Fix timestamp module (if enabled)
						tbl[#tbl][1]:gsub("(BCMt:)%d+", "%1"..timestampNum)
						timestampNum = timestampNum + 1
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

