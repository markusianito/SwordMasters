local Inventory = {}

local plr=game:GetService("Players").LocalPlayer

local connections={}
local inventoryData={}

local inventoryGui=plr:WaitForChild("PlayerGui"):WaitForChild("Inventory")

local function getPlrAbilitiesValues()
	return plr:WaitForChild("Inventory"):WaitForChild("Abilities"):GetChildren()
end

local function refreshInventory()
	
end

local function refreshInventoryData()
	inventoryData={}
	for i,abilityValue in pairs(getPlrAbilitiesValues()) do
		table.insert(inventoryData, abilityValue.Name)
	end
end

-- loading inventory data --
refreshInventoryData()
refreshInventory()


return Inventory
