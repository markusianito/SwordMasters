-->> HealthMain.lua - Client
--> bro makes the healtbar works like a slave.

--> Preload

local HEART={
	[1] = 18167338973;
	[2] = 18167342922;
	[3] = 18167348064;
	[4] = 18167353642;
	[5] = 18167357841;
	[6] = 18167363852
}
for i,v in pairs(HEART) do
	HEART[i] = workspace:GetAttribute("robloxstr") .. v;
end


local DARKRED = Color3.fromRGB(100, 35, 36);
local RED = Color3.fromRGB(255, 90, 93);
local ORANGE = Color3.fromRGB(255, 148, 71);
local YELLOW = Color3.fromRGB(255, 235, 85);
local GREEN; 

local runSvc = game:GetService("RunService");
local plr = game.Players.LocalPlayer;
local char = plr.Character or plr.CharacterAdded:Wait();
local hum:Humanoid = char:WaitForChild("Humanoid")

--> Load
local gui = script.Parent.Main;
local bar = gui:WaitForChild("Bar");
local GUEPUTA = gui:WaitForChild("HP")
local bot = gui:WaitForChild("ImageButton");
GUEPUTA.Text = hum.Health .." HP";


GREEN = bar.BackgroundColor3;

local doHeart= function(num)
	bot.Image = HEART[math.clamp(num,1,6)];
end

--> OnLoad
--runSvc.Heartbeat:Connect(function()
executing = false;
local function Update(_,forced)
	repeat task.wait() until not executing;
	game:GetService("ContentProvider"):PreloadAsync(HEART);
	executing = true;
	task.wait()
	local health, maxhealth = math.clamp(hum.Health,0,hum.MaxHealth), hum.MaxHealth;
	local factor = math.clamp(health / maxhealth,0,1);
	--print(factor);

	local n = tonumber(GUEPUTA.Text:sub(1,3)) or tonumber(GUEPUTA.Text:sub(1,2));

	local diff = n - health;
	local increased = diff < 0;

	local barSize = UDim2.new(factor, 0, 1, 0);
	if not forced then
		bar:TweenSize(barSize,Enum.EasingDirection.Out,Enum.EasingStyle.Sine,0.03 * factor, true);
	else
		bar.Size = barSize
	end
	if (factor <= 1) and (factor >= 0.75) then
		bar.BackgroundColor3 = GREEN--:Lerp(YELLOW, (1-factor)/0.25)
		doHeart(1)

	elseif (factor < 0.75) and (factor >= 0.50) then
		bar.BackgroundColor3 = YELLOW--:Lerp(ORANGE, (1-factor)/0.5)
		doHeart(2)

	elseif (factor < 0.50) and (factor >= 0.25) then
		bar.BackgroundColor3 = ORANGE--:Lerp(RED, (1-factor)/0.75)
		doHeart(3)

	elseif (factor < 0.25) and (factor >= 0.10) then
		bar.BackgroundColor3 = RED--:Lerp(DARKRED, (1-factor)/1)
		doHeart(4)

	elseif (factor < 0.10) and (factor >= 0) then
		bar.BackgroundColor3 = DARKRED--:Lerp(Color3.new(0,0,0), (1-factor)/1)
		if factor == 0 then
			doHeart(6)
		else
			doHeart(5);
		end
	end	
	
	if forced then
		GUEPUTA.Text = tostring(health) .. " HP"
		
	else
		
		for i = 1, math.abs(diff) do
			GUEPUTA.Text = tostring(increased and (n + i) or (n - i )) .. " HP"
			if i%2 == 0 then
				task.wait()
			end
		end
		
	end
	executing = false;
end

local actual;
actual = hum.HealthChanged:Connect(Update)
task.wait()

while task.wait(0.25) do
	local cam = workspace.CurrentCamera;
	if cam then
		if cam.CameraSubject then
			if cam.CameraSubject:IsA("Humanoid") then
				if cam.CameraSubject ~= hum then
					hum = cam.CameraSubject;
					actual:Disconnect();
					actual = nil;
					actual = hum.HealthChanged:Connect(Update);
					Update(nil, true);
				end
			end
		end
	end
end