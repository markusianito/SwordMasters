-->> Use.lua - Server
--> Ability use manager, adapted as a library by Marcos.

--->>>> NOTE:	In case of a bug,
--				where just a player at once can use abilities,
--				try changing the OnServer functions to coroutines / spawns



--> Includes // Load
local Use = {}
local playerData = {};


local rs = game:GetService("ReplicatedStorage")
local bring			=	rs:WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Bring")
local cback			=	rs.RemoteEvents:WaitForChild("Abilities"):WaitForChild("Callback")
local UseEvent		=	rs.RemoteEvents:WaitForChild("Abilities"):WaitForChild("Use")
local Load			=	rs.RemoteEvents:WaitForChild("Abilities"):WaitForChild("Load")
local Loaded		=	rs.RemoteEvents:WaitForChild("Abilities"):WaitForChild("Loaded")
local Unlock		=	rs.RemoteEvents:WaitForChild("Abilities"):WaitForChild("Unlock")

local lib = require(script.Lib);
local kill = game.ServerScriptService.Sword.Kill;
local stamed = game.ReplicatedStorage.RemoteEvents.StaminaED;
local Settings = require(game.ReplicatedStorage.Client_Modules.ReplicatedSettings)
local forceSL = game.ReplicatedStorage.RemoteEvents.Shiftlock;


local absExclude = { --> [NameOfTheChildToExclude] = exclude
	["Lib"] = true;
}


local abs = {}

for _,v in pairs(script:GetChildren()) do
	if not absExclude[v.Name] then
		abs[v.Name] = require(v);
	end
end




local function onUse(plr,ability)
	if abs[ability] then
		abs[ability].Use(plr, playerData, Loaded, bring, cback, kill, forceSL);
	else
		print(`No module to handle {ability} ability`);
	end
end

UseEvent.OnServerEvent:Connect(onUse)

Unlock.OnServerInvoke = function(plr, ability)
	--local c = coroutine.create(function()
	if abs[ability] then
		local args = {true};
		local ok, err = pcall(function()
			args = {abs[ability].Unlock(plr, playerData, Loaded, bring, cback, kill, forceSL)};
		end)

		if not ok then
			return true, err;
		end
		return table.unpack(args or {true, err});
	else
		print(`No module to handle {ability} ability`);
	end
	--end)
	--return select(2, coroutine.resume(c)); 
end

Load.OnServerInvoke = function(plr, ability)
	--local c = coroutine.create(function()
		if abs[ability] then
			local args = {true}
			local ok, err = pcall(function()
				args = {abs[ability].Load(plr, playerData, Loaded, bring, cback, kill, forceSL);}
		end)
		if not ok then
			return true, err;
		end
			return table.unpack(args or {true, err})
		else
			print(`No module to handle {ability} ability`);
		end
	--end)
	--return select(2, coroutine.resume(c)); 
end 





Use.Main = function()
	game.Players.PlayerAdded:Connect(function(plr) --> Data setup

		playerData[plr.Name] = {};
		local t = playerData[plr.Name];


		t.AbilityAnims = {}
		t.AbilityData = {}
		t.AbCooldown = false;

		plr.CharacterAdded:Connect(function(char)

			local animator:Animator = char:WaitForChild("Humanoid"):WaitForChild("Animator");
			for id,ability in pairs(plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities"):GetChildren()) do
				--warn(ability.Name)
				t.AbilityData[ability.Name] = {};
				
				
				t.AbilityAnims[ability.Name] = {}
				local anims;
				xpcall(function()
					anims = Settings.Abilities[ability.Name].Animations
				end,function()
					anims = Settings.Abilities.Dash.Animations;
					warn(string.format("Could not get the animations for %s ability",ability.Name));
				end)
				if type(anims) == "table" then
					for i,v in ipairs(anims) do

						local animationToLoad = Instance.new("Animation");
						animationToLoad.AnimationId = workspace:GetAttribute("robloxstr") .. v;
						animationToLoad.Name = i;
						animationToLoad.Parent = animator;

						task.wait(0.1)
						local track:AnimationTrack = animator:LoadAnimation(animationToLoad);
						track.Priority = Enum.AnimationPriority.Action;
						table.insert(t.AbilityAnims[ability.Name],track)

					end
				end
			end
		end)
	end)

	game.Players.PlayerRemoving:Connect(function(plr)
		local t = playerData[plr.Name];
		if t then
			lib:MemoryBan(t)
		end
		playerData[plr.Name] = nil;
	end)
end

return Use
