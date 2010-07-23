
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
	CHAT_BATTLEGROUND_GET = "|Hchannel:Battleground|h[BG]|h %s:\32"
	CHAT_BATTLEGROUND_LEADER_GET = "|Hchannel:Battleground|h[BGL]|h %s:\32"
	CHAT_GUILD_GET = "|Hchannel:Guild|h[G]|h %s:\32"
	CHAT_PARTY_GET = "|Hchannel:Party|h[P]|h %s:\32"
	CHAT_PARTY_LEADER_GET = "|Hchannel:party|h[PL]|h %s:\32"
	CHAT_PARTY_GUIDE_GET = "|Hchannel:PARTY|h[PL]|h %s:\32"
	CHAT_OFFICER_GET = "|Hchannel:o|h[O]|h %s:\32"
	CHAT_RAID_GET = "|Hchannel:raid|h[R]|h %s:\32"
	CHAT_RAID_LEADER_GET = "|Hchannel:raid|h[RL]|h %s:\32"
	CHAT_RAID_WARNING_GET = "[RW] %s:\32"

	rplc = {
		"[GEN]", --General
		"[T]", --Trade
		"[WD]", --WorldDefense
		"[LD]", --LocalDefense
		"[LFG]", --LookingForGroup
		"[GR]", --GuildRecruitment
	}

	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn = {
			"%[%d+%. Общий.-%]",
			"%[%d+%. Торговля.-%]",
			"%[%d+%. Оборона: глобальный%]", --Defense: Global
			"%[%d+%. Оборона.-%]", --Defense: Zone
			"%[%d+%. Поиск спутников%]",
			"%[%d+%. Гильдии.-%]",
		}
	elseif L == "deDE" then --German
		chn = {
			"%[%d+%. Allgemein.-%]",
			"%[%d+%. Handel.-%]",
			"%[%d+%. Weltverteidigung%]",
			"%[%d+%. LokaleVerteidigung.-%]",
			"%[%d+%. SucheNachGruppe%]",
			"%[%d+%. Gildenrekrutierung.-%]",
		}
	else --English & any other language not translated above.
		chn = {
			"%[%d+%. General.-%]",
			"%[%d+%. Trade.-%]",
			"%[%d+%. WorldDefense%]",
			"%[%d+%. LocalDefense.-%]",
			"%[%d+%. LookingForGroup%]",
			"%[%d+%. GuildRecruitment.-%]",
		}
	end
end

local function AddMessage(frame, text, ...)
	for i = 1, 6 do
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

