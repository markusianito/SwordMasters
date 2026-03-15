local SimpleFunctions = {}

SimpleFunctions.GetTimeStringFromSeconds=function(timeInSeconds:number)
	local hours=0
	local minutes=0
	local seconds=0

	hours = math.floor(timeInSeconds/3600);
	minutes= math.floor((timeInSeconds-hours*3600)/60)
	seconds=math.floor(timeInSeconds-hours*3600-minutes*60)

	if hours+seconds+minutes==0 then
		return "00:00:00"
	else
		if hours~=0 then
			if minutes<10 then minutes="0"..tostring(minutes) end
			if seconds<10 then seconds="0"..tostring(seconds) end
			return hours.." : "..minutes.." : "..seconds
		elseif minutes~=0 then
			if minutes<10 then minutes="0"..tostring(minutes) end
			if seconds<10 then seconds="0"..tostring(seconds) end
			return minutes.." : "..seconds
		elseif seconds~=0 then
			if seconds<10 then seconds="0"..tostring(seconds) end
			return seconds
		end
	end
end


return SimpleFunctions
