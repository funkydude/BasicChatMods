
--[[     URLCopy Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_URLCopy then return end

	local repTbl = {
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/%S+",
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?/%S+",
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/",
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?/",
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?$",
		"%a-://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?$",
		"(%a-://[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?) ",
		"(%a-://[%a%-%d]*%.?[%a%-%d]+%.[%a%-%d]+%.%a%a%a?) ",
		"[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/%S+",
		"[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?/",
		"[%a%-%d]*%.?[%a%-%d]+%.%a%a%a?$",
		"([%a%-%d]*%.?[%a%-%d]+%.%a%a%a?) ",
		"%d+%.%d+%.%d+%.%d+:?%d*/?%S*",
	}

	local gsub = gsub
	local filterFunc = function(_, _, msg, ...)
		for i=1, #repTbl do
			local newMsg, found = gsub(msg, repTbl[i], "|cffffffff|Hbcmurl~%1|h[%1]|h|r")
			if found > 0 then return false, newMsg, ... end
		end
	end

	ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_OFFICER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER_INFORM", filterFunc)
	ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_CONVERSATION", filterFunc)

	local SetHyperlink = ItemRefTooltip.SetHyperlink
	function ItemRefTooltip:SetHyperlink(data, ...)
		local isURL, link = strsplit("~", data)
		if isURL and isURL == "bcmurl" then
			BCM.popup = link
			StaticPopup_Show("BCM_CopyBox")
		else
			SetHyperlink(self, data, ...)
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
				frame.editBox:SetText(BCM.popup)
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

