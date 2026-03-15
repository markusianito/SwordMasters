-->> LevelService.lua - Server
--> Level service idc

local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit.KnitServer);
local lvlSettings = require(storage.StandardLibraries.LevelSettings);
local dataSvc-- = require(game:GetService("ServerScriptService").Services.DataService);


local rank = knit.CreateService({Name = "RankService", Client = {UpdateAll = knit.CreateSignal(); OnXPAdd = knit.CreateSignal()}});

function rank:GetGoalXP(lvl)
	return lvlSettings.General.ObtenerExperienciaConNivel(lvl);
end


function rank:GetLevelInfo(plr:Player): table

    local profile = dataSvc:GrabDataAsync(plr, 15);
	if profile then
        profile = profile.Data;
        profile.Goods.GoalXP = rank:GetGoalXP(profile.Goods.Level);
	    return profile.Goods;
    end

end



function rank:LevelUp(plr:Player, nowait:boolean)
	local profile = rank:GetLevelInfo(plr);
	local lvlVal:IntValue, xpVal:IntValue, goalVal:IntValue = plr.Goods.Level, plr.Goods.XP, plr.Goods.GoalXP;
	
	if profile.Level >= lvlSettings.General.MaxLevel then 
		rank:DisplayPlayerLevelInfo(plr)
		return;
	end
	
	
	local condition = nil;
	repeat
		if profile.Level >= lvlSettings.General.MaxLevel then
			profile.Level = lvlSettings.General.MaxLevel;
			profile.XP = 0;
			break;
		end

		local diff = (profile.XP - profile.GoalXP)
        --local _diff = (diff == 0) and 1 or diff

		if math.sign(diff) >= 0 then
            
            profile.Level += math.sign(diff + 1);
            profile.XP = diff;
            profile.GoalXP = rank:GetGoalXP(profile.Level);

            lvlVal.Value = profile.Level;
            xpVal.Value = profile.XP;
            goalVal.Value = profile.GoalXP;

            

            condition = profile.XP < profile.GoalXP;

		else
			--condition = profile.XP > profile.GoalXP;
            warn("Cannot level down a player right now.")
            return false;
		end
        rank:DisplayPlayerLevelInfo(plr);
        if not nowait then
		    task.wait(1.2); --> When player is online
        end

	until condition

    task.delay(0.6, function()
        rank:DisplayPlayerLevelInfo(plr);
    end)

	return profile;
end



function rank:AddXP(plr:Player, xp:number)
    local profile = rank:GetLevelInfo(plr);
	
	if profile.Level >= lvlSettings.General.MaxLevel then
		if profile.XP ~= 0 then
			profile.XP = 0
		end
		return;
	end
	
	xp = math.round(xp - 0.25);
	profile.XP = math.clamp(profile.XP + xp,0, math.huge)
    profile.GoalXP = rank:GetGoalXP(profile.Level);

    pcall(function()
        plr.Goods.XP.Value = profile.XP
        plr.Goods.GoalXP.Value = profile.XP
    end)

    rank.Client.OnXPAdd:Fire(plr, xp);

    if profile.XP >= profile.GoalXP then
        rank:LevelUp(plr);
    end
    return true;
end



function rank:DisplayPlayerLevelInfo(plr:Player)
	local profile = rank:GetLevelInfo(plr);
    local lvl: IntValue = plr:WaitForChild("Goods"):WaitForChild("Level")
    local xp: IntValue = plr:WaitForChild("Goods"):WaitForChild("XP")
    local goal: IntValue = plr:WaitForChild("Goods"):WaitForChild("GoalXP")

    lvl.Value = profile.Level;
    xp.Value = profile.XP;
    goal.Value = profile.GoalXP;
end

function rank:KnitInit()
    
end

function rank:KnitStart()
    game:GetService("Players").PlayerAdded:Connect(function(player)
        rank:DisplayPlayerLevelInfo(player);
        rank.Client.UpdateAll:Fire(player);
    end)
    dataSvc = knit.GetService("DataService");
    print("RankService started")
end

return rank

