scmSticky = AceLibrary("AceAddon-2.0"):new()

SCM_STICKY = {
	["SAY"] = true,
	["WHISPER"] = true,
	["YELL"] = true,
	["PARTY"] = true,
	["GUILD"] = true,
	["OFFICER"] = true,
	["RAID"] = true,
	["RAID_WARNING"] = true,
	["BATTLEGROUND"] = true,
	["CHANNEL"] = true,
	["EMOTE"] = true
}

function scmSticky:OnEnable()
	for k, v in pairs( SCM_STICKY ) do
		if v then
			ChatTypeInfo[k].sticky = 1
		else
			ChatTypeInfo[k].sticky = 0
		end
	end
end

function scmSticky:OnDisable()
	for k, v in pairs( SCM_STICKY ) do
		ChatTypeInfo[k].sticky = 0
	end
end
