-->> RankController.lua
--> Level handler from client.
--> Scripted by Marcos.

local players = game:GetService("Players");
local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"));
local stack = require(storage.StandardLibraries.HostStack);
local settings = require(storage.StandardLibraries.LevelSettings);
local goods = players.LocalPlayer:WaitForChild("Goods", 30);
local guis = players.LocalPlayer:WaitForChild("PlayerGui");

local levelsGui = guis:WaitForChild("Level");
local frm = levelsGui:WaitForChild("MainFrame");
local name,image = frm:WaitForChild("Playername"), frm:WaitForChild("PlayerIcon");
local image, sword = image:WaitForChild("PlayerImage"), image:WaitForChild("Sword decoration");
local barFrame = frm:WaitForChild("LevelUpBar")
local bar, xp, lvl = barFrame:WaitForChild("Bar"), barFrame:WaitForChild("AmountXP"), barFrame:WaitForChild("Level");
local lvlVal:IntValue, xpVal:IntValue, goalXPVal:IntValue = goods:WaitForChild("Level"), goods:WaitForChild("XP"), goods:WaitForChild("GoalXP")

local twi = TweenInfo.new(0.333, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false);
local tws = game:GetService("TweenService");


local black, lup = levelsGui:WaitForChild("Frame"), levelsGui:WaitForChild("LeveUpImage");
local total = barFrame:WaitForChild("XPEarnedTotal");

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
local rank = knit.CreateController({Name = "RankController"})
rank.XPVal = nil;

function rank.OnAddXP(xp)
    rank.XPVal.Value += xp;
end

function rank.OnLevelChanged()
    task.wait()
    local val = lvlVal.Value;
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
	tveens[1]:Play();tveens[3]:Play();
	task.wait(3.333);
	tveens[2]:Play();tveens[4]:Play();


    --> I HAD TO REPEAT MYSELF HERE SORRY FUCK
end


function rank.OnXPChanged()
    task.wait(0.1);
    local val = xpVal.Value;
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
end


function rank.OnXPChangedReliable()
	if lvlVal.Value >= settings.General.MaxLevel then return; end
	xp.Text = string.format(xp:GetAttribute("txt"), xpVal.Value, goalXPVal.Value);
end


function rank:KnitStart()
    image.Image = players:GetUserThumbnailAsync(players.LocalPlayer.UserId,Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100);
    name.Text = players.LocalPlayer.DisplayName;

    rank.XPVal = Instance.new("IntValue");
    rank.XPVal.Name = "EarnedXP";
    rank.XPVal.Parent = goods;

	lvlVal.Changed:Connect(rank.OnLevelChanged)
	xpVal.Changed:Connect(rank.OnXPChanged)
	goalXPVal.Changed:Connect(rank.OnXPChangedReliable)

    stack:LookForValue(rank.XPVal, total, UDim2.new(1.2,0,1,0))

	local rankSvc = knit.GetService("RankService");
	rankSvc.OnXPAdd:Connect(rank.OnAddXP);
	rankSvc.UpdateAll:Connect(function()
		rank.OnLevelChanged();
		rank.OnXPChanged();
		rank.OnXPChangedReliable();
		print("Updated level info")
	end)

    print("RankController is ready")
end


return rank;