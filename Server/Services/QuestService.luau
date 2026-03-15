-->> questervice.lua - Server
--> Quest functions shared across server for SM


export type Quest = {
	Mission: {
		Eliminate: {
			Players: number|nil,
			Enemies: number|nil
		}?,

		Win: {
			Round: {
				Mode: string|nil,
				Amount: number
			}
		}?
	},

	Reward: {
		Coins: number|nil,
		XP: number|nil
	}
}

export type QuestProgress = {
	Amount: number;
	Claimed: boolean
}

export type Rarity = "Uncommon"|"Common"|"Rare"|"Epic"|"Legendary"

-->> QuestData Scopes:
--		quests: quest general info
--		questing: quest progress info

local knit = require(game.ReplicatedStorage.Packages.Knit);

local coinSvc;
local dataSvc;

local storage = game:GetService("ReplicatedStorage");
local questModule = require(game.ReplicatedStorage.StandardLibraries.Quests)

local storageSv = game:GetService("ServerStorage");
local timeNdate = require(storage.Packages.TimeNDate);
local net = require(storage.Packages.Net);

local consult = storageSv.ServerEvents.QuestConsult;
local data = net:RemoteFunction("QuestData")
local claim = net:RemoteEvent("ClaimQuest")
local timer = net:RemoteEvent("UpdateTimer");



local plrTries = {}

local quest = knit.CreateService({Name = "QuestService"});

function quest:TryGet(plr, scope)
	local data = dataSvc:GrabDataAsync(plr, 10)
	if data then
		data = data.Data;
		if scope == "quests" then
			return data.Quests;
		elseif scope == "questing" then
			return data.QuestProgress
		elseif scope == "lastUpdate" then
			return data.Information.LastOnline
		end
	end
end

function quest:TrySet(plr, scope, val)
	local data = dataSvc:GrabDataAsync(plr, 10)
	if data then
		data = data.Data;
		if scope == "quests" then
			data.Quests = table.clone(val);
		elseif scope == "questing" then
			data.QuestProgress = table.clone(val);
		elseif scope == "lastUpdate" then
			data.Information.LastOnline = val;
		end
	end
	return true;
end



function quest:RandomRarity(): Rarity
	local sumaProbabilidades = 0
	for _, probabilidad in pairs(questModule.Tiers) do
		sumaProbabilidades = sumaProbabilidades + probabilidad
	end

	local numeroAleatorio = math.random()

	local acumulado = 0
	for rareza, probabilidad in pairs(questModule.Tiers) do
		acumulado = acumulado + probabilidad / sumaProbabilidades
		if numeroAleatorio <= acumulado then
			return rareza
		end
	end
end



function quest:GetRandomQuest(rarity:Rarity): Quest
	rarity = rarity or quest:RandomRarity();
	local folder = questModule.Quests[rarity];
	
	local quest = folder[math.random(1,#folder)]
	return quest, rarity;
end



function quest:GenerateQuestTable(rarity)
	local data = {}
	for i = 1,3 do
		local t:Quest, rarity:Rarity = quest:GetRandomQuest(rarity);
		t["1"] = rarity

		data[tostring(i)] = t;
	end
	return data;
end

function quest:GetEmptyProgressTable()
	return {
		["1"] = {
			Amount = 0;
			Claimed = false;
		},
		["2"] = {
			Amount = 0;
			Claimed = false;
		},
		["3"] = {
			Amount = 0;
			Claimed = false;
		}
	}
end



local req = require(game.ReplicatedStorage.Packages.Net):RemoteEvent("UpdateSignal")
local update = require(game.ReplicatedStorage.Packages.Net):RemoteEvent("UpdateQuestInfo")
print("log")
function quest:UpdateQuestInfoFor(plr, data: {Quest}?, progress: {QuestProgress}?)
	data = data or quest:TryGet(plr, "quests")
	progress = progress or quest:TryGet(plr, "questing")
	
	req:FireClient(plr, data, progress);
end


function quest:RerollQuestsFor(plr)
	local data = quest:GenerateQuestTable();
	local progress = quest:GetEmptyProgressTable();
	quest:TrySet(plr, "quests", data);
	quest:TrySet(plr, "questing", progress)
	
	return data, progress
end




function quest:GetQuestInfo(plr)
	local progress = quest:TryGet(plr, "questing")
	local data = quest:TryGet(plr, "quests");
	
	if not data then
		data = quest:GenerateQuestTable();
	end
	quest:TrySet(plr, "quests", data);
	
	
	if not progress then
		progress = quest:GetEmptyProgressTable();
	end
	quest:TrySet(plr, "questing", progress);
	
	return data, progress;
end



function quest:SaveLastUpdate(plr)
	local now = os.time();
	local suses = quest:TrySet(plr, "lastUpdate", now);
	if suses then
		warn(`Saved {plr.Name} last update: {now}`)
	else
		warn("Cannot save last update")
	end
	
	return suses;
end


function quest:ReadLastUpdate(plr)
	local lastUpdate = quest:TryGet(plr, "lastUpdate");
	return lastUpdate;
end



local roundGoods = {["PVP"] = true, ["Survival"] = true, ["Bossfight"] = true}
function quest.CheckRoundGood(good: string)
	return roundGoods[good];
end





function quest:UpdateQuestInfo(plr, good)
	warn("Quest Good: ", good, plr)
	local progress = quest:TryGet(plr, "questing");
	local data = quest:TryGet(plr, "quests");
	
	local slots:{string} = {};
	for i,v in pairs(data) do
		if v.Mission.Win then
			if v.Mission.Win.Round.Mode == nil then
				if quest.CheckRoundGood(good) then
					table.insert(slots, i)
				end
				
			end
			if v.Mission.Win.Round.Mode == good then
				table.insert(slots, i)
				
			end
			
		elseif v.Mission.Eliminate then
			if (v.Mission.Eliminate.Enemies) and ((good == "Zombie") or (good == "Miniboss")) then
				table.insert(slots, i)
				
			elseif (v.Mission.Eliminate.Players) and (good == "Player") then
				table.insert(slots, i)
				
			elseif (v.Mission.Eliminate.Boss) and (good == "Bossfight") then
				table.insert(slots, i)
				
			end
		end
	end
	if #slots == 0 then return; end
	
	for _,slot in pairs(slots) do
		progress[slot].Amount += 1;
	end
	
	local succ = quest:TrySet(plr, "questing", progress);
	
	if succ then
		for _,slot in pairs(slots) do
			update:FireClient(plr, "describe", slot, progress[slot]);
		end
	end
	return succ
end

local notify = net:RemoteEvent("MessagesStars");

function Notify(plr, reward): ()
	notify:FireClient(plr, "NewItem", {AinStr = "You received", Object = reward}) 
end

function quest:ClaimQuest(plr, slot: string)
	local progress = quest:TryGet(plr, "questing");
	local data:Quest = quest:TryGet(plr, "quests");
	
	if progress[slot].Claimed then return false; end
	
	data = data[slot]
	local goal;
	if data.Mission.Eliminate then
		goal = data.Mission.Eliminate.Players or data.Mission.Eliminate.Enemies or data.Mission.Eliminate.Boss
	elseif data.Mission.Win then
		goal = data.Mission.Win.Round.Amount
	end
	
	if progress[slot].Amount >= goal then
		progress[slot].Claimed = true;
	else
		return false;
	end
	
	local succ = quest:TrySet(plr, "questing", progress);
	if succ then
		update:FireClient(plr, "describe", slot, progress[slot]);
		
		if data.Reward.Coins then
			coinSvc:PayPlayer(plr, data.Reward.Coins);
			Notify(plr, `{data.Reward.Coins} Coins`)
		elseif data.Reward.XP then
			coinSvc:TeachPlayer(plr, data.Reward.XP);
			Notify(plr, `{data.Reward.XP} XP`)
		end
		
		return true
	else
		return false;
	end
end


function quest:KnitStart()
	coinSvc = knit.GetService("EconomyService")
	dataSvc = knit.GetService("DataService");
	
	-->> QuestMgr.lua - Server
	--> Quest main program for server

	local EVERY = 24 --> Every 24 hours, quests will reroll
	local OFFSET = 2 --> The 24 hour countdown, takes the UTC time, so i want it to take UTC+2 time, as Bordii said.


	data.OnServerInvoke = function(plr)
		return quest:GetQuestInfo(plr)
	end

	consult.Event:Connect(function(plr, good)
		quest:UpdateQuestInfo(plr, good)
	end)

	claim.OnServerEvent:Connect(function(plr, slot:string)
		quest:ClaimQuest(plr, slot)
	end)


	local timezoneOffset = OFFSET * 3600
	local resetInterval = EVERY * 3600

	local function getCurrentTimeInTimeZone(timezoneOffset)
		return os.time() + timezoneOffset
	end

	local function getLastResetTime(timezoneOffset, resetInterval)
		local currentTime = getCurrentTimeInTimeZone(timezoneOffset)

		local lastResetTime = currentTime - (currentTime % resetInterval)

		return lastResetTime - timezoneOffset
	end


	-- Comprobar si se deben reiniciar las misiones del jugador
	local function shouldResetMissions(player, timezoneOffset, resetInterval)

		local lastLogoutTime = quest:ReadLastUpdate(player);

		if lastLogoutTime then
			local lastResetTime = getLastResetTime(timezoneOffset, resetInterval)

			-- Si el jugador salió antes del último reinicio, reiniciar misiones
			if lastLogoutTime < lastResetTime then
				return true
			end
		end

		return false
	end


	game.Players.PlayerAdded:Connect(function(plr)
		local data: timeNdate.TimeDate = quest:ReadLastUpdate(plr)
		if data then
			if shouldResetMissions(plr, timezoneOffset, resetInterval) then
				warn("Player joined after quests reseted globally");


				local ts, prog = quest:RerollQuestsFor(plr);
				quest:UpdateQuestInfoFor(plr, ts, prog)
			end
		end
	end)


	game.Players.PlayerRemoving:Connect(function(plr)
		quest:SaveLastUpdate(plr);
	end)

	game:BindToClose(function()
		for _,v in pairs(game.Players:GetPlayers()) do
			quest:SaveLastUpdate(v);
		end
	end)



	task.spawn(function()
		while task.wait(1) do
			local time = timeNdate:GetTimeUntilNextInterval(EVERY, OFFSET)

			timer:FireAllClients(timeNdate:format(time))

			time -= 1

			if time <= 0 then
				time = timeNdate:GetTimeUntilNextInterval(EVERY, OFFSET)
				for _,player in pairs(game.Players:GetPlayers()) do

					local ts, prog = quest:RerollQuestsFor(player);
					quest:UpdateQuestInfoFor(player, ts, prog)
				end
			end
		end
	end)

	print("QuestService started")
end


return quest
