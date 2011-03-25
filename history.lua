
--[[     History Module     ]]--

local _, f = ...
f.modules[#f.modules+1] = function()
	if bcmDB.BCM_History then bcmDB.lines = nil return end

	if not bcmDB.lines then bcmDB.lines = {["ChatFrame1"] = 1000} end

	for k, v in pairs(bcmDB.lines) do
		_G[k]:SetMaxLines(v)
	end
end

