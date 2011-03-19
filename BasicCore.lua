
--[[     BCM Core     ]]--

local _, f = ...
f.functions = {}
f.fire = CreateFrame("Frame")
f.fire:RegisterEvent("PLAYER_LOGIN")
f.fire:SetScript("OnEvent", function()
	--[[ Check Database ]]--
	if type(bcmDB) ~= "table" then bcmDB = {} end
	if not bcmDB.v then
		bcmDB.v = 1
		bcmDB.BCM_AutoLog = true
		bcmDB.BCM_PlayerNames = true
	end

	--[[ Run Modules ]]--
	for i = 1, #f.functions do
		f.functions[i]()
		f.functions[i] = nil
	end

	--[[ Re-MotD ]]--
	if IsInGuild() then
		f.fire.t = GetTime()
		f.fire:SetScript("OnUpdate", function(frame)
			if (GetTime() - frame.t) > 10 then
				local info = ChatTypeInfo.GUILD
				for i=1, 10 do
					local cF = _G[("%s%d"):format("ChatFrame", i)]
					for j=1, #cF.messageTypeList do
						if cF.messageTypeList[j] == "GUILD" then
							cF:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(GetGuildRosterMOTD()), info.r, info.g, info.b)
						end
					end
				end
				frame.t = nil
				frame:SetScript("OnUpdate", nil)
			end
		end)
	end

	--[[ Self-Cleanup ]]--
	f.functions = nil
	f.fire:UnregisterEvent("PLAYER_LOGIN")
	f.fire:SetScript("OnEvent", nil)
	f.fire = nil

	for i=1, 10 do
		--Increase message history
		local cF = _G[format("%s%d", "ChatFrame", i)]
		if i ~= 2 and #cF.messageTypeList > 0 then
			cF:SetMaxLines(1000)
		end

		--Allow arrow keys editing in the edit box
		local eB =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		eB:SetAltArrowKeyMode(false)
	end
end)

--These need to be set before PLAYER_LOGIN
for i=1, 10 do
	--Allow resizing chatframes to whatever size you wish!
	local cF = _G[format("%s%d", "ChatFrame", i)]
	cF:SetMinResize(0,0)
	cF:SetMaxResize(0,0)

	--Allow the chat frame to move to the end of the screen
	cF:SetClampRectInsets(0,0,0,0)
end
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

