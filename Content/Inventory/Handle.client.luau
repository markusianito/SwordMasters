--disable
local remote = game.ReplicatedStorage.RemoteEvents.DataEvents:WaitForChild("DataSend")
local module = require(game.ReplicatedFirst:WaitForChild("DataLoad"))

local inventoryFrame = script.Parent:WaitForChild("Inventory Frame")

function DataLoadIn(data)
	module.DataLoad(data, inventoryFrame.InsideInvFrame.ScrollingFrameSkins, inventoryFrame.InsideInvFrame.ScrollingFrameSwords,inventoryFrame.InsideInvFrame.ScrollingFrameAbilities, inventoryFrame:WaitForChild("Item Information Frame"))
end

remote.OnClientEvent:Connect(DataLoadIn)


