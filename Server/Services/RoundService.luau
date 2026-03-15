 
-->> RoundService.lua
--> Main round system for Sword Masters
--> Scripted by Marcos Saenz (ds: malcosrub)
--> Revamped


export type RoundState = "Intermission"|"Paused"|"Teleporting"|"Starting"|"Running"

local MAX_FAIL_COUNT = 1;

local players = game:GetService("Players")
local storage = game:GetService("ReplicatedStorage");
local sss = game:GetService("ServerScriptService")
local sv = require(sss.ServerBegin.Server)
local bin = storage.Packages;
local knit = require(bin.Knit);
local promise = require(bin.Promise)
local signal = require(bin.Signal);
local net = require(bin.Net);
local isDone = false;


local maps = require(storage.Classes.Maps);
local goals = require(storage.Goals);


local display: RemoteEvent = net:RemoteEvent("Intermission");
local uied: RemoteEvent = net:RemoteEvent("UiEnableDisable"); --> Used to show / hide uis and make them display stuff before showing or when hiding.
local uimod: RemoteEvent = net:RemoteEvent("UiModify"); --> Used to change ui stuff whenever you want.
--> Ui stuff = a frame's color, a textlabel's text, etc.
local vote: RemoteEvent = net:RemoteEvent("VoteMap");


local sword-- = require(game:GetService("ServerScriptService").Providers.SwordProvider);
local light-- = require(game:GetService("ServerScriptService").Providers.LightingProvider);
local economy;
local data;
local bossfight;



local round = knit.CreateService({Name = "RoundService", Client = {RoundStarted = knit.CreateSignal();RoundEnded = knit.CreateSignal(); Teleporting = knit.CreateSignal();}})

round.RoundStarted = signal.new();
round.RoundEnded = signal.new();
round.TeleportedPlayers = signal.new();

round.MapVotes = {};
round.MapsPerVote = 3;		-->															v
round.SocialCredits = 0; 	--> SocialCredits == Objective Progress (Eliminate enemies: 7 / 20)
--																						^

round.Client.Running = false;

round.FailCount = 0;

round.Players = {};

round.EndedManually = false;
round.ChosenMap = "Mystery Forest";
round.LastMap = nil
round.VoteSignal = signal.new();

round.Text = {
	WaitingForPlayers = "Waiting for Players...";
	NotEnoughPlayers = "Not enough players in game";
	Intermission = "Round starting in %d"; -- %d will be replaced with a number
	SelectedMap = "Selected map is %s"; -- %s will be replaced with map name
	LoadingMap = "Loading %s";
	Teleporting = "%d";
	RoundBegin = "Round starts in %d";
	RoundEnd = "Round ends in %d";
	RoundEnded = "Times up!";
	NoChoose = "Players did not want to choose a map...";
}

round.Settings = {
	IntermissionTime = 30;
	TimeToVote = 15;
	TimeToTeleport = 3;
	TimeToStartRound = 3;
	TimeBeforeNextIntermission = 3;
}

round.MapsNumber = 0;



local function Display(txt:string, ...)
	display:FireAllClients(txt:format(...))
end

local mapnames = {}

function round:RandomMap()
	math.randomseed(math.random());
	local rand = math.random(1,round.MapsNumber);

	return maps[mapnames[rand]];
end


local function SetupVoteSignal(): ()
	round.VoteSignal = signal.new();
	round.VoteSignal:Once(function()
		round.MapVotes = {}
		local PromiseDiffMap
		function PromiseDiffMap()
			local t = maps;

			local claves = {}
			for clave in pairs(t) do





				if clave == "Lobby" then continue; end





				table.insert(claves, clave)
			end

			local seleccionados = {}

			for i = 1, round.MapsPerVote do
				-- Seleccionar un índice aleatorio de la lista de claves
				local indiceAleatorio = math.random(1, #claves)
				local claveSeleccionada = claves[indiceAleatorio]

				-- Añadir el string seleccionado a la tabla de seleccionados
				table.insert(seleccionados, t[claveSeleccionada])

				-- Eliminar la clave seleccionada de la lista de claves
				table.remove(claves, indiceAleatorio)
			end

			return seleccionados
		end


		local maps = PromiseDiffMap();
		for i = 1,#maps do
			round.MapVotes[i] = {Name = maps[i].Name, Image = maps[i].Image, Votes = {}};
		end

		local clientTable = {}
		for i = 1, #maps do
			clientTable[i] = {Name = maps[i].Name, Image = maps[i].Image};
		end
		uied:FireAllClients("VoteMap", true, clientTable);
	end)
end


function round.GetMap() --> Deprecated
	return workspace.GameMap:FindFirstChild("Map")
end

function round:TimeoutInfoGui(gui, plr: Player, ...: any)
	local args = {...};

	local function Do(v)
		task.spawn(function()
			uied:FireClient(v, gui, true, args);
			uied:FireClient(v, gui, false, args);
		end)
	end

	if plr then
		Do(plr);
		return;
	end

	for _,v in pairs(players:GetPlayers()) do
		Do(v);
	end

end


round.ModeLoop = {
	PVP = function(map)
		local plrs = round:GetPlayers();
		local count = #plrs
		if count == maps[map].MinPlayers then
			local ok = pcall(function()
				local plr = plrs[1];
				round:TimeoutInfoGui("PVPWinner", nil, {Text = plr.Name});
				economy:PayPlayer(plr, economy.CoinDeals[map]);
				economy:TeachPlayer(plr, economy.XPDeals[map]);
				data:AddStat(plr, "PVP", "Stats.Kills", 1);
			end)
		else
			round:TimeoutInfoGui("PVPNoWinner", nil);
		end
	end;
	ZombieHunt = function(map)
		for _,v in pairs(players:GetPlayers()) do
			if v:GetAttribute("IsInRound") then
				economy:PayPlayer(v,economy.CoinDeals[map]);
				economy:TeachPlayer(v,economy.XPDeals[map]);
				data:AddStat(v, "ZombieHunt", "Stats.Kills", 1);
			end
		end
	end;
	Bossfight = function()

	end;
}

round.ModeBegin = {
	PVP = function(map)
		
	end,
	ZombieHunt = function(map)
		
	end,
	Bossfight = function(map)
		if map == "Mountain Top" then
			bossfight.new():SpawnBoss();
		end
	end,
}


local uid = {}
local eventMeta = {
	__index = function (t,k)
		--warn("*access to element " .. tostring(k))
		return t[uid][k]
	end,

	__newindex = function (t,k,v)
		--warn(t);
		--warn("*update of element " .. tostring(k) .." to " .. tostring(v))
		t[uid][k] = v 
	end
}
local function ElementChanged(t)
	local proxy = {}
	proxy[uid] = t
	setmetatable(proxy, eventMeta);
	return proxy
end


function round:AddSocialCredits(a: number) --> Adds objective amount (not goal, amount.)
	assert(type(a)=="number", "-500 Social Credits ::::((((((, 'a' Must be a number.");

	if maps[round.ChosenMap].Mode == "PVP" then
		return;
	end

	round.ObjectiveProgress += a;
	uimod:FireAllClients("Objective", {Amount = round.ObjectiveProgress});


	--print(`{a<0 and "" or "+"} Social Credits!!!!111!1!!11!!!!`)
end


-- Returns an iterator function to use in for loop\
-- Iterates over players whose are currently in round
function round.PlayingPlayers()
	local players = round:GetPlayers()  -- Obtener todos los jugadores
	local index = 0  -- Índice inicial para la iteración

	return function()
		index = index + 1
		while index <= #players do
			local player = players[index]
			-- Verificar si el jugador tiene el atributo 'IsInRound' y está en true
			return player  -- Retornar el jugador que cumple con la condición
		end
		return nil  -- Final de la iteración
	end
end


round.StatesRun = {
	Intermission = function()
		Display(round.Text.Intermission, round.Time);

		task.wait(1);
		round.Time -= 1;
		

		if (round.Time >= round.Settings.TimeToVote - 2) and (round.Time <= round.Settings.TimeToVote) then
			round.VoteSignal:Fire();
		end

		if round.Time <= 0 then --> Once
			round.State = "Paused";
		end
	end,

	Paused = function() --> In Paused function. Time will always be 0;

		if round.ChosenMap then --> Players chose map so round is about to start.


			Display(round.Text.SelectedMap, round.ChosenMap);
			uied:FireAllClients("VoteMap", false);

			if maps[round.ChosenMap].Mode == "PVP" then
				if #players:GetPlayers() <= 1 then
					Display(round.Text.NotEnoughPlayers);
					task.wait(2);
					round.Time = round.Settings.IntermissionTime;
					round.State = "Intermission";

					SetupVoteSignal();
					return;
				end
			end
			task.wait(1);

			round:LoadMap(round.ChosenMap);
			Display(round.Text.LoadingMap, round.ChosenMap);
			task.wait(3);
			
			round.ObjectiveProgress = 0;
			round.State = "Teleporting";

			round.Client.Running = true;

			round.TeleportedPlayers:Fire(round.ChosenMap)
			round.Client.Teleporting:FireAll(round.ChosenMap)

			task.wait(3);
			round.Time = round.Settings.TimeToTeleport;

		else --> Round just ended or players didnt choose map.
			
			if round.LastMap then --> Round just ended.
				round.Client.Running = false;
				round.RoundEnded:Fire(round.LastMap);
				round.Client.RoundEnded:FireAll(round.LastMap);


				Display(round.Text.RoundEnded);

				local mode = maps[round.LastMap].Mode
				round.ModeLoop[mode](round.LastMap);

				if not round.EndedManually then
					round:SendPlayers2Lobby();
				end
				round.EndedManually = false;








				round.LastMap = nil -- lastmap is now useless, so i delete it here.
			else
				Display(round.Text.NoChoose)
			end
			

			SetupVoteSignal();
			task.wait(round.Settings.TimeBeforeNextIntermission);
			round.Time = round.Settings.IntermissionTime
			round.State = "Intermission";
		end
	end,

	Teleporting = function()
		Display(round.Text.Teleporting, round.Time);
		task.wait(1);
		round.Time -= 1;

		if round.Time <= 0 then --> Once
			round:TeleportPlayers();


			round.Time = round.Settings.TimeToStartRound
			round.State = "Starting";
		end
	end,

	Starting = function()
		Display(round.Text.RoundBegin, round.Time);
		task.wait(1);
		round.Time -= 1;

		if round.Time <= 0 then --> Once
			local mode = maps[round.ChosenMap].Mode


			round.RoundStarted:Fire(round.ChosenMap);
			round.Client.RoundStarted:FireAll(round.ChosenMap);

			local map = maps[round.ChosenMap];
			round:GiveSwordsToPlayers();
			for player in round.PlayingPlayers() do
				local max = goals.GetGoals(map.Name, map.Mode);
				uimod:FireClient(player, "Objective",{
					ObjectiveText = map.ObjectiveText;
					Max = max;
					Amount = 0;
					State = true;
				})
				uied:FireClient(player, "Objective", true);
			end
			

			round.ModeBegin[mode](round.ChosenMap);



			round.Time = maps[round.ChosenMap].MapTime;
			round.State = "Running";
		end
	end,




	Running = function()
		Display(round.Text.RoundEnd, round.Time);
		task.wait(1);
		round.Time -= 1;

		local plrs = round:GetPlayers()
		if #plrs <= maps[round.ChosenMap].MinPlayers then
			if maps[round.ChosenMap].Mode == "PVP" then
				round.ObjectiveProgress = 1;
				uimod:FireClient(plrs[1], "Objective", {Amount = round.ObjectiveProgress});
			end
			round.Time = 0;
		end


		if round.Time <= 0 then --> Once
			round.LastMap = round.ChosenMap;
			round.ChosenMap = nil;
			warn("Lastmap:",round.LastMap)
			round.State = "Paused";
		end
	end


}


function round:GetPlayers()
	local plrs = {};
	for _,plr in pairs(players:GetPlayers()) do
		if plr:GetAttribute("InRound") then
			table.insert(plrs, plr);
		end
	end
	return plrs;
end



local function RoundFunction(resolve, reject)
	while isDone do
		round.StatesRun[round.State]();
	end
end



function round:LoadMap(a)
	local Map: Folder = storage.Assets.Maps[a]:Clone();
	Map.Name = "Map";
	Map:SetAttribute("Mode", maps[a].Mode)
	Map:SetAttribute("Name", a)
	Map.Parent = workspace.GameMap;
end


function round:CheckMode()
	return maps[round.ChosenMap].Mode
end


function round:TeleportPlayers(exclude: string)
	if not round.ChosenMap then

		return;
	end
	local spawns = workspace.Spawns[round.ChosenMap]:GetChildren()

	for i,plr in pairs(players:GetPlayers()) do
		if plr.Name == exclude then continue end
		if not plr:GetAttribute("AFK") then
			local skin = plr.Inventory.EquippedSkin.Value;
			local char: Model = storage.Assets.Characters:FindFirstChild(skin)
			if char then
				char = char:Clone();
				char.Name = plr.Name;
				char.HumanoidRootPart.Anchored = false;
				char:PivotTo(spawns[i].CFrame);
				for _,v in pairs(game:GetService("StarterPlayer").StarterCharacterScripts:GetChildren()) do
					v:Clone().Parent = char;
				end

				plr.Character = char;

				for _,l:BasePart in pairs(char:GetDescendants()) do
					if l:IsA("BasePart") then
						l.CollisionGroup = "Player"
					end
				end

				char.Parent = workspace

				plr:SetAttribute("InRound", true);

				local folder, t = light:Get(round.ChosenMap);
				light:Setup(folder, t, plr);

				round.Players[plr.Name].OnDeath = plr.Character.Humanoid.Died:Once(function()--TODO:Player_Cleanup_Function
					round.Players[plr.Name].OnDeath = nil;
					local sword = round.Players[plr.Name].Sword;
					if sword then
						sword:TakeAway();
					end
					uimod:FireClient(plr, "Objective", {State = false});
					uied:FireClient(plr, "Objective", false);
					plr:SetAttribute("InRound", false);
					light:Remove(plr);
				end)

			else
				--> Warn to player that his datastore is broken.
			end
		end
	end
end



function round:GiveSwordsToPlayers()
	for _,plr in pairs(round:GetPlayers()) do
		round.Players[plr.Name].Sword = sword.new(plr, plr.Inventory.EquippedSword.Value)
	end
end



function round:SendPlayers2Lobby()
	for i,v in pairs(round.Players) do
		local k = v.Sword
		if k then
			k:TakeAway();
			v.Sword = nil;
		end

		local k = v.OnDeath
		if k then
			k:Disconnect();
			k = nil;
		end
	end

	for player:Player in round.PlayingPlayers() do --> WARNING: THIS WILL ONLY EXECUTE ON PLAYERS THAT DIDNT DIE
		uimod:FireClient(player, "Objective", {State = false});
		uied:FireClient(player, "Objective", false);
		player:LoadCharacter();
	end 


	light:Remove();

	task.delay(5, function()
		if workspace.GameMap:FindFirstChild("Map") then
			workspace.GameMap.Map:Destroy();
		end
	end)

	round.LastMap = round.ChosenMap;
	round.ChosenMap = nil;
	round.Time = 0;
	round.State = "Paused";
	round.EndedManually = true;

end

function round:EndRound()
	return round:SendPlayers2Lobby();
end




local function Setup()
	round.Time = round.Settings.IntermissionTime;
	round.State = "Intermission"
	round.MainPromise = promise.new(RoundFunction):andThen(function()
		print("RoundService: Stopped.");
	end):catch(function(massage)
		if round.FailCount >= MAX_FAIL_COUNT then
			sv.ShutDownServer(0x2)
		end
		warn("RoundService: Stopped by Exception:");
		warn(massage);
		warn("Restarting RoundService...")
		round:Stop();
		Display("Round ended to prevent cheaters.")
		light:Remove();
		for _,v in pairs(players:GetPlayers()) do
			v:LoadCharacter();
		end
		round.FailCount += 1;
		task.wait(3)
		round:Start();
	end)

end




function round:Start()
	mapnames = {}
	for i,_ in pairs(maps) do
		if i == "Lobby" then continue; end
		table.insert(mapnames, i);
		round.MapsNumber += 1;
	end

	if isDone then
		error("We cant have two round systems running in a server at the same time.");
	end
	isDone = true;

	Setup();
end



function round:Reset()
	if round.MainPromise.State ~= "Rejected" then
		round.MainPromise:cancel();
	end
	Setup();
end



function round:Stop()
	round.MainPromise:cancel();
	round.MainPromise = nil;
	isDone = false;
end


local function encontrarIndiceMayor(tabla)
	local indiceMayor = 1
	local valorMayor = tabla[1]

	for i = 2, #tabla do
		if tabla[i] > valorMayor then
			valorMayor = tabla[i]
			indiceMayor = i
		end
	end

	return indiceMayor
end



function round.VoteMapCallback(plr: Player, l: number)
	local amounts = {}

	for _,v in pairs(round.MapVotes) do
		local i = table.find(v.Votes, plr.Name)
		if i then
			table.remove(v.Votes, i);
		end
	end

	table.insert(round.MapVotes[l].Votes,plr.Name);
	for i,v in pairs(round.MapVotes) do
		amounts[i] = #v.Votes;
	end

	--> I GOT TO FUCKING REPEAT MYSELF IN THIS FUCKING FUNCTION
	--> BECAUSE LUA OR WHATEVER WAS BUGGING SO BAD
	--> THIS FUNCTION WASNT WORKING AS IT SHOULD. SO I HAD TO DO THIS.



	round.ChosenMap = round.MapVotes[encontrarIndiceMayor(amounts)].Name;

	vote:FireAllClients(amounts)

	return true
end



function round:KnitInit()
	players.PlayerAdded:Connect(function(plr)
		round.Players[plr.Name] = {}
	end)

	players.PlayerRemoving:Connect(function(plr)
		if round.Players[plr.Name] then
			round.Players[plr.Name] = nil
		end
	end)

	vote.OnServerEvent:Connect(round.VoteMapCallback)

	SetupVoteSignal();
end

function round:KnitStart()
	sword = knit.GetService("SwordProvider");
	light = knit.GetService("LightingProvider");
	economy = knit.GetService("EconomyService");
	data = knit.GetService("DataService");
	bossfight = knit.GetService("BossFight");
	sss.Ready.Event:Connect(function()
		round:Start();
	end)
	print("RoundService: Started");
end


return round
