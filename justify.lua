scmJustify = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

SCM_JUSTIFY_CHANNEL = {
	"LEFT",		--[1]
	"RIGHT",	--[2]
	"LEFT",		--[3]
	"LEFT", 	--[4]
	"LEFT", 	--[5]
	"LEFT", 	--[6]
	"LEFT", 	--[7]
}

function scmJustify:OnEnable()
	for i=1,NUM_CHAT_WINDOWS do
    	local cf = getglobal("ChatFrame"..i)
    	cf:SetJustifyH(SCM_JUSTIFY_CHANNEL[i])
	end
end
