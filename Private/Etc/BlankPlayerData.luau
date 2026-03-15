-->> BlankPlayerData.lua
--> This is how a player table looks like in SM

--> Notes:
	-- If an index has "__" at beginning, it will be ignored by describer, it will be used as configuration for the table
	
	-- If an index has "_" at beginning, it will also be ignored by describer.
	-- 	It will be used as a metatable for a table with the same name (no "_").
	--	Used for tables with numerical indexes


export type Dato = (number|string|boolean)?

local pdMetadata = require(game:GetService("ServerStorage").Etc.PlayerDataMeta);


return 




	{
		Goods = {
			__folder = true;
			__onupdate = "PlayerDataMeta._Goods";
			Coins = 0;
			Level = 1;
			XP = 0;
			GoalXP = 0;
		};

		Inventory = {
			__folder = true;
			EquippedSkin = "Default";
			EquippedSword = "Default Sword";
			EquippedAbilities = {"Dash"};

			Skins = {
				"Default";
			};
			Swords = {
				"Default Sword";
			};
			Abilities = {
				"Dash";
			};
			
			
			
			
			--> Metatables


			_EquippedSkin = {
				__onupdate = "PlayerDataMeta._EquippedSkin";
			},
			_EquippedSword = {
				__onupdate = "PlayerDataMeta._EquippedSword";
			},
			_EquippedAbilities = {
				__folder = true;
				__onupdate = "PlayerDataMeta._EquippedAbilities";
			},
			
			_Skins = {
				__folder = true;
				__onupdate = "PlayerDataMeta._Skins"
			},
			_Swords = {
				__folder = true;
				__onupdate = "PlayerDataMeta._Swords"
			},
			_Abilities = {
				__folder = true;
				__onupdate = "PlayerDataMeta._Abilities"
			},

			Passes = {},
			_Passes = {
				__folder = false;
			},




		};

		Information = {
			JoinedAfterRevamp = false,
			LastOnline = 0;
			PlayerImage = nil;
			Observations = { -- {Type = "", Description = "", Time = 0}
			};
			Rank = "Player";
		};

		Quests = {};
		QuestProgress = {};
		RedeemedCodes = {};
		Stats = {
			Kills = {
				Player = 0;
				Zombie = 0;
				Miniboss = 0;
				Boss = 0;
				
				PVP = 0;
				Survival = 0;
				Bossfight = 0;
			};

			General = {
				NewPlayer = true;
				TimePlayed = 0;
			};
		};
		Badges = {};
		Settings = {
			__folder = true;
			MusicVolume = 75;
			SFXVolume = 75;
			AFK = false;
		}
	}