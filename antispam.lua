local scmAntiSpam = {}

SCM_ANTISPAM_HISTORY = 5
SCM_ANTISPAM_BLOCKSPAMMERS = true

local tokens = {
	"29games",
	"365ig",
	"agamego",
	"buyw0wgame",
	"gamenoble",
	"gmwork",
	"gmw0rk",
	"goldwithyou",
	"gold4guild",
	"hugold",
	"igs36",
	"igm365",
	"igamebuy",
	"igdollarc",
	"igtuc",
	"itembay",
	"itemratec",
	"helpugame",
	"mmoinn",
	"ogchannel",
	"ogmarket",
	"gs365",
	"ogs4u",
	"okstar2008",
	"peons4",
	"p3ons4",
	"player123",
	"playsupplier",
	"ssegames",
	"speedpanda",
	"wow7gold",
	"wowcoming",
	"woweuropecn",
	"wowforever",
	"wowfreebuy",
	"wowgoldsky",
	"wowpanning",
	"wowpfs",
	"wowspa",
	"wowstar2008",
	"wowsupplier",
	"wowseller",
	"zlywy",
	"gmauthorization",
	"woweuropegold",
	"1225game",
	"plsalec",
}
local spammers = {}

local spam = {}
local prehook = nil

function scmAntiSpam:Enable()
	prehook = ChatFrame_MessageEventHandler
	ChatFrame_MessageEventHandler = function(...)
		if type(arg1) == "string" and type(arg2) == "string" and not arg1:find("^/") then
			if spammers[arg2] and SCM_ANTISPAM_BLOCKSPAMMERS then return end
			local x = arg1..arg2
			if spam[x] then return end
			table.insert(spam, x)
			spam[x] = 1
			if #spam > SCM_ANTISPAM_HISTORY then
				spam[table.remove(spam, 1)] = nil
			end
			
			local spamString = arg1:gsub("%p", ""):trim():lower()
			for i, v in ipairs(tokens) do
				if spamString:find(v) then
					spammers[arg2] = true
					return
				end
			end
		end

		return prehook(...)
	end
end

function scmAntiSpam:Disable()
	if not prehook then return end
	ChatFrame_MessageEventHandler = prehook
end

scmAntiSpam:Enable()
