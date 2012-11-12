
--[[     Resize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Resize then return end

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(n)
		local cF = _G[n]
		--Allow resizing chatframes to whatever size you wish!
		cF:SetMinResize(100,10)
		cF:SetMaxResize(0,0)
	end
end

