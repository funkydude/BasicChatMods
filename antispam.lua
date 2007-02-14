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
	"hugold",
	"igs36",
	"igamebuy",
	"itembay",
	"mmoinn",
	"ogchannel",
	"ogmarket",
	"gs365",
	"ogs4u",
	"okstar2008",
	"peons4",
	"player123",
	"ssegames",
	"speedpanda",
	"wowcoming",
	"woweurope.cn",
	"wowforever",
	"wowfreebuy",
	"wowgoldsky",
	"wowpanning",
	"wowpfs",
	"wowspa",
	"wowstar2008",
	"wowsupplier",
	"zlywy",
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
			if #spam > SCM_ANTISPAM_HISTORY then
				spam[table.remove(spam, 1)] = nil
			end
			table.insert(spam, x)
			spam[x] = 1

			local spamString = arg1:gsub("%A", ""):trim():lower()
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
