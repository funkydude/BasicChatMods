
--[[		Justify Module		]]--

--[[
	Justify your chat frames!
	valid options are: "LEFT","RIGHT", or "CENTER"
	ChatFrames 1 - 10
	e.g.
	ChatFrame4:SetJustifyH("CENTER")
	We justify ChatFrame2 to the right here (combatlog)
]]--

local _, f = ...
f.functions[#f.functions+1] = function()
	ChatFrame2:SetJustifyH("RIGHT")
end

