-->> Collectables.lua
--> Functoins used in collectable objects
--> Marcos


local runSvc = game:GetService("RunService");

local c = {}

function c:SineFloat(p: BasePart, rotate: number)
	rotate = rotate or 0;
	repeat task.wait() until p:FindFirstAncestor("Workspace");
	local yPos = p.Position.Y;
	local at = 0;
	runSvc.Heartbeat:Connect(function(dt)
		at += dt;
		p.CFrame = CFrame.new(p.Position.X, yPos + math.sin(at), p.Position.Z)
		p.Orientation += Vector3.new(0,rotate,0);
	end)

	return self;
end


return c;