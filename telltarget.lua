scmTellTarget = {}

function scmTellTarget:Enable()
	SlashCmdList["TELLTARGET"] = function(str) self:tellTarget(str) end
	SLASH_TELLTARGET1 = "/tt"
end

function scmTellTarget:Disable()
	SlashCmdList["TELLTARGET"] = nil
	SLASH_TELLTARGET1 = nil
end

function scmTellTarget:tellTarget(str)
	if not (UnitExists("target")
		and UnitName("target")
		and UnitIsPlayer("target")
		and GetDefaultLanguage("player") == GetDefaultLanguage("target"))
	or not (str and strlen(str)>0) then
		return
	end

	local name, realm = UnitName("target")
	if realm and realm ~= GetRealmName() then
		name = string.format("%s-%s", name, realm)
	end

	SendChatMessage(str, "WHISPER", nil, name)
end

scmTellTarget:Enable()

