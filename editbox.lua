Editbox = {}

function Editbox:Enable()
	local eb = ChatFrameEditBox
	eb:ClearAllPoints()
	eb:SetPoint('BOTTOMLEFT',  'ChatFrame1', 'TOPLEFT',  -5, 0)
	eb:SetPoint('BOTTOMRIGHT', 'ChatFrame1', 'TOPRIGHT', 5, 0)
end

function Editbox:Disable()
	local eb = ChatFrameEditBox
	eb:ClearAllPoints()
	eb:SetPoint('TOPLEFT',  'ChatFrame1', 'BOTTOMLEFT',  -5, 0)
	eb:SetPoint('TOPRIGHT', 'ChatFrame1', 'BOTTOMRIGHT', 5, 0)
end

Editbox:Enable()
