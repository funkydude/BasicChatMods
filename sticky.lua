bcmSticky = {}

BCM_STICKY = {
	["SAY"] = true,
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

function bcmSticky:Enable()
	for k, v in pairs( BCM_STICKY ) do
		if v then
			ChatTypeInfo[k].sticky = 1
		else
			ChatTypeInfo[k].sticky = 0
		end
	end
end

function bcmSticky:Disable()
	for k, v in pairs( BCM_STICKY ) do
		ChatTypeInfo[k].sticky = 0
	end
end

