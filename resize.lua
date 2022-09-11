
--[[     Resize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_Resize then return end

	BCM.chatFuncsPerFrame[#BCM.chatFuncsPerFrame+1] = function(cF)
		--Allow resizing chatframes to whatever size you wish!
		if cF.SetResizeBounds then -- XXX Dragonflight compat
			cF:SetResizeBounds(100, 10, 0, 0)
		else
			cF:SetMinResize(100,10)
			cF:SetMaxResize(0,0)
		end
	end
end

