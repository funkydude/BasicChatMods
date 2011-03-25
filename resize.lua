
--[[     Resize Module     ]]--

local _, f = ...
f.modules[#f.modules+1] = function()
	if bcmDB.BCM_Resize then return end

	for i=1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--Allow resizing chatframes to whatever size you wish!
		cF:SetMinResize(100,10)
		cF:SetMaxResize(0,0)
	end
end

