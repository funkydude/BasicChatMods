
--[[     Font Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	--[[for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		local font, size = cF:GetFont()
		cF:SetFont(font, size, "OUTLINE")
	end]]
end

