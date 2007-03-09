scmUrlCopy = AceLibrary("AceAddon-2.0"):new("AceHook-2.1", "AceConsole-2.0")

SCM_URL_STYLE = " |cffffffff|Hurl:%s|h[%s]|h|r "

local patterns = {
	[" www%.([_A-Za-z0-9-]+)%.([_A-Za-z0-9-%.&/]+)%s?"] = "http://www.%1.%2",
	[" (%a+)://(%S+)%s?"] = "%1://%2",
	[" ([_A-Za-z0-9-%.]+)@([_A-Za-z0-9-]+)(%.+)([_A-Za-z0-9-%.]+)%s?"] = "%1@%2%3%4",
	[" (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?):(%d%d?%d?%d?%d?)%s?"] = "%1.%2.%3.%4:%5",
	[" (%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%.(%d%d?%d?)%s?"] = "%1.%2.%3.%4",
	[" ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%s?"] = "%1.%2.%3",
	[" ([_A-Za-z0-9-]+)%.([_A-Za-z0-9-]+)%.(%S+)%:([_0-9-]+)%s?"] = "%1.%2.%3:%4",
}

local _G = getfenv(0)

function scmUrlCopy:OnEnable()
	for i=1,NUM_CHAT_WINDOWS do
		self:Hook(_G["ChatFrame"..i], "AddMessage", true)
	end
	self:Hook( "SetItemRef", true )
end

function scmUrlCopy:AddMessage(frame, text, ...)
	if type(text) == "string" then
		for k, v in pairs( patterns ) do
			text = text:gsub( k, SCM_URL_STYLE:format( v, v ) )
		end
	end
	self.hooks[frame].AddMessage(frame, text, ...)
end

function scmUrlCopy:SetItemRef( link, text, button )
	if ( strsub(link, 1, 3) == "url" ) then
		self:StaticPopupUrl( strsub(link, 5) )
		return
	end
	self.hooks["SetItemRef"](link, text, button)
end

-- Ripped the popup straight from Prat.
function scmUrlCopy:StaticPopupUrl(link)
    StaticPopupDialogs["SHOW_URL"] = {
        text = "URL : %s",
        button2 = TEXT(ACCEPT),
        hasEditBox = 1,
        hasWideEditBox = 1,
        showAlert = 1, -- HACK : it"s the only way I found to make de StaticPopup have sufficient width to show WideEditBox :(

        OnShow = function()
            local editBox = getglobal(this:GetName().."WideEditBox")
            editBox:SetText(format(link))
            editBox:SetFocus()
            editBox:HighlightText(0)

            local button = getglobal(this:GetName().."Button2")
            button:ClearAllPoints()
            button:SetWidth(200)
            button:SetPoint("CENTER", editBox, "CENTER", 0, -30)

            getglobal(this:GetName().."AlertIcon"):Hide() -- HACK : we hide the false AlertIcon
        end,

        OnHide = function() end,
        OnAccept = function() end,
        OnCancel = function() end,
        EditBoxOnEscapePressed = function() this:GetParent():Hide(); end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = 1
    };

    StaticPopup_Show ("SHOW_URL", link);
end
