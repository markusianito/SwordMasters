--disable
-->> MainObj.lua - Client
--> Objective manager when a round starts / ends

local OBJ_TEXT = "%s / %s" -- %s is replaced by a number
local MAX = 0;
local COMPLETED_TEXTCOLOR = Color3.fromRGB(35, 176, 52)

local rstart = game.ReplicatedStorage.Objective.RoundStart;
local rend = game.ReplicatedStorage.Objective.RoundEnd;
local call = game.ReplicatedStorage.Objective.Update;


local program = script.Parent;
local frame = program:WaitForChild("Background");
local count = frame:WaitForChild("ObjectiveCount");

local defcol, defstk = count.TextColor3, count.UIStroke.Color;

frame:SetAttribute("Active", true);
local sPos = frame.Position;


local HideUI = function()
	if frame:GetAttribute("Active") then
		frame:TweenPosition(UDim2.new(0, sPos.X.Offset, sPos.Y.Scale, sPos.Y.Offset));
		frame:SetAttribute("Active", false);
	end
end

local UpdateText = function(val, max, finished, defaultext)
	val = math.clamp(tonumber(val),0, max)
	count.Text = OBJ_TEXT:format(tostring(val), tostring(max));
	
	if finished then
		count.TextColor3 = COMPLETED_TEXTCOLOR;
		count.Parent.ObjectiveDescription.TextColor3 = COMPLETED_TEXTCOLOR;
		
		count.UIStroke.Color = COMPLETED_TEXTCOLOR:Lerp(Color3.new(0,0,0), 0.2);
		count.Parent.ObjectiveDescription.UIStroke.Color = COMPLETED_TEXTCOLOR:Lerp(Color3.new(0,0,0), 0.2);
	end

	if defaultext then
		count.Parent.ObjectiveDescription.Text = defaultext;
	end
end

local ShowUI = function(max, defaultext)
	if frame:GetAttribute("Active") then
		return true;
	end
	MAX = max;

	UpdateText(0, MAX, nil, defaultext)

	count.TextColor3 = defcol
	count.Parent.ObjectiveDescription.TextColor3 = defcol

	count.UIStroke.Color = defstk
	count.Parent.ObjectiveDescription.UIStroke.Color = defstk
	
	frame:TweenPosition(sPos, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.7)
	frame:SetAttribute("Active", true);
end


rstart.OnClientEvent:Connect(function(max, defaultext)
	ShowUI(max, defaultext);
end)

rend.OnClientEvent:Connect(function()
	HideUI();
end)

call.OnClientEvent:Connect(function(value, finished)
	UpdateText(value, MAX, finished);
end)

HideUI();