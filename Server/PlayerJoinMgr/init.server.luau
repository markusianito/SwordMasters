--disable
--!nonstrict
-->> PlayerJoinMgr.lua - Server
--> General stuff to do when a player joins

--/<MemorySave>


local Players = game.Players; 
local add = function(char)
	if char.Name == "Mountain Guardian" then return; end
	local hrp = char:WaitForChild("Left Leg")
	local Weld = Instance.new("WeldConstraint");
	Weld.Name = "StompVFXWeld";
	Weld.Parent = char:WaitForChild("Left Leg");
	Weld.Part0 = hrp;


	local VFX = script.Abilities.Stomp.VFX:Clone();
	VFX.Name = "StompFX"
	VFX.Parent = hrp;
	Weld.Part1 = VFX;
	VFX.Position = hrp.Position
	--asdasdasdasdasdasdasdasdasdasd
	

	local RootAtt = Instance.new("Attachment");
	RootAtt.Name = "LeftGripAttachment"
	RootAtt.Parent = char["Left Arm"];
	RootAtt.Position = Vector3.new(0,-1,0);

	local hrp:Part = char:WaitForChild("HumanoidRootPart");
	local RootAtt = Instance.new("Attachment");
	RootAtt.Name = "RootAttachment"
	RootAtt.Parent = hrp

	local Weld = Instance.new("WeldConstraint");
	Weld.Name = "HealVFXWeld";
	Weld.Parent = hrp;
	Weld.Part0 = hrp;

	local VFX = script.Abilities.Burger.VFX:Clone();
	VFX.Name = "HealFX"
	VFX.Parent = hrp;
	VFX.CFrame = hrp.CFrame - Vector3.new(0,3,0);
	Weld.Part1 = VFX;

	local Weld = Instance.new("WeldConstraint");
	Weld.Name = "DashVFXWeld";
	Weld.Parent = hrp;
	Weld.Part0 = hrp;

	local VFX = script.Abilities.Dash.VFX:Clone();
	VFX.Name = "DashFX"
	VFX.Transparency = 1;
	VFX.CanCollide = false;
	VFX.Parent = hrp;
	VFX.CFrame = hrp.CFrame * CFrame.Angles(0,math.pi,0);
	Weld.Part1 = VFX;

	local Weld = Instance.new("WeldConstraint");
	Weld.Name = "GodDashVFXWeld";
	Weld.Parent = hrp;
	Weld.Part0 = hrp;

	local VFX = script.Abilities["God's Dash"].VFX:Clone();
	VFX.Name = "GodDashFX"
	VFX.Transparency = 1;
	VFX.CanCollide = false;
	VFX.Parent = hrp;
	VFX.CFrame = hrp.CFrame * CFrame.Angles(0,math.pi,0);
	Weld.Part1 = VFX;

	local ao = script.Abilities.Dash.AlignOrientation:Clone();
	ao.Attachment0 = RootAtt;
	ao.Parent = hrp;







	local Weld = Instance.new("WeldConstraint");
	Weld.Name = "SuperjumpVFXWeld";
	Weld.Parent = hrp;
	Weld.Part0 = hrp;

	local VFX = script.Abilities.Superjump.VFX:Clone();
	VFX.Name = "SuperjumpFX"
	VFX.Transparency = 1;
	VFX.CanCollide = false;
	VFX.Parent = hrp;
	VFX.CFrame = hrp.CFrame - Vector3.new(0,2.5,0);
	Weld.Part1 = VFX;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 18566623260;
	SFX.Name = "ChargeSuperjump"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 18566629359;
	SFX.Name = "JumpSuperjump"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 101059086454870;
	SFX.Name = "StompSound"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 116576165344096;
	SFX.Name = "BurgerSound"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 114100253043046;
	SFX.Name = "HealSFX"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 106466373500925;
	SFX.Name = "FireballSound"
	SFX.Volume = 0.3;
	SFX.Looped = true;
	SFX.Parent = hrp;


	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 105432434737045;
	SFX.Name = "FireballThrow"
	SFX.Parent = hrp;

	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 91775141437300           ;
	SFX.Name = "LaserActivation"
	SFX.PlaybackSpeed = 1.5
	SFX.Parent = hrp;
	
	local SFX = Instance.new("Sound");
	SFX.SoundId = workspace:GetAttribute("robloxstr") .. 77881946445703           ;
	SFX.Name = "LaserBeaming"
	SFX.Volume = 0.7;
	SFX.Looped = true;
	SFX.Parent = hrp;



	local ao = script.Abilities.Superjump.Anchor:Clone();
	ao.Attachment0 = RootAtt;
	ao.Parent = hrp;
end

Players.PlayerAdded:Connect(function(plr)
	
	plr.CharacterAdded:Connect(function(char)
		add(char);
	end)
end)

workspace.ChildAdded:Connect(function(child)
	task.wait()
	if child then
		if child:FindFirstChild("Humanoid") then
			add(child);
		end
	end
end)

local setch = game.ReplicatedStorage.Sethc
   
local ANIM = workspace:GetAttribute("robloxstr") .. 17793881173;
local JUMP = workspace:GetAttribute("robloxstr") .. 11244070986;

local sup = {};

setch.OnServerEvent:Connect(function(plr, key)
	plr = plr.Character;
	local hum:Humanoid = plr.Humanoid
	local t = plr.Animate
	if key=="sprintin" then
		local a:Animator = plr.Humanoid:WaitForChild("Animator");
		sup[plr.Name] = {
			t.walk.WalkAnim.AnimationId;
			t.run.RunAnim.AnimationId;
			t.jump.JumpAnim.AnimationId
		}

		t.walk.WalkAnim.AnimationId = ANIM
		t.run.RunAnim.AnimationId = ANIM

		hum:ChangeState(Enum.HumanoidStateType.Landed)
		
	end
	if key=="sprintout" then
		if sup[plr.Name] then
			
			t.jump.JumpAnim.AnimationId = sup[plr.Name][3]
			t.walk.WalkAnim.AnimationId = sup[plr.Name][1]
			t.run.RunAnim.AnimationId = sup[plr.Name][2]

			hum:ChangeState(Enum.HumanoidStateType.Landed)
			
			sup[plr.Name] = nil;
		end
	end
end)

game.Players.PlayerAdded:Connect(function(plr)
	plr.CharacterAdded:Connect(function(character)
		if sup[plr.Name] then
			sup[plr.Name] = nil
		end
	end)
end)