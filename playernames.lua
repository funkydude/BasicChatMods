
--[[     Player Names Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	local bcmDB = bcmDB
	if bcmDB.BCM_PlayerNames then bcmDB.nolevel = nil bcmDB.nogroup = nil bcmDB.nobnet = nil return end

	local newAddMsg, nameLevels, nameGroup, frame = {}, {}, {}, CreateFrame("Frame")

	--[[ Harvest Levels ]]--
	nameLevels[UnitName("player")] = tostring(UnitLevel("player"))
	frame:SetScript("OnEvent", function(_, event)
		if event == "PLAYER_TARGET_CHANGED" and not bcmDB.nolevel then
			if UnitIsPlayer("target") and UnitFactionGroup("player") == UnitFactionGroup("target") then
				nameLevels[UnitName("target")] = tostring(UnitLevel("target"))
			end
		elseif event == "GUILD_ROSTER_UPDATE" and not bcmDB.nolevel then
			if not IsInGuild() then return end
			for i=1, GetNumGuildMembers() do 
				local n, _, _, l, _, _, _, _, online = GetGuildRosterInfo(i) 
				if online then 
					nameLevels[n] = tostring(l)
				end 
			end
		elseif event == "RAID_ROSTER_UPDATE" and not bcmDB.nogroup then
			wipe(nameGroup)
			if UnitInRaid("player") then
				for i=1, GetNumRaidMembers() do
					local n, _, g = GetRaidRosterInfo(i)
					nameGroup[n] = tostring(g)
				end
			end
		elseif event == "PARTY_MEMBERS_CHANGED" and not bcmDB.nolevel then
			for i=1, GetNumPartyMembers() do
				local n = UnitName("party"..i)
				local l = UnitLevel("party"..i)
				nameLevels[n] = tostring(l)
			end
		elseif event == "UPDATE_MOUSEOVER_UNIT" and not bcmDB.nolevel then
			if UnitIsPlayer("mouseover") and UnitFactionGroup("player") == UnitFactionGroup("mouseover") then
				nameLevels[UnitName("mouseover")] = tostring(UnitLevel("mouseover"))
			end
		elseif event == "FRIENDLIST_UPDATE" and not bcmDB.nolevel then
			for i = 1, GetNumFriends() do
				local n, l = GetFriendInfo(i)
				if n and l then
					nameLevels[n] = tostring(l)
				end
			end
		end
	end)
	frame:RegisterEvent("PLAYER_TARGET_CHANGED")
	frame:RegisterEvent("RAID_ROSTER_UPDATE")
	frame:RegisterEvent("GUILD_ROSTER_UPDATE")
	frame:RegisterEvent("PARTY_MEMBERS_CHANGED")
	frame:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	frame:RegisterEvent("FRIENDLIST_UPDATE")

	local changeName = function(name, misc, nameToChange)
		if not bcmDB.nolevel and nameLevels[name] then
			nameToChange = (nameLevels[name])..":"..nameToChange
		end
		if not bcmDB.nogroup and nameGroup[name] then
			nameToChange = nameToChange..":"..nameGroup[name]
		end
		return ("|Hplayer:%s:%s[%s]|h"):format(name, misc, nameToChange)
	end
	local changeBnetName = function(misc, id, moreMisc, fakeName)
		local englishClass = select(7, BNGetToonInfo(id))
		local class
		for k,v in pairs(LOCALIZED_CLASS_NAMES_FEMALE) do
			if v == englishClass then class = k break end
		end
		if not class then
			for k,v in pairs(LOCALIZED_CLASS_NAMES_MALE) do
				if v == englishClass then class = k break end
			end
		end
		local tbl = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class]
		local color = ("|cFF%02x%02x%02x%s|r"):format(tbl.r*255, tbl.g*255, tbl.b*255, fakeName)
		return ("|HBNplayer:%s|k:%s:%s|h[%s]|h"):format(misc, id, moreMisc, color)
	end
	local AddMessage = function(frame, text, ...)
		if not bcmDB.nolevel or not bcmDB.nogroup then
			text = text:gsub("|Hplayer:(.-):(.+)%[(.-)%]|h", changeName)
		end
		if not bcmDB.nobnet then
			text = text:gsub("|HBNplayer:(.+)|k:(%d-):(.+)|h%[(.-)%]|h", changeBnetName)
		end
		--|Hplayer:Name:185:WHISPER:NAME|h[|cffc69b6dName|r]|h whispers: test 5
		--|HBNplayer:|Kf17|k0000000000000000|k:17:93:BN_WHISPER:|Kf17|k0000000000000000|k|h[|Kf17|k0000000000000000|k]|h whispers: hi

		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 and #cF.messageTypeList > 0 then
			newAddMsg[format("%s%d", "ChatFrame", i)] = cF.AddMessage
			cF.AddMessage = AddMessage
		end
	end
end

