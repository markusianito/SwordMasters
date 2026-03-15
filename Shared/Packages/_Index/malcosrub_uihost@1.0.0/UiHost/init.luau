--[[
    Made by SolarDev (@noober2359 on Roblox)
    Twitter: @SolarArxaia
]]--;

-->TODO:ScalableGUI

local drg = require(script:WaitForChild("DraggableObject"))

local Uirt = {};
Uirt.__index = Uirt;

function Uirt.New(obj)
	assert(typeof(obj)=="Instance", "Instance expected");
	--assert(obj.ClassName=="ImageButton"or obj.ClassName=="TextButton", "UI Button expected")
	local self	=	{};
	self.Object	=	obj;
	
	setmetatable(self,Uirt);
	
	return self;
end

function Uirt:MoveOnPress(Offset:number,BindFunction)
	assert(type(BindFunction)=="function",
		"Expected function at BindFunction");
	assert(typeof(self.Object)=="Instance",
		"Expected instance at self");
	assert(self.Object.ClassName=="ImageButton"or self.Object.ClassName=="TextButton",
		"Expected UI Button at self");
	assert(type(Offset)=="number",
		"Expected number");
	local i = self.Object;
	local pos = i.Position;
	local connection = i.MouseEnter:Connect(function(_)
		local down = false;
		i.MouseButton1Down:Connect(function(_)
			if not down then
				down = true;
				i.Position = UDim2.new(i.Position.X.Scale,i.Position.X.Offset,
					i.Position.Y.Scale,i.Position.Y.Offset + Offset);
			end
		end)
		i.MouseButton1Up:Connect(function(_)
			if down then
				i.Position = UDim2.new(i.Position.X.Scale,i.Position.X.Offset,
					i.Position.Y.Scale,i.Position.Y.Offset - Offset);
				down = false;
			end
		end)
	end)
	i.MouseLeave:Connect(function()
		i.Position = pos;
		connection:Disconnect();
	end)
	i.MouseButton1Click:Connect(function(_)
		BindFunction(i.Position);
	end)

	return connection, i;
end

function Uirt:Drag(activated:boolean)
	local obj = drg.New(self.Object);
	if activated then
		obj:Enable();
	else
		obj:Disable();
	end
end

return Uirt;