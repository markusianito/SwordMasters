-->> ShopService.luau
-- Handles shop in sm
--> Scripted by Marcos



local storageSv = game:GetService("ServerStorage");
local sss = game:GetService("ServerScriptService");
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit.KnitServer);

local skins = require(storage.Classes.Skins);
local swords = require(storage.Classes.Swords);




local ShopService = knit.CreateService({Name = "ShopService";});



function ShopService:RandomSkin()
	
end
 



function ShopService:KnitInit()

end

function ShopService:KnitStart()

end


return ShopService;