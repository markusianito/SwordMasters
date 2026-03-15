--disable
-- idc

local fire = game.ReplicatedStorage.ClientEvents.TokenFire;

local ain = script.Parent:WaitForChild("MainFrame");
local pos = ain.Position;

local on, off = function()
	ain:TweenPosition(pos, Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, true)
end, function()
	ain:TweenPosition(pos + UDim2.new(1,0,0,0),Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 1, false,function()
		ain.Bar.Size = UDim2.new(1,0,1,0);
	end);
end

local inFire = nil;
local secondCalled = false;
local currentTime = 0;


fire.OnClientEvent:Connect(function(token, time, txt, icon, color) --> Start countdown
	if inFire == nil then
		ain.Bar.Size = UDim2.new(1,0,1,0);
		currentTime = time;
		inFire = token;
		ain.TokenIcon.Image = icon
		ain.Time.Text = currentTime .. " s"
		ain.TokenName.Text = txt;
		ain.Bar.BackgroundColor3 = color;
		
		on();
		ain.Bar:TweenSize(UDim2.new(0,0,1,0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, currentTime, true, function()
			if not secondCalled then
				off();
			end
		end)
		
		while currentTime > 0 do
			task.wait(1);
			currentTime -= 1;
			ain.Time.Text = currentTime .. " s";
		end
		
		
		inFire = nil;
		secondCalled = false;
	elseif inFire == token then
		secondCalled = true;
		currentTime += time;
		ain.Time.Text = currentTime .. " s";
		
		ain.Bar:TweenSize(UDim2.new(1,0,1,0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, 0.1, true)
		task.wait(0.1);
		ain.Bar:TweenSize(UDim2.new(0,0,1,0), Enum.EasingDirection.In, Enum.EasingStyle.Linear, currentTime, true, function()
				off();
		end)
	end
end)

off();