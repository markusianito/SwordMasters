-->> CurrencyController.lua
--> Coins & Level Handler from client.
--> Scripted by Marcos.

local players = game:GetService("Players");
local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"));
local math = require(bin:WaitForChild("MathTena"));
local stack = require(storage.StandardLibraries.HostStack);
local lvlsettings = require(storage.StandardLibraries.LevelSettings);
local goods = players.LocalPlayer:WaitForChild("Goods", 30);
local coins = goods:WaitForChild("Coins")
local guis = players.LocalPlayer:WaitForChild("PlayerGui");

local coinsGui = guis:WaitForChild("Currency"):WaitForChild("CurrencyBackground");
local coinsStackLabel = coinsGui:WaitForChild("CoinsEarnedTotal");
local coinsLabel = coinsGui:WaitForChild("CoinsText")
local AddCoins = net:RemoteEvent("AddCoins");




local eco = knit.CreateController({Name = "CurrencyController"});
eco.CoinsVal = nil;



function eco.OnAddCoins(coins)
    eco.CoinsVal.Value += coins;
end

function eco.OnCoinsUpdate()
    task.wait()
    coinsLabel.Text = math.formatInt(coins.Value)
end


function eco:KnitStart()
    AddCoins.OnClientEvent:Connect(eco.OnAddCoins)
    coins.Changed:Connect(eco.OnCoinsUpdate);

    
    eco.CoinsVal = Instance.new("IntValue");
    eco.CoinsVal.Name = "EarnedCoins";
    eco.CoinsVal.Parent = goods

    stack:LookForValue(eco.CoinsVal, coinsStackLabel ,UDim2.new(0.5, 0,-0.17, 0))
    eco.OnCoinsUpdate();
    print("CurrencyController is ready")
end

return eco;