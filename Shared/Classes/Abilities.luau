-->> Abilities.luau
-- Abilities information for Sword Masters
--> Scripted by Marcos


local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local _


local Abilities = {
	["God's Dash"] = {
		Image = 18554810102,
		Cooldown = 0,
		Rarity = "Admin",
		Price = 100_000_000_000_000_000,
		Description = "Dash but OP",
		Animations = {
			[1] = 17662395631,
			[2] = 17662400332
		};

		Sound = 17770380699;
		--> Technical Info

		MoveStuds = 65;
		MoveSpeed = 30;
	};
	
	["Dash"] = {
		Image = 17367969921,
		Cooldown = 5,
		Rarity = "Starter",
		Price = 0,
		Description = "Starter ability of the game!",
		Animations = {
			[1] = 17662395631,
			[2] = 17662400332
		};

		Sound = 17770380699;
		--> Technical Info

		MoveStuds = 50;
		MoveSpeed = 30;
		
	},
	["Superjump"] = {
		Image = 18196338846,
		Cooldown = 13,
		Rarity = "Common",
		Price = 4500,
		
		Description = "Jump over your enemies!";
		
		Animations = {
			[1] = 17748219923;
			[2] = 17748223635
		};
		
		--> Tec
		
		MaxChargeTime = 4;
	},
	["Stomp"] = {
		Image = 18196344569,
		Cooldown = 12,
		Rarity = "Uncommon",
		Price = 10000,
		
		Description = "Create a crack in the ground with your leg!";
		
		Animations = {
			17771733008
		};
		
		--> Tec
		
		DamageAreaRadius = 34;
		Damage = 50;
	},

	["Burger"] = {
		Image = 17368096624,
		Cooldown = 35,
		Rarity = "Rare",
		Price = 22500,
		
		Description = "Very tasty burger made by Bob himself!";
		
		Animations = {
			17780360200
		};
		
		HealAmount = 40;
	},

	["Fireball"] = {
		Image = 17368160173,
		Cooldown = 22,
		Rarity = "Epic",
		Price = 35000,
		
		Description = "Throw a molten hot fireball at your enemies!";
		
		Animations = {
			[1] = 17811583823;	--> Activation FireballArrives
			[2] = 17811591684;	--> Idle
			[3] = 17811602763;	--> Aiming Fireball
			[4] = 17811607533	--> Shot FireballRelease
		};
		
		--> Technical info
		MaxChargeTime = 3; -- seconds
		MaxRadius = 75; -- studs
		Damage = 80;
		DamageAreaRadius = 33;
	},
	
	
	["Laser beam"] = {
		Image = 18266611670,
		Cooldown = 44,
		Rarity = "Legendary",
		Price = 67500,
		
		Description = "Take out your laser and beam at your enemies!";
		Animations = {
			[1] = 17889859807; --> Takeout => LaserSwitch && LaserInTorso
			[2] = 17889875566; --> Activation
			[3] = 18579497865; --> Imagele
			[4] = 18165796391; --> Jump
			[5] = 17889887559; --> Walk
			[6] = 17889894431; --> Ending => LaserRips && SwordbackLaser
		};
		
		MaxDistance = 135; -- studs should be 75 but i wanto to be 80 idc
		Duration = 8; -- seconds
		Damage = 0.4;
		
	}


};


Abilities.ResetInterval = 4; --> Every 4 hours
Abilities.ResetTimeUTC = -2; --> Under the UTC-2 time


Abilities.AbilitiesInShop = { -- list of abilities that will appear in the shop
	"Superjump",
	"Stomp",
	"Burger",
	"Fireball",
	"Laser beam",
}

Abilities.OwnsAbilityDisplaySettings = {
	TextStrokeColor = Color3.fromRGB(76, 76, 76),
	TextStrokeThickness = 2,
	BorderStrokeColor = Color3.fromRGB(36, 120, 31),
	BorderStrokeThickness = 4.2,
	TextColor = Color3.fromRGB(255, 255, 255)
}

Abilities.DefaultAbilitiesPriceGuiLook = {
	TextStrokeColor = Color3.fromRGB(135, 116, 39),
	TextStrokeThickness = 2,
	BorderStrokeColor = Color3.fromRGB(36, 120, 31),
	BorderStrokeThickness = 4.2,
	TextColor = Color3.fromRGB(255, 223, 106)
}






return Abilities;