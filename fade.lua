
do
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	for i=1, 10 do
		local tab = _G[format("%s%d%s", "ChatFrame", i, "Tab")]
		tab:SetAlpha(0)
		tab.noMouseAlpha = 0
	end
end

