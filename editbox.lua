bcmEditbox = {}

function bcmEditbox:Enable()
	local eb = ChatFrameEditBox
	eb:ClearAllPoints()
	eb:SetPoint("BOTTOMLEFT",  "ChatFrame1", "TOPLEFT",  -5, 0)
	eb:SetPoint("BOTTOMRIGHT", "ChatFrame1", "TOPRIGHT", 5, 0)
end

function bcmEditbox:Disable()
	local eb = ChatFrameEditBox
	eb:ClearAllPoints()
	eb:SetPoint("TOPLEFT",  "ChatFrame1", "BOTTOMLEFT",  -5, 0)
	eb:SetPoint("TOPRIGHT", "ChatFrame1", "BOTTOMRIGHT", 5, 0)
end

bcmEditboxAltKey = {}

function bcmEditboxAltKey:Enable()
	ChatFrameEditBox:SetAltArrowKeyMode(false)
end

function bcmEditboxAltKey:Disable()
	ChatFrameEditBox:SetAltArrowKeyMode(true)
end

bcmEditbox:Enable()
bcmEditboxAltKey:Enable(
)
