scmPlayernames = AceLibrary("AceAddon-2.0"):new("AceEvent-2.0", "AceHook-2.1")
scmPlayernames.Colors = {
	DRUID   = "ff7c0a",
	HUNTER  = "aad372",
	MAGE    = "68ccef",
	PALADIN = "f48cba",
	PRIEST  = "ffffff",
	ROGUE   = "fff468",
	SHAMAN  = "f48cba",
	WARLOCK = "9382c9",
	WARRIOR = "c69b6d"
}
scmPlayernames.Names = {}

function scmPlayernames:OnEnable()
	self:Hook(ChatFrame1, "AddMessage")
	self:Hook(ChatFrame2, "AddMessage")
	self:Hook(ChatFrame3, "AddMessage")
	self:Hook(ChatFrame4, "AddMessage")
	self:Hook(ChatFrame5, "AddMessage")
	self:Hook(ChatFrame6, "AddMessage")
	self:Hook(ChatFrame7, "AddMessage")

	self:RegisterBucketEvent("FRIENDLIST_UPDATE", 5, "updateFriends")
	self:RegisterBucketEvent("GUILD_ROSTER_UPDATE", 5, "updateGuild")
	self:RegisterBucketEvent("RAID_ROSTER_UPDATE", 5, "updateRaid")
	self:RegisterBucketEvent("PARTY_MEMBERS_CHANGED", 5, "updateParty")
	self:RegisterBucketEvent("WHO_LIST_UPDATE", 5, "updateWho")
	self:RegisterEvent("PLAYER_TARGET_CHANGED", "updateTarget")

	local _, pclass = UnitClass("player")
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
		_, Class = UnitClass("party" .. i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:updateTarget()
	if not UnitExists("target") or not UnitIsPlayer("target") or not UnitIsFriend("player", "target") then return end
	local _, Class = UnitClass("target")
	self:addName(UnitName("target"), Class)
end

function scmPlayernames:updateWho()
	local Name, Class
	for i = 1, GetNumWhoResults() do
		Name, _, _, _, Class = GetWhoInfo(i)
		self:addName(Name, Class)
	end
end

function scmPlayernames:addName(Name, Class)
	if not Class then return end
	Class = string.upper(Class)
	if Class == "UNKNOWN" or not self.Colors[Class] then return end
	self.Names[Name] = string.format("|cff%s%s|r", self.Colors[Class], Name)
end

function scmPlayernames:AddMessage(frame, text, r, g, b, id)
	if type(text) == "string" then
		local name = text:gsub(".*|Hplayer:(.-)|h.*", "%1")
		if self.Names[name] then name = self.Names[name] end
		text = text:gsub("|Hplayer:(.-)|h%[.-%]|h.-:", "<|Hplayer:%1|h" .. name .. "|h>")
	end

	self.hooks[frame].AddMessage(frame, text, r, g, b, id)
end

