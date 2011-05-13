
--[[     History Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_History then bcmDB.lines = nil return end

	if not bcmDB.lines then bcmDB.lines = {["ChatFrame1"] = 1000} end
	for k, v in pairs(bcmDB.lines) do
		local f, tbl = _G[k], {}

		--Save all chat before changing MaxLines.
		for regions = f:GetNumRegions(),1,-1 do
			local region = select(regions, f:GetRegions())
			if region:GetObjectType() == "FontString" then
				tinsert(tbl, {region:GetText(), region:GetTextColor()})
			end
		end

		f:SetMaxLines(v) --Set the max lines (Also clears the Chat Frame).

		--Restore all chat.
		for _,w in pairs(tbl) do
			f:AddMessage(unpack(w))
			wipe(w)
		end
		wipe(tbl)
		tbl=nil
	end
end

