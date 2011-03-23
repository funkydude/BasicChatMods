
--[[     BCM Core     ]]--

local _, f = ...

--[[ Common Functions ]]--
function f:GetColor(className, isLocal)
	if isLocal then
		local found
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == className then className = k found = true break end
		end
		if not found then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == className then className = k break end
			end
		end
	end
	local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[className] or RAID_CLASS_COLORS[className]
	local color = ("%02x%02x%02x"):format(tbl.r*255, tbl.g*255, tbl.b*255)
	return color
end

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
				ChatFrame1:AddMessage("|cFF33FF99BasicChatMods|r: "..(GUILD_MOTD_TEMPLATE):format(GetGuildRosterMOTD()), info.r, info.g, info.b)
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
		--XXX needs own module
		local cF = _G[format("%s%d", "ChatFrame", i)]
		if i ~= 2 and #cF.messageTypeList > 0 then
			cF:SetMaxLines(1000)
		end

		--Allow arrow keys editing in the edit box
		local eB =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
		eB:SetAltArrowKeyMode(false)

		--Allow resizing chatframes to whatever size you wish!
		--XXX needs own module
		cF:SetMinResize(100,10)
		cF:SetMaxResize(0,0)
	end
end)

--These need to be set before PLAYER_LOGIN
for i=1, 10 do
	local cF = _G[format("%s%d", "ChatFrame", i)]
	--Allow the chat frame to move to the end of the screen
	cF:SetClampRectInsets(0,0,0,0)
end
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

