-->> LightingProvider.lua
--> Revamped version of Light module by MahDev
--> Scripted by Marcos.

local lightSvc = game:GetService("Lighting");
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit);
local net = require(bin.Net);

local maps = require(storage.Classes.Maps);


local light = knit.CreateService({Name = "LightingProvider", Client = {OnUpdate = knit.CreateSignal();}});


function light:Get(map: string)
	return storage.Assets.Maps[map].Light, maps[map].Light
end
function light.Client:Get(_, map: string)
	return light:Get(map);
end


function light:SetupLighting(lightFolder, lightTable)
	lightSvc:ClearAllChildren();
	for _,v in pairs(lightFolder:GetChildren()) do
		v:Clone().Parent = lightSvc
	end

	for i,v in pairs(lightTable) do
		lightSvc[i] = v;
	end
end

function light.Client:Setup(plr, lightFolder: Folder, lightTable: table)
	light:Setup(lightFolder, lightTable, plr)
end


function light:Setup(lightFolder: Folder, lightTable: table, plr: Player)
	--warn(lightTable, lightFolder, plr);
	if plr then
		light.Client.OnUpdate:Fire(plr, lightFolder, lightTable);
	else
		light:SetupLighting(lightFolder, lightTable);
	end;
end

function light:Remove(plr)
	if plr then
		light.Client.OnUpdate:Fire(plr, light:Get("Lobby"));
	else
		light:SetupLighting(light:Get("Lobby"));
	end
end


function light:KnitInit()
	lightSvc:ClearAllChildren();
	light:Setup(light:Get("Lobby"));
end

function light:KnitStart()
	print("LightingProvider is ready.")
end



return light