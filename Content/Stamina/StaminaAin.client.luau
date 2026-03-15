--disable
-->> Main.lua - Client
--> Main stamine thing 
script.Parent.StaminaMain.Enabled = false;
--> Preload
local ANIM = workspace:GetAttribute("robloxstr") .. 17793881173;
local KAY = Enum.KeyCode.LeftControl;
local KAY2 = Enum.KeyCode.LeftShift;
local MAX = 100; --> max
local SPS = 20; --> Stamina per second

local plr = game.Players.LocalPlayer;
local caSvc = game:GetService("ContextActionService");
local uiSvc = game:GetService("UserInputService");
local runSvc = game:GetService("RunService");
local tws = game:GetService("TweenService")
local twi1 = TweenInfo.new(3,Enum.EasingStyle.Sine,Enum.EasingDirection.Out, 0, false, 0);
local twi2 = TweenInfo.new(0.2,Enum.EasingStyle.Sine,Enum.EasingDirection.Out, 0, false, 0);

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
	task.spawn(function()
		hum.Jumping:Wait();
		anima:Stop();
	end)
end
function anim:Stop()
	anima:Stop()
end


animate();
task.spawn(function()
	while task.wait(1) do
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

local peg = false;
local sethc = game.ReplicatedStorage.Sethc;
local getch, setch = function(D)
	--if not char:GetAttribute("Busy") then
	hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1);
	--end
	if not corutina then
		corutina = coroutine.create(function()
			task.wait(3);
			recarga = true;
		end)
		coroutine.resume(corutina);
	end
	if creatina then
		coroutine.close(creatina);
		creatina = nil;
	end
	if recarga then
		energy = math.clamp(energy + (SPS * D), 0, 100)
	end

	if energy >= 96 then
		procutina = coroutine.create(function()
			task.wait(3);
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
			sethc:FireServer("sprintout")
			hum.WalkSpeed=0;
			task.wait()
			hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
			--disconnect();
		end
	end


	if (energy > 1) and (not char:GetAttribute("Busy")) then
		hum.WalkSpeed = SPRINT_SPEED * (char:GetAttribute("MoreSpeed") or 1)
	else
		if not char:GetAttribute("Busy") then
			hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
		end
		animing = false;
		repeat task.wait() until hum.FloorMaterial ~= Enum.Material.Air;
		anim:Stop();
		if not peg then
			sethc:FireServer("sprintout")
			peg = true;
			hum.WalkSpeed=0;
			task.wait()
			hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
		end
		--disconnect();
	end
	if energy > 15 then
		--peg = false;
	end

	if (hum.MoveDirection.Magnitude > 0) and (not hrp.Anchored) and (hum.WalkSpeed ~= 0) and (not char:GetAttribute("Busy")) and (char:GetAttribute("DamageMultiplier"))then
		energy = math.clamp(energy - (SPS * D), 0, 100) end

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
local main = true
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
				--anim:Stop();
				hum.WalkSpeed = ORIGINAL_SPEED * (char:GetAttribute("MoreSpeed") or 1)
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