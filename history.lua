
--[[     History Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	if bcmDB.BCM_History then return end

	for i=1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--Increase message history
		if i ~= 2 and #cF.messageTypeList > 0 then
			cF:SetMaxLines(1000)
		end
	end
end

