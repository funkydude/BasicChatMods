
--[[     Channel Name Replacements Module     ]]--

local _, BCM = ...
BCM.modules[#BCM.modules+1] = function()
	if bcmDB.BCM_ChannelNames then bcmDB.replacements = nil return end

	if not bcmDB.replacements then
		bcmDB.replacements = {
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
			"[%1]", --Custom Channels
		}
	end
	if not bcmDB.replacements[17] then bcmDB.replacements[17] = "[%1]" end --Temp

	local rplc = bcmDB.replacements
	local gsub = gsub
	local chn = {
		"%[%d0?%. General.-%]",
		"%[%d0?%. Trade.-%]",
		"%[%d0?%. WorldDefense%]",
		"%[%d0?%. LocalDefense.-%]",
		"%[%d0?%. LookingForGroup%]",
		"%[%d0?%. GuildRecruitment.-%]",
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
		"%[(%d0?)%. (.-)%]", --Custom Channels
	}

	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d0?%. Общий.-%]"
		chn[2] = "%[%d0?%. Торговля.-%]"
		chn[3] = "%[%d0?%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d0?%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d0?%. Поиск спутников%]"
		chn[6] = "%[%d0?%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d0?%. Allgemein.-%]"
		chn[2] = "%[%d0?%. Handel.-%]"
		chn[3] = "%[%d0?%. Weltverteidigung%]"
		chn[4] = "%[%d0?%. LokaleVerteidigung.-%]"
		chn[5] = "%[%d0?%. SucheNachGruppe%]"
		chn[6] = "%[%d0?%. Gildenrekrutierung.-%]"
	elseif L == "frFR" then --French
		chn[1] = "%[%d0?%. Général.-%]"
		chn[2] = "%[%d0?%. Commerce.-%]"
		chn[3] = "%[%d0?%. DéfenseUniverselle%]"
		chn[4] = "%[%d0?%. DéfenseLocale.-%]"
		chn[5] = "%[%d0?%. RechercheDeGroupe%]"
		chn[6] = "%[%d0?%. RecrutementDeGuilde.-%]"
	elseif L == "zhTW" then --Traditional Chinese
		chn[1] = "%[%d0?%. 綜合.-%]"
		chn[2] = "%[%d0?%. 交易.-%]"
		chn[3] = "%[%d0?%. 世界防務%]"
		chn[4] = "%[%d0?%. 本地防務.-%]"
		chn[5] = "%[%d0?%. 尋求組隊%]"
		chn[6] = "%[%d0?%. 公會招募.-%]"
	end

	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		for i=1, 17 do
			text = gsub(text, chn[i], rplc[i])
		end
		return text
	end
end

