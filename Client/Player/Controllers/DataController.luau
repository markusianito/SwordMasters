-->> DataCtrl.luau
-- Handles everything related with inventory client-side
--> Scripted by Marcos


export type PlayerData = {
	Goods: {
		__folder: boolean?;
		Coins: number;
		Level: number;
		XP: number;
	};

	Inventory: {
		__folder: boolean?;
		EquippedSkin: string;
		EquippedSword: string;
		EquippedAbilities: {string};

		Skins: {string};
		Swords: {string};
		Abilities: {string};


	};

	Information: {
		__folder: boolean?;
		LastOnline: number;
		PlayerImage: nil;
		Observations: {
			{
				Type: number,
				Description: number,
				Time: number
			}
		};
		Rank: string;
	};

	Quests: {__folder: boolean?;};
	QuestProgress: {__folder: boolean?;};
	RedeemedCodes: {__folder: boolean?;};
	Stats: {
		__folder: boolean?;
		Kills: {
			Player: number;
			Zombie: number;
			Miniboss: number;
			Boss: number;
			PVP: number;
			Survival: number;
			Bossfight: number;
		};

		General: {
			NewPlayer: boolean;
			TimePlayed: number;
		};
	};
	Badges: {__folder: boolean?;};
	Settings: {
		__folder: boolean?;
		MusicVolume: number;
		SFXVolume: number;
		AFK: boolean;
	}
}


local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"));
local r = workspace:GetAttribute("robloxstr");



local myself = knit.Player;
local gui = myself:WaitForChild("PlayerGui");
local swordSlot = gui:WaitForChild("Sword");
local abilitySlot = gui:WaitForChild("AbilitySlot");
local inventory = gui:WaitForChild("Inventory");
local invFrame = inventory:WaitForChild("MainFrame");
local infoFrame = invFrame:WaitForChild("Info"):WaitForChild("Frame")
local equipButton: TextButton = infoFrame:WaitForChild("Equip")
local selectedItem: StringValue = invFrame:WaitForChild("SelectedItem");
local slot = invFrame:WaitForChild("Slot");

local swords = require(storage.Classes.Swords);
local abilities = require(storage.Classes.Abilities);
local skins = require(storage.Classes.Skins);

local myData: PlayerData = nil;



local dataMod = net:RemoteFunction("DataMod");



local data
local DataCtrl = knit.CreateController({Name = "DataController"});

DataCtrl.Assets = {
	Skin = skins;
	Sword = swords;
	Ability = abilities;
}

DataCtrl.LayoutPriorities = {
	Starter = 100,
	Common = 99,
	Uncommon = 98,
	Rare = 97,
	Epic = 96,
	Legendary = 95,
	Special = 94,
	Exclusive = 93,
	Admin = 1,
}
DataCtrl.RarityNameColors = {
	Starter = {Color = Color3.new(0.847059, 0.847059, 0.847059), Stroke = Color3.new(0.54902, 0.54902, 0.54902)},
	Common = {Color = Color3.new(0.847059, 0.847059, 0.847059), Stroke = Color3.new(0.54902, 0.54902, 0.54902)},
	Uncommon = {Color = Color3.new(0.466667, 0.917647, 0.368627), Stroke = Color3.new(0.262745, 0.517647, 0.223529)},
	Rare = {Color = Color3.new(0.4, 0.811765, 1), Stroke = Color3.new(0.188235, 0.345098, 0.439216)},
	Epic = {Color = Color3.new(0.552941, 0.403922, 1), Stroke = Color3.new(0.298039, 0.168627, 0.494118)},
	Legendary = {Color = Color3.new(1, 0.717647, 0.054902),  Stroke = Color3.new(0.552941, 0.337255, 0.0313725)},
	Special = {Color = Color3.new(0, 1, 0.615686),  Stroke = Color3.new(0.0901961, 0.470588, 0.356863)},
	Exclusive = {Color = Color3.new(0.411765, 0.00784314, 0.596078),  Stroke = Color3.new(0.152941, 0.0745098, 0.196078)},
	Admin = {Color = Color3.new(0, 0, 0),  Stroke = Color3.new(1, 1, 1)
	}
}

DataCtrl.RarityBorders = {
	Starter = Color3.new(0.439216, 0.439216, 0.439216),
	Common = Color3.new(0.439216, 0.439216, 0.439216),
	Uncommon = Color3.new(0.239216, 0.470588, 0.211765),
	Rare = Color3.new(0.00784314, 0.376471, 0.458824),
	Epic = Color3.new(0.313725, 0.156863, 0.470588),
	Legendary = Color3.new(0.560784, 0.4, 0),
	Special = Color3.new(0.168627, 0.560784, 0.396078),
	Exclusive = Color3.new(0.0901961, 0.0392157, 0.121569),
	Admin = Color3.new(0.898039, 0.898039, 0.898039),
}



function DataCtrl:DisplaySword(sword: string)
	sword = sword or myData.Inventory.EquippedSword
	swordSlot.SwordSlot.SwordImage.Image = r .. swords[sword].Image;
	swordSlot.SwordSlot.SwordName.Text = sword;
end

function DataCtrl:DisplayAbilities(abs: {string})
	abs = abs or myData.Inventory.EquippedAbilities;
	local slots = {}
	for _,slot: Frame in pairs(abilitySlot:GetChildren()) do
		local num = tonumber(slot.Name:sub(string.len("SLOT") + 1))
		slots[num] = slot;
	end

	for i,slot:Frame in ipairs(slots) do
		if abs[i] then
			slot.AbilityImage.Image = abilities[abs[i]].Image;
			slot.AbilityName.Text = abs[i];
		end
	end
end


function DataCtrl:DescribeInformation(item, type)
	--if not myData.Inventory[type:gsub("y", "ie").."s"][item] then warn("Item unavailable") return; end
	local obj = DataCtrl.Assets[type][item];
	infoFrame.ItemRarity.UIStroke.Color = DataCtrl.RarityNameColors[obj.Rarity].Stroke
	infoFrame.ItemRarity.TextColor3 = DataCtrl.RarityNameColors[obj.Rarity].Color

	infoFrame.ItemRarity.Text = obj.Rarity
	infoFrame.ItemName.Text = item
	infoFrame.ItemDescription.Text  = obj.Description or ""

	infoFrame.ItemImage.Image= r..obj.Image
end

function DataCtrl:AddInventorySlot(item: string, type: string)
	--if not myData.Inventory[type:gsub("y", "ie").."s"][item] then warn("Item unavailable") return; end

	local scrollingFrame = invFrame:WaitForChild("Stuff")
	scrollingFrame = scrollingFrame:WaitForChild(type);
	if scrollingFrame:FindFirstChild(item) then return; end;

	local new: ImageButton = slot:Clone();
	new.Visible = true;
	new.Name = item;

	local obj = DataCtrl.Assets[type][item];


	new.LayoutOrder = DataCtrl.LayoutPriorities[obj.Rarity]
	new.Image = r .. obj.Image
	new.UIStroke.Color = DataCtrl.RarityBorders[obj.Rarity]
	new.BackgroundColor3 = DataCtrl.RarityBorders[obj.Rarity]

	new.Parent = scrollingFrame;

	new.Activated:Connect(function(inputObject, clickCount)

		selectedItem:SetAttribute("Type", type);
		selectedItem.Value = new.Name

	end)

end


function DataCtrl:Reconcile()
	data:Manifest():andThen(function(profileData)
        myData = profileData;
        data.Mine = profileData;

        DataCtrl:DisplaySword();
		DataCtrl:DisplayAbilities();
		for _,v in pairs(profileData.Inventory.Abilities) do
			DataCtrl:AddInventorySlot(v, "Ability");
		end
		for _,v in pairs(profileData.Inventory.Swords) do
			DataCtrl:AddInventorySlot(v, "Sword");
		end
		for _,v in pairs(profileData.Inventory.Skins) do
			DataCtrl:AddInventorySlot(v, "Skin");
		end
    end)
end


function DataCtrl:KnitInit()


	selectedItem.Changed:Connect(function()
		task.wait();
		DataCtrl:DescribeInformation(selectedItem.Value, selectedItem:GetAttribute("Type"))
	end)

	equipButton.Activated:Connect(function(inputObject, clickCount)
		dataMod:FireServer("Equip", selectedItem.Value, selectedItem:GetAttribute("Type"));
	end)

	dataMod.OnClientInvoke = function(mode: string)
		if mode == "Reconcile" then
			DataCtrl:Reconcile();
		end
		return true;
	end 
end

function DataCtrl:KnitStart()
	data  = knit.GetService("DataService");
	DataCtrl:Reconcile();
    print("DataCtrl is ready")
end


return DataCtrl;