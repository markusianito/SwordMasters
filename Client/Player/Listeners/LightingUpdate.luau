-->> LightingUpdate.lua
--> Applies lighting for maps in client.
--> Scripter by Marcos.

local lighting = game:GetService("Lighting");
local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"))


local lightSvc = nil;
local light = knit.CreateController({Name = "LightingUpdate"});


function light.OnUpdate(lightFolder: Folder, lightTable: table)
	--warn(lightTable, lightFolder);
	lighting:ClearAllChildren();
	for _,v in pairs(lightFolder:GetChildren()) do
		v:Clone().Parent = lighting
	end

	for i,v in pairs(lightTable) do
		lighting[i] = v;
	end
end


function light.KnitStart()
	lightSvc = knit.GetService("LightingProvider");
	lightSvc.OnUpdate:Connect(light.OnUpdate);
	print("LightingListener is ready");
end


return light;