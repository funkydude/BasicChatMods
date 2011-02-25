
--[[     BCM Core     ]]--

local _, f = ...
f.functions = {}
f.fire = CreateFrame("Frame")
f.fire:RegisterEvent("PLAYER_LOGIN")
f.fire:SetScript("OnEvent", function()
	--[[ Check Database ]]--
	if type(bcmDB) ~= "table" then
		bcmDB = {}
	end

	--[[ Run Modules ]]--
	for i = 1, #f.functions do
		f.functions[i]()
		f.functions[i] = nil
	end

	--[[ Self-Cleanup ]]--
	f.functions = nil
	f.fire:UnregisterEvent("PLAYER_LOGIN")
	f.fire:SetScript("OnEvent", nil)
	f.fire = nil
end)

for i = 1, 10 do
	--Allow resizing chatframes to whatever size you wish!
	local cf = _G[format("%s%d", "ChatFrame", i)]
	cf:SetMinResize(0,0)
	cf:SetMaxResize(0,0)

	--Allow the chat frame to move to the end of the screen
	cf:SetClampRectInsets(0,0,0,0)

	--Allow arrow keys editing in the edit box
	local eb =  _G[format("%s%d%s", "ChatFrame", i, "EditBox")]
	eb:SetAltArrowKeyMode(false)
end
--Clamp the toast frame to screen to prevent it cutting out
BNToastFrame:SetClampedToScreen(true)

