--disable

local stackhost = require(game.ReplicatedStorage.Client_Modules.HostStack);
local ongrant = game.ReplicatedStorage.RemoteEvents.AllPlayersEvent.OnAddCoins
local localplayer:Player =  game.Players.LocalPlayer
local earned = script.Parent:WaitForChild("CoinsEarnedTotal");

function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1 ")
	return minus .. int:reverse():gsub("^ ,", "") .. fraction
end


localplayer:FindFirstChild("PlayerStats").Coins.Changed:Connect(function()
	
	if localplayer:FindFirstChild("PlayerStats") then
		script.Parent.CurencyText.Text = format_int(localplayer:FindFirstChild("PlayerStats").Coins.Value) 

	else
		print("we cant find leaderstats now maybe player in round or still loading")

	end
	
end)

script.Parent.CurencyText.Text = format_int(localplayer:FindFirstChild("PlayerStats").Coins.Value)

local val = Instance.new("IntValue");
val.Name = "EarnedCoins";
val.Parent = localplayer:WaitForChild("PlayerStats")

stackhost:LookForValue(val, earned,UDim2.new(0.5, 0,-0.17, 0))

ongrant.OnClientEvent:Connect(function(reward)
	val.Value += reward
end)

