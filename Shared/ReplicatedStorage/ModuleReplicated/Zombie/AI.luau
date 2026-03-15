local AI = {}
AI.__index = AI

local PathfindingService = game:GetService("PathfindingService")

function AI.new(Object)
	local self = {}

	self.Object = Object
	
	--self.Object.HumanoidRootPart:SetNetworkOwnership(nil)

	return setmetatable(self, AI)
end

function AI:Walk()
	local X = math.random(-50, 50)
	local Z = math.random(-50, 50)

	local Finish = self.Object.HumanoidRootPart.Position + Vector3.new(X, 0, Z)

	local Path: Path = PathfindingService:CreatePath()
	Path:ComputeAsync(self.Object.HumanoidRootPart.Position, Finish)

	local Waypoints = Path:GetWaypoints()

	if Path.Status == Enum.PathStatus.Success then
		for _, Waypoint: PathWaypoint in ipairs(Waypoints) do
			if Waypoint.Action == Enum.PathWaypointAction.Jump then
				self.Object.Humanoid.Jump = true
			end
			self.Object.Humanoid:MoveTo(Waypoint.Position)
			local Timeout = self.Object.Humanoid.MoveToFinished:Wait(1)
			if not Timeout then
				self.Object.Humanoid.Jump = true
				self:Walk()
			end
		end
	else
		task.wait(1)
		self:Walk()
	end
end

function AI:FindPath(Target)
	local Path: Path = PathfindingService:CreatePath()
	Path:ComputeAsync(self.Object.HumanoidRootPart, Target.Position)

	local Waypoints = Path:GetWaypoints()

	if Path.Status == Enum.PathStatus.Success then
		for _, Waypoint: PathWaypoint in ipairs(Waypoints) do
			if Waypoint.Action == Enum.PathWaypointAction.Jump then
				self.Object.Humanoid.Jump = true
			end
			self.Object.Humanoid:MoveTo(Waypoint.Position)
			local Timeout = self.Object.Humanoid.MoveToFinished:Wait(1)

			if not Timeout then
				self.Object.Humanoid.Jump = true
				self:FindPath(Target)
				break
			end

			if self:Cast(Target) then
				repeat
					self.Object.Humanoid:MoveTo(Target.Position)
					task.wait(0.1)
					if Target == nil then
						break
					elseif Target.Parent == nil then
						break
					end
				until self:Cast(Target) == false or self.Object.Humanoid.Health < 1 or Target.Parent.Humanoid.Health < 1
			end

			if (self.Object.HumanoidRootPart.Position - Waypoints[1].Position).Magnitude > 20 then
				self:FindPath(Target)
				break
			end
		end
	end
end

function AI:Cast(Target): boolean
	local Params = RaycastParams.new()
	Params.FilterType = Enum.RaycastFilterType.Exclude
	Params.FilterDescendantsInstances = {self.Object}

	local Result = workspace:Raycast(
		self.Object.HumanoidRootPart.Position,
		(Target.Position - self.Object.HumanoidRootPart.Position).Unit * 40,
		Params
	)

	if Result then
		if Result:IsDescendantOf(Target.Parent) and math.abs(Result.Position.Y - self.Object.HumanoidRootPart.Position.Y) < 3 then
			return true
		end
	end

	return false
end

function AI:CheckPotenitalTargets(Distance)
	
	local Dist = Distance
	local Target = nil
	local PotentialTargets = {}
	local SeenTargets = {}

	for _, v in ipairs(workspace:GetChildren()) do
		for _, Player in next, game.Players:GetChildren() do
			local Humanoid = v:FindFirstChild("Humanoid")
			local Torso = v:FindFirstChild("Torso") or v:FindFirstChild("HumanoidRootPart")
			if Humanoid and Torso and v.Name ~= self.Object.Name and v.Name == Player.Name then
				if (self.Object.HumanoidRootPart.Position - Torso.Position).Magnitude < Dist and Humanoid.Health > 0 then
					table.insert(PotentialTargets, Torso)
				end
			end
		end
	end

	if #PotentialTargets > 0 then
		for _, v in ipairs(PotentialTargets) do
			if self:Cast(v) then
				table.insert(SeenTargets, v)
			elseif #SeenTargets == 0 and (self.Object.HumanoidRootPart.Position - v.Position).Magnitude < Dist then
				Target = v
				Dist = (self.Object.HumanoidRootPart.Position - v.Position).Magnitude
			end
		end
	end
	
	if #SeenTargets > 0 then
		Dist = Distance
		for _, v in ipairs(SeenTargets) do
			if (self.Object.HumanoidRootPart.Position - v.Position).Magnitude < Dist then
				Target = v
				Dist = (self.Object.HumanoidRootPart.Position - v.Position).Magnitude
			end
		end
	end
	
	return Target
end

function AI:Attack(Target, Damage)
	if (self.Object.HumanoidRootPart.Position - Target.Position).Magnitude < 5 then
		if Target.Parent ~= nil then
			Target.Parent:TakeDamage(Damage)
		end
		task.wait(0.4)
	end
end



return AI