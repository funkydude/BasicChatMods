scmUrlCopy = AceLibrary("AceAddon-2.0"):new("AceHook-2.1")

SCM_URL_STYLE = " |cffffffff|Hurl:%s|h[%s]|h|r "

local patterns = {
	{ " www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?", "http://www.%1.%2"},
	{ " (%a+)://(%S+)%s?", "%1://%2"},
	{ " ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?", "%1@%2%3%4"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?", "%1.%2.%3"},
	{ " ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?", "%1.%2.%3:%4"},
	{ " ([_A-Za-z0-9-]+)%.(%a%a%a)%s?", "%1.%2"},
}
local currentLink
local _G = getfenv(0)

function scmUrlCopy:OnEnable()
	for i=1,NUM_CHAT_WINDOWS do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
	self:Hook( "SetItemRef", true )

	StaticPopupDialogs["SCMUrlCopyDialog"] = {
		text = "URL",
		button2 = TEXT(CLOSE),
		hasEditBox = 1,
		hasWideEditBox = 1,
		showAlert = 1,
		OnShow = function()
			local editBox = _G[this:GetName().."WideEditBox"]
			if editBox then
				editBox:SetText(currentLink)
				editBox:SetFocus()
				editBox:HighlightText(0)
			end
			local button = _G[this:GetName().."Button2"]
			if button then
				button:ClearAllPoints()
				button:SetWidth(200)
				button:SetPoint("CENTER", editBox, "CENTER", 0, -30)
			end
			local icon = _G[this:GetName().."AlertIcon"]
			if icon then
				icon:Hide()
			end
		end,
		EditBoxOnEscapePressed = function() this:GetParent():Hide() end,
		timeout = 0,
		whileDead = 1,
		hideOnEscape = 1,
	}
end

function scmUrlCopy:AddMessage(frame, text, ...)
	if type(text) == "string" and text:len() > 7 then
		for i, v in ipairs( patterns ) do
			text = text:gsub( v[1], SCM_URL_STYLE:format( v[2], v[2] ) )
		end
	end
	self.hooks[frame].AddMessage(frame, text, ...)
end

function scmUrlCopy:SetItemRef(link, text, button)
	if link:sub(1, 3) == "url" then
		self:StaticPopupUrl(link:sub(5))
		return
	end
	self.hooks["SetItemRef"](link, text, button)
end

-- Ripped the popup straight from Prat.
function scmUrlCopy:StaticPopupUrl(link)
	currentLink = link
	StaticPopup_Show("SCMUrlCopyDialog")
end

