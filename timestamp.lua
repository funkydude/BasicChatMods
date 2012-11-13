
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB
	if bcmDB.BCM_Timestamp then bcmDB.stampcolor = nil bcmDB.stampformat = nil return end

	if GetCVar("showTimestamps") ~= "none" then
		SetCVar("showTimestamps", "none")
		CHAT_TIMESTAMP_FORMAT = nil --disable Blizz stamping as it doesn't stamp everything
	end
	if not bcmDB.stampcolor or (bcmDB.stampcolor ~= "" and strlen(bcmDB.stampcolor) ~= 10) then bcmDB.stampcolor = "|cff777777" end --add a color if we lack one or the the current is invalid
	if not bcmDB.stampformat then bcmDB.stampformat = "[%I:%M:%S]" end --add a format if we lack one

	local time = time

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		local data = text:gsub("|[Tt]Interface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|[Tt]", "{rt%1}") -- I like being able to copy raid icons
		text = bcmDB.stampcolor.."|HBCMlinecopy:"..data:gsub("|", "#^V^V#")..":BCMlinecopy|h".. BetterDate(bcmDB.stampformat, time()) .. "|h|r "..text
		return text
	end

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(link, ...)
		local msg = link:match("BCMlinecopy:(.+):BCMlinecopy")
		if msg then
			BCM.popup = msg
			StaticPopup_Show("BCM_CopyBox")
		else
			SetHyperlink(self, link, ...)
		end
	end

	--[[ Popup Box ]]--
	if not StaticPopupDialogs.BCM_CopyBox then
		StaticPopupDialogs.BCM_CopyBox = {
			preferredIndex = 4,
			text = "BasicChatMods",
			button1 = CLOSE,
			hasEditBox = 1,
			editBoxWidth = 600,
			OnShow = function(frame)
				frame.editBox:SetText(BCM.popup:gsub("#%^V%^V#", "|"))
				frame.editBox:SetFocus()
				frame.editBox:HighlightText(0)
				BCM.popup = nil
			end,
			EditBoxOnEscapePressed = function(frame) frame:GetParent():Hide() end,
			timeout = 0,
			whileDead = 1,
			hideOnEscape = 1,
		}
	end
end

