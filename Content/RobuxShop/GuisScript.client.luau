local player = game:GetService("Players").LocalPlayer

local screenGui = script.Parent
local Main = screenGui.Main

local CurrencyButton = Main.CurrencySectionButton
local GamepassButton = Main.GamepassSectionButton

local MarketplaceService = game:GetService("MarketplaceService")

local function purchaseProduct(player, pId)	
	MarketplaceService:PromptProductPurchase(player, pId)
end

local function purchasePass(player, pId)
	MarketplaceService:PromptGamePassPurchase(player, pId)
end

-- Buttons

--[[ Blivion Note: This script sucks and i repeated my self alot but i prefer doing 
	it when i use MarketPlaceService for security purposes
]]--

local button1 = Main.CurrencyFrame.CurrencyBuy1.Buy1
local button2 = Main.CurrencyFrame.CurrencyBuy2.Buy2
local button3 = Main.CurrencyFrame.CurrencyBuy3.Buy3
local button4 = Main.CurrencyFrame.CurrencyBuy4.Buy4
local button5 = Main.CurrencyFrame.CurrencyBuy5.Buy5
local button6 = Main.CurrencyFrame.CurrencyBuy6.Buy6



local button7 = Main.GamepassesFrame.GamepassBuy1.GBuy1;

button1.MouseButton1Click:Connect(function()
	local productId = 1933533773 -- 500$

	if player then
		purchaseProduct(player, productId)
	end
end)

button2.MouseButton1Click:Connect(function()
	local productId = 1933534359 -- 1000$

	if player then
		purchaseProduct(player, productId)
	end
end)

button3.MouseButton1Click:Connect(function()
	local productId = 1933534481 -- 5000$

	if player then
		purchaseProduct(player, productId)
	end
end)

button4.MouseButton1Click:Connect(function()
	local productId = 1933534616 -- 10000$

	if player then
		purchaseProduct(player, productId)
	end
end)

button5.MouseButton1Click:Connect(function()
	local productId = 1933535168 -- 50000$

	if player then
		purchaseProduct(player, productId)
	end
end)

button6.MouseButton1Click:Connect(function()
	local productId = 1933535308 -- 100000$

	if player then
		purchaseProduct(player, productId)
	end
end)

button7.MouseButton1Click:Connect(function()
	local productId = 921433846 -- molten knight

	if player then
		purchasePass(player, productId)
	end
end)














local function onClick(name)

	-- name = "C" ("Currency")
	-- name = "G" ("Gamepass")

	if name == "C" then
		Main.CurrencyFrame.Visible = true
		Main.GamepassesFrame.Visible = false
	end

	if name == "G" then
		Main.CurrencyFrame.Visible = false
		Main.GamepassesFrame.Visible = true
	end
end

CurrencyButton.MouseButton1Click:Connect(function()
	onClick("C")
end)
GamepassButton.MouseButton1Click:Connect(function()
	onClick("G")
end)

