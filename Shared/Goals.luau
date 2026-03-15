-->> Goals.lua - Server
--> Objective goals modulo idc


local Maps = require(game.ReplicatedStorage.Classes.Maps);


local goals = {}

function goals.ZombieHunt(Map)
	Map = Maps[Map];
	
	local amount = Map.MinZombieAmount + ((#game.Players:GetPlayers() - 1) * Map.ZombieIncrementPerPlayer); --> 40 if 1 player, 80 if 3 players;
	--warn(Map)
	return amount
end

function goals.Bossfight(Map)
	Map = Maps[Map];
	return Map.Amount
end

function goals.PVP(Map)
	Map = Maps[Map];
	return Map.Amount
end


function goals.GetGoals(Map, Mode)
	if not Map then return; end;
	Mode = Maps[Map].Mode
	return goals[Mode](Map)
end

return goals
