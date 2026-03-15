-->> Stomp.lua - Server
--> Main program for Stomp ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Stomp"
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

	local Tag = "Stomped_" .. math.random(0,3690)

	local character:Model = plr.Character;
	local hrp:Part = character.HumanoidRootPart
	local hum:Humanoid = character.Humanoid
	local leftleg:Part = character["Left Leg"];

	repeat task.wait() until hum.FloorMaterial ~= Enum.Material.Air;

	hrp.Anchored = true;

	local hitbox = Instance.new("Part");
	hitbox.Color = Color3.new(1);
	hitbox.Anchored = true;
	hitbox.CanCollide = false;
	hitbox.Transparency = 1;
	hitbox.Position = hrp.Position;


	hitbox.Size = Vector3.one * Settings[self].DamageAreaRadius;
	hitbox.Parent = workspace.ToDestroy;


	local Info = t.AbilityData.Stomp;
	local anim:AnimationTrack = t.AbilityAnims.Stomp[1];

	local VFX = leftleg.StompFX;

	anim:Play();

	while true do
		print "mak"
		runSvc.Heartbeat:Wait();
		if anim.TimePosition >= 0.6 then break; end
	end

	task.delay(0.5, function()
		hrp.Anchored = false;
	end)

	for _,v:ParticleEmitter in pairs(VFX:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"));
		end
	end
	
	hrp.StompSound:Play();

	local parts = workspace:GetPartsInPart(hitbox,lib.TheParams);

	for _,v:BasePart in pairs(parts) do
		local char:Model = v:FindFirstAncestorOfClass("Model");
		if char then
			if (char ~= character) and (not char:HasTag(Tag)) then
				local hum:Humanoid = char:FindFirstChildOfClass("Humanoid");
				if hum then
					if lib.knit.GetService("RoundService"):CheckMode() == "PVP" then
						hum:TakeDamage(Settings[self].Damage * character:GetAttribute("MoreDamage"));
						Baller:AddTag(char, Tag)
						task.wait(0.1);
						if hum.Health == 0 then
							kill:Fire(plr.Name,char);
						end
					else
						if not game.Players:GetPlayerFromCharacter(char) then
							hum:TakeDamage(Settings[self].Damage * character:GetAttribute("MoreDamage"));
							Baller:AddTag(char, Tag)
							task.wait(0.1);
							if hum.Health == 0 then
								kill:Fire(plr.Name,char);
							end
						end
					end

				end
			end
		end
	end
	print "emd"
end


return main;