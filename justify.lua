
--[[     Justify Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_Justify then bcmDB.justify = nil return end

	if bcmDB.justify then
		for k, v in pairs(bcmDB.justify) do
			_G[k]:SetJustifyH(v)
		end
	end
end

