local module = {}

module.LayoutRarities = {
	["Starter"] = 100,
	["Common"] = 99,
	["Uncommon"] = 98,
	["Rare"] = 97,
	["Epic"] = 96,
	["Legendary"] = 95,
	["Special"] = 94,
	["Exclusive"] = 93,
	["Admin"] = 1,}
module.RarityNameColors = {
	["Starter"] = {Color = Color3.new(0.847059, 0.847059, 0.847059), Stroke = Color3.new(0.54902, 0.54902, 0.54902)},
	["Common"] = {Color = Color3.new(0.847059, 0.847059, 0.847059), Stroke = Color3.new(0.54902, 0.54902, 0.54902)},
	["Uncommon"] = {Color = Color3.new(0.466667, 0.917647, 0.368627), Stroke = Color3.new(0.262745, 0.517647, 0.223529)},
	["Rare"] = {Color = Color3.new(0.4, 0.811765, 1), Stroke = Color3.new(0.188235, 0.345098, 0.439216)},
	["Epic"] = {Color = Color3.new(0.552941, 0.403922, 1), Stroke = Color3.new(0.298039, 0.168627, 0.494118)},
	["Legendary"] = {Color = Color3.new(1, 0.717647, 0.054902),  Stroke = Color3.new(0.552941, 0.337255, 0.0313725)},
	["Special"] = {Color = Color3.new(0, 1, 0.615686),  Stroke = Color3.new(0.0901961, 0.470588, 0.356863)},
	["Exclusive"] = {Color = Color3.new(0.411765, 0.00784314, 0.596078),  Stroke = Color3.new(0.152941, 0.0745098, 0.196078)},
	["Admin"] = {Color = Color3.new(0, 0, 0),  Stroke = Color3.new(1, 1, 1)
	}
}

module.RarityBorders = {
	["Starter"] = Color3.new(0.439216, 0.439216, 0.439216),
	["Common"] = Color3.new(0.439216, 0.439216, 0.439216),
	["Uncommon"] = Color3.new(0.239216, 0.470588, 0.211765),
	["Rare"] = Color3.new(0.00784314, 0.376471, 0.458824),
	["Epic"] = Color3.new(0.313725, 0.156863, 0.470588),
	["Legendary"] = Color3.new(0.560784, 0.4, 0),
	["Special"] = Color3.new(0.168627, 0.560784, 0.396078),
	["Exclusive"] = Color3.new(0.0901961, 0.0392157, 0.121569),
	["Admin"] = Color3.new(0.898039, 0.898039, 0.898039),
}

module.RarityChances = {
	["Common"] = 59,
	["Uncommon"] = 30,
	["Rare"] = 10,
	["Epic"] = 1,
	["Legendary"] = 3,
}


module.Skins = {
	["Default"] = {Name = "Default" , ID =  13275067652, Rarity = "Starter", Description = "The starter skin of the game",Type = "Skin"},
	["Green Default"] = {Name = "Green Default" , ID =  13275080504, Rarity = "Common", Description = "Green edition of Default skin",Type = "Skin"},
	["Blue Default"] = {Name = "Blue Default" , ID =  13275088193, Rarity = "Common", Description = "Blue edition of Default skin",Type = "Skin"},
	["Red Default"] = {Name = "Red Default" , ID =  13275095270, Rarity = "Common", Description = "Red edition of Default skin",Type = "Skin"},
	["Yellow Default"] = {Name = "Yellow Default" , ID =  13275102846, Rarity = "Common", Description = "Yellow edition of Default skin",Type = "Skin"},
	["Black Default"] = {Name = "Black Default" , ID =  13275110830, Rarity = "Common", Description = "Black edition of Default skin",Type = "Skin"},
	["Noob"] = {Name = "Noob" , ID =  13275117554, Rarity = "Uncommon", Description = "He is just a cute innocent noobie!",Type = "Skin"},  -- Start of Uncommons
	["Jack"] = {Name = "Jack" , ID =  13275124115, Rarity = "Uncommon", Description = "Dude from the hood",Type = "Skin"},
	["Tom"] = {Name = "Tom" , ID =  15645663791, Rarity = "Uncommon", Description = "An artist with a sword fighting skills",Type = "Skin"},
	["Jake"] = {Name = "Jake" , ID =  13275145431, Rarity = "Uncommon", Description = "A good friend of Bob",Type = "Skin"},
	["K.O.S.S.O"] = {Name = "K.O.S.S.O" , ID =  76960835627344, Rarity = "Rare", Description = "A robotic knight programmed to fight the evil",Type = "Skin"}, -- Start of Rares
	["Bob"] = {Name = "Bob" , ID =  13275158458, Rarity = "Rare", Description = "Some People see him as a cook, others see him as meme, but everyone knows he's Bob!",Type = "Skin"},
	["Shadow Warrior"] = {Name = "Shadow Warrior" , ID =  17072310877, Rarity = "Epic",Description = "A strange warrior from the unknown side of the space",Type = "Skin"}, -- Start of Epic
	["Gladiator"] = {Name = "Gladiator" , ID =  17173113068, Rarity = "Epic", Description = "This guy rules the Colosseum, for years no one took over his role as King of the Colosseum",Type = "Skin"},
	["Crystal King"] = {Name = "Crystal King" , ID =  88883248982536, Rarity = "Legendary", Description = "Ruler of the Crystal kingdom",Type = "Skin"}, -- Start of Legendaries
	["Mountain Guardian"] = {Name = "Mountain Guardian" , ID =  14113743972, Rarity = "Special", Description = "This thing rules the mountain top. No one knows if he's evil or not, but he doesn't let anyone be on his mountain...",Type = "Skin"},
	["Molten Knight"] = {Name = "Molten Knight" , ID =  91943337217989, Rarity = "Exclusive", Description = "A knight that came straight out from the lava",Type = "Skin"},
	["Void Crystal King"] = {Name = "Void Crystal King" , ID =  89603376233486, Rarity = "Exclusive", Description = "Void version of Crystal King which is exclusive to players who complete special challenges",Type = "Skin"}, 
}

module.Skins.Prices = {
	["Common"] = 2000,
	["Uncommon"] = 6250,
	["Rare"] = 12500,
	["Epic"] = 25000,
	["Legendary"] = 60000,

}

module.Swords = {
	["Default Sword"] = {Name = "Default Sword" , ID = 18148544101, Rarity = "Starter", Description = "Default Sword of the game",Type = "Sword", Damage = 15, Delay = 0.35},
	["Green Sword"] = {Name = "Green Sword" , ID = 18148691575, Rarity = "Common" , Description = "Green version of the default sword",Type = "Sword", Damage = 15, Delay = 0.35},
	["Blue Sword"] = {Name = "Blue Sword" , ID = 18148825328, Rarity= "Common" , Description = "Blue version of the default sword",Type = "Sword", Damage = 15, Delay = 0.35},
	["Red Sword"] = {Name = "Red Sword" , ID = 18148840345, Rarity ="Common" , Description = "Red version of the default sword",Type = "Sword", Damage = 15, Delay = 0.35},
	["Gladiator's Sword"] = {Name = "Gladiator's Sword" , ID = 18148861656, Rarity = "Uncommon" , Description = "The great spartan sword",Type = "Sword", Damage = 16, Delay = 0.35},
	["Bob's Knife"] = {Name = "Bob's Knife" , ID = 18148884388, Rarity = "Rare" , Description = "Perfect for cooking!",Type = "Sword", Damage = 18, Delay = 0.35},
	["Great Sword"] = {Name = "Great Sword" , ID = 126165401292845, Rarity = "Rare" , Description = "Great sword owned by advanced sword masters!",Type = "Sword", Damage = 18, Delay = 0.35},
	["Shadow Sword"] = {Name = "Shadow Sword" , ID = 18131378192, Rarity = "Epic" , Description = "Mysterious sword created by the unknown",Type = "Sword", Damage = 20, Delay = 0.35},
	["Crystal Sword"] = {Name = "Crystal Sword" , ID = 126446528852253, Rarity = "Legendary" , Description = "Shiny sword made out of rare crystals!",Type = "Sword", Damage = 22, Delay = 0.35},
	["Mountain Sword"] = {Name = "Mountain Sword" , ID = 14133395468, Rarity = "Special" , Description = "The great mountain sword staight from the top",Type = "Sword", Damage = 22, Delay = 0.35},
	["Molten Sword"] = {Name = "Molten Sword" , ID = 95641756499877, Rarity = "Exclusive" , Description = "Molten hot sword made out of lava rocks and steel",Type = "Sword", Damage = 22, Delay = 0.35},
	["Void Crystal Sword"] = {Name = "Void Crystal Sword" , ID = 131121800170987, Rarity = "Exclusive" , Description = "Void version of Crystal Sword which is exclusive to players who complete special challenges",Type = "Sword", Damage = 22, Delay = 0.35},
	["Admin pan"] = {Name = "Admin pan" , ID = 18148544101, Rarity = "Admin", Description = "Pan of gods",Type = "Sword", Damage = 1000, Delay = 0.15}
}

module.Swords.Prices = {
	["Common"] = 1500,
	["Uncommon"] = 5000,
	["Rare"] = 10000,
	["Epic"] = 22000,
	["Legendary"] = 50000,

}

SkinLockedId = 13761477638
local module2 = require(game.ReplicatedStorage.Client_Modules.ReplicatedSettings)

local gettedClient = game.ReplicatedStorage.ClientEvents.Transactions;
function module.DataLoad(data, SkinHold, SwordHold, AbilityHold, ItemInformation) 

	for _, skin in pairs(data.Skins) do
		if module.Skins[skin] then
			local SkinInModule = module.Skins[skin] 
			local CreateSlot = script.Slot:Clone()
			CreateSlot.Parent= SkinHold
			CreateSlot.Name=skin

			if module.RarityBorders[SkinInModule.Rarity] then
				CreateSlot.BackgroundColor3 = module.RarityBorders[SkinInModule.Rarity]
			end

			CreateSlot.LayoutOrder = module.LayoutRarities[SkinInModule["Rarity"]]
			CreateSlot.Image = "rbxassetid://"..SkinInModule.ID
			CreateSlot.UIStroke.Color = module.RarityBorders[SkinInModule.Rarity]
			CreateSlot.MouseButton1Click:Connect(function()


				ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[SkinInModule["Rarity"]].Color

				ItemInformation.Frame.SelectedItem.Value=skin

				local SelectedItem = ItemInformation.Frame.SelectedItem
				ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..SkinInModule.ID

				if SkinInModule["Description"] then
					ItemInformation.Frame.Description.Text  = SkinInModule.Description
				end

				ItemInformation.Frame.Rarity.Text = SkinInModule.Rarity

				ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[SkinInModule["Rarity"]].Stroke

				ItemInformation.Frame:WaitForChild("Item name").Text = skin



				ItemInformation.Frame.TypeOfItem.Value="Skin"

			end)
		end
	end




	for _, sword in pairs(data.Swords) do
		if module.Swords[sword] then
			local SwordInModule = module.Swords[sword] 
			local CreateSlot = script.Slot:Clone()
			CreateSlot.Parent= SwordHold
			CreateSlot.Name=sword

			if module.RarityBorders[SwordInModule.Rarity] then
				CreateSlot.BackgroundColor3 = module.RarityBorders[SwordInModule.Rarity]
			end
			CreateSlot.LayoutOrder = module.LayoutRarities[SwordInModule["Rarity"]]
			CreateSlot.Image = "rbxassetid://"..SwordInModule.ID
			CreateSlot.UIStroke.Color = module.RarityBorders[SwordInModule.Rarity]
			CreateSlot.MouseButton1Click:Connect(function()


				ItemInformation.Frame.SelectedItem.Value=sword

				local SelectedItem = ItemInformation.Frame.SelectedItem
				ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..SwordInModule.ID

				if SwordInModule["Description"] then
					ItemInformation.Frame.Description.Text  = SwordInModule.Description

				else
					ItemInformation.Frame.Description.Text="None"
				end

				ItemInformation.LayoutOrder = module.LayoutRarities[SwordInModule["Rarity"]]

				if SwordInModule["Rarity"] then
					ItemInformation.Frame.Rarity.Text = SwordInModule.Rarity
					ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[SwordInModule["Rarity"]].Color
					ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[SwordInModule["Rarity"]].Stroke
				end

				ItemInformation.Frame:WaitForChild("Item name").Text = sword

				ItemInformation.Frame.TypeOfItem.Value="Sword"

			end)
		end
	end




	for _,ability in pairs(data.Abilities) do
		if module2.Abilities[ability] then
			--print(ability)
			local AbInModule = module2.Abilities[ability] 
			local CreateSlot = script.Slot:Clone()
			CreateSlot.Parent= AbilityHold
			CreateSlot.Name=ability

			if module.RarityBorders[AbInModule.Rarity] then
				CreateSlot.BackgroundColor3 = module.RarityBorders[AbInModule.Rarity]
			end
			CreateSlot.LayoutOrder = module.LayoutRarities[AbInModule["Rarity"]]
			CreateSlot.Image = "rbxassetid://"..AbInModule.ID
			CreateSlot.UIStroke.Color = module.RarityBorders[AbInModule.Rarity]
			CreateSlot.MouseButton1Click:Connect(function()


				ItemInformation.Frame.SelectedItem.Value=ability

				local SelectedItem = ItemInformation.Frame.SelectedItem
				ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..AbInModule.ID

				if AbInModule["Description"] then
					ItemInformation.Frame.Description.Text  = AbInModule.Description

				else
					ItemInformation.Frame.Description.Text="None"
				end

				ItemInformation.LayoutOrder = module.LayoutRarities[AbInModule["Rarity"]]

				if AbInModule["Rarity"] then
					ItemInformation.Frame.Rarity.Text = AbInModule.Rarity
					ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[AbInModule["Rarity"]].Color
					ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[AbInModule["Rarity"]].Stroke
				end

				ItemInformation.Frame:WaitForChild("Item name").Text = ability

				ItemInformation.Frame.TypeOfItem.Value="Ability"

			end)
		end
	end
end

function module.NewItemAdded(player, ItemName, ItemType)
	warn("NEW ITEM ADDED")
	local ItemInformation = player.PlayerGui.InventoryGui:WaitForChild("Inventory Frame"):WaitForChild("Item Information Frame")

	if ItemType=="Skin" then
		if player.Data.Skins:FindFirstChild(ItemName) then
			local SkinHold  = player.PlayerGui.InventoryGui:WaitForChild("Inventory Frame").InsideInvFrame.ScrollingFrameSkins
			if module.Skins[ItemName] then
				local SkinInModule = module.Skins[ItemName] 
				local CreateSlot = script.Slot:Clone()
				CreateSlot.Parent= SkinHold
				CreateSlot.Name=ItemName

				CreateSlot.LayoutOrder = module.LayoutRarities[SkinInModule["Rarity"]]

				if module.RarityBorders[SkinInModule.Rarity] then
					CreateSlot.BackgroundColor3 = module.RarityNameColors[SkinInModule.Rarity].Color
				end

				CreateSlot.Image = "rbxassetid://"..SkinInModule.ID
				CreateSlot.UIStroke.Color = module.RarityBorders[SkinInModule.Rarity]

				CreateSlot.MouseButton1Click:Connect(function()

					CreateSlot.UIStroke.Color = module.RarityBorders[SkinInModule.Rarity]
					ItemInformation.Frame.SelectedItem.Value=ItemName

					local SelectedItem = ItemInformation.Frame.SelectedItem
					ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..SkinInModule.ID

					if SkinInModule["Description"] then
						ItemInformation.Frame.Description.Text  = SkinInModule.Description
					end

					ItemInformation.Frame.Rarity.Text = SkinInModule.Rarity
					ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[SkinInModule["Rarity"]].Color
					ItemInformation.Frame:WaitForChild("Item name").Text = ItemName

					ItemInformation.LayoutOrder = module.LayoutRarities[SkinInModule["Rarity"]]

					ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[SkinInModule["Rarity"]].Stroke

					ItemInformation.Frame.TypeOfItem.Value="Skin"

				end)
			end
		end
	end

	if ItemType=="Sword" then
		if player.Data.Swords:FindFirstChild(ItemName) then
			local SwordHold  = player.PlayerGui.InventoryGui:WaitForChild("Inventory Frame").InsideInvFrame.ScrollingFrameSwords
			if module.Swords[ItemName] then
				local SwordInModule = module.Swords[ItemName] 
				local CreateSlot = script.Slot:Clone()
				CreateSlot.Parent= SwordHold
				CreateSlot.Name=ItemName

				CreateSlot.LayoutOrder = module.LayoutRarities[SwordInModule["Rarity"]]

				if module.RarityBorders[SwordInModule.Rarity] then
					CreateSlot.BackgroundColor3 = module.RarityBorders[SwordInModule.Rarity]
				end

				CreateSlot.Image = "rbxassetid://"..SwordInModule.ID
				CreateSlot.UIStroke.Color = module.RarityBorders[SwordInModule.Rarity]
				CreateSlot.MouseButton1Click:Connect(function()

					ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[SwordInModule["Rarity"]].Color 

					ItemInformation.Frame.SelectedItem.Value=ItemName

					local SelectedItem = ItemInformation.Frame.SelectedItem
					ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..SwordInModule.ID

					if SwordInModule["Description"] then
						ItemInformation.Frame.Description.Text  = SwordInModule.Description

					else
						ItemInformation.Frame.Description.Text="None"

					end
					ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[SwordInModule["Rarity"]].Stroke
					ItemInformation.LayoutOrder = module.LayoutRarities[SwordInModule["Rarity"]]

					if SwordInModule["Rarity"] then
						ItemInformation.Frame.Rarity.Text = SwordInModule.Rarity
					end

					ItemInformation.Frame:WaitForChild("Item name").Text = ItemName .." Sword"

					ItemInformation.Frame.TypeOfItem.Value="Sword"

				end)
			end
		end
	end

	if ItemType=="Ability" then
		if player.Data.Abilities:FindFirstChild(ItemName) then
			local AbHold  = player.PlayerGui.InventoryGui:WaitForChild("Inventory Frame").InsideInvFrame.ScrollingFrameAbilities
			if module2.Abilities[ItemName] then
				local AbInModule = module2.Abilities[ItemName] 
				local CreateSlot = script.Slot:Clone()
				CreateSlot.Parent= AbHold
				CreateSlot.Name=ItemName

				CreateSlot.LayoutOrder = module.LayoutRarities[AbInModule["Rarity"]]

				if module.RarityBorders[AbInModule.Rarity] then
					CreateSlot.BackgroundColor3 = module.RarityBorders[AbInModule.Rarity]
				end

				CreateSlot.Image = "rbxassetid://"..AbInModule.ID
				CreateSlot.UIStroke.Color = module.RarityBorders[AbInModule.Rarity]
				CreateSlot.MouseButton1Click:Connect(function()

					ItemInformation.Frame.Rarity.TextColor3 = module.RarityNameColors[AbInModule["Rarity"]].Color 

					ItemInformation.Frame.SelectedItem.Value=ItemName

					local SelectedItem = ItemInformation.Frame.SelectedItem
					ItemInformation.Frame:WaitForChild("Item Image").Image= "rbxassetid://"..AbInModule.ID

					if AbInModule["Description"] then
						ItemInformation.Frame.Description.Text  = AbInModule.Description

					else
						ItemInformation.Frame.Description.Text="None"

					end
					ItemInformation.Frame.Rarity.UIStroke.Color = module.RarityNameColors[AbInModule["Rarity"]].Stroke
					ItemInformation.LayoutOrder = module.LayoutRarities[AbInModule["Rarity"]]

					if AbInModule["Rarity"] then
						ItemInformation.Frame.Rarity.Text = AbInModule.Rarity
					end

					ItemInformation.Frame:WaitForChild("Item name").Text = ItemName .." Ability"

					ItemInformation.Frame.TypeOfItem.Value="Ability"

				end)
			end
		end
	end


	gettedClient:Fire("NewItem", {AinStr = "You Received", Object = ItemName});
end



function module.RemoveItemSync(player,ItemName,ItemType)

end

return module
