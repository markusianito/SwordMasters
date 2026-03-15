-->> BadgesClient.lua
--> El fucking depurador que da advertencias que no se pueden silenciar

local badges = 10;
local promise = require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Promise"));


local compile = require(script:WaitForChild("Describe"));
local BUTT_ONS = require(game.ReplicatedStorage.StandardLibraries.Quests).Assets.Buttons

local badgesComm = game.ReplicatedStorage.RemoteEvents.BadgesCallback
local frame = script.Parent:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame");


badgesComm.OnClientInvoke = function(mode: mode, data:killData, claims:claimData)
	if mode == "describe" then
		compile:Describe(data, claims);
		return true;
	end
	return true;
end


local onLoaded = promise.new(function(resolve, reject)
	local time = 0;
	repeat time+=task.wait() if time >= 10 then warn("algo") end until #frame:GetChildren() == (badges + 1);
	
	resolve()
end):andThen(function()
	local data, claims = badgesComm:InvokeServer("describe");
	--warn(data, claims);
	compile:Describe(data, claims)
end):catch(function(err)
	warn("Failed to load Stats: ", err)
	compile:Describe({
		Player = -1;
		Zombie = -1;
		Miniboss = -1;
		Boss = -1;
	},nil)
end)