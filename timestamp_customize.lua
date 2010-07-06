
--[[		Timestamp Customize Module		]]

--[[
	Timestamp coloring, http://www.december.com/html/spec/colorcodes.html
	We use "777777" and add brackets []
	Must start with |cff and end with |r
	DO NOT remove anything inside the brackets
	DO NOT remove the |c as the function that timestamps lines that Blizzard misses in channelnames.lua
	e.g. loot, achievements, requires each line to start with |c
	Leave the space at the end if you want a space between timestamps and text
]]--

TIMESTAMP_FORMAT_HHMM = "|cff777777[%I:%M]|r "
TIMESTAMP_FORMAT_HHMM_24HR = "|cff777777[%H:%M]|r "
TIMESTAMP_FORMAT_HHMM_AMPM = "|cff777777[%I:%M %p]|r "

TIMESTAMP_FORMAT_HHMMSS = "|cff777777[%I:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_24HR = "|cff777777[%H:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_AMPM = "|cff777777[%I:%M:%S %p]|r "

