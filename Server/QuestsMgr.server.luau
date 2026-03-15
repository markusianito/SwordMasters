


--#################################################################



local function is_valid_timestamp(timestamp)
	local h, m, s = timestamp:match("^(%d%d?):(%d%d):?(%d?%d?)")
	warn(h, m ,s)
	if h and m then
		h = tonumber(h)
		m = tonumber(m)
		s = tonumber(s) or 0
		return h >= 0 and h < 24 and m >= 0 and m < 60 and s >= 0 and s < 60
	end
	return false
end

local function getResetIntervalInHours(resetTimeInSeconds, timezoneOffset)
	local timeInTimeZone = (resetTimeInSeconds + timezoneOffset) % (24 * 3600)

	local resetInterval = timeInTimeZone / 3600
	resetInterval = math.floor(resetInterval * 2) / 2

	return resetInterval
end

local resetTimeInSeconds = 13 * 3600 + 30 * 60
local timezoneOffset = -5 * 3600

local interval = getResetIntervalInHours(resetTimeInSeconds, timezoneOffset)






local function calculateResetInterval(restartTimeInSeconds, timezoneOffset)
	local dayInSeconds = 24 * 3600

	local adjustedRestartTime = restartTimeInSeconds - timezoneOffset

	adjustedRestartTime = adjustedRestartTime % dayInSeconds

	local intervalInHours = (adjustedRestartTime) / 3600

	return intervalInHours
end

local restartTimeInSeconds =  ((15 * 3600) + (30 * 60))
local timezoneOffset = -5 * 3600

local resetInterval = calculateResetInterval(restartTimeInSeconds, timezoneOffset)