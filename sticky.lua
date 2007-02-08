scmSticky = {}

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

function scmSticky:Enable()
	for k, v in pairs( SCM_STICKY ) do
		if v then
			ChatTypeInfo[k].sticky = 1
		else
			ChatTypeInfo[k].sticky = 0
		end
	end
end

function scmSticky:Disable()
	for k, v in pairs( SCM_STICKY ) do
		ChatTypeInfo[k].sticky = 0
	end
end

