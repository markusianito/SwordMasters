-->> LevelSettings.lua
--> settings for level up system in SM

local settings = {}


settings.General = {
	MaxLevel = 100;
	StartXP = 50;
	
	StartExtra = 8;
	Extra = 4;
	
	ObtenerExperienciaConNivel = function(nivel) --> Programado por mi buen amigo ChatGPT
		if nivel <= 1 then
			return settings.General.StartXP  -- Experiencia de inicio Para subir al nivel 2
		else
			local experienciaNivelAnterior = settings.General.ObtenerExperienciaConNivel(nivel - 1)
			local incrementoPorDecena = math.floor((nivel - 1) / 10) * settings.General.Extra  -- Determina el incremento por cada decena de niveles
			local incremento = settings.General.StartExtra + incrementoPorDecena
			return experienciaNivelAnterior + incremento
		end
	end
}

settings.Rewards = {
	["Abandoned Village"]	= 50																	;
	["Desert Village"]		= 50																	;
	["Training Arena"]		= 50																	;
	["Mystery Forest"]		= 75																	;
	["Colosseum"]			= 140																	;
	["Mountain Top"]		= 90																    ;
	["Zombie"]				= 1																		;
	["Miniboss"]			= 10																	;
	["Player"]				= 5																		;
}

settings.Costumes = {
	Decorations = {
		18237735136; --> 0
		18237759354; --> 25+
		18237767250; --> 50+
		18237784376; --> 100+
	};
	Max = {
		TextColor3 = Color3.fromRGB(255, 213, 0);
		TextStrokeColor3 = Color3.fromRGB(102, 80, 28);
	}
}


return settings
