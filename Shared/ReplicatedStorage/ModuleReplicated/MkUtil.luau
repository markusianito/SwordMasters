-->> MkUtil.lua
--> Universal Utilites 

local module = {}

function module.RandomResult(mul)
	mul = mul or 1;
	local realRandom = wait() * 1e7;
	return math.floor((Random.new():NextNumber() * realRandom) * mul)
end

return module