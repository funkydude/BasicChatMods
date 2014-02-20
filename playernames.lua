
--[[     Player Names Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	local bcmDB = bcmDB
	if bcmDB.BCM_PlayerNames then --Cleanup vars for disabled modules
		bcmDB.nolevel, bcmDB.nogroup, bcmDB.noMiscColor = nil, nil, nil
		if bcmDB.BCM_BNet then bcmDB.playerLBrack, bcmDB.playerRBrack, bcmDB.playerSeparator = nil, nil, nil end
		return
	end

	if not bcmDB.playerLBrack then bcmDB.playerLBrack = "[" bcmDB.playerRBrack = "]" bcmDB.playerSeparator = ":" end

	local GetGuildRosterInfo, Ambiguate, GetRaidRosterInfo = GetGuildRosterInfo, Ambiguate, GetRaidRosterInfo
	local tostring = tostring

	--[[ Start Harvest Data ]]--
	local nameLevels, nameGroup, nameColor = nil, nil, nil

	if not bcmDB.nolevel then
		nameLevels = {}
		nameLevels[(UnitName("player"))] = tostring((UnitLevel("player")))

		BCM.Events.PLAYER_TARGET_CHANGED = function()
			if UnitIsPlayer("target") and UnitIsFriend("player", "target") then
				local n, s = UnitName("target")
				local l = UnitLevel("target")
				if n and l and l > 0 then
					if s and s ~= "" then n = n.."-"..s end
					nameLevels[n] = tostring(l)
				end
			end
		end
		BCM.Events:RegisterEvent("PLAYER_TARGET_CHANGED")

		BCM.Events.UPDATE_MOUSEOVER_UNIT = function()
			if UnitIsPlayer("mouseover") and UnitIsFriend("player", "mouseover") then
				local n, s = UnitName("mouseover")
				local l = UnitLevel("mouseover")
				if n and l and l > 0 then
					if s and s ~= "" then n = n.."-"..s end
					nameLevels[n] = tostring(l)
				end
			end
		end
		BCM.Events:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	end

	if not bcmDB.nolevel or not bcmDB.nogroup then
		if not bcmDB.nogroup then
			nameGroup = {}
		end
		BCM.Events.GROUP_ROSTER_UPDATE = function()
			if not IsInGroup() then
				if nameGroup then wipe(nameGroup) end
				return
			end

			for i = 1, GetNumGroupMembers() do
				local name, _, subgroup, level = GetRaidRosterInfo(i)
				if nameLevels and name and level and level > 0 then
					nameLevels[name] = tostring(level)
				end
				if nameGroup and name and subgroup then
					nameGroup[name] = tostring(subgroup)
				end
			end
		end
		BCM.Events:RegisterEvent("GROUP_ROSTER_UPDATE")
		BCM.Events.GROUP_ROSTER_UPDATE()
	end

	if not bcmDB.nolevel or not bcmDB.noMiscColor then
		if not bcmDB.noMiscColor then
			nameColor = {}
		end
		BCM.Events.FRIENDLIST_UPDATE = function()
			local _, num = GetNumFriends()
			for i = 1, num do
				local n, l, c = GetFriendInfo(i)
				if nameLevels and n and l and l > 0 then
					nameLevels[n] = tostring(l)
				end
				if nameColor and n and c then
					nameColor[n] = BCM:GetColor(c, true)
				end
			end
		end
		BCM.Events:RegisterEvent("FRIENDLIST_UPDATE")
		ShowFriends()

		if IsInGuild() then
			BCM.Events.GUILD_ROSTER_UPDATE = function(frame)
				local num = GetNumGuildMembers()
				if num == 0 then return end -- Can fire with 0 at login, wait for a valid update
				for i=1, num do
					local n, _, _, l, _, _, _, _, online, _, c = GetGuildRosterInfo(i)
					if n and online then
						n = Ambiguate(n, "none")
						if nameLevels and l and l > 0 then
							nameLevels[n] = tostring(l)
						end
						if nameColor and c then
							nameColor[n] = BCM:GetColor(c)
						end
					end
				end
				-- Cache all names at login
				frame:UnregisterEvent("GUILD_ROSTER_UPDATE")
				frame.GUILD_ROSTER_UPDATE = nil
			end
			BCM.Events:RegisterEvent("GUILD_ROSTER_UPDATE")
		end
	end
	--[[ End Harvest Data ]]--

	local changeName = function(name, misc, nameToChange, colon)
		if misc:len() < 5 and not nameToChange:find("|c", nil, true) then
			--Do this here instead of listening to the guild event, as the event is slower than a player login
			--leading to player logins lacking color/level, unless we held a database of the entire guild.
			--Since the event usually fires when a player logs in, doing it this way should be virtually the same.
			if ((nameColor and not nameColor[name]) or (nameLevels and not nameLevels[name])) then
				for i=1, GetNumGuildMembers() do
					local n, _, _, l, _, _, _, _, _, _, c = GetGuildRosterInfo(i)
					if n then
						n = Ambiguate(n, "none")
						if n == name then
							if nameLevels and l and l > 0 then nameLevels[n] = tostring(l) end
							if nameColor and c then nameColor[n] = BCM:GetColor(c) end
							break
						end
					end
				end
			end
			if nameColor then
				--If the displayed name was an in-chat who result, take the data and color it.
				if not nameColor[name] then
					local num = GetNumWhoResults()
					for i=1, num do
						local n, _, l, _, _, _, c = GetWhoInfo(i)
						if n == name and l and l > 0 then
							if nameLevels then nameLevels[n] = tostring(l) end
							if nameColor and c then nameColor[n] = BCM:GetColor(c) end
							break
						end
					end
				end
				if nameColor[name] then
					nameToChange = "|cFF"..nameColor[name]..nameToChange.."|r"
				end
			end
		end
		if nameLevels and nameLevels[name] then
			nameToChange = (nameLevels[name])..":"..nameToChange
		end
		if nameGroup and nameGroup[name] and IsInRaid() then
			nameToChange = nameToChange..":"..nameGroup[name]
		end
		return "|Hplayer:"..name..misc..bcmDB.playerLBrack..nameToChange..bcmDB.playerRBrack..(colon == ":" and bcmDB.playerSeparator or colon).."|h"
	end
	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		text = text:gsub("|Hplayer:([^:|]+)([^%[]+)%[([^%]]+)%]|h(:?)", changeName)
		return text
	end
end

