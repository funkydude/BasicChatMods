
--[[		Outline Module		]]--

--[[
	Add a shadowy outline to your
	chat font. Fetches the size and font
	of your current chat so it's not
	butchered by this module.

	Enable this module by reading
	Disable Modules.txt
	(Remove the # in the .toc file)
]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		local font, size = cF:GetFont()
		cF:SetFont(font, size, "OUTLINE")
	end
end

