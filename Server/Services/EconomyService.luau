-->> EconomyService.lua
--> This service includes coins and level handlers for SM
--> Scripted by Marcos


local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit);
local net = require(bin.Net);

local lvlSettings = require(storage.StandardLibraries.LevelSettings)



local AddCoins = net:RemoteEvent("AddCoins");



local eco = knit.CreateService({Name = "EconomyService"});


eco.CoinDeals = {
	["Abandoned Village"]	= 75;
	["Desert Village"]		= 75;
	["Training Arena"]		= 75;
	["Mystery Forest"]		= 90;
	["Colosseum"]			= 150;
	["Mountain Top"]		= 120;
	["Zombie"]				= 1;
	["Miniboss"]			= 30;
	["Player"]				= 20;
	["Boss"]				= 0
}

eco.XPDeals = lvlSettings.Rewards;




function eco:PayPlayer(plr: Player, coins: number)
	local val = plr.Goods.Coins;
	if val then
		val.Value += coins;
		AddCoins:FireClient(plr, coins);
	end
end



function eco:TeachPlayer(plr, xp)
	
end

function eco:KnitInit()

end
function eco:KnitStart()
	
	print("EconomyService: Started")
end




return eco;