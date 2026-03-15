-->> MarketplaceService.luau
-- Handles robux purchases in SM
--> Scripted by Marcos


local DataStoreService = game:GetService("DataStoreService")

local storageSv = game:GetService("ServerStorage");
local sss = game:GetService("ServerScriptService");
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit.KnitServer);
local net = require(bin.Net);


local mpSvc = game:GetService("MarketplaceService")
local Players = game:GetService("Players")
local data;
local questSvc;


local getted = net:RemoteEvent("MessagesStars")
local function notify(player, ItemName)
	getted:FireClient(player, "NewItem", {AinStr = "Successfully purchased", Object = ItemName});
end


local MarketplaceService = knit.CreateService({Name = "MarketplaceService";});
MarketplaceService.ProductsIds = {
		-- DON'T MOVE THE ORDER!
		1933533773,  -- 500$
		1933534359, -- 1000$
		1933534481, -- 5000$
		1933534616, -- 10000$
		1933535168, -- 50000$
		1933535308-- 100000$
}

MarketplaceService.Passes = {
    ["Molten_Knight"] = 921433846
}




local function processRequest(receiptInfo)

	local player = Players:GetPlayerByUserId(receiptInfo.PlayerId)

	if not player then
		return Enum.ProductPurchaseDecision.NotProcessedYet
	end

	if receiptInfo.ProductId == 1933534157 then
		if player then

			-->> REROLL QUESTS
			local ts, prog = questSvc:RerollQuestsFor(player);
			questSvc:UpdateQuestInfoFor(player, ts, prog)


			notify(player, "Reroll Quests")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[1] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 500
			print("Processed 500!")

			notify(player, "500 Coins")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[2] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 1000
			print("Processed 1000!")
			notify(player, "1 000 Coins")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[3] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 5000
			print("Processed 5000!")
			notify(player, "5 000 Coins")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[4] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 10000
			print("Processed 10.000!")
			notify(player, "10 000 Coins")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[5] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 50000
			print("Processed 50.000!")
			notify(player, "50 000 Coins")
		end
	end

	if receiptInfo.ProductId == MarketplaceService.ProductsIds[6] then
		if player then
			player:WaitForChild("PlayerStats"):WaitForChild("Coins").Value += 100000
			print("Processed 100.000!")
			notify(player, "100 000 Coins")
		end
	end

	return Enum.ProductPurchaseDecision.PurchaseGranted
end




function MarketplaceService:KnitInit()

end

function MarketplaceService:KnitStart()
	data = knit.GetService("DataService");
	questSvc = knit.GetService("QuestService");

    mpSvc.ProcessReceipt = processRequest
    mpSvc.PromptGamePassPurchaseFinished:Connect(function(plr, id, done)
        if plr then
            if done then
                if id == MarketplaceService.Molten_Knight then
                    data.Grant.Molten_Knight(plr)
                end
            end
        end
    end)

    print("MarketplaceService started");
end


return MarketplaceService;