--disable
local module = require(game.ReplicatedFirst:WaitForChild("DataLoad"))

local Remote2 = game.ReplicatedStorage.RemoteEvents.DataEvents.NewItem
local remote1 = game.ReplicatedStorage.RemoteEvents.DataEvents.DelItem

local plr = game.Players.LocalPlayer

Remote2.OnClientEvent:Connect(function(ItemName,ItemType)
	module.NewItemAdded(plr, ItemName, ItemType)
end)

remote1.OnClientEvent:Connect(function(ItemName,ItemType)
	module.RemoveItemSync(plr, ItemName, ItemType)
end)