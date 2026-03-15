-->> ServerBegin.lua
--> Starts all SM services scripts, scripted by me.
--> Scripted by Marcos Saenz.

print("Hello world, from Server!")

local players = game:GetService("Players")
local sss = game:GetService("ServerScriptService")
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit);
local net = require(bin.Net);
local sv = require(script.Server);


local ok = true;
local CloseServer = function()
	ok = false;
	sv.ShutDownServer(0x1)
end


xpcall(function()
	knit.AddServices(sss.Services);
	knit.AddServices(sss.Providers);
	knit.AddServices(sss.Providers.BossProviderDeprecated);
end, CloseServer)



if ok then
	knit.Start():andThen(function()
		print("Knit Started");
	end):catch(CloseServer)
else
	return
end

local loaded = false;
local plrs  = {}
net:RemoteEvent("Loaded1st").OnServerEvent:Connect(function(plr)
	if plrs[plr.Name] then
		plr:Kick("ClientBegin.luau requested player disconnect")
		plrs[plr.Name] = nil;
		return;
	end

	plrs[plr.Name] = true;

	if not loaded then
		loaded = true;
		script.Parent.Ready:Fire();
	end
end)

players.PlayerRemoving:Connect(function(plr)
	plrs[plr.Name] = nil;
end)