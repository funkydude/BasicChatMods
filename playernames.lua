scmPlayernames = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1")

SCM_PLAYERNAMES_LEFTBRACKET = "<"
SCM_PLAYERNAMES_RIGHTBRACKET = ">"
SCM_PLAYERNAMES_MOUSEOVER = nil

scmPlayernames.Colors = {
	DRUID   = "ff7c0a",
	HUNTER  = "aad372",
	MAGE    = "68ccef",
	PALADIN = "f48cba",
	PRIEST  = "ffffff",
	ROGUE   = "fff468",
	SHAMAN  = "00dbba",
	WARLOCK = "9382c9",
	WARRIOR = "c69b6d"
}
scmPlayernames.Names = {}

local _G = getfenv(0)

function scmPlayernames:OnEnable()
	for i=1,NUM_CHAT_WINDOWS do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
	self:RegisterBucketEvent("FRIENDLIST_UPDATE", 5, "updateFriends")
	self:RegisterBucketEvent("GUILD_ROSTER_UPDATE", 5, "updateGuild")
	self:RegisterBucketEvent("RAID_ROSTER_UPDATE", 5, "updateRaid")
	self:RegisterBucketEvent("PARTY_MEMBERS_CHANGED", 5, "updateParty")
	self:RegisterBucketEvent("WHO_LIST_UPDATE", 5, "updateWho")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "updateTarget")
	self:RegisterEvent("CHAT_MSG_SYSTEM", "updateSystem")
	if SCM_PLAYERNAMES_MOUSEOVER then
		self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "updateMouseover")
	end

	local pclass = select(2, UnitClass("player"))
	self:addName(UnitName("player"), pclass)

	if IsInGuild() then
		GuildRoster()
	end
	if GetNumFriends() > 0 then
		ShowFriends()
	end
end

function scmPlayernames:updateFriends()
	local Name, Class
	for i = 1, GetNumFriends() do
		Name, _, Class = GetFriendInfo(i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:updateGuild()
	local Name, Class
	for i = 1, GetNumGuildMembers() do
		Name, _, _, _, Class = GetGuildRosterInfo(i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:updateRaid()
	local Name, Class
	for i = 1, GetNumRaidMembers() do
		Name, _, _, _, _, Class = GetRaidRosterInfo(i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:updateParty()
	local Name, Class
	for i = 1, GetNumPartyMembers() do
		Name = UnitName("party" .. i)
		Class = select(2, UnitClass("party" .. i))
		self:addName(Name, Class)
	end
end

function scmPlayernames:updateTarget()
	if not UnitExists("target") or not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then return end
	local Class = select(2, UnitClass("target"))
	self:addName(UnitName("target"), Class)
end

function scmPlayernames:updateMouseover()
	if not UnitExists("mouseover") or not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then return end
	local Class = select(2, UnitClass("mouseover"))
	self:addName(UnitName("mouseover"), Class)
end

function scmPlayernames:updateSystem( msg )
	local name, class = select(3, msg:find("^|Hplayer:%w+|h%[(%w+)%]|h: Level %d+ %w+ (%w+) %- .+$"))
	if name and class then 
		self:addName(name, class) 
	end
end

function scmPlayernames:updateWho()
	local Name, Class
	for i = 1, GetNumWhoResults() do
		Name, _, _, _, Class = GetWhoInfo(i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:addName(Name, Class)
	if not Class or not Name then return end
	Class = Class:upper()
	if Class == "UNKNOWN" or not self.Colors[Class] then return end
	self.Names[Name] = string.format("|cff%s%s|r", self.Colors[Class], Name)
end

function scmPlayernames:AddMessage(frame, text, ...)
	if type(text) == "string" then
		local name = text:gsub(".*|Hplayer:(.-)|h.*", "%1")
		if self.Names[name] then name = self.Names[name] end
		text = text:gsub("|Hplayer:(.-)|h%[.-%]|h.-:", SCM_PLAYERNAMES_LEFTBRACKET.."|Hplayer:%1|h" .. name .. "|h"..SCM_PLAYERNAMES_RIGHTBRACKET)
	end

	self.hooks[frame].AddMessage(frame, text, ...)
end

