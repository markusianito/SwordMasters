-->> ClientBegin.lua
--> Starts all SM controllers, and setups stuff for client.
--> Scripted by Marcos Saenz.

print("Hello world, from client!")

local tws = game:GetService("TweenService");
local content = game:GetService("ContentProvider");
local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local twi = TweenInfo.new(15 * 255, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1, false, 0)
local twi2 = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.Out, 0, false, 0)
local twt = {Position = UDim2.fromScale(0, -255)};
local twt_1 = {BackgroundTransparency = 1;};
local twt_2 = {BackgroundTransparency = 1; ImageTransparency = 1};
local twt_3 = {TextTransparency = 1};
local loadSc = script:WaitForChild("GameLoad");
loadSc.Parent = knit.Player:WaitForChild("PlayerGui");

local ass = {}
for _,v in game:GetService("StarterGui"):GetDescendants() do
	table.insert(ass, v);
end

local frame = loadSc:WaitForChild("Background");
local skip = frame:WaitForChild("Skip")
local pattern = frame:WaitForChild("Swoos")
local text = frame:WaitForChild("AssetsLoaded");
local label = frame:WaitForChild(" ");



content:PreloadAsync({pattern:WaitForChild("Pattern")})
game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen();





local doneTween = {
	tws:Create(frame, twi2, twt_1);
	tws:Create(skip, twi2, twt_2);
	tws:Create(pattern:WaitForChild("Pattern"), twi2, twt_2);
	tws:Create(text, twi2, twt_3);
	tws:Create(label, twi2, twt_3);
}
tws:Create(pattern, twi, twt):Play();

local isDone = false;
local function done()
	if not isDone then
		isDone = true;
		for _,v: Tween in doneTween do
			v:Play();
		end
		task.delay(2, function()
			loadSc:Destroy();
		end)
		
		local net = require(bin.Net);
		local loaded = net:RemoteEvent("Loaded1st")
		loaded:FireServer();
	end
end




--> ControllersBegin


knit.AddControllers(game:GetService("StarterPlayer").StarterPlayerScripts:WaitForChild("Controllers"));
knit.AddControllers(game:GetService("StarterPlayer").StarterPlayerScripts:WaitForChild("Listeners"));

knit.Start():andThen(function()
	print(`Knit Started in {knit.Player.Name}`);
end):catch(function(err)
	warn(err);
	knit.Player:Kick("Failed to start client services, exit code 1");
end)



--> PerformLoad


skip.Visible = true;
text.Text = text:GetAttribute("txt"):format(0, #ass);
label.Text = "Loading Assets";
skip.Activated:Connect(done)

for i = 1,#ass do
	content:PreloadAsync({ass[i]})
	text.Text = text:GetAttribute("txt"):format(i, #ass);
end

done();


return--;