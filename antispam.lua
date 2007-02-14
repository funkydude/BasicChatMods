local scmAntiSpam = {}

SCM_ANTISPAM_HISTORY = 5
SCM_ANTISPAM_BLOCKSPAMMERS = true

local tokens = {
	["29games"] = true,
	["365ig"] = true,
	["agamego"] = true,
	["buyw0wgame"] = true,
	["gamenoble"] = true,
	["gmwork"] = true,
	["gmw0rk"] = true,
	["goldwithyou"] = true,
	["hugold"] = true,
	["igs36"] = true,
	["igamebuy"] = true,
	["itembay"] = true,
	["mmoinn"] = true,
	["ogchannel"] = true,
	["ogmarket"] = true,
	["gs365"] = true,
	["ogs4u"] = true,
	["okstar2008"] = true,
	["peons4"] = true,
	["player123"] = true,
	["ssegames"] = true,
	["speedpanda"] = true,
	["wowcoming"] = true,
	["woweurope.cn"] = true,
	["wowforever"] = true,
	["wowfreebuy"] = true,
	["wowgoldsky"] = true,
	["wowpanning"] = true,
	["wowpfs"] = true,
	["wowspa"] = true,
	["wowstar2008"] = true,
	["wowsupplier"] = true,
	["zlywy"] = true,
}
local spammers = {}

local spam = {}
local prehook = nil

function scmAntiSpam:Enable()
	prehook = ChatFrame_MessageEventHandler
	ChatFrame_MessageEventHandler = function(...)
		if type(arg1) == "string" and type(arg2) == "string" then
			if spammers[arg2] and SCM_ANTISPAM_BLOCKSPAMMERS then return end
			local x = arg1..arg2
			if spam[x] then return end
			if #spam > SCM_ANTISPAM_HISTORY then
				spam[table.remove(spam, 1)] = nil
			end
			table.insert(spam, x)
			spam[x] = 1

			local spamString = arg1:gsub("%A", ""):trim():lower()
			for k, v in pairs(tokens) do
				if spamString:find(k) then
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
