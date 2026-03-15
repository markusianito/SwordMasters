--disable
-->> LevelMain.lua - Client
--> Level main

local stackhost = require(game.ReplicatedStorage.Client_Modules.HostStack);
local plr, plrs = game.Players.LocalPlayer, game:GetService("Players");
local settings = require(game.ReplicatedStorage.Client_Modules.LevelSettings);
local comms = game.ReplicatedStorage.RemoteEvents.LevelEvents;
local ask = comms.AskData;
local onadd = comms.OnAddXP;

plr:WaitForChild("PlayerGui")

local twi = TweenInfo.new(0.333, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false);
local tws = game:GetService("TweenService");
local frm = script.Parent:WaitForChild("MainFrame");
local name,image = frm:WaitForChild("Playername"), frm:WaitForChild("PlayerIcon");
local image, sword = image:WaitForChild("PlayerImage"), image:WaitForChild("Sword decoration");


local barFrame = frm:WaitForChild("LevelUpBar")
local bar, xp, lvl = barFrame:WaitForChild("Bar"), barFrame:WaitForChild("AmountXP"), barFrame:WaitForChild("Level");


local stats = plr:WaitForChild("PlayerStats");
local lvlVal:IntValue, xpVal:IntValue, goalXPVal:IntValue = stats:WaitForChild("Level"), stats:WaitForChild("XP"), stats:WaitForChild("GoalXP")


local black, lup = script.Parent:WaitForChild("Frame"), script.Parent:WaitForChild("LeveUpImage");
local total = barFrame:WaitForChild("XPEarnedTotal");


--> OnLoad

local tt = Enum.ThumbnailType
local possibilities = {
	tt.AvatarBust;
	tt.HeadShot
}


image.Image = plrs:GetUserThumbnailAsync(plr.UserId,Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100);
name.Text = plr.DisplayName;

local earnedVal = Instance.new("IntValue");
earnedVal.Name = "EarnedXP";
earnedVal.Parent = stats;

stackhost:LookForValue(earnedVal, total, UDim2.new(1.2,0,1,0))

onadd.OnClientEvent:Connect(function(x)
	earnedVal.Value += x;
end)


local swoos = function(index)
	local str = workspace:GetAttribute("robloxstr")
	image.Parent["Sword decoration"].Image = str .. settings.Costumes.Decorations[index]
	image.Parent["Sword decoration2"].Image = str .. settings.Costumes.Decorations[index]
end


local tveens = {
	tws:Create(black, twi, {BackgroundTransparency = 0.4});
	tws:Create(black, twi, {BackgroundTransparency = 1});
	tws:Create(lup, twi, {ImageTransparency = 0});
	tws:Create(lup, twi, {ImageTransparency = 1})
}


local loaded = false;

lvlVal.Changed:Connect(function(val)
	for i = 0,20 do
		lvl.TextTransparency = i/20
		task.wait();
	end


	if val >= settings.General.MaxLevel then
		lvl.Text = lvl:GetAttribute("txt"):format(tostring(settings.General.MaxLevel));
			bar.Size = UDim2.new(1,0,1,0);

			xp.Text = lvl:GetAttribute("MaxText");
			xp.TextColor3 = settings.Costumes.Max.TextColor3;
			xp.UIStroke.Color = settings.Costumes.Max.TextStrokeColor3;
	else

		lvl.Text = lvl:GetAttribute("txt"):format(tostring(val));

	end

	for i = 20,0,-1 do
		lvl.TextTransparency = i/20
		task.wait();
	end


	if (val < 25) and (val >= 0) then
		swoos(1)
	elseif (val < 50) and (val >= 25) then
		swoos(2)
	elseif (val < 100) and (val >= 50) then
		swoos(3)
	else
		swoos(4)
	end


	if not loaded then loaded = true; return; end
	if val >= settings.General.MaxLevel then return; end
	
	task.wait();

	tveens[1]:Play();
	tveens[3]:Play();
	
	
	task.wait(3.333);
	
	tveens[2]:Play();
	tveens[4]:Play();

	
end)

xpVal.Changed:Connect(function(val)
	task.wait(0.2);
	if lvlVal.Value >= settings.General.MaxLevel then
		bar.Size = UDim2.new(1,0,1,0);
		
		xp.Text = lvl:GetAttribute("MaxText");
		xp.TextColor3 = settings.Costumes.Max.TextColor3;
		xp.UIStroke.Color =settings.Costumes.Max.TextStrokeColor3;
		
		
		return;
	end
	
	bar:TweenSize(UDim2.new(math.clamp(val / goalXPVal.Value,0,1),0,1,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine,0.75,true)

	local init = tonumber(xp.Text:sub(1,string.find(xp.Text,"/")-2));
	if (val - init) > 99 then
		xp.Text = string.format(xp:GetAttribute("txt"), val, goalXPVal.Value);
	else
		for i = init, val do
			xp.Text = string.format(xp:GetAttribute("txt"), i, goalXPVal.Value);
			task.wait();
		end
	end
	task.wait(0.1)
	xp.Text = string.format(xp:GetAttribute("txt"), xpVal.Value, goalXPVal.Value);
end)

goalXPVal.Changed:Connect(function(val)
	if lvlVal.Value >= settings.General.MaxLevel then return; end
	xp.Text = string.format(xp:GetAttribute("txt"), xpVal.Value, goalXPVal.Value);
end)

task.wait();--game.UserInputService.InputBegan:Wait();
ask:InvokeServer(); --> asks the players level data to the server so the player can see it;