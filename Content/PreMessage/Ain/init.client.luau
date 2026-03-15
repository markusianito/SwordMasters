-->> workinonit
--> NYRYNARANARANANRANARA YOU KNOW, TARARARA PAM

export type data = {AinStr: string, Object: string}
export type mode = "NewItem" | "Insufficient" | "Failed"


local WHITE, RED = Color3.fromRGB(247, 247, 247), Color3.fromRGB(222, 27, 39)



local tws = game:GetService("TweenService");
local twi = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, 5)
local getted = require(game.ReplicatedStorage.Packages.Net):RemoteEvent("MessagesStars");
local sheik = require(script:WaitForChild("GuiShakerModule"));
local ain = script.Parent:WaitForChild("ItemRecievedText")
local event = game.ReplicatedStorage.ClientEvents.Transactions;


local tveen = tws:Create(ain, twi, {TextTransparency = 1});


local MODE = {}

MODE.NewItem = function(data: data)
	ain.TextColor3 = WHITE
	ain.Text = `{data.AinStr}{data.Object and ": " or " "}{data.Object and data.Object or ""}`
	tveen:Cancel();
	ain.TextTransparency = 0;
	
	tveen:Play();
end


MODE.Insufficient = function(data: data)
	ain.TextColor3 = RED
	ain.Text = `{data.AinStr}{data.Object and ": " or " "}{data.Object}`
	tveen:Cancel();
	ain.TextTransparency = 0;
	sheik:ShakeOnce(ain, 10, 0.3,0.3)


	tveen:Play();
end

MODE.Failed = function(data: data)
	ain.TextColor3 = RED
	ain.Text = `{data.AinStr}{data.Object and ": " or " "}{data.Object}`
	tveen:Cancel();
	ain.TextTransparency = 0;
	sheik:ShakeOnce(ain, 4, 1,1	)


	tveen:Play();
end


event.Event:Connect(function(mode: mode, data:data)
	MODE[mode](data);
end)

getted.OnClientEvent:Connect(function(mode: mode, data:data)
	event:Fire(mode, data);
end)