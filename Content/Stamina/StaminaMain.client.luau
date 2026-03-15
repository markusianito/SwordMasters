--disable
-->> Main.lua - Client
--> Main stamine thing 

--> Preload
local JUMP = workspace:GetAttribute("robloxstr") .. 11244070986;
local ANIM = workspace:GetAttribute("robloxstr") .. 17793881173;
local KAY = Enum.KeyCode.LeftControl;
local KAY2 = Enum.KeyCode.LeftShift;
local MAX = 100; --> max
local SPS_Consume = 17; --> Stamina per second
local SPS_Regen = 65; --> Stamina per second

local plr = game.Players.LocalPlayer;
local caSvc = game:GetService("ContextActionService");
local uiSvc = game:GetService("UserInputService");
local runSvc = game:GetService("RunService");
local tws = game:GetService("TweenService")
local twi1 = TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out, 0, false, 0);
local twi2 = TweenInfo.new(0.1,Enum.EasingStyle.Sine,Enum.EasingDirection.Out, 0, false, 0);

--> Load
local char = plr.Character or plr.CharacterAdded:Wait();
local hum:Humanoid = char:WaitForChild("Humanoid");
local hrp:Part = char:WaitForChild("HumanoidRootPart");
local ain = script.Parent:WaitForChild("Main")
local bar = ain:WaitForChild("Bar");
local bot = script.Parent:WaitForChild("MobileshiftButton");

local strokeT, barT, imgT, txtT = ain:WaitForChild("UIStroke").Transparency, bar.Transparency, ain:WaitForChild("ImageButton").ImageTransparency, ain:WaitForChild("TextLabel").TextTransparency
local tweens:{Tween} = {
	[1] = tws:Create(ain.UIStroke, twi1, {Transparency = 1});
	[2] = tws:Create(ain.UIStroke, twi2, {Transparency = strokeT});

	[3] = tws:Create(bar, twi1, {BackgroundTransparency = 1});
	[4] = tws:Create(bar, twi2, {BackgroundTransparency = barT});

	[5] = tws:Create(ain.ImageButton, twi1, {ImageTransparency = 1});
	[6] = tws:Create(ain.ImageButton, twi2, {ImageTransparency = imgT});

	[7] = tws:Create(ain.TextLabel, twi1, {TextTransparency = 1});
	[8] = tws:Create(ain.TextLabel, twi2, {TextTransparency = txtT})
}

for i,v in pairs(tweens) do
	if i%2 == 1 then
		v:Play();
	end
end

local anima2:AnimationTrack
hum:WaitForChild("Animator")
anima2 = hum.Animator:FindFirstChild("SprintJump") or Instance.new("Animation");
anima2.AnimationId = JUMP;
anima2.Name = "SprintJump";
anima2.Parent = hum:WaitForChild("Animator");

anima2 = hum.Animator:LoadAnimation(anima2);
anima2.Priority = Enum.AnimationPriority.Action;

local anima:AnimationTrack
animate = function()
	hum:WaitForChild("Animator")
	anima = hum.Animator:FindFirstChild("Sprint") or Instance.new("Animation");
	anima.AnimationId = ANIM;
	anima.Name = "Sprint";
	anima.Parent = hum:WaitForChild("Animator");

	anima = hum.Animator:LoadAnimation(anima);
	anima.Priority = Enum.AnimationPriority.Idle
	anima.Looped = true;

end

local anim = {}

function anim:Play()
	anima:Play();

	hum:ChangeState(Enum.HumanoidStateType.Landed)
	task.spawn(function()
		hum.Jumping:Wait();
		anima:Stop();
	end)
end
local sethc = game.ReplicatedStorage.Sethc;
function anim:Stop()
	anima:Stop()
	sethc:FireServer("sprintout")
	
	task.wait(0.1)
	hum:ChangeState(Enum.HumanoidStateType.Landed)
end


animate();
task.spawn(function()
	while task.wait(3) do
		if char then
			if not char:WaitForChild("Humanoid"):WaitForChild("Animator"):FindFirstChild("Sprint") then
				animate();
			end
		end
	end
end)

local ORIGINAL_SPEED = hum.WalkSpeed
local SPRINT_SPEED = hum.WalkSpeed * 2.5;


local energy = 100;

local recarga = false;
local corutina;
local procutina;
local creatina;
local animing = false;


local function DoTweening(active)
	for i,v in ipairs(tweens) do
		if active and (i%2==0) then
			v:Play();
		elseif (not active) and (i%2~=0) then
			v:Play();
		end
	end
end
task.wait(3);
--if not hum.Parent:GetAttribute("DamageMultiplier") then script.Parent.StaminaAin.Enabled = true; end

local main = true
local ayin = false;
local once = false;
local getch, setch = function(D)
	--if not char:GetAttribute("Busy") then
	hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1);
	--end
	if not once then
once = true
		--hum.WalkSpeed = 0;
		--task.wait(0.1);
		--hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
		sethc:FireServer("sprintout")
	end
	
	if not corutina then
		corutina = coroutine.create(function()
			task.wait(0.5);
			recarga = true;
		end)
		coroutine.resume(corutina);
	end
	if creatina then
		coroutine.close(creatina);
		creatina = nil;
	end
	if recarga then
		energy = math.clamp(energy + (SPS_Regen * D), 0, 100)
	end

	if energy >= 96 then
		procutina = coroutine.create(function()
			task.wait(1);
			DoTweening(false);
		end)
		coroutine.resume(procutina);
	end

	if animing then
		animing = false;
		anim:Stop();
		--disconnect();
	end

end,function(D)
	if once then
		once = false;
	end
	if corutina then
		coroutine.close(corutina);
		corutina = nil;
		recarga = false;
	end
	if procutina then
		coroutine.close(procutina);
		procutina = nil;
	end

	creatina = coroutine.create(function()
		DoTweening(true);
	end)
	coroutine.resume(creatina);


	if (hum.MoveDirection.Magnitude > 0) and (not hrp.Anchored) and (hum.WalkSpeed ~= 0) and (not char:GetAttribute("Busy"))then
		if not animing then
			animing = true;
			anim:Play();
			--connect();
		end
	else
		if animing then
			animing = false;
			anim:Stop();
			--disconnect();
		end
	end


	if (energy > 10) and (not char:GetAttribute("Busy")) then
		hum.WalkSpeed = SPRINT_SPEED * (char:GetAttribute("MoreSpeed") or 1)
		ayin = false;
	else
		if not char:GetAttribute("Busy") then
			hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
		end
		anim:Stop();
		if not ayin then
			ayin = true;
			--hum.WalkSpeed = 0;
			--task.wait(0.1);
			---hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
			sethc:FireServer("sprintout")
		end
		animing = false;
		main = false;
		--disconnect();
	end

	if (hum.MoveDirection.Magnitude > 0) and (not hrp.Anchored) and (hum.WalkSpeed ~= 0) and (not char:GetAttribute("Busy")) and (char:GetAttribute("DamageMultiplier"))then
		energy = math.clamp(energy - (SPS_Consume * D), 0, 100) end

end


bot.Visible = require(game.ReplicatedStorage.Client_Modules.Libraries.StatesOfDevice).isMobile

local shiftin = false;

bot.MouseButton1Down:Connect(function()
	shiftin = not shiftin
	if shiftin then
		bot.ImageTransparency = 0.4
	else
		bot.ImageTransparency = 0
	end
end)

--> OnLoad
local ain = false;
local ayn = false;
task.spawn(function()
	while true do --> Heartbeat is not a good idea bc if player has more FPS, stamina may bug.
		if main then
			if not ain then
				ain = true;
			end
			if (uiSvc:IsKeyDown(KAY) or uiSvc:IsKeyDown(KAY2) or shiftin) and (not char:GetAttribute("Busy")) and (not uiSvc:IsKeyDown(Enum.KeyCode.E)) then
				setch(task.wait(0.03));
				if not ayn then
					ayn = true;
					--anim:Play();
					sethc:FireServer("sprintin")
				end
			else
				task.wait(0.1);
				getch(task.wait(0.03));
				if ayn then
					ayn = false;
					--anim:Stop();
					sethc:FireServer("sprintout")
				end
			end
			bar.Size = UDim2.new(energy / 100,0,1,0)
		else
			if ain then
				ain = false;
				anim:Stop();
				sethc:FireServer("sprintout")
				--hum.WalkSpeed = 0;
				--task.wait();
				--hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
				task.delay(3, function()
					main = true;
				end)
			end
			task.wait();
		end
	end
end)


--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
-->> ED.lua - Client
--> Enable/Disable manager, no interface version (Events)
--> by Marcos

local event = game.ReplicatedStorage.RemoteEvents.StaminaED;
local localEvent = game.ReplicatedStorage.ClientEvents.StaminaED;


--local override = false;


local function ed(enabled)
	main = enabled
end

event.OnClientEvent:Connect(function(enabled)
	--print("called", enabled)
	--override = enabled;
	ed(enabled);
end)


localEvent.Event:Connect(function(enabled)
	--print("self called", enabled, override)
	--if not override then
	--print("done selfcall with prebius enabled")
	ed(enabled);
	--end
end);

--game.ContextActionService:BindAction("Sprint", function() end, true)