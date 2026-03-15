-->> AI_thing.lua (Module)
--> My first """"aI"""", some of the code is taken from the main AI module to make it compatible.

local aiSvc = game:GetService("PathfindingService")
local runSvc = game:GetService("RunService");

local thing = {}
thing.__index = thing -- its not necessary, its just a trend

thing.NewThing = function(rig: Model, Settings: table)

	local self = setmetatable({},thing);

	self.OnDeath = Instance.new("BindableEvent")
	self.OnDeath.Name = string.format("%s Died Connection", rig:GetFullName())
	self.OnDeath.Parent = script

	self.Settings = {
		walkSpeed = Settings.walkSpeed or 16,
		health = Settings.health or 100,
		sightRadius = Settings.sightRadius or 100,
		combatDistance = Settings.combatDistance or 5,
		damageRate = Settings.damageRate or 2,
		damage = Settings.damage or 10,
		canJump = Settings.canJump or true,
		canClimb = Settings.canClimb or true,
		destroyAfterDeath = Settings.destroyAfterDeath or true,
		timeToDestroyAfterDeath = Settings.timeToDestroyAfterDeath or 2,
		attackFunction = Settings.attackFunction or function(_enemyCharacter : Model, _walkingToPosition : Vector3)
			warn("Make sure to change the attack function setting!")
		end,
		animations = {
			climb = Settings.animations.climb or 180436334,
			fall = Settings.animations.fall or 180436148,
			idle1 = Settings.animations.idle1 or 180435571,
			idle2 = Settings.animations.idle2 or 180435792,
			jump = Settings.animations.jump or 125750702,
			run = Settings.animations.run or 180426354,
			sit = Settings.animations.sit or 178130996,
			toolnone = Settings.animations.toolnone or 182393478,
			walk = Settings.animations.walk or 180426354,
		}
	}

	local hrp:Part = rig:WaitForChild("HumanoidRootPart");
	local hum:Humanoid = rig:WaitForChild("Humanoid");

	self.Rig = rig;
	self.HRP = hrp;
	self.Humanoid = hum;
	hum.WalkSpeed = self.Settings.walkSpeed
	hum.MaxHealth = self.Settings.health
	hum.Health = self.Settings.health

	local anims = script:WaitForChild("Animate"):Clone()
	anims.climb.ClimbAnim.AnimationId = "rbxassetid://"..self.Settings.animations.climb
	anims.fall.FallAnim.AnimationId = "rbxassetid://"..self.Settings.animations.fall
	anims.idle.Animation1.AnimationId = "rbxassetid://"..self.Settings.animations.idle1 
	anims.idle.Animation2.AnimationId = "rbxassetid://"..self.Settings.animations.idle2 
	anims.jump.JumpAnim.AnimationId = "rbxassetid://"..self.Settings.animations.jump
	anims.run.RunAnim.AnimationId ="rbxassetid://".. self.Settings.animations.run
	anims.sit.SitAnim.AnimationId = "rbxassetid://"..self.Settings.animations.sit 
	anims.toolnone.ToolNoneAnim.AnimationId = "rbxassetid://"..self.Settings.animations.toolnone
	anims.walk.WalkAnim.AnimationId = "rbxassetid://"..self.Settings.animations.walk

	anims.Parent = rig;

	self.ChaseConnection = nil;
	self.PointHeadConnection = nil;
	self.DestroyConnection = nil;
	self.CurrentEnemy = nil;
	self.CurrentEnemyDistance = nil;
	self.OnDeathConnection = nil;
	self.IsDed = false;
	self.WalkTo = Vector3.zero;

	self.Attacking = nil;

	return self;
end



function thing:FindFirstPlr()
	local closest_player, closest_distance = nil, self.Settings.sightRadius;
	for i, player in pairs(game.Players:GetPlayers()) do
		if player.Character then
			local distance = (self.Rig.PrimaryPart.Position - player.Character.HumanoidRootPart.Position).Magnitude
			if distance < closest_distance then
				closest_player = player.Character
				closest_distance = distance
			end
		end
	end
	return closest_player, closest_distance
end



function thing:Attack()
	if self.Attacking then return; end
	if self.CurrentEnemy and self.CurrentEnemyDistance then
		if self.CurrentEnemyDistance <= self.Settings.combatDistance then
			task.spawn(function()
				self.Attacking = true;
				self.Settings.attackFunction(self.CurrentEnemy)
				task.wait(self.Settings.damageRate)
				self.Attacking = false
			end)
		end
	end
end



function thing:Wakeup()
	self.OnDeathConnection = self.Humanoid.Died:Connect(function()
		self.OnDeath:Fire()
		self.IsDed = true;
		if not self.Settings then return; end;
		if self.Settings.destroyAfterDeath then
			task.wait(self.Settings.timeToDestroyAfterDeath)
			self:Kill(true);
			return;
		end
		self:Kill();
	end)

	self.DestroyConnection = self.Rig.Destroying:Connect(function()
		self:Kill();
	end)


	local neck: Motor6D = self.Rig.Head:FindFirstChild("Neck")

	local neckCF

	self.ChaseConnection = coroutine.create(function()
		while task.wait() do
			task.spawn(function()
			if self.IsDed then return end;
			self:Attack()

			self.HRP:SetNetworkOwner(nil);
			local path:Path = aiSvc:CreatePath({
				AgentCanJump = self.Settings.canJump, 
				AgentCanClimb = self.Settings.canClimb
			})
			self.CurrentEnemy, self.CurrentEnemyDistance = self:FindFirstPlr();
			if self.CurrentEnemy and self.CurrentEnemyDistance > 0 then
				if self.CurrentEnemy.Humanoid.MoveDirection.Magnitude > 0 then
					self.WalkTo = self.CurrentEnemy.HumanoidRootPart.Position + (self.CurrentEnemy.HumanoidRootPart.CFrame.LookVector * 10)
				else
					self.WalkTo = self.CurrentEnemy.HumanoidRootPart.Position
				end
				path:ComputeAsync(self.HRP.Position, self.WalkTo)
				local waypoints = path:GetWaypoints()
				for _, waypoint:PathWaypoint in pairs(waypoints) do  
					waypoint = waypoint or CFrame.new();

					self.Rig.Humanoid:MoveTo(waypoint.Position);
					task.spawn(function()
						while wait() do
							if self.IsDed then break; end;
							if not self.HRP then break; end;
							self.CurrentEnemy = self.CurrentEnemy or workspace["Mountain Guardian"];
							local distance = (self.HRP.Position - waypoint.Position).Magnitude
							local distance_from_player = (self.HRP.Position - self.CurrentEnemy.PrimaryPart.Position).Magnitude
							if distance < 5 then
								break
							end
							if distance_from_player < 10 then
								self.Rig.Humanoid:MoveTo((self.Rig.HumanoidRootPart.CFrame*CFrame.new(0,0,-3)).Position)
								break
							end
						end
					end)
				end
			end
			end)
		end
		return true;
	end)

	coroutine.resume(self.ChaseConnection);

	if neck then
		neckCF = neck.C0
		self.PointHeadConnection = runSvc.Heartbeat:Connect(function()
			if self.CurrentEnemy and (not self.IsDed) then
				local IsLooking = self.Rig.PrimaryPart.CFrame:ToObjectSpace(self.CurrentEnemy.PrimaryPart.CFrame).Z < 0
				if IsLooking then
					local unit = -(self.Rig.PrimaryPart.CFrame.p - self.CurrentEnemy.PrimaryPart.Position).unit
					neck.C0 = neckCF * CFrame.new(Vector3.zero, unit) * CFrame.Angles(0, -math.rad(self.Rig.PrimaryPart.Orientation.Y), 0)
				end
			end
		end)
	end

end



function thing:Kill(destroy: boolean)
	self.Settings = nil;
	if destroy then
		if self.Rig then
			self.Rig:Destroy()
		end
	end
	self.Rig = nil;
	self.HRP = nil;
	self.Humanoid = nil;

	if typeof(self.ChaseConnection) == "RBXScriptConnection" then
		self.ChaseConnection:Disconnect();
	elseif typeof(self.ChaseConnection) == "thread" then
		if coroutine.status(self.ChaseConnection) ~= "dead" then
			coroutine.close(self.ChaseConnection);
		end
	end
	self.ChaseConnection = nil;

	if self.PointHeadConnection then
		self.PointHeadConnection:Disconnect();
	end
	self.PointHeadConnection = nil;

	if self.DestroyConnection then
		self.DestroyConnection:Disconnect();
	end
	self.DestroyConnection = nil;

	if self.DeathConnection then
		self.DeathConnection:Disconnect();
	end
	self.DeathConnection = nil;

	self.CurrentEnemy = nil;
	self.CurrentEnemyDistance = nil;
	self.OnDeathConnection = nil;
	self.IsDed = nil;
	self.WalkTo = nil;

	self.Attacking = nil;

	self = nil;
end

return thing