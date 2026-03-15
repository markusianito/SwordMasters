-->> DataService.lua
--> Handles player information, stats, etc in Sword Masters (sponsored by ProfileService xd)
--> This is a remake of "DataManger" script by MahDev
--> Scripted by Marcos Saenz



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


local Passes = {
		Molten_Knight = 921433846
}


local dataSvc = game:GetService("DataStoreService");
local levelsDB = dataSvc:GetDataStore("Levels");
local killsDB = dataSvc:GetDataStore("Kills");
local badgesDB = dataSvc:GetDataStore("BadgesDatabase");
local marketplace = game:GetService("MarketplaceService")
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local players = game:GetService("Players");

local ServerScriptService = game:GetService("ServerScriptService")

local storageSv = game:GetService("ServerStorage");
local runSvc = game:GetService("RunService");
local knit = require(bin.Knit);
local net = require(bin.Net);
local signal = require(bin:WaitForChild("Signal"));
local promise = require(bin.Promise);
local profileSvc = require(bin.ProfileService);
local economySvc;
local questSvc;

local getted = net:RemoteEvent("MessagesStars")
local dataMod = net:RemoteFunction("DataMod");


local function deprecate(f, fName)
	return function(...)
		warn(`DataService: "{fName or "function"}" is deprecated. Consider using another one.`)
		warn(debug.traceback(nil,2));
        return f(...)
    end
end

local function notify(player, ItemName)
	getted:FireClient(player, "NewItem", {AinStr = "Successfully purchased", Object = ItemName});
end

local function pointFunc(ref: string, address)
	address = address
	local pastAddress = address
	for match in ref:gmatch("[^.]+") do
		local ok, err = pcall(function()
			pastAddress = address;
			address = address[match]
		end)
		if not ok then
			warn(`Couldnt find {match} in {address} Parent address:`, pastAddress);
			warn(err);
			return nil;
		end
	end
	return address
end


local data = knit.CreateService({Name = "DataService", Client = {Mine = nil;OnUpdate = knit.CreateSignal()}})
data.Grant = {}

data.DefaultData = require(storageSv.Etc.BlankPlayerData);
data.Store = profileSvc.GetProfileStore("PlayerData",data.DefaultData);
data.Profiles = {};
data.PlayerStatements = {};
data.LoadedProfile = signal.new()
data.etc = {}


--> Intented for adding stats to player information that doesnt has a folder in the player Instance (i.e kills)
local badgesComm = game.ReplicatedStorage.RemoteEvents.BadgesCallback
function data:AddStat(plr: Player, stat: string, address: string, amount: number)
	if typeof(stat) == "Instance" then
		stat = stat:GetAttribute("Type");
	end
	data:GrabData(plr,10):andThen(function(profile: PlayerData)
		profile = profile.Data;
		address = address and pointFunc(address, profile) or profile.Stats.Kills 
		address[stat] += amount or 1
		badgesComm:InvokeClient(plr, "describe", profile.Stats.Kills)
	end)
end

function data.Client:Manifest(plr)
	local p = data:GrabDataAsync(plr, 10);
	return p.Data
end



function data.Grant.Molten_Knight(plr: Player)
	local profile = data.Profiles[plr.Name]
	if profile then
		profile = profile.Data;
		if not (table.find(profile.Inventory.Passes, "Molten_Knight")) then
			local item1 = "Molten Sword"
			local item2 = "Molten Knight"
		
			local ms = Instance.new("StringValue");
			ms.Name = item1
			ms.Parent = plr:WaitForChild("Inventory"):WaitForChild("Swords")
			local ms = Instance.new("StringValue");
			ms.Name = item2
			ms.Parent = plr:WaitForChild("Inventory"):WaitForChild("Skins")
		
			economySvc:PayPlayer(plr, 10000);
			
			table.insert(profile.Inventory.Passes, "Molten_Knight");
		
			notify(plr, "Molten Knight Pack");
		else
			economySvc:PayPlayer(plr, 10000);
		
		
			notify(plr, "Molten Knight Pack (Already owned)");
		end
	end
end



function data.DeleteDuplicates(t: table)
	local hash = {}
	local res = {}
	for _,v in ipairs(t) do
		if (not hash[v]) then
			res[#res+1] = v
			hash[v] = true
		end
	end
	return res
end



local exclude = {
	["Backpack"] = true;
	["PlayerGui"] = true;
}

function Search(plr: Player, name)


	local function SearchIn(obj)
		if obj.Name == name then
			return obj
		end

		for _, child: Folder in pairs(obj:GetChildren()) do
			if (not exclude[child.Name]) and (child:IsA("Folder")) and (not child:HasTag("ExcludeSearch")) then
				local resultado = SearchIn(child)
				if resultado then
					return resultado
				end
			end
		end

		return nil
	end

	return SearchIn(plr)
end




function data:Describe(plr: Player, t: PlayerData, parent: string?, parentTable: table?)
	parentTable = parentTable or t;
	for i: string,v: table in pairs(t) do
		local meta = parentTable[`_{i}`] or {};
		if v.__folder or meta.__folder then
			local folder = Instance.new("Folder");
			folder.Name = i;
			folder.Parent = parent and (Search(plr, parent) or plr) or plr;

			for k: string,b: any | table? in pairs(v) do
				local meta = v[`_{k}`];
				local indexName = true;

				if typeof(k) == "number" then
					indexName = false;
				elseif k:sub(1,1)=="_" then
					continue;
				end


				local value;
				if typeof(b) == "number" then
					value = Instance.new("IntValue");

				elseif typeof(b) == "string" then
					value = Instance.new("StringValue");

				elseif typeof(b) == "boolean" then
					value = Instance.new("BoolValue");

				elseif typeof(b) == "table" then
					data:Describe(plr, {[k] = b}, i, v);
					continue;
				end
				value.Name = indexName and k or b;
				value.Value = b;
				value.Parent = folder;

				if v.__onupdate then
					value.Changed:Connect(function()
						task.wait(.1);
						if typeof(v.__onupdate) == "string" then
							pointFunc(v.__onupdate, data.etc)({item = value.Name, val = value.Value}, t);
							return;
						end
						v.__onupdate({item = value.Name, val = value.Value}, t);
					end)
				end
			end
		end
	end
end




local function kick(plr: Player, massage: string)
	data.Profiles[plr.Name] = nil
	data.PlayerStatements[plr.Name] = nil;
	plr:Kick(massage)
end
local massage = "DataService requested player disconnect: Is someone else using your account?"
function data.HostProfile(plr: Player)
	data.PlayerStatements[plr.Name] = {}
	local profile = data.Store:LoadProfileAsync("Player_".. plr.UserId)
	if profile then
		profile:AddUserId(plr.UserId)
		profile:Reconcile()
		profile:ListenToRelease(function()
			kick(plr, massage)
		end)
		if plr:IsDescendantOf(players) then
			data.Profiles[plr.Name] = profile
			data.LoadedProfile:Fire(plr, profile);
		else
			profile:Release()
		end
	else
		kick(plr, massage)
	end
end



function data:ItemGotAdded(plr: Player, item: string, class: string)
	data.Client.OnUpdate:Fire(plr, item, class)
end



function data:AddItem(plr, item: Instance)
	local item = Search(storage.Assets);
	if item then
		local profile:PlayerData = data.Profiles[plr.Name]
		if profile then

			local haystack = item.Parent.Name
			local t = table.clone(profile.Inventory[haystack]);
			table.insert(t, item.Name)

			profile.Inventory[haystack] = data.DeleteDuplicates(t)

			data:ItemGotAdded(plr, item.Name, item:GetAttribute("Class"));
			notify(plr, item.Name);

			return true;
		else
			warn("Player profile unavailable");
			return false;
		end
	else
		warn(item.." Not found");
		return false;
	end
end

data.LoadedProfile:Connect(function(plr: Player, profile: PlayerData)
	profile = profile.Data;

	local abs = profile.Inventory.Abilities
	local swords = profile.Inventory.Swords
	local skins = profile.Inventory.Skins
	profile.Inventory.Abilities = data.DeleteDuplicates(abs)
	profile.Inventory.Swords = data.DeleteDuplicates(swords)
	profile.Inventory.Skins = data.DeleteDuplicates(skins)


	-->>>>>>>> Legacy Configuration.
	if not profile.Information.JoinedAfterRevamp then
		do --> LegacyConfiguration
			if profile.PlayerStats then
				profile.Goods.Coins = profile.PlayerStats.Coins;
				profile.PlayerStats = nil;
			end
	
	
			do --> Levels
				local lvl, xp;
				local ok, err = pcall(function()
					
					lvl = levelsDB:GetAsync("Level_" .. tostring(plr.UserId))
					xp = levelsDB:GetAsync("XP_" .. tostring(plr.UserId));
				end)
				if ok then
					if lvl then
						profile.Goods.Level = lvl;
		
						local ok, err = pcall(function()
							levelsDB:RemoveAsync("Level_" .. tostring(plr.UserId))
						end)
						if not ok then
							warn(err);
							
							plr:Kick("Please rejoin: is Roblox down?");
						end
					end
					if xp then
		
						profile.Goods.XP = xp;
		
						local ok, err = pcall(function()
							levelsDB:RemoveAsync("XP_" .. tostring(plr.UserId))
						end)
						if not ok then
							warn(err);
							plr:Kick("Please rejoin: is Roblox down?");
						end
						
					end
				else
					warn(err);
					plr:Kick("Please rejoin: Is Roblox down?");
				end
			end
	
			do --> Stats AKA Kills
	
				local kills;
	
				local ok, err = pcall(function()
					kills = killsDB:GetAsync(tostring(plr.UserId));
				end)
	
				if ok then
					if kills then
						profile.Stats.Kills = table.clone(kills)
						killsDB:RemoveAsync(tostring(plr.UserId));
					end
				else
					warn(err);
					plr:Kick("Please rejoin: is Roblox down?");
				end
				
			end
		end
		profile.Information.JoinedAfterRevamp = true;
	end

	print(profile)
	data:Describe(plr, profile);

	for i,v in pairs(Passes) do
		if marketplace:UserOwnsGamePassAsync(plr.UserId, v) then
			if (not table.find(profile.Inventory.Passes, i)) then
				task.delay(2, function()
					data.Grant[i](plr);
				end)
			end
		end
	end
end);


--[=[
	Yields the current thread until the profile of the given player exists.
	If player's profile is not found after `timeout` during player disconnect, An error will be thrown.

	@yields
	@return Profile -- The player's profile.
]=]
function data:GrabDataAsync(plr: Player, timeout: number)
	timeout = timeout or 5;
	local _ = 0
	--[[
	repeat
		if data.Profiles[plr.Name] then
			return data.Profiles[plr.Name];
		end
		_ += task.wait();
	until _ >= timeout
	]]

	while true do --> Brand NEW wait and timeout system
		if data.PlayerStatements[plr.Name] then --> data.PlayerStatements has tables indicating players who actually joined
			if data.Profiles[plr.Name] then
				return data.Profiles[plr.Name];
			end
			task.wait();
		else
			_ += task.wait();
		end
		if _ >= timeout then
			break;
		end
	end

	error("DataService: Player profile unavailable.")
end

--[=[
	Returns a promise that resolves when the player's profile is found.
	If player's profile is not found after `timeout` during player disconnect. The promise will reject.

	@return Promise
]=]
function data:GrabData(plr, timeout)
	return promise.new(function(resolve, reject)
		timeout = timeout or 5;
		local _ = 0

		while true do
			if data.PlayerStatements[plr.Name] then
				if data.Profiles[plr.Name] then
					resolve(data.Profiles[plr.Name]);
					break;
				end
				task.wait();
			else
				_ += task.wait();
			end
			if _ >= timeout then
				reject(_);
				break;
			end
		end
	end)
end




function data:KnitInit()
	for _,v in pairs(storageSv.Etc:GetChildren()) do
		if v:GetAttribute("include") == "DataService" then
			data.etc[v.Name] = require(v)
		end
	end
end


function data:KnitStart()
	--questSvc = knit.GetService("QuestService");
	economySvc = knit.GetService("EconomyService");
	for _, plr in pairs(players:GetPlayers()) do
		task.spawn(data.PlayerAdded, plr);
	end

	players.PlayerAdded:Connect(data.HostProfile);

	players.PlayerRemoving:Connect(function(player)
		local profile = data.Profiles[player.Name]
		if profile then
			profile:Release()
		end
	end)


	dataMod.OnServerInvoke = function(plr: Player, mode: string, ...)
		if mode == "Equip" then
			local item, type, index = table.unpack({...});
			data:GrabData(plr, 10):andThen(function(profile: PlayerData)
				profile = profile.Data;
				if type == "Ability" then
					profile.Inventory.EquippedAbilities[index or 1] = item;
				elseif (type == "Skin") or (type == "Sword") then
					profile.Inventory[`Equipped{type}`] = item;
				end
			end)
		end

		dataMod:InvokeClient(plr, "Reconcile");
		return true;
	end
	
	game.ServerScriptService.Sword.Kill.Event:Connect(function(plr, stat)
		data:AddStat(plr, stat);
	end)

	print("DataService: Started")
end


return data;