
--[[    Tell Target     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_TellTarget then return end

end

