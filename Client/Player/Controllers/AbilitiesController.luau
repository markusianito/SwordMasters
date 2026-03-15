-->> AbilitiesController.luau
-- Handles abilities from client
--> Scripted by Marcos



local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local _


local AbilitiesController = knit.CreateController({Name = "AbilitiesController"});







function AbilitiesController:KnitInit()

end

function AbilitiesController:KnitStart()

end


return AbilitiesController;