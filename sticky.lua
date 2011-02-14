
--[[		Sticky Channels		]]--

local _, f = ...
f.functions[#f.functions+1] = function()

--[[
	The following are off(0) by default in Blizz so we turn them on,
	change them to 0 to turn them off.
	You can also turn off other sticky channels that Blizz sticks
	e.g. ChatTypeInfo.WHISPER.sticky = 0
	Making it 0 will no longer sticky whispers
]]
	ChatTypeInfo.EMOTE.sticky = 1
	ChatTypeInfo.YELL.sticky = 1
	ChatTypeInfo.RAID_WARNING.sticky = 1
	--If you want to unsticky whispers or BNet whispers, remove the "--" on the following lines
	--ChatTypeInfo.WHISPER.sticky = 0
	--ChatTypeInfo.BN_WHISPER.sticky = 0

end

