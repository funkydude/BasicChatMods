
--[[		Channel Name Replacements Module		]]--

local gsub = _G.string.gsub
local time = _G.time
local newAddMsg = {}

--[[
	To customize what you want for channel names
	simply change the text in the brackets []
]]--

local chn, rplc
do
	rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
		"[BG]", --Battleground
		"[BGL]", --Battleground Leader
		"[G]", --Guild
		"[P]", --Party
		"[PL]", --Party Leader
		"[PL]", --Party Leader (Guide)
		"[O]", --Officer
		"[R]", --Raid
		"[RL]", --Raid Leader
		"[RW]", --Raid Warning
	}
	chn = {
		"%[%d+%. General.-%]",
		"%[%d+%. Trade.-%]",
		"%[%d+%. WorldDefense%]",
		"%[%d+%. LocalDefense.-%]",
		"%[%d+%. LookingForGroup%]",
		"%[%d+%. GuildRecruitment.-%]",
		gsub(CHAT_BATTLEGROUND_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_BATTLEGROUND_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
	}

	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d+%. Общий.-%]"
		chn[2] = "%[%d+%. Торговля.-%]"
		chn[3] = "%[%d+%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d+%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d+%. Поиск спутников%]"
		chn[6] = "%[%d+%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d+%. Allgemein.-%]"
		chn[2] = "%[%d+%. Handel.-%]"
		chn[3] = "%[%d+%. Weltverteidigung%]"
		chn[4] = "%[%d+%. LokaleVerteidigung.-%]"
		chn[5] = "%[%d+%. SucheNachGruppe%]"
		chn[6] = "%[%d+%. Gildenrekrutierung.-%]"
	end
end

local function AddMessage(frame, text, ...)
	for i = 1, 16 do
		text = gsub(text, chn[i], rplc[i])
	end

	--If Blizz timestamps is enabled, stamp anything it misses
	if CHAT_TIMESTAMP_FORMAT and not text:find("^|r") then
		text = BetterDate(CHAT_TIMESTAMP_FORMAT, time())..text
	end
	text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
	return newAddMsg[frame:GetName()](frame, text, ...)
end

do
	for i = 1, 5 do
		if i ~= 2 then -- skip combatlog
			local f = _G[format("%s%d", "ChatFrame", i)]
			newAddMsg[format("%s%d", "ChatFrame", i)] = f.AddMessage
			f.AddMessage = AddMessage
		end
	end
end

