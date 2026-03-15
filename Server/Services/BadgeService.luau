-->> BadgeService.lua
--> Self explanatory shit

local badgeSvc = game:GetService("BadgeService")
local dsSvc = game:GetService("DataStoreService");
local badgesDB = dsSvc:GetDataStore("BadgesDatabase");
local notify = game.ReplicatedStorage.ClientEvents.BoughtThing;
local coinSvc

function Notify(plr, reward): ()
	notify:FireClient(plr, "NewItem", {AinStr = "You received", Object = reward})
end



local plrTries = {}

local knit = require(game.ReplicatedStorage.Packages.Knit);

local badges = knit.CreateService({Name = "BadgeService"});

badges.Badges = {
	FirstElimination = 3431305683974715;
	PvpBeginner = 3547778537084658;
	PvpProfessional = 3844513776622880;
	PvpMaster = 3614689108171803;
	PvpChampion = 3100920707859568;
	ZombieHunter = 3332731187493327;
	ZombieSmasher = 3040108189216251;
	ZombieSlayer = 1353807275282941;
	ZombieChampion = 568359464080167;
	DefeatMountainGuardian = 465000555631493;
}

badges.Rewards = {
	FirstElimination = {Coins = 100};
	PvpBeginner = {Coins = 250};
	PvpProfessional = {Coins = 1000};
	PvpMaster = {Coins = 10_000};
	PvpChampion = {Coins = 50_000};
	ZombieHunter = {Coins = 100};
	ZombieSmasher = {Coins = 600};
	ZombieSlayer = {Coins = 2500};
	ZombieChampion = {Coins = 20_000};
	DefeatMountainGuardian = {Coins = 200};
}



function badges:TryGet(plr)
	if plrTries[plr.Name] then
		plrTries[plr.Name] += 1;
	else
		plrTries[plr.Name] = 0;
	end

	local data;
	local succ = pcall(function()
		data = badgesDB:GetAsync(`badges_{plr.UserId}`);
	end)

	if not succ then
		if plrTries[plr.Name] >= 5 then
			succ = true;
			data = false;
			plrTries[plr.Name] = nil;
		end
	end

	if succ then
		return data;
	else
		return badges:TryGet(plr);
	end
end

function badges:TrySet(plr, val)
	if plrTries[plr.Name] then
		plrTries[plr.Name] += 1;
	else
		plrTries[plr.Name] = 0;
	end

	local data;
	local succ = pcall(function()
		badgesDB:SetAsync(`badges_{plr.UserId}`, val);
	end)

	if not succ then
		if plrTries[plr.Name] >= 5 then
			succ = "waht";
			plrTries[plr.Name] = nil;
		end
	end

	if succ then
		return succ
	else
		return badges:TrySet(plr, val);
	end
end



function badges:UserHasBadgeAsync(plr, badge)
	local data = badges:TryGet(plr)
	if data == nil then
		data = {};
		badges:TrySet(plr, data);
		return false;
	end
	local found = table.find(data, badge)
	return not not found;
end

function badges:AwardBadge(plr, badge)
	local data = badges:TryGet(plr);
	if not badges:UserHasBadgeAsync(plr, badge) then
		local ok = pcall(function()
			table.insert(data, badge);
			badges:TrySet(plr, data)
		end)
		return ok;
	end
	return false;
end



function badges:ClaimBadge(plr:Player, badge)
	local badgeId = badges.Badges[badge]
	if not badgeSvc:UserHasBadgeAsync(plr.UserId, badgeId) then
		task.spawn(function()
			badgeSvc:AwardBadge(plr.UserId, badgeId)
		end)
	end
	if not badges:UserHasBadgeAsync(plr, badge) then
		if badges.Rewards[badge].Coins then
			coinSvc:PayPlayer(badges.Rewards[badge].Coins, plr);
			Notify(plr, `{badges.Rewards[badge].Coins} Coins`)
			
		elseif badges.Rewards[badge].XP then
			coinSvc:TeachPlayer(plr, badges.Rewards[badge].XP);
			Notify(plr, `{badges.Rewards[badge].XP} XP`)
			
		
		end
		task.spawn(function()
			badges:AwardBadge(plr, badge)
		end)
		return true;
	end
	return false;
end


local killsTemplate = require(game.ServerStorage.Etc.BlankPlayerData).Stats.Kills;
function badges:KnitStart()
	coinSvc = knit.GetService("EconomyService")
	local dataSvc = knit.GetService("DataService");
	
	local badgesComm = game.ReplicatedStorage.RemoteEvents.BadgesCallback




	
	

	local function describe(plr)
		local data = dataSvc:GrabDataAsync(plr, 10).Data.Stats.Kills

		local claims = {}
		for i,v in pairs(badges.Badges) do
			claims[i] = badges:UserHasBadgeAsync(plr, i)
		end

		return data, claims
	end



	badgesComm.OnServerInvoke = function(plr: Player, mode, badge)
		if mode == "describe" then
			return describe(plr)

		elseif mode == "consult" then
			local success = badges:ClaimBadge(plr, badge)

			return describe(plr)
		end
	end
	print("badges started")
end


return badges
