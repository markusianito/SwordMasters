-->> UiEnableDisableListener.lua
--> Enables or disables uis
--> Scripted by Marcos.


local tws = game:GetService("TweenService");
local players = game:GetService("Players");
local player = players.LocalPlayer;
local plrgui = player:WaitForChild("PlayerGui")
local etc = require(plrgui:WaitForChild("bin"):WaitForChild("etc"))


local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"));
local promise = require(bin:WaitForChild("Promise"));


local event = net:RemoteEvent("UiEnableDisable");





local uied = knit.CreateController({Name = "UiED"})
uied.ManageUis = {
	"Achievements",
	"Codes",
	"VoteMap",
	"RobuxShop",
	"AbilitiesShop",
	"Shop",
	"Inventory"
}


uied.twiIn = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0);
uied.twiOut = TweenInfo.new(.03, Enum.EasingStyle.Sine, Enum.EasingDirection.Out,0,false,0);


function uied:TweenTransparency(frame, a)
	local visible;
	local twi;
	if a then
		visible = true;
		twi = uied.twiIn;
	else
		visible = false;
		twi = uied.twiOut;
	end
	
	frame.Visible = visible
	
	a = a and 0 or 1;
	
	local FrameBackgroundTransparency = math.clamp(a,frame:GetAttribute("BackgroundTransparency") or 0,1)
	for _,v in pairs(frame:GetDescendants()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("TextBox") then
			local _TextTransparency = math.clamp(a,v:GetAttribute("TextTransparency"),1)
			local _BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
			
			tws:Create(v, twi, {BackgroundTransparency = _BackgroundTransparency, TextTransparency = _TextTransparency}):Play();
			
		elseif v:IsA("ImageButton") or v:IsA("ImageLabel") then
			local _ImageTransparency = math.clamp(a,v:GetAttribute("ImageTransparency"),1)
			local _BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
			
			
			tws:Create(v, twi, {BackgroundTransparency = _BackgroundTransparency, ImageTransparency = _ImageTransparency}):Play();

			
		elseif v:IsA("Frame") then
			local _BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
			
			tws:Create(v, twi, {BackgroundTransparency = _BackgroundTransparency}):Play();

		elseif v:IsA("UIStroke") then
			local _Transparency = math.clamp(a,v:GetAttribute("Transparency"),1)

			tws:Create(v, twi, {Transparency = _Transparency}):Play();

		elseif v:IsA("ScrollingFrame") then
			local _ScrollBarImageTransparency = math.clamp(a,v:GetAttribute("ScrollBarImageTransparency"),1)
			local _BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1);

			tws:Create(v, twi, {BackgroundTransparency = _BackgroundTransparency, ScrollBarImageTransparency = _ScrollBarImageTransparency}):Play();

		end
	end
end


function uied:Hide(ui: ScreenGui) -- ui: Exclude.
	for _,gui in pairs(etc.AlternableUis) do
		if ui then
			if gui == ui.Name then continue end;
		end
		local frm = plrgui[gui]:FindFirstChildOfClass("Frame")
		if frm then
			uied:TweenTransparency(frm,false);
		end
	end
end


function uied:Toggle(ui: string|ScreenGui, enabled: boolean, args: table)
	args = args or {};

	task.wait(.1);
	local ui:ScreenGui = (typeof(ui) == "string") and (player.PlayerGui:FindFirstChild(ui) or player.PlayerGui.Gui:FindFirstChild(ui)) or ui;
	
	if not ui then return end
	if ui:IsA("ScreenGui") then
		local frm = ui:FindFirstChildOfClass("Frame") or ui:FindFirstChild("MainFrame");
		uied:TweenTransparency(frm, enabled);

		if args.Text then
			local label = frm:FindFirstChild("Label", true)
			if label then
				label.Text = args.Text;
			end
		end
		
		uied:Hide(ui);
	end
end


function uied:KnitInit()
	event.OnClientEvent:Connect(function(ui: string, enabled: boolean, args: table)
		uied:Toggle(ui, enabled, args);
	end)
end

function uied:KnitStart()
	uied:Hide();
	knit.Player:WaitForChild("PlayerGui")
	local SetupUIs = promise.new(function(resolve, reject)

		for _,v in pairs(uied.ManageUis) do
			local ui = knit.Player.PlayerGui:WaitForChild(v, 10);
			if ui then
				local close: ImageButton = ui:FindFirstChild("Exit", true)
				if close then
					close.Activated:Connect(function()
						uied:Toggle(ui, false);
					end)
				end
			else
				reject(v)  
			end
		end
	end)
	
	print("UIED is ready")
end



return uied;