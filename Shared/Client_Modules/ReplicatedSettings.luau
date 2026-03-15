local Replicated_Settings = {}

Replicated_Settings.Abilities={
	["RefreshingUTCTimes"]={
		0,
		4,
		8,
		12,
		16,
		20
	},
	["ActivatingKeys"]={
		["Slot1"]=Enum.KeyCode.E -- ... can add more in the future
	},

	["God's Dash"] = {
		ID = 18554810102,
		Cooldown=0, --[seconds]
		Rarity="Admin",
		Price = 100_000_000_000_000_000,
		Description = "Dash but OP",
		Animations = {
			[1] = 17662395631,
			[2] = 17662400332
		};

		Sound = 17770380699;
		--> Technical Info

		MoveStuds = 65;
		MoveSpeed = 30; -- studs per second
	};

	["Dash"]={
		ID = 17367969921,
		Cooldown=5, --[seconds]
		Rarity="Starter",
		Price=0,
		Description = "Starter ability of the game!",
		Animations = {
			[1] = 17662395631,
			[2] = 17662400332
		};

		Sound = 17770380699;
		--> Technical Info

		MoveStuds = 50;
		MoveSpeed = 30; -- studs per second

	},
	["Superjump"]={
		ID=18196338846,
		Cooldown=13, --[seconds]
		Rarity="Common",
		Price=4500,

		Description = "Jump over your enemies!";

		Animations = {
			[1] = 17748219923;
			[2] = 17748223635
		};

		--> Tec

		MaxChargeTime = 4;
	},
	["Stomp"]={
		ID=18196344569,
		Cooldown=12, --[seconds]
		Rarity="Uncommon",
		Price=10000,

		Description = "Create a crack in the ground with your leg!";

		Animations = {
			17771733008
		};

		--> Tec

		DamageAreaRadius = 34;
		Damage = 50;
	},
	["Burger"]={
		ID=17368096624,
		Cooldown=35, --[seconds]
		Rarity="Rare",
		Price=22500,

		Description = "Very tasty burger made by Bob himself!";

		Animations = {
			17780360200
		};

		HealAmount = 40;
	},
	["Fireball"]={
		ID=17368160173,
		Cooldown=22, --[seconds]
		Rarity="Epic",
		Price=35000,

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


	["Laser beam"]={
		ID=18266611670,
		Cooldown=44, --[seconds]
		Rarity="Legendary",
		Price=67500,

		Description = "Take out your laser and beam at your enemies!";
		Animations = {
			[1] = 17889859807; --> Takeout => LaserSwitch && LaserInTorso
			[2] = 17889875566; --> Activation
			[3] = 18579497865; --> Idle
			[4] = 18165796391; --> Jump
			[5] = 17889887559; --> Walk
			[6] = 17889894431; --> Ending => LaserRips && SwordbackLaser
		};

		MaxDistance = 135; -- studs should be 75 but i wanto to be 80 idc
		Duration = 8; -- seconds
		Damage = 0.4;

	}
}

--<CustomIncludes>



Replicated_Settings.ShopAbilities={ -- list of abilities that will appear in the shop
	"Superjump",
	"Stomp",
	"Burger",
	"Fireball",
	"Laser beam",
}

Replicated_Settings.OwnsAbilityDisplaySettings={
	TextStrokeColor=Color3.fromRGB(76, 76, 76),
	TextStrokeThickness=2,
	BorderStrokeColor=Color3.fromRGB(36, 120, 31),
	BorderStrokeThickness=4.2,
	TextColor=Color3.fromRGB(255, 255, 255)
}

Replicated_Settings.DefaultAbilitiesPriceGuiLook={
	TextStrokeColor=Color3.fromRGB(135, 116, 39),
	TextStrokeThickness=2,
	BorderStrokeColor=Color3.fromRGB(36, 120, 31),
	BorderStrokeThickness=4.2,
	TextColor=Color3.fromRGB(255, 223, 106)
}

--[[

 (STARTER)
-Dash
(FREE)

(COMMON)
-Super Jump
(2,5K)

(Uncommon)
-Stomp
(5K)

(rare)
-Bob Burger
(10K)

(Epic)
-Fireball
(25K)

(Legendary)
-Laser beam 
(50K)

Dash

ID: rbxassetid://17367969921
Cooldown = 3 seconds
Rarity = Starter 
Superjump 

ID: rbxassetid://17367992377 (PLACEHOLDER)
Cooldown =  7 seconds
Rarity = Common

Stomp

ID: rbxassetid://17368091218 (PLACEHOLDER)
Cooldown = 10 seconds
Rarity = Uncommon 

Burger

ID: rbxassetid://17368096624
Cooldown 20 seconds
Rarity = Rare
Fireball 

ID: rbxassetid://17368160173
Cooldown = 20 seconds
Rarity = Epic
Laser beam 

ID: rbxassetid://17368167869
Cooldown = 45 seconds
Rarity = Legendary

]]

return Replicated_Settings
