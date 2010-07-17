
--[[		Timestamp Customize Module		]]

--[[
	Color codes ---> http://www.december.com/html/spec/colorcodes.html
	We use "777777" and add brackets []
	If you want to color chat, you must start with |cff and end with |r
	DO NOT remove anything INSIDE the brackets []
	e.g. %I <-- DO NOT EDIT

	DO NOT remove the |r at the start, it's invisible in chat, and is a
	needed function that timestamps lines that Blizzard misses in channelnames.lua
	e.g. loot, achievements, requires each line to start with |r

	Leave the space at the end if you want a space between timestamps and text (looks better)

	Here is an example of timestamps without colors
	TIMESTAMP_FORMAT_HHMM = "|r[%I:%M] "
]]--

TIMESTAMP_FORMAT_HHMM = "|r|cff777777[%I:%M]|r "
TIMESTAMP_FORMAT_HHMM_24HR = "|r|cff777777[%H:%M]|r "
TIMESTAMP_FORMAT_HHMM_AMPM = "|r|cff777777[%I:%M %p]|r "

TIMESTAMP_FORMAT_HHMMSS = "|r|cff777777[%I:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_24HR = "|r|cff777777[%H:%M:%S]|r "
TIMESTAMP_FORMAT_HHMMSS_AMPM = "|r|cff777777[%I:%M:%S %p]|r "

