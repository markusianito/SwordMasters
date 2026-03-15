
-->> Laser beam.lua - Server
--> Main program for Laserbeam ability in Sword Masters.
--> OSI-2 formatting
--> Scripted by Marcos

local self = "Laser beam"
local lib = require(script.Parent:WaitForChild("Lib"))
local Settings = require(game:GetService("ReplicatedStorage").Client_Modules.ReplicatedSettings).Abilities;
local Baller = game:GetService("CollectionService");
local runSvc = game:GetService("RunService");
local tws = game:GetService("TweenService");
local wait = task.wait;

local unlockable = false;


local Tag = "DeadByLaser";



local function Cleanup(plr:Player, playerData, sl)
	return function()
		local info;
		local suck, err = pcall(function()
			info = playerData[plr.Name].AbilityData[self];
		end)
		if not suck then
			warn(err);
			return nil;
		end

		lib:MemoryBan(info);
		sl:FireClient(plr, false, false);
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



function main.Load(plr:Player, playerData:{tables}, Loaded:RemoteEvent,_, cback:RemoteFunction, kill:BindableEvent, sl:RemoteEvent)
	--stamed:FireClient(plr, false);

	--> Load
	local ded = false;
	local t = playerData[plr.Name];
	if not t then warn("Player is not registered") return; end

	local character:Model = plr.Character;
	if character:GetAttribute("Busy") then return nil; end;
	character:SetAttribute("Busy", true);
	character:SetAttribute("MoreSpeed", 0.25)

	local rightarm:Part = character["Right Arm"];
	local hum:Humanoid = character.Humanoid
	local hrp = character.HumanoidRootPart;
	hum.WalkSpeed = 16;
	local slow = hum.WalkSpeed;


	local sword = Instance.new("WeldConstraint");
	sword.Part0 = rightarm;
	sword.Part1 = character:FindFirstChildOfClass("Tool").Handle;
	sword.Parent = rightarm;

	local sword:Tool = character:FindFirstChildOfClass("Tool");
	local chest:Part = script.chest:Clone();
	local laser:Part = script.In:Clone();


	local cleanF = hum.Died:Once(function()
		ded = true;
		main.Cleanup(plr, playerData, sl)();
	end)

	local Info = t.AbilityData["Laser beam"];
	local anims = t.AbilityAnims["Laser beam"];

	local takeout:AnimationTrack		=	anims[1]
	local activation:AnimationTrack		=	anims[2]
	local idle:AnimationTrack			=	anims[3]
	local jump:AnimationTrack			=	anims[4]
	local walk:AnimationTrack			=	anims[5]
	local ending:AnimationTrack			=	anims[6]

	local t = character.Animate
	local anims = {t.walk.WalkAnim.AnimationId,t.run.RunAnim.AnimationId,
		t.idle.Animation1.AnimationId, t.jump.JumpAnim.AnimationId
	}
	t.walk.WalkAnim.AnimationId = walk.Animation.AnimationId
	t.run.RunAnim.AnimationId = walk.Animation.AnimationId
	t.idle.Animation1.AnimationId = idle.Animation.AnimationId;
	t.idle.Animation2.AnimationId = idle.Animation.AnimationId;
	t.jump.JumpAnim.AnimationId = jump.Animation.AnimationId;
	--> OnLoad
	for _,v in pairs(hum.Animator:GetPlayingAnimationTracks()) do
		v:Stop();
	end

	takeout:Play();

	for i = 95,0,-5 do
		if ded then return true; end
		runSvc.Heartbeat:Wait();
		i += 0.01
		sword:ScaleTo(i/100);
	end

	local phase1 = false;


	while not phase1 do --> takeout:GetMarkerReachedSignal("LaserSwitch")
		if ded then return true; end
		runSvc.Heartbeat:Wait();
		if takeout.TimePosition >= 0.95 then break; end
	end

	chest.Parent = rightarm;
	chest.CFrame = rightarm.CFrame:ToWorldSpace(CFrame.new(-0.666,-0.5,0)):ToWorldSpace(CFrame.Angles(0,-math.pi/2,math.pi/2))
	chest.Weld.Part1 = rightarm;


	while not phase1 do --> takeout:GetMarkerReachedSignal("LaserInTorso")
		if ded then return true; end
		runSvc.Heartbeat:Wait();
		if takeout.TimePosition >= 1.95 then break; end
	end

	chest.Weld.Part1 = nil--character.Torso
	chest.CFrame = character.Torso.CFrame:ToWorldSpace(CFrame.new(0,0.25,-0.666666666)):ToWorldSpace(CFrame.Angles(0,0,0));
	chest.Weld.Part1 = character.Torso
	phase1 = true;

	repeat runSvc.Heartbeat:Wait(); until phase1;
	phase1=nil; 

	local getch, data, err = cback:InvokeClient(plr, "Laser beam", "getch"); -- Getch yields this function until the player clicks or something
	if not getch then error(err) end

	activation:Play();
	hrp.LaserActivation:Play();
	if ded then return true; end

	--idle:Play();


	--local av = Instance.new("AngularVelocity");
	--av.Attachment0 = hrp.RootAttachment;
	--av.MaxTorque = 9999;
	--av.Parent = hrp;

	sl:FireClient(plr, true, true);


	local INSTANCE
	local jp = hum.JumpPower;
	do --> OnActivate
		hum.WalkSpeed = 4
		--
		INSTANCE = Instance.new("Part")
		local A1 = Instance.new("Weld")
		A1.Parent = INSTANCE
		A1.Part0 = character:WaitForChild("HumanoidRootPart")
		A1.Part1 = INSTANCE
		INSTANCE.CanCollide = false
		INSTANCE.Transparency = 1
		INSTANCE.Anchored = false
		INSTANCE.Size = Vector3.new(20, 20, 20)
		INSTANCE.CanTouch = false
		INSTANCE.CanQuery = false
		INSTANCE.CFrame = character:WaitForChild("HumanoidRootPart").CFrame

		INSTANCE.Parent = character
	end
	Info.Limiter = INSTANCE;


	activation.Ended:Wait(); --> LaserInit

	hrp.LaserActivation:Stop();
	hrp.LaserBeaming:Play();
	
	
	chest.p.Transparency = 0;


	laser.Parent = character;
	laser.CFrame = chest.CFrame;
	laser.Weld.Part0 = chest;
	
	
	Info.JumpConnection = hum.Jumping:Connect(function(active)
		if active then
			hum.JumpPower = 0;
			task.delay(3, function()
				hum.JumpPower = jp;
			end)
		end
	end)


	local Time = 0;
	local completed = false;

	local firstTime = true

	Info.LaserMain = runSvc.Heartbeat:Connect(function(dT)
		Time += dT;

		local ray = workspace:Blockcast(
			chest.CFrame,Vector3.one,
			(chest.CFrame.LookVector * Settings[self].MaxDistance),
			lib.TheParams2
		)
		ray = ray and ray.Distance or Settings[self].MaxDistance;
		laser.Out.Position = (laser.CFrame:ToWorldSpace(CFrame.new(0,0,-ray))).Position;

		local parts = workspace:GetPartBoundsInBox(
			laser.CFrame:Lerp(laser.Out.CFrame,0.5),
			Vector3.new(1,1,(laser.Position - laser.Out.Position).Magnitude),
			lib.TheParams
		)

		for _,v:BasePart in pairs(parts) do
			local char:Model = v:FindFirstAncestorOfClass("Model");
			if char then
				if (char ~= character)then
					local hum:Humanoid = char:FindFirstChildOfClass("Humanoid");
					if hum then
						if lib.knit.GetService("RoundService"):CheckMode() == "PVP" then
							task.wait(0.1);
							hum:TakeDamage(Settings[self].Damage * character:GetAttribute("MoreDamage"));
							task.wait(0.1);
							if (hum.Health == 0) and (not Baller:HasTag(char, Tag)) then
								Baller:AddTag(char, Tag)
								kill:Fire(plr.Name,char);
							end
						else
							if not game.Players:GetPlayerFromCharacter(char) then
								task.wait(0.1);
								hum:TakeDamage(Settings[self].Damage * character:GetAttribute("MoreDamage"));
								task.wait(0.1);
								if (hum.Health == 0) and (not Baller:HasTag(char, Tag)) then
									Baller:AddTag(char, Tag)
									kill:Fire(plr.Name,char);
								end
							end
						end

					end
				end
			end
		end


		if Time >= Settings[self].Duration then
			if Info.LaserMain then
				Info.LaserMain:Disconnect();
			end
			Info.LaserMain = nil
			completed = true;
		end
	end)

	while not completed do 
		if ded then return true; end wait(); end

	tws:Create(laser.Out,lib.twi,{
		Position = laser.Position
	}):

	Play()
	wait(1)

	laser:Destroy();
	idle:Stop();
	
	hrp.LaserBeaming:Stop();

	sl:FireClient(plr, false, false);

	if INSTANCE then
		INSTANCE:Destroy();
	end
	if Info.WalkConnection then
		Info.WalkConnection:Disconnect();
	end
	Info.WalkConnection = nil;
	if Info.JumpConnection then
		Info.JumpConnection:Disconnect();
	end
	Info.JumpConnection = nil;
	walk:Stop();
	
	hum.WalkSpeed = slow;
	hum.JumpPower = jp;

	wait(); --> Finished
	chest.p.Transparency = 1;

	ending:Play();
	while true do --> ending:GetMarkerReachedSignal("LaserRips"):Wait();
		if ded then return true; end
		runSvc.Heartbeat:Wait();
		if ending.TimePosition >= 2.111 then break; end
	end

	chest.Weld.Part1 = nil;
	chest.CFrame = rightarm.CFrame:ToWorldSpace(CFrame.new(-0.666,-0.5,0)):ToWorldSpace(CFrame.Angles(0,-math.pi/2,math.pi/2))
	chest.Weld.Part1 = rightarm;

	while true do --> ending:GetMarkerReachedSignal("SwordbackLaser"):Wait();
		runSvc.Heartbeat:Wait();
		if ending.TimePosition >= 3.666 then break; end
	end

	chest:Destroy();
	for i = 5,100,5 do
		runSvc.Heartbeat:Wait();
		sword:ScaleTo(i/100);
	end


	t.walk.WalkAnim.AnimationId		=	anims[1];
	t.run.RunAnim.AnimationId		=	anims[2];
	t.idle.Animation1.AnimationId	=	anims[3];
	t.idle.Animation2.AnimationId	=	anims[3];
	t.jump.JumpAnim.AnimationId		=	anims[4];
	
	table.clear(anims)
	anims = nil;
	
	--stamed:FireClient(plr, true);
	if cleanF then
		cleanF:Disconnect();
	end
	cleanF = nil;
	main.Cleanup(plr, playerData, sl)();

	character:SetAttribute("MoreSpeed", 1)
	return not character:SetAttribute("Busy", false);
end



function main.Use(plr:Player, playerData:{tables})
	plr.Character:SetAttribute("MoreSpeed", 1)
	plr.Character:SetAttribute("Busy", false);
	return true;
end


return main;