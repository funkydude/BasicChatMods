local scmAntiSpam = {}

SCM_ANTISPAM_HISTORY = 5

local spam = {}
local prehook = nil

function scmAntiSpam:Enable()
	prehook = ChatFrame_MessageEventHandler
	ChatFrame_MessageEventHandler = function(...)
		if type(arg1) == "string" and type(arg2) == "string" then
			local x = arg1..arg2
			if spam[x] then return end
			if #spam > SCM_ANTISPAM_HISTORY then
				spam[table.remove(spam, 1)] = nil
			end
			table.insert(spam, x)
			spam[x] = 1
		end

		return prehook(...)
	end
end

function scmAntiSpam:Disable()
	if not prehook then return end
	ChatFrame_MessageEventHandler = prehook
end

scmAntiSpam:Enable()
