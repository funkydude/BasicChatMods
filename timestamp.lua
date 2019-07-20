
--[[     Timestamp Customize Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	--[[ Color codes ---> http://www.december.com/html/spec/colorcodes.html ]]--

	local bcmDB = bcmDB

	if bcmDB.BCM_Timestamp then bcmDB.stampcol = nil bcmDB.stampfmt = nil return end

	if GetCVar("showTimestamps") ~= "none" then
		SetCVar("showTimestamps", "none")
		CHAT_TIMESTAMP_FORMAT = nil -- Disable Blizz stamping as it doesn't stamp everything
	end
	if not bcmDB.stampcol or (bcmDB.stampcol ~= "" and strlen(bcmDB.stampcol) ~= 6) then bcmDB.stampcol = "777777" end -- Add a color if we lack one or the the current is invalid
	if not bcmDB.stampfmt then bcmDB.stampfmt = "[%I:%M:%S] " end --add a format if we lack one

	local time = time
	local format = format
	local num = 0

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		local stamp = BetterDate(bcmDB.stampfmt, time())
		num = num + 1
		if bcmDB.stampcol == "" then
			text = format("|HbattlePetAbil:-010101:%d:|h%s|h%s", num, stamp, text)
		else
			text = format("|cFF%s|HbattlePetAbil:-010101:%d:|h%s|h|r%s", bcmDB.stampcol, num, stamp, text)
		end
		return text
	end

	-- This may seem weird, because it is.
	-- This is an "interesting" way to avoid doing an insecure hook of `ItemRefTooltip.SetHyperlink`
	-- It works, and avoiding insecure hooks is what matters!
	hooksecurefunc("FloatingPetBattleAbility_Show", function(signature, id)
		if signature == -010101 then -- Unique signature, CHANGE THIS IF YOU ARE COPYING THIS CODE. Blizz checks for > 0 so using < 0 means Blizz won't run it
			local prefix = ("battlePetAbil:-010101:%d:"):format(id)
			for num = 1, 20 do
				if num ~= 2 then
					local cf = _G[format("ChatFrame%d", num)]
					if cf then
						for i = cf:GetNumMessages(), 1, -1 do
							local text = cf:GetMessageInfo(i)
							if text:find(prefix, nil, true) then
								text = text:gsub("|T[^\\]+\\[^\\]+\\[Uu][Ii]%-[Rr][Aa][Ii][Dd][Tt][Aa][Rr][Gg][Ee][Tt][Ii][Nn][Gg][Ii][Cc][Oo][Nn]_(%d)[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
								text = text:gsub("|T13700([1-8])[^|]+|t", "{rt%1}") -- I like being able to copy raid icons
								text = text:gsub("|T[^|]+|t", "") -- Remove any other icons to prevent copying issues
								text = text:gsub("|K[^|]+|k", BCM.protectedText) -- Remove protected text
								BCM:Popup(text)
								return
							end
						end
					end
				end
			end
		end
	end)
end

