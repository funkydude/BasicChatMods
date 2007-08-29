scmJustify = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

function scmJustify:OnEnable()
	local cf = getglobal("ChatFrame2")
	cf:SetJustifyH("RIGHT")
end
