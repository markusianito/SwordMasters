-->> Main.lua - Client
--> Standalone script for codes, client-side
--> Scripted by Marcos

local frm = script.Parent:WaitForChild("MainFrame");
local bot = frm:WaitForChild("RedeemButton");
local box = frm:WaitForChild("RedeemCodeBox");

local net = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("Net"))
local get = net:RemoteFunction("RedeemCode");
local uied = net:RemoteEvent("UiEnableDisable");


local cd = false;
bot.Activated:Connect(function()
	local txt = string.match(string.upper(box.Text),"%w+");
	
	if txt then
		if not cd then
			cd = true;

			box.PlaceholderText = "Loading...";
			box.Text = "";
			local success = get:InvokeServer(txt)
			if success then
				box.PlaceholderColor3 = Color3.fromRGB(12, 184, 46)
				box.PlaceholderText = "Code redeemed!";
			else
				box.PlaceholderText = "Invalid code!";
				box.PlaceholderColor3 = Color3.fromRGB(213, 5, 8)
			end
			task.delay(2, function()
				box.PlaceholderText = "Type here!"
				box.PlaceholderColor3 = Color3.fromRGB(255, 255, 255)
			end)
			
			task.wait(2);
			cd = false;
		end
	end
end)

local btn = script.Parent:WaitForChild("ButtonED");

local isHovering = false -- this is good, approved.


btn.MouseEnter:Connect(function()

	isHovering = true

	btn:TweenSize(UDim2.new(0.04,0 ,0.07, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseLeave:Connect(function()

	isHovering = false

	btn:TweenSize(UDim2.new(0.044,0 ,0.074, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Down:Connect(function()

	btn:TweenSize(UDim2.new(0.034,0 ,0.064, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
end)

btn.MouseButton1Up:Connect(function()

	if not isHovering then
		btn:TweenSize(UDim2.new(0.044,0 ,0.074, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	else
		btn:TweenSize(UDim2.new(0.04,0 ,0.07, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, 0.2, true)
	end
end)

local Sound = script:WaitForChild("ClickCodes");

btn.MouseButton1Click:Connect(function()
	Sound:Play()
	uied:FireServer("Codes", true)
end)