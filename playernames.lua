scmPlayernames = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1")

SCM_PLAYERNAMES_LEFTBRACKET = "<"
SCM_PLAYERNAMES_RIGHTBRACKET = ">"
SCM_PLAYERNAMES_MOUSEOVER = nil

SCM_PLAYERNAMES_COLORS = {
	DRUID   = "ff7c0a",
	HUNTER  = "aad372",
	MAGE    = "68ccef",
	PALADIN = "f48cba",
	PRIEST  = "ffffff",
	ROGUE   = "fff468",
	-- SHAMAN  = "00dbba", -- Old lightblue shaman color
	SHAMAN  = "2359ff",
	WARLOCK = "9382c9",
	WARRIOR = "c69b6d"
}

local classes = {} -- Key: Name, Value: Class
local names = setmetatable({}, {__index =
	function(self, key) -- Key: Name
		if classes[key] then
			self[key] = string.format("|cff%s%s|r", SCM_PLAYERNAMES_COLORS[classes[key]], key)
			return self[key]
		end
		return nil
	end
})

local function addName(name, class)
	if not class or not name or classes[name] then return end
	class = class:upper()
	if class == "UNKNOWN" or not SCM_PLAYERNAMES_COLORS[class] then return end
	classes[name] = class
end

function scmPlayernames:OnEnable()
	local _G = getfenv(0)
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
	addName(UnitName("player"), pclass)

	if IsInGuild() then
		GuildRoster()
	end
	if GetNumFriends() > 0 then
		ShowFriends()
	end
end

function scmPlayernames:updateFriends()
	for i = 1, GetNumFriends() do
		local name, _, class = GetFriendInfo(i)
		addName(name, class)
	end
end

function scmPlayernames:updateGuild()
	for i = 1, GetNumGuildMembers() do
		local name, _, _, _, class = GetGuildRosterInfo(i)
		addName(name, class)
	end
end

function scmPlayernames:updateRaid()
	for i = 1, GetNumRaidMembers() do
		local name, _, _, _, _, class = GetRaidRosterInfo(i)
		addName(name, class)
	end
end

function scmPlayernames:updateParty()
	for i = 1, GetNumPartyMembers() do
		addName(UnitName("party" .. i), select(2, UnitClass("party" .. i)))
	end
end

function scmPlayernames:updateTarget()
	if not UnitExists("target") or not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then return end
	addName(UnitName("target"), select(2, UnitClass("target")))
end

function scmPlayernames:updateMouseover()
	if not UnitExists("mouseover") or not UnitIsPlayer("mouseover") or not UnitIsFriend("player", "mouseover") then return end
	addName(UnitName("mouseover"), select(2, UnitClass("mouseover")))
end

function scmPlayernames:updateSystem( msg )
	local name, class = select(3, msg:find("^|Hplayer:%w+|h%[(%w+)%]|h: Level %d+ %w+ (%w+) %- .+$"))
	if name and class then 
		addName(name, class)
	end
end

function scmPlayernames:updateWho()
	for i = 1, GetNumWhoResults() do
		local name, _, _, _, class = GetWhoInfo(i)
		addName(name, class)
	end
end

function scmPlayernames:AddMessage(frame, text, ...)
	if type(text) == "string" then
		local name = text:gsub(".*|Hplayer:(.-):?%d*|h.*", "%1")
		if names[name] then name = names[name] end
		text = text:gsub("|Hplayer:(.-)|h%[.-%]|h.-:", SCM_PLAYERNAMES_LEFTBRACKET.."|Hplayer:%1|h" .. name .. "|h"..SCM_PLAYERNAMES_RIGHTBRACKET)
	end

	self.hooks[frame].AddMessage(frame, text, ...)
end

