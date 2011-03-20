
--[[     Player Names Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	local bcmDB = bcmDB
	if bcmDB.BCM_PlayerNames then bcmDB.nolevel = nil bcmDB.nogroup = nil bcmDB.playerNameLBrack = nil bcmDB.playerNameRBrack = nil return end

	local newAddMsg = {}
	if not bcmDB.playerNameLBrack then bcmDB.playerNameLBrack = "[" end
	if not bcmDB.playerNameRBrack then bcmDB.playerNameRBrack = "]:" end

	--[[ Harvest Levels ]]--
	local nameLevels, nameGroup
	if not bcmDB.nolevel or not bcmDB.nogroup then
		nameLevels, nameGroup = {}, {}
		local frame = CreateFrame("Frame", "BCM_PlayerName_Harvest")
		nameLevels[UnitName("player")] = tostring(UnitLevel("player"))
		frame:SetScript("OnEvent", function(_, event)
			if event == "PLAYER_TARGET_CHANGED" and not bcmDB.nolevel then
				if UnitIsPlayer("target") and UnitFactionGroup("player") == UnitFactionGroup("target") then
					local n, l = UnitName("target")
					if n and l and l > 0 then
						nameLevels[n] = tostring(l)
					end
				end
			elseif event == "GUILD_ROSTER_UPDATE" and not bcmDB.nolevel then
				if not IsInGuild() then return end
				for i=1, GetNumGuildMembers() do 
					local n, _, _, l, _, _, _, _, online = GetGuildRosterInfo(i) 
					if online and n and l and l > 0 then 
						nameLevels[n] = tostring(l)
					end 
				end
			elseif event == "RAID_ROSTER_UPDATE" and not bcmDB.nogroup then
				wipe(nameGroup)
				if UnitInRaid("player") then
					for i=1, GetNumRaidMembers() do
						local n, _, g = GetRaidRosterInfo(i)
						if n and g then nameGroup[n] = tostring(g) end
					end
				end
			elseif event == "PARTY_MEMBERS_CHANGED" and not bcmDB.nolevel then
				for i=1, GetNumPartyMembers() do
					local n = UnitName("party"..i)
					local l = UnitLevel("party"..i)
					if n and l and l > 0 then nameLevels[n] = tostring(l) end
				end
			elseif event == "UPDATE_MOUSEOVER_UNIT" and not bcmDB.nolevel then
				if UnitIsPlayer("mouseover") and UnitFactionGroup("player") == UnitFactionGroup("mouseover") then
					local n, l = UnitName("mouseover"), UnitLevel("mouseover")
					if n and l and l > 0 then
						nameLevels[n] = tostring(l)
					end
				end
			elseif event == "FRIENDLIST_UPDATE" and not bcmDB.nolevel then
				for i = 1, GetNumFriends() do
					local n, l = GetFriendInfo(i)
					if n and l and l > 0 then
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
	end

	local changeDetailedName = function(name, misc, nameToChange, colon)
		if not bcmDB.nolevel and nameLevels and nameLevels[name] then
			nameToChange = (nameLevels[name])..":"..nameToChange
		end
		if not bcmDB.nogroup and nameGroup and nameGroup[name] then
			nameToChange = nameToChange..":"..nameGroup[name]
		end
		local rBrack = bcmDB.playerNameRBrack --Don't add colon for events where no colon exists
		if colon == "" and rBrack:find(":$") then rBrack = rBrack:sub(0,-2) end
		return "|Hplayer:"..name..misc..bcmDB.playerNameLBrack..nameToChange..rBrack.."|h "
	end
	--local changeName = function(name, nameToChange)
	--	
	--	return "|Hplayer:"..name.."|h%"..bcmDB.playerNameLBrack..nameToChange..rBrack.."|h"
	--end
	local AddMessage = function(frame, text, ...)
		text = text:gsub("|Hplayer:(.-)(:.-)%[(.-)%]|h(:?) ", changeDetailedName)
		--text = text:gsub("|Hplayer:(.-)|h%[(.-)%]|h", changeName)
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

