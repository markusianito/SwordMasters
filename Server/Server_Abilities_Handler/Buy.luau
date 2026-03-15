local Buy = {}

local BuyEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy")

local function onBuy(plr,abilityName)
	
end

BuyEvent.OnServerEvent:Connect(onBuy)

return Buy
