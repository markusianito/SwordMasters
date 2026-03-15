-->> Burger.lua - Server
--> Main program for Burger ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Burger"
local lib = require(script.Parent:WaitForChild("Lib"))
local Settings = require(game:GetService("ReplicatedStorage").Client_Modules.ReplicatedSettings).Abilities;
local runSvc = game:GetService("RunService");
--local tws = game:GetService("TweenService");
local Baller = game:GetService("CollectionService");

local unlockable = true;






local function Cleanup(plr:Player, playerData, cback)
	return function()
		local suck, err = pcall(function()
			playerData = playerData[plr.Name].AbilityData[self];
		end)
		if suck then
			lib:MemoryBan(playerData[plr.Name]);
			return true;
		end
		warn(`Cleanup function in {self}: ` .. err);
		return false;
	end
end



local main = {};


function main.Cleanup(...)
	return Cleanup(...)
end



function main.Unlock()
	return unlockable;
end



function main.Load(plr:Player, playerData:{tables}, Loaded:RemoteEvent, bring:RemoteEvent, cback:RemoteFunction, kill:BindableEvent)
	Loaded:FireClient(plr, self);
	return true;
end



function main.Use(plr:Player, playerData:{tables}, Loaded:RemoteEvent, bring:RemoteEvent, cback:RemoteFunction, kill:BindableEvent)
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end

	local character:Model = plr.Character;
	local hrp:Part = character.HumanoidRootPart
	local hum:Humanoid = character.Humanoid
	local leftarm:Part = character["Left Arm"];
	local anim = t.AbilityAnims.Burger[1];
	
	task.delay(0.7, function()
		hrp.BurgerSound:Play();
	end)

	local burger = script.Burger:Clone();
	burger.Parent = leftarm;
	burger.CFrame = leftarm.LeftGripAttachment.WorldCFrame:ToWorldSpace(CFrame.Angles(math.pi/-2,0,math.pi/2)):ToWorldSpace(CFrame.new(0,0,-0.5))
	burger.Weld.Part0 = burger;
	burger.Weld.Enabled = true;
	burger.Weld.Part1 = leftarm;

	anim:Play();

	while true do
		runSvc.Heartbeat:Wait();
		if anim.TimePosition >= 0.36 then break; end
	end

	burger.Transparency = 0;

	while true do
		runSvc.Heartbeat:Wait();
		if anim.TimePosition >= 1 then break; end
	end

	burger:Destroy();
	hum.Health += Settings[self].HealAmount
	
	hrp.HealSFX:Play();
	for _,v:ParticleEmitter in pairs(hrp.HealFX:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"));
		end
	end
end


return main;