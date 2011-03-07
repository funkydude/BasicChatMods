
--[[     Player Names Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	local bcmDB = bcmDB
	bcmDB.nobnet = nil
	if bcmDB.BCM_PlayerNames then bcmDB.nolevel = nil bcmDB.nogroup = nil return end

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
	local AddMessage = function(frame, text, ...)
		text = text:gsub("|Hplayer:(.-):(.+)%[(.-)%]|h", changeName)
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

