
--[[     Channel Name Replacements Module     ]]--

local _, f = ...
f.functions[#f.functions+1] = function()
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
		}
	end

	local rplc = bcmDB.replacements
	local gsub = gsub
	local chn = {
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

	local newAddMsg = {}
	local AddMessage = function(frame, text, ...)
		for i = 1, 16 do
			text = gsub(text, chn[i], rplc[i])
		end
		text = gsub(text, "%[(%d0?)%. .-%]", "[%1]") --custom channels
		return newAddMsg[frame:GetName()](frame, text, ...)
	end

	for i = 1, 10 do
		local cF = _G[format("%s%d", "ChatFrame", i)]
		--skip combatlog and frames with no messages registered
		if i ~= 2 and #cF.messageTypeList > 0 then
			newAddMsg[format("%s%d", "ChatFrame", i)] = cF.AddMessage
			cF.AddMessage = AddMessage
		end
	end
end

