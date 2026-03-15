-->> Dash.lua - Server
--> Main program for God's Dash ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "God's Dash"
local lib = require(script.Parent:WaitForChild("Lib"))
local Settings = require(game:GetService("ReplicatedStorage").Client_Modules.ReplicatedSettings).Abilities;

local unlockable = true;


local dash = require(script.Parent.Dash);




local function Cleanup(plr:Player, playerData, cback)
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
	Loaded:FireClient(plr, self);
	return true;
end



function main.Use(plr:Player, playerData:{tables})

	print("Used", self)
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end

	local character:Model = plr.Character;
	local hrp:Part = character.HumanoidRootPart
	local hum:Humanoid = character.Humanoid
	local dashInfo = t.AbilityData["God's Dash"];
	local animations = t.AbilityAnims["God's Dash"];

	local vfx = hrp.GodDashFX;

	local sfx = Instance.new("Sound")
	sfx.Parent = hrp;
	sfx.TimePosition = 0.4;
	sfx.SoundId = workspace:GetAttribute("robloxstr") .. Settings[self].Sound;
	sfx.Volume = 1;
	sfx.PlayOnRemove = false;
	sfx:Play();--sfx:Destroy();


	for i,v:ParticleEmitter in pairs(vfx:GetDescendants()) do --> Emit VFX
		if v:IsA("ParticleEmitter") then
			v:Emit(2)
			task.spawn(function()
				for i = 80,100 do
					task.wait()
					v.Transparency = NumberSequence.new(i / 100);
				end
			end)
		end
	end	for i,v:ParticleEmitter in pairs(hrp.HealFX:GetDescendants()) do --> Emit VFX
		if v:IsA("ParticleEmitter") then
			v:Emit(v:GetAttribute("EmitCount"))
		end
	end
	hum.Health += 10;
	local ao:AlignOrientation = hrp.AlignOrientation
	ao.CFrame = CFrame.Angles(hrp.CFrame:ToOrientation());

	task.wait();


	if not dashInfo.AnimationState then
		dashInfo.AnimationState = 1
	elseif (dashInfo.AnimationState > #Settings[self].Animations) then
		dashInfo.AnimationState = 1;
	end	


	ao.Enabled = true;


	local track:AnimationTrack = animations[dashInfo.AnimationState];
	if track then
		track:Play();
	else
		warn("Animation track not found")
		return;
	end

	dashInfo.AnimationState += 1;

	local lookvector = hrp.CFrame.LookVector;
	local pos = hrp.Position + (hrp.CFrame.LookVector * Settings[self].MoveStuds);
	local to = script.DashTo:Clone();
	to.Position = pos + Vector3.new(0,1,0);
	to.Responsiveness = Settings[self].MoveSpeed;

	local dir = script.DashDirection:Clone();
	dir.LineDirection = Vector3.new(
		lookvector.Z,
		0,
		-lookvector.X
	)

	local End = Instance.new("Part");
	End.Anchored = true;
	End.CanCollide = false;
	End.Transparency = 1;
	End.Size = Vector3.one * 0.1;
	End.Position = pos;
	End.Parent = workspace;


	local Destroy = function()
		to:Destroy();
		t.HitboxConnection:Disconnect();
		t.HitBoxConnection = nil;
		End:Destroy();
		task.wait()
		dir:Destroy();

		ao.Enabled = false;


	end

	t.HitboxConnection = End.Touched:Connect(function(part)
		local pler = game.Players:GetPlayerFromCharacter(part.Parent);
		if pler then
			if pler.Name == plr.Name then
				Destroy();
			end
		end
	end)

	task.delay(0.4,function()
		Destroy();
		for i,v:ParticleEmitter in pairs(vfx:GetDescendants()) do
			if v:IsA("ParticleEmitter") then
				task.wait(1);
				v.Transparency = NumberSequence.new(0.8)
				sfx:Destroy();
			end
		end
	end)

	to.Parent = hrp;
	to.Attachment0 = hrp.RootAttachment
end


return main;