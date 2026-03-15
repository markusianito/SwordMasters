local picker = {}

local multiplier=1000000 -- so u can have minumum 0.000001% chance if u need less then u can make amount of zeros= amount of numbers after . 

--[[ items list example:

local items = {
	["one"]=50,
	["two"]=25,
	["three"]=12.5,
	["four"]=6.25,
	["five"]=3.125,
	["six"]=3.125
}
]]

function picker.Pick(itemsList)
	local chancesSum=100*multiplier
	local chance=math.random(1,chancesSum)
	
	
	for itemName,itemChance in pairs(itemsList) do
		local multiplaiedItemChance=itemChance*multiplier
		if chance<=multiplaiedItemChance then
			return itemName
		else
			chance-=multiplaiedItemChance
		end
	end
end

return picker
