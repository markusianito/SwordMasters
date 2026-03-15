--> TimeNDate by Marcos
--> general time and date functions

--[[
while true do
	local time_until_next_interval = getTimeUntilNextInterval()

	os.execute("cls");
	print("Lua custom Countdown: Made by Marcos\n\n"..formatTime(time_until_next_interval))
	os.execute("timeout /t 1 > NUL")

	time_until_next_interval = time_until_next_interval - 1

	if time_until_next_interval <= 0 then
		time_until_next_interval = getTimeUntilNextInterval()
	end
end
]]

export type TimeZone = number|string

export type TimeDate = {
	year: number,
	month: number,
	wday: number,
	yday: number,
	day: number,
	hour: number,
	min: number,
	sec: number,
	isdst: boolean
}


local td = {}



function td:GetTimeUntilNextInterval(intervalHours, offsetHours, format:"*t"|"!*t")
	local now = os.time()
	local currentTime = os.date(format or "!*t", now)

	-- Definir el intervalo de 4 horas y el desplazamiento inicial
	local intervalHours = intervalHours or 1
	local offsetHours = offsetHours or 0
	local secondsInInterval = intervalHours * 3600

	-- Calcular el tiempo actual en segundos desde el inicio del día
	local currentSeconds = currentTime.hour * 3600 + currentTime.min * 60 + currentTime.sec

	-- Calcular el tiempo en segundos desde las 00:00
	local secondsFromMidnight = (currentTime.hour + offsetHours) * 3600 + currentTime.min * 60 + currentTime.sec

	-- Encontrar el tiempo transcurrido desde el último intervalo
	local secondsSinceLastInterval = (secondsFromMidnight % secondsInInterval)

	-- Tiempo restante hasta el próximo intervalo
	local secondsUntilNextInterval = secondsInInterval - secondsSinceLastInterval

	return secondsUntilNextInterval
end



-- Función para obtener el número del día ajustado a la zona horaria
function td:GetDayInTimezone(localTime: TimeDate, localZone:TimeZone, goalZone: TimeZone)
	local tiempoOrigen = os.time(localTime)

	local diferenciaSegundos = (goalZone - localZone) * 3600

	local tiempoDestino = tiempoOrigen + diferenciaSegundos

	local tablaDestino = os.date("!*t", tiempoDestino)

	return tablaDestino.day
end



-- Función para formatear el tiempo en horas, minutos y segundos
function td:format(seconds)
	local hours = math.floor(seconds / 3600)
	local minutes = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60

	return string.format("%02d:%02d:%02d", hours, minutes, secs)
end



return td
