
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
			"[I]", --Instance
			"[IL]", --Instance Leader
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

	local rplc = bcmDB.replacements
	local gsub = gsub
	local chn = {
		"%[%d%d?%. General[^%]]*%]",
		"%[%d%d?%. Trade[^%]]*%]",
		"%[%d%d?%. WorldDefense[^%]]*%]",
		"%[%d%d?%. LocalDefense[^%]]*%]",
		"%[%d%d?%. LookingForGroup[^%]]*%]",
		"%[%d%d?%. GuildRecruitment[^%]]*%]",
		gsub(CHAT_INSTANCE_CHAT_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_INSTANCE_CHAT_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_GUILD_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_PARTY_GUIDE_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_OFFICER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_LEADER_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		gsub(CHAT_RAID_WARNING_GET, ".*%[(.*)%].*", "%%[%1%%]"),
		"%[(%d%d?)%. ([^%]]+)%]", --Custom Channels
	}

	local L = GetLocale()
	if L == "ruRU" then --Russian
		chn[1] = "%[%d%d?%. Общий.-%]"
		chn[2] = "%[%d%d?%. Торговля.-%]"
		chn[3] = "%[%d%d?%. Оборона: глобальный%]" --Defense: Global
		chn[4] = "%[%d%d?%. Оборона.-%]" --Defense: Zone
		chn[5] = "%[%d%d?%. Поиск спутников%]"
		chn[6] = "%[%d%d?%. Гильдии.-%]"
	elseif L == "deDE" then --German
		chn[1] = "%[%d%d?%. Allgemein[^%]]*%]"
		chn[2] = "%[%d%d?%. Handel[^%]]*%]"
		chn[3] = "%[%d%d?%. Weltverteidigung[^%]]*%]"
		chn[4] = "%[%d%d?%. LokaleVerteidigung[^%]]*%]"
		chn[5] = "%[%d%d?%. SucheNachGruppe[^%]]*%]"
		chn[6] = "%[%d%d?%. Gildenrekrutierung[^%]]*%]"
	elseif L == "frFR" then --French
		chn[1] = "%[%d%d?%. Général[^%]]*%]"
		chn[2] = "%[%d%d?%. Commerce[^%]]*%]"
		chn[3] = "%[%d%d?%. DéfenseUniverselle[^%]]*%]"
		chn[4] = "%[%d%d?%. DéfenseLocale[^%]]*%]"
		chn[5] = "%[%d%d?%. RechercheDeGroupe[^%]]*%]"
		chn[6] = "%[%d%d?%. RecrutementDeGuilde[^%]]*%]"
	elseif L == "zhTW" then --Traditional Chinese
		chn[1] = "%[%d%d?%. 綜合.-%]"
		chn[2] = "%[%d%d?%. 交易.-%]"
		chn[3] = "%[%d%d?%. 世界防務%]"
		chn[4] = "%[%d%d?%. 本地防務.-%]"
		chn[5] = "%[%d%d?%. 尋求組隊%]"
		chn[6] = "%[%d%d?%. 公會招募.-%]"
	elseif L == "koKR" then --Korean
		chn[1] = "%[%d%d?%. 일반.-%]"
		chn[2] = "%[%d%d?%. 거래.-%]"
		chn[3] = "%[%d%d?%. 광역수비%]"
		chn[4] = "%[%d%d?%. 지역수비.-%]"
		chn[5] = "%[%d%d?%. 파티찾기%]"
		chn[6] = "%[%d%d?%. 길드찾기.-%]"
	end

	local num = #chn
	BCM.chatFuncs[#BCM.chatFuncs+1] = function(text)
		for i=1, num do
			text = gsub(text, chn[i], rplc[i])
		end
		return text
	end
end

