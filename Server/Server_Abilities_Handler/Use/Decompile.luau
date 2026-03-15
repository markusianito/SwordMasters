-->> Decompile.lua - Server
--> 
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Decompile"
local lib = require(script.Parent:WaitForChild("Lib"))

local unlockable = false;






local function Cleanup(plr:Player, playerData, cback)
	return function()
		local suck, err = pcall(function()
			playerData = playerData[plr.Name].AbilityData[self];
		end)
		if suck then
			lib:MemoryBan(playerData[plr.Name]);
			return true;
		end
		warn(`Cleanup function in {self}: ` .. err);
		return false;
	end
end



local main = {};


function main.Cleanup(...)
	return Cleanup(...)
end



function main.Unlock()
	return unlockable;
end



function main.Load(plr:Player, playerData:{tables}, Loaded:RemoteEvent, bring:RemoteEvent, cback:RemoteFunction, kill:BindableEvent)
	Loaded:FireClient(plr, self);
	return true;
end



function main.Use(plr:Player, playerData:{tables}, vfxName:string)
	
end


return main;