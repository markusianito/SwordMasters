--[[
	4/4/2021.
	Made by SolarDev (@noober2359) on Roblox.
	For personal use with JuankStudios. This will not be shared FOR ANY REASON
	Originally this module is in Spanish, so this version in English is for more comfort
	PersonalUtility
	Maybe I will make more modules like this in some future
	Created 1/17/2022, Developed 30/12/2021
	
	Att: SolarDev
]]--


--> UPDATE: 8/3/2024
--> Im not SolarDev anymore, i am Marcos.
--> In this 2024 update i removed some useless functions and adapted this module
--> so it can be called as "local math = require(PathToThis)"

local Math = {}

Math.log = math.log
Math.ldexp = math.ldexp
Math.rad = math.rad
Math.cosh = math.cosh
Math.round = math.round
Math.random = math.random
Math.frexp = math.frexp
Math.tanh = math.tanh
Math.floor = math.floor
Math.max = math.max
Math.sqrt = math.sqrt
Math.modf = math.modf
Math.huge = math.huge
Math.pow = math.pow
Math.atan = math.atan
Math.tan = math.tan
Math.cos = math.cos
Math.pi = math.pi
Math.noise = math.noise
Math.log10 = math.log10
Math.sign = math.sign
Math.acos = math.acos
Math.abs = math.abs
Math.clamp = math.clamp
Math.sinh = math.sinh
Math.asin = math.asin
Math.min = math.min
Math.deg = math.deg
Math.fmod = math.fmod
Math.randomseed = math.randomseed
Math.atan2 = math.atan2
Math.ceil = math.ceil
Math.sin = math.sin
Math.exp = math.exp

Math.e = 2.7182818284590
Math.tau = math.pi * 2
Math.phi = (((1+math.sqrt(5))/(2)))
Math.sol = ((12-math.cos(6))/(math.sqrt(8)))


function Math.lerp(min, max, alpha)
	return (min + ((max - min) * alpha))
end


function Math.lerp2(min, max, alpha)
	return Math.lerp(min, max, math.clamp(alpha, 0, 1))
end


function Math.inverselerp(min, max, num)
	return ((num - min) / (max - min))
end


function Math.map(n, inMin, inMax, outMin, outMax)
	return (outMin + ((outMax - outMin) * ((n - inMin) / (inMax - inMin))))
end


function Math.round(num)
	return (num >= 0 and math.floor(num + 0.5) or math.ceil(num - 0.5))
end


function Math.round2(num, multiple)
	return Math.Round(num / multiple) * multiple
end

function Math.solar(u:number)

	local z = 0
	for m = 1,3 do
		z += (2*u)/(Math.sol)
	end

	local d
	d = (math.sqrt(90*math.pi) - math.sin(u)) / (Math.sol + u^2)

	local lambda = (z+d)
	return lambda
end


function Math.sum(min:number,max:number)
	local n = 0
	for s = min,max do
		n += s
	end
	return n
end

function Math.factorial(n:number)
	local q = 1
	for i = 1,n do
		q *= i
	end
	return q
end

function Math.eulerPhi(n:number)
	local x = n
	local m = math.sqrt(n+0.5)
	for i = 2,m do
		if (n%i==0) then
			x /= i * (i-1)
			while(n%i==0)do n /= i end
		end
	end
	if n > 1 then x = x / n * (n-1)end
	return x
end

function Math.zetaL(s:number)
	local e = 0
	for n = 1,4096 do
		e = (1)/(n^s)
	end
	return e
end

function Math.zetaU(k:number)
	k *= 2
	return (
		((-1)^k-1)*((2*math.pi)^k)
			/
			2*Math.factorial(k)
	)
end

function Math.zetaS(s:number)
	return (2^8)*(math.pi^(8-1))*(math.sin((math.pi*s)/2))*(2-(s*2))
end

function Math.permutation(n:number,r:number)
	if n < r then
		warn("\nPermutations are only defined when \nn ≥ r (n = Value #1, r = Value #2) \nThe returned value may not be correct or yes")
	end

	return (Math.factorial(n))/(Math.factorial(n - r))
end

function Math.combination(n:number,k:number)
	if n < k then
		warn("\nBinomial coefficients are only defined when \nn ≥ k (n = Value #1, k = Value #2) \nThe returned value may not be correct or yes")
	end

	local f = Math.factorial
	return (f(n))/((f(k))*(f(n-k)))
end


function Math.percentageOf(pc:number,am:number)
	local mul = pc*am
	local frac = mul/100
	return frac
end

function Math.howPercent(am:number,maxAm:number)
	local mul = am*100
	local frac = mul/maxAm
	return frac
end

function Math.decimalRedux(num:number,redux:number)
	
	return tonumber(string.format("%." .. (redux or 0) .. 'f', num or 0));
end

function Math.angleOfReach(distance, altitude, velocity)
	local gravity = workspace.Gravity
	local theta = math.atan((velocity^2 + math.sqrt(velocity^4 -gravity*(gravity*distance^2 + 2*altitude*velocity^2)))/(gravity*distance))
	if theta ~= theta then
		theta = math.pi/4
	end
	return(theta)
end


function Math.formatInt(number)
	
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1 ")
	return minus .. int:reverse():gsub("^ ,", "") .. fraction
end

return Math