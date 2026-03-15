-->> Fireball.lua - Server
--> Main program for Fireball ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Fireball"
local lib = require(script.Parent:WaitForChild("Lib"))
local Settings = require(game:GetService("ReplicatedStorage").Client_Modules.ReplicatedSettings).Abilities;
local runSvc = game:GetService("RunService");
local tws = game:GetService("TweenService");
local Baller = game:GetService("CollectionService");
local theDeath = game:GetService("Debris")

local unlockable = false;






local function Cleanup(plr:Player, playerData)
	return function()
		return true;
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
	local ded = false;
	local a
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end

	local character:Model = plr.Character;
	if character:GetAttribute("Busy") then return nil; end;
	character:SetAttribute("Busy", true);

	local hrp:Part = character.HumanoidRootPart
	local hum:Humanoid = character.Humanoid
	local leftarm = character:FindFirstChild("Left Arm");
	local Info = t.AbilityData.Fireball;
	local anims = t.AbilityAnims.Fireball


	local Tag = "Burned_"..math.random(0,3690);


	local cleanF = hum.Died:Once(function()
		ded = true;
		main.Cleanup(plr, playerData)();
	end)



	local invoke		:AnimationTrack = anims[		1		]
	local idle			:AnimationTrack = anims[		2		]
	local aim			:AnimationTrack = anims[		3		]
	local shot			:AnimationTrack = anims[		4		]



	local fireball = script.Fireball:Clone();
	local s1, s2 = fireball.Size, fireball.FX.Size;
	fireball.Size = Vector3.one * 0.1; fireball.FX.Size = Vector3.one * 0.1;

	local adjust = function()
		fireball.CFrame = leftarm.LeftGripAttachment.WorldCFrame:ToWorldSpace(CFrame.Angles(math.pi/2,0,math.pi/2)):ToWorldSpace(CFrame.new(0,0,0.666));
		--fireball.FX.CFrame = fireball.CFrame;
	end
	fireball.Parent = leftarm;
	adjust();
	fireball.Weld.Part0 = leftarm;
	fireball.Weld.Part1 = fireball;
	local ween1 = tws:Create(fireball,lib.twi,{Size = s1})
	ween1:Play();
	local ween2 = tws:Create(fireball.FX,lib.twi,{Size = s2})
	ween2:Play();


	invoke:Play();
	idle:Play();
	hrp.FireballSound:Play();
	
	--> IDLE.
	
	
	
	if ded then return true; end


	repeat task.wait()
		--adjust();
	until (ween1.PlaybackState == Enum.PlaybackState.Completed) and (ween2.PlaybackState == Enum.PlaybackState.Completed)


	Info.BringConnection = bring.OnServerEvent:Connect(function(plr2,ready)
		if plr2 == plr then
			if ready then
				aim:Play();
				while true do
					if ded then return true; end
					runSvc.Heartbeat:Wait();
					if aim.TimePosition >= 4.81 then break; end
				end
				aim:AdjustSpeed(0);
			end
		end
	end)

	
	local positions, dead = cback:InvokeClient(plr, "Fireball", true); --> Call client and get positions.
	if dead then return true; end
	
	if Info.BringConnection then
		Info.BringConnection:Disconnect();
		Info.BringConnection = nil;
	end

	aim:Stop();
	idle:Stop();
	hrp.FireballSound:Stop();

	shot:Play();
	hrp.FireballThrow:Play();
	while true do
		if ded then return true; end
		runSvc.Heartbeat:Wait();
		if shot.TimePosition >= 0.35 then break;end
	end
	fireball.Weld:Destroy();
	local position = 1;

	local ao = script.WaypointMove:Clone();
	ao.Attachment0 = fireball.Attachment;
	ao.Position = positions[position];
	ao.Parent = fireball;
	shot:Stop();



	local function Explode(pos)
		
		local ptcs = Instance.new("Part");
		ptcs.Transparency = 1;
		ptcs.Anchored = true;
		ptcs.CanCollide = false;
		ptcs.Position = pos
		ptcs.Parent = workspace;
		fireball.Attachment:Clone().Parent = ptcs
		theDeath:AddItem(ptcs, 20);
		
		task.wait()
		
		for _,v:ParticleEmitter in ptcs.Attachment:GetChildren() do
			v:Emit(v:GetAttribute("EmitCount"));
		end
		--fireball.Sound:Play();


		local box = Instance.new("Part");
		box.Transparency = 1;
		box.CanCollide = false;
		box.Anchored = true;
		box.Shape = Enum.PartType.Ball;
		box.Size = Vector3.one * Settings[self].DamageAreaRadius;
		box.Position = pos
		box.Parent = workspace;
		theDeath:AddItem(box, 2);

		local parts = workspace:GetPartsInPart(box, lib.TheParams)

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

	end
	
	local b
	b = runSvc.Heartbeat:Connect(function()
		for _,p in pairs(workspace:GetPartsInPart(fireball, lib.TheParams3)) do
			if
				p:FindFirstAncestor("Destroyables") or
				p:FindFirstAncestor("Destroyables2") or
				p:HasTag("Destroyables") or
				p:GetAttribute("Destroyables")
			then
				warn(p);
				Explode(fireball.Position);
				fireball:Destroy();
				if not b then return end;
				b:Disconnect();
				b = nil;
			end

		end
	end)
	
	while true do
		if not fireball then break; end;
		if fireball then
			pcall(function()
				fireball:SetNetworkOwner(plr)
			end)
		end
		position = math.clamp(position + 1,1,#positions)
		if position%2 then runSvc.Heartbeat:Wait();end
		ao.Position = positions[position];
		if position == #positions then break; end;
	end
	

	ao:Destroy();



	character:SetAttribute("Busy", false);

	if cleanF then
		cleanF:Disconnect();
	end
	cleanF = nil;
	main.Cleanup(plr, playerData)();

	return true;
end



function main.Use(plr:Player, playerData:{tables})
	return true;
end


return main;