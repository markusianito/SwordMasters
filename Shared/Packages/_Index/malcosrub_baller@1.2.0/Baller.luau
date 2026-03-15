--> Baller.lua
-- One action for each possible event occurring with balls. usually sport games.

local Velocity = "AssemblyLinearVelocity"
local Tags = game:GetService("CollectionService")
local Destroyer = game:GetService("Debris");
local rad = math.rad;

local Global = {}

function Global.IsDirection(v3)
	return v3.Magnitude == 1;
end

function Global.GetDirection(v3)
	if Global.IsDirection(v3) then return v3; end
	return v3.Unit;
end



local Baller = {}

Baller.__index = Baller

Baller.__call = function(obj, ...) -- experimenting with metamethods
	if obj["Directing"] then
		obj.Reached = false;
		obj.Active = false;
		obj.Object = nil;
		obj.LimitInstances = nil;
	else
		warn("Only directionals can be called");
		return obj;
	end
end


function Baller.IsMoving(obj)
	return obj.AssemblyAngularVelocity:Abs().Magnitude >= 0.03;
end


function Baller.ListenToBlast(ObjFolder)
	local self = setmetatable({}, Baller)

	self.Listener = true;
	self.Admin = nil
	self.Song = nil;
	self.Objects = ObjFolder
	return self
end


function Baller:SoundOnBlast(sound, multiplier, identifier: ParentTagName)
	assert(self.Listener, "SoundOnBlast must be called on ListenToBlast object")

	self.Admin = {
		["State"] = {};
		["Connections"] = {}
	}

	self.Song = sound.Name

	for i,v:BasePart in pairs(self.Objects:GetChildren()) do
		local s = sound:Clone();
		s.Parent = v;

		self.Admin.State[v.Name] = false;

		self.Admin.Connections[v.Name] = v.Touched:Connect(function(p) --p: ball who made the touch v: ball who got touched

			if Tags:HasTag(p.Parent, identifier) then
				if not self.Admin.State[v.Name] then
					self.Admin.State[v.Name] = true;

					local s:Sound = v:FindFirstChild(self.Song);
					local factor = math.ceil(math.abs(v[Velocity].X - v[Velocity].Z))

					local volval = factor * (multiplier / 100)

					if s then
						s.Volume = volval s:Play();
					end

					task.wait();
					self.Admin.State[v.Name] = false;
				end
			end
		end)
	end
end


function Baller:StopListening(str)
	if self.Admin then
		local conns = self.Admin.Connections
		if conns then
			for _,v in pairs(conns) do
				v:Disconnect();
				v = nil;
			end
		end

		local states = self.Admin.State
		if states then
			for _,v in pairs(states) do
				v = nil;
			end
		end

		self.Admin = nil;

		for _,v in pairs(self.Objects) do
			local sng = v:FindFirstChild(self.Song)
			if sng then
				Destroyer:AddItem(sng, 0.1);
			end
		end
	end
end


function Baller.NewDirectional(ball: Part, recursive: boolean, limitInstances: Folder)
	local self = setmetatable({}, Baller)

	self.Directing = true;
	self.Object = ball;
	self.LimitInstances = limitInstances;
	self.Recursive = recursive;
	
	self.ReachConnection = nil;
	self.Reached = false;
	self.Active = false;

	return self;
end


function ComputeDirection(self, direction: Vector3, collisionCF:CFrame, visiblePoints:boolean, silent: boolean)
	direction = Global.GetDirection(direction);

	local params = RaycastParams.new()
	params.CollisionGroup = self.Object.CollisionGroup;
	params.FilterType = Enum.RaycastFilterType.Include;
	params.IgnoreWater = true;
	params.FilterDescendantsInstances = {self.Object.Parent, self.LimitInstances}

	local cf:CFrame, radius = self.Object.CFrame, self.Object.Size.X / 2	

	local firstRay, finishPoint

	firstRay = workspace:Spherecast(
		cf.Position,
		radius,
		collisionCF:ToWorldSpace(CFrame.new(0,0,100)).Position - cf.Position,
		params
	)
	

	local function LookForDirectionReach(ray:RaycastResult, already)
		self.Active = true;
		
		local line: LinearVelocity = self.Object:FindFirstChild("MoveDirection") -- linearvelocity in line mode, no limits enabled

		if line then

			line.LineDirection = Vector3.new(
				direction.Z,
				0,
				-direction.X
			)

			line.Enabled = true;
			Tags:AddTag(self.Object, "directionlocked");


			if not already then	
				finishPoint = Instance.new("Part");
				finishPoint.Shape = self.Object.Shape;
				finishPoint.Anchored = true;
				finishPoint.CanCollide = false;
				finishPoint.Size = self.Object.Size -- + Vector3.one;
				finishPoint.CollisionGroup = self.Object.CollisionGroup;
				finishPoint.Transparency = visiblePoints and 0.5 or 1;
				finishPoint.Color = self.Object.Color;
				finishPoint.Name = self.Object.Name;

				--finishPoint.CFrame = CFrame.lookAt(self.Object.Position,collisionCF.Position):ToWorldSpace(CFrame.new(-ray.Distance,0,0))
				finishPoint.Position = ray.Position

				finishPoint.Parent = workspace.FinishPoints
				self.ReachConnection = finishPoint.Touched:Connect(function(ball)
					if ball == self.Object and Tags:HasTag(ball, "directionlocked") then
						line.Enabled = false;
						Tags:RemoveTag(self.Object, "directionlocked");
						self.Reached = true;

						if not silent then
							warn("Baller.lua: " .. self.Object.Name .. " Direction Reached");
						end
						
						if not self.Recursive then
							Destroyer:AddItem(finishPoint, 1);
						end
					end
				end)
			end
		end
	end

	
	if firstRay then
		LookForDirectionReach(firstRay,
			firstRay.Distance < (self.Object.Size.X + 0.15)
		)
	end
	if self.Recursive then
		while not self.Reached do
			task.wait();
			if not self.Active then
				break;
			end
		end

		if not self.Active then return; end
		
		if finishPoint then
			finishPoint.TouchEnded:Connect(function(ball)
				if ball == self.Object then
					ComputeDirection(self,self.Object[Velocity],CFrame.new(),visiblePoints,silent);
					Destroyer:AddItem(finishPoint, 0.25);
				end
			end)
		end
	end
end

function Baller:StartDirection(direction: Vector3, collisionCF:CFrame, visiblePoints:boolean, silent: boolean)
	ComputeDirection(self, direction, collisionCF, visiblePoints, silent);
end


function Baller:StopDirection(announce)
	local success, err = pcall(function()
		if typeof(self.ReachConnection) == "RBXScriptConnection" then
			self.ReachConnection:Disconnect();
			self.ReachConnection = nil;
		end
		self.Active = false;
		local line = self.Object:FindFirstChild("MoveDirection");
		if line then
			line.Enabled = false;
		end
		
		for _,v in pairs(workspace.FinishPoints:GetChildren()) do
			if v.Name == self.Object.Name then
				Destroyer:AddItem(v, 0.1)
			end
		end
	end)
	
	if not success then
		warn("Baller.lua (StopDirection): " .. err)
	else
		if announce then
			warn("Baller.lua: " .. self.Object.Name .. " Direction Stopped")
		end
	end
end


return Baller

--[[
		local pos = firstRay.Position
		local normal = firstRay.Normal
		local reflect = (pos - normal * 2 * pos:Dot(normal))
		
		secondRay = workspace:Spherecast(
			pos,
			radius,
			reflect,
			params
		)
	end
	
	if secondRay then
		return secondRay.Normal
	end
	end
	
	function Global.IsntMoving(inst: Part)
	return inst.AssemblyAngularVelocity:Abs().Magnitude <= 0.03
end
	]]