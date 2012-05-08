
--[[     Player Names Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	local bcmDB = bcmDB
	bcmDB.playerNameLBrack = nil --temp
	bcmDB.playerNameRBrack = nil --temp
	if bcmDB.BCM_PlayerNames then --Cleanup vars for disabled modules
		bcmDB.nolevel, bcmDB.nogroup, bcmDB.noMiscColor = nil, nil, nil
		if bcmDB.BCM_BNet then bcmDB.playerLBrack, bcmDB.playerRBrack, bcmDB.playerSeparator = nil, nil, nil end
		return
	end

	if not bcmDB.playerLBrack then bcmDB.playerLBrack = "[" bcmDB.playerRBrack = "]" bcmDB.playerSeparator = ":" end

	--[[ Start Harvest Data ]]--
	local nameLevels, nameGroup, nameColor = nil, nil, nil

	if not bcmDB.nolevel then
		nameLevels = {}
		nameLevels[UnitName("player")] = tostring(UnitLevel("player"))

		BCM.Events.PLAYER_TARGET_CHANGED = function()
			if UnitIsPlayer("target") and UnitIsFriend("player", "target") then
				local n, l = UnitName("target"), UnitLevel("target")
				if n and l and l > 0 then
					nameLevels[n] = tostring(l)
				end
			end
		end
		BCM.Events:RegisterEvent("PLAYER_TARGET_CHANGED")

		BCM.Events.PARTY_MEMBERS_CHANGED = function()
			for i=1, GetNumPartyMembers() do
				local n = UnitName("party"..i)
				local l = UnitLevel("party"..i)
				if n and l and l > 0 then nameLevels[n] = tostring(l) end
			end
		end
		BCM.Events:RegisterEvent("PARTY_MEMBERS_CHANGED")

		BCM.Events.UPDATE_MOUSEOVER_UNIT = function()
			if UnitIsPlayer("mouseover") and UnitIsFriend("player", "mouseover") then
				local n, l = UnitName("mouseover"), UnitLevel("mouseover")
				if n and l and l > 0 then
					nameLevels[n] = tostring(l)
				end
			end
		end
		BCM.Events:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end

	if not bcmDB.nogroup then
		nameGroup = {}
		BCM.Events.RAID_ROSTER_UPDATE = function()
			wipe(nameGroup)
			if UnitInRaid("player") then
				for i=1, GetNumRaidMembers() do
					local n, _, g = GetRaidRosterInfo(i)
					if n and g then nameGroup[n] = tostring(g) end
				end
			end
		end
		BCM.Events:RegisterEvent("RAID_ROSTER_UPDATE")
	end

	if not bcmDB.noMiscColor then
		nameColor = {}
	end

	if not bcmDB.nogroup or not bcmDB.noMiscColor then
		BCM.Events.FRIENDLIST_UPDATE = function()
			local _, num = GetNumFriends()
			for i = 1, num do
				local n, l, c = GetFriendInfo(i)
				if n and l and l > 0 then
					if nameLevels then nameLevels[n] = tostring(l) end
					if nameColor then nameColor[n] = BCM:GetColor(c, true) end
				end
			end
		end
		BCM.Events:RegisterEvent("FRIENDLIST_UPDATE")

		if IsInGuild() then
			for i=1, GetNumGuildMembers() do
				local n, _, _, l, _, _, _, _, online, _, c = GetGuildRosterInfo(i)
				if online and n and l and l > 0 then
					if nameLevels then nameLevels[n] = tostring(l) end
					if nameColor then nameColor[n] = BCM:GetColor(c) end
				end
			end
		end
	end
	--[[ End Harvest Data ]]--

	local changeName = function(name, misc, nameToChange, colon)
		if misc:len() < 5 then
			--Do this here instead of listening to the guild event, as the event is slower than a player login
			--leading to player logins lacking color/level, unless we held a database of the entire guild.
			--Since the event usually fires when a player logs in, doing it this way should be virtually the same.
			if ((nameColor and not nameColor[name]) or (nameLevels and not nameLevels[name])) and UnitIsInMyGuild(name) then
				for i=1, GetNumGuildMembers() do
					local n, _, _, l, _, _, _, _, _, _, c = GetGuildRosterInfo(i)
					if n == name and l and l > 0 then
						if nameLevels then nameLevels[n] = tostring(l) end
						if nameColor then nameColor[n] = BCM:GetColor(c) end
						break
					end
				end
			end
			if nameColor and nameColor[name] then
				nameToChange = "|cFF"..nameColor[name]..nameToChange.."|r"
			end
		end
		if nameLevels and nameLevels[name] then
			nameToChange = (nameLevels[name])..":"..nameToChange
		end
		if nameGroup and nameGroup[name] then
			nameToChange = nameToChange..":"..nameGroup[name]
		end
		return "|Hplayer:"..name..misc..bcmDB.playerLBrack..nameToChange..bcmDB.playerRBrack..(colon == ":" and bcmDB.playerSeparator or colon).."|h"
	end
	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		text = text:gsub("|Hplayer:(%S-)([:|]%S-)%[(%S- ?%S*)%]|h(:?)", changeName)
		return text
	end
end

