-->> Lib.lua
--> Functions and stuff shared across all the abilities scripts.
--> Scripted by Marcos

local module = {}


local twi = TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.In,0, false,0)


local TheParams = OverlapParams.new() --> THE SIGN REFRENCCE OMG :0
TheParams.FilterType = Enum.RaycastFilterType.Exclude
TheParams.FilterDescendantsInstances = {workspace.Lobby, workspace.GameMap};


local TheParams2 = RaycastParams.new()
TheParams2.FilterType = Enum.RaycastFilterType.Include
TheParams2.FilterDescendantsInstances = {workspace.GameMap, workspace.Lobby};
TheParams2.RespectCanCollide = true;

local TheParams3 = OverlapParams.new()
TheParams3.FilterType = Enum.RaycastFilterType.Include;
TheParams3.FilterDescendantsInstances = {workspace.GameMap, workspace.Lobby};
--TheParams3.MaxParts = 5;


module.knit = require(game.ReplicatedStorage.Packages.Knit);
module.twi = twi;
module.TheParams = TheParams;
module.TheParams2 = TheParams2;
module.TheParams3 = TheParams3



function module:MemoryBan(t:table)
	self = t;
	for _,v in pairs(self) do
		if typeof(v) == "RBXScriptConnection" then
			v:Disconnect();
			v = nil;
		elseif typeof(v) == "Instance" then
			v:Destroy();
			v = nil;
		elseif typeof(v) == "table" then

			module:MemoryBan(v);

		else
			v = nil;
		end
	end
end

return module
