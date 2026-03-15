local module = {


	["Mountain Top"] = {
		Name = "Mountain Top",
		Image           = 91484770410968,
		MapTime         = 300,
		FriendlyFire    = false,
		MusicBackground = 16150379156,
		
		
		Light = {ClockTime = 16.147;
		GeographicLatitude = -51.996;},
		

		ObjectiveText = "Defeat Mountain Guardian";
		Amount = 1;
		Mode = "Bossfight";
		MinPlayers = 0;
	},
	["Abandoned Village"] = {
		Name = "Abandoned Village",
		Image           = 18611516466,
		MapTime         = 200,
		FriendlyFire    = true,
		MusicBackground = nil,
		

		Light = {ClockTime = 16.704,
		GeographicLatitude = -36.355,},
		
		
		ObjectiveText = "Be the last one standing";
		Amount = 1;
		Mode = "PVP";
		MinPlayers = 1;
	},
	["Desert Village"] = {
		Name = "Desert Village",
		Image           = 18611793269,
		MapTime         = 200,
		FriendlyFire    = true,
		MusicBackground = nil,
		

		Light = {ClockTime =  10.099,
		GeographicLatitude = -8.555,},
		
		
		ObjectiveText = "Be the last one standing";
		Amount = 1;
		Mode = "PVP";
		MinPlayers = 1;
	},
	["Training Arena"] = {
		Name = "Training Arena",
		Image           = 135678571092695,
		MapTime         = 200,
		FriendlyFire    = true,
		MusicBackground = nil,
		
		
		Light = {ClockTime = 14.1,
		GeographicLatitude = -36.355,},
		
		
		ObjectiveText = "Be the last one standing";
		Amount = 1;
		Mode = "PVP";
		MinPlayers = 1;
	},
	["Colosseum"] = {
		Name = "Colosseum",
		Image           = 79392481085838,
		MapTime         = 225,
		FriendlyFire    = false,
		MaxZombies	    = 40,
		SpawnRate		= 7,
		MaxSpawn = 10,
		MusicBackground = nil;
		
		
		Light = {ClockTime = 10.099,
		GeographicLatitude = -8.555,},
		

		MinZombieAmount = 20;
		ZombieIncrementPerPlayer = 7;
		ObjectiveText = "Eliminate Enemies";
		Mode = "ZombieHunt";
		MinPlayers = 0;
	},
	["Mystery Forest"] = {
		Name = "Mystery Forest",
		Image           = 136195725984530,
		MapTime         = 225,
		FriendlyFire    = false,
		MaxZombies	    = 75,
		SpawnRate		= 5,
		MaxSpawn = 7,
		MusicBackground = nil;
		

		Light = {ClockTime = 8.057,
		GeographicLatitude = 12.105,},
		

		MinZombieAmount = 15;
		ZombieIncrementPerPlayer = 4;
		ObjectiveText = "Eliminate Enemies";
		Mode = "ZombieHunt";
		MinPlayers = 0;
	},
	["Lobby"] = {Light = {
		ClockTime = 11.135,
		GeographicLatitude = -36.355,}
	}
}

return module;