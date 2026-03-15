-->> HostStack.lua - Server

local math = require(game:GetService("ReplicatedStorage"):WaitForChild("Packages"):WaitForChild("MathTena"));
local tws = game:GetService("TweenService");
local twi1 = TweenInfo.new(0.5);
local twi2 = TweenInfo.new(3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,0,false,5);

local stack = {}
stack.__index = stack

local sign = math.sign


-- "Just do a new constructor": Bro, You aint gonna need it, im just looking for a value, instead of .new():LookForvalue()

function stack:LookForValue(value: ValueBase, to: TextLabel, goalPosOnShow: UDim2)
	local self = setmetatable({}, self)
	self.Value = value
	self.Text = to
	self.InitValue = value.Value;
	self.StartPos = to.Position;
	self.Visible = false;
	self.Hiding = false;
	self.ShowTween = tws:Create(self.Text, twi1, {
		TextTransparency = 0;
		TextStrokeTransparency = 0
	})
	
	self.HideTween = tws:Create(self.Text, twi2, {
		TextTransparency = 1;
		TextStrokeTransparency = 1
	})
	
	self.OnHideConnection = nil
	
	self.HideFunc = function()
		self.HideTween:Play();
		self.OnHideConnection = self.HideTween.Completed:Connect(function(ps)
			if ps == Enum.PlaybackState.Cancelled then return end;
			if self.Visible then
				self.Visible = false;
				self.Text.Position = self.StartPos;
				self.Value.Value = 0;
				self.OnHideConnection:Disconnect();
				self.OnHideConnection = nil;
			end
		end)
	end
	
	self.ChangedFunc = function(val)
		task.wait(0.1);
		local diff = val - self.InitValue;
		if diff == 0 then return; end

		local finalStr = `{sign(diff) == 1 and "+" or "-"}{math.formatInt((diff))}`
		self.Text.Text = finalStr;
		self.Text:TweenPosition(goalPosOnShow,Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.333, true);
		self.HideTween:Cancel();
		self.ShowTween:Play();
		task.wait(self.ShowTween.TweenInfo.Time);
		
		self.HideFunc();
		
		
		self.Visible = true; 
	end
	
	self.ChangedConnection = value.Changed:Connect(self.ChangedFunc);
	
	
	
	
	return self
end


return stack
