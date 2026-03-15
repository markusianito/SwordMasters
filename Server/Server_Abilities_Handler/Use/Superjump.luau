-->> Superjump.lua - Server
--> Main program for Superjump ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Superjump"
local lib = require(script.Parent:WaitForChild("Lib"))
local Settings = require(game:GetService("ReplicatedStorage").Client_Modules.ReplicatedSettings).Abilities;
local runSvc = game:GetService("RunService");
--local tws = game:GetService("TweenService");
--local Baller = game:GetService("CollectionService");

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
	local ded = false;
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end

	local character:Model = plr.Character;
	local hrp:Part = character.HumanoidRootPart
	local hum:Humanoid = character.Humanoid
	local Info = t.AbilityData.Superjump;
	local animations = t.AbilityAnims.Superjump
	local charge:AnimationTrack, jump:AnimationTrack = animations[1], animations[2]

	character:SetAttribute("Busy", true)
	character:SetAttribute("MoreSpeed", 0.01)



	local cleanF = hum.Died:Once(function()
		ded = true;
		--main.Cleanup(plr, playerData)();
	end)


	--local anchor:AlignPosition = hrp.Anchor;--hrp.Anchored = true;

	repeat task.wait()--[[anchor.Position = hrp.Position;]] until hum.FloorMaterial ~= Enum.Material.Air
	--anchor.Enabled = true
	if ded then return true; end
	
	local s1:Sound, s2:Sound = hrp.ChargeSuperjump, hrp.JumpSuperjump
	s1.Volume = 1.5;
	s1:Play();

	local VFX = hrp.SuperjumpFX
	local t1, t2 = VFX.Attachment.A1.Transparency, VFX.Attachment.A2.Transparency;

	--charge.Looped = true;
	charge:Play();

	for _,v:ParticleEmitter in pairs(VFX:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			if ded then return true; end
			v.Enabled = true;
		end
	end

	local jp = hum.JumpPower;
	local vel = hum.WalkSpeed
	hum.JumpPower = 0;
	hum.WalkSpeed = 0.01

	Info.Loaded = false;

	Info.StartTime = os.clock();
	Info.ElapsedTime = 0;
	--Info.LoadFunc = coroutine.create(function()
	while task.wait() do
		if ded then return true; end
		Info.ElapsedTime = os.clock() - Info.StartTime
		for _,v:ParticleEmitter in pairs(VFX.Attachment:GetChildren()) do
			v.Color = ColorSequence.new(Color3.new(1,1,1):Lerp(Color3.new(1, 0.282353, 0),math.clamp(Info.ElapsedTime/5,0,1)))
		end
		if (Info.ElapsedTime >= Settings[self].MaxChargeTime) or (Info.Loaded) then
			break;
		end
	end
	s1:Stop();
	s2:Play();
	
	charge:Stop();
	jump:Play();


	Info.Loaded = true;

	--anchor.Enabled = false;
	--print(math.ceil(Info.ElapsedTime))
	task.wait();
	--hum.JumpPower = Settings.Abilities.Superjump.JumpPower;
	hum.JumpPower = jp;
	hum.Jump = true;

	task.wait();

	Info.ElapsedTime = math.clamp(math.ceil(Info.ElapsedTime),1,5) + 2

	hrp.AssemblyLinearVelocity = (hrp.CFrame.LookVector * (Info.ElapsedTime * 35)) + Vector3.new(0,Info.ElapsedTime * 20,0);


	for _,v:ParticleEmitter in pairs(VFX:GetDescendants()) do
		if v:IsA("ParticleEmitter") then
			task.spawn(function()
				for i = 80,100 do
					task.wait()
					v.Transparency = NumberSequence.new(i / 100);
					if i == 100 then
						v.Enabled = false;
					end
				end
			end)
		end
	end
	--Destroyer:AddItem(VFX,1.2);
	--end)
	--coroutine.resume(Info.LoadFunc)

	while not Info.Loaded do
		if ded then return true; end
		task.wait();
	end

	Info.ElapsedTime = 0;
	Info.Loaded = false;

	hum.JumpPower = jp;
	hum.WalkSpeed = vel;


	task.delay(1, function()
		VFX.Attachment.A1.Transparency = t1;
		VFX.Attachment.A2.Transparency = t2;
	end)

	return Info.ElapsedTime;
end



function main.Use(plr:Player, playerData:{tables})
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end
	local Info = t.AbilityData.Superjump;

	local hrp:Part = plr.Character.HumanoidRootPart
	
	print("Used", self)
	
	Info.Loaded = true;

	if Info.ElapsedTime then
		--if Info.ElapsedTime < 0.666 then
		for _,v:ParticleEmitter in pairs(hrp.SuperjumpFX:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				v.Enabled = false;
			end
		end
		--end
	end

	plr.Character:SetAttribute("Busy", false)
	plr.Character:SetAttribute("MoreSpeed", 1)
	
	return true;
end


return main;