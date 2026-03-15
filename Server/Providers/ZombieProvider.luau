-->> zombieSvc.luau
-- Main service script for zombiess in Sword Masters. Handles zombieSvc creating, destroying and AI
--> Scripted by Marcos



export type ZombieInformation = {
	Type: "Miniboss"|"Standard";
	Rarity: number;
	Shield: number;
	AttackDistance: number;
	Animations: {
		Idle: number;
		Jump: number;
		Death: number;
		Punch: number;
		Run: number;
	};
	Health: number;
	AttackCooldown: number;
	Speed: number;
	HasMelee: boolean;
	HasShield: boolean;
	Damage: number;
}

export type Zombie = {
	Zombie: Model;
	hrp: Part;
	hum: Humanoid;
	Reaction: number;
	Animate: Script;
	Information: ZombieInformation;
	Path: Path;
	GoalPosition: Vector3;
	TargetPlayer: Model;
	WalkingPurpose: boolean;
	GotStuck: boolean;
	Resting: boolean;
	StartNeckCFrame: CFrame;

	AttackAnimation: AnimationTrack;
	DeathAnimation: AnimationTrack;
	OnDeath: RBXScriptConnection;
	DoEveryFrame: RBXScriptConnection;
	AttackPromise: any;
	Janitor: any;
}


local MAX_DIST = 255;


local runSvc = game:GetService("RunService");
local splr = game:GetService("StarterPlayer");
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit.KnitServer);
local promise = require(bin.Promise);
local spath = require(bin.SimplePath);
local signal = require(bin.Signal);
local janitor = require(bin.Janitor);

local zombiesInfo = require(storage.Classes.Zombies)
local maps = require(storage.Classes.Maps)
local rr6 = require(splr.StarterCharacterScripts:WaitForChild("R6"));

local rstr = workspace:GetAttribute("robloxstr");

local round;

local zombieSvc = knit.CreateService({Name = "ZombieProvider";});
zombieSvc.__index = zombieSvc;
zombieSvc.Zombies = {};
zombieSvc.Corpses = {};
zombieSvc.InfectPromise = nil;

zombieSvc.ZombieDex = {
	["Zombie"] = "Mystery Forest";
	["Slow Zombie"] = "Mystery Forest";
	["Fast Zombie"] = "Mystery Forest";
	["Crystal Guard"] = "Mystery Forest";

	["Zombie Gladiator"] = "Colosseum";
	["Attacker Zombie"] = "Colosseum";
	["Victorious Zomdiator"] = "Colosseum";
	["Armored Zombie"] = "Colosseum";
}

function zombieSvc.NewInfected(zombie: string, reactionStuds: number, onAttack: any, timeout: number, debug: boolean): Zombie
	if not zombie then return nil; end;
	reactionStuds = reactionStuds or 6;
	local map = zombieSvc.ZombieDex[zombie];
	local zombie:Model = storage.Assets.Zombies[map][zombie]:Clone();
	local info = zombiesInfo[map][zombie.Name];
	local anims = storage.StandardLibraries.Animate:Clone();
	do  --> Setup Animations
		anims.climb.ClimbAnim.AnimationId = rstr..(info.Animations.Climb or 180436334)
		anims.fall.FallAnim.AnimationId = rstr..(info.Animations.Fall or 180436148)
		anims.idle.Animation1.AnimationId = rstr..(info.Animations.Idle or 180435571)
		anims.idle.Animation2.AnimationId = rstr..(info.Animations.Idle2 or 180435792)
		anims.jump.JumpAnim.AnimationId = rstr..(info.Animations.Jump or 125750702)
		anims.run.RunAnim.AnimationId =rstr.. (info.Animations.Run or 180426354)
		anims.sit.SitAnim.AnimationId = rstr..(info.Animations.Sit or 178130996)
		anims.walk.WalkAnim.AnimationId = rstr..(info.Animations.Run or 180426354)

		anims.Parent = zombie;
	end

	zombie.HumanoidRootPart.Anchored = true;
	zombie.Humanoid.WalkSpeed = info.Speed;
	zombie.Parent = workspace;
	anims.Enabled = true;

	local path = spath.new(zombie, {WaypointSpacing = reactionStuds / 2});
	path.Visualize = not not debug;

	local self = setmetatable({}, zombieSvc);

	self.Zombie = zombie;
	self.hrp = zombie:WaitForChild("HumanoidRootPart");
	self.hum = zombie:WaitForChild("Humanoid")
	self.Reaction = reactionStuds;
	self.Animate = anims;
	self.Information = info;
	self.Path = path;
	self.GoalPosition = Vector3.zero;
	self.TargetPlayer = nil;
	self.WalkingPurpose = false;
	self.GotStuck = false;
	self.Resting = false;
	self.LieDownOnDeath = false;
	self.TimeoutSignal = signal.new();
	self._TimeoutSignal = signal.new();
	self.Timeout = timeout
	self.StartNeckCFrame = zombie.Torso.Neck.C0;
	self.GarbageCollected = false;
	

	self.Run = function(a, goalPosition: Vector3)
		if self.GarbageCollected then return; end;
		local ok, err = pcall(function()
			a:Run(goalPosition);
		end)
		if not ok then
			--warn("Trying to kill a zombie after ok is false:", self)
			pcall(function()
				self:GarbageCollect();
			end)
		end
	end
	
	local function reset()
		if self.GarbageCollected then return; end
		pcall(function()
			self._TimeoutSignal:Once(function()
				self.TimeoutSignal:Fire("r")
			end)
		end)
	end
	reset();
	
	self.TimeoutSignal:Connect(function(mode: "r"|"w")
		if mode == "w" then
			self.Timeout = timeout
		elseif mode == "r" then
			self.Run(path, self.GoalPosition);
			reset();
		end
	end)


	local _a = Instance.new("Animation");
	_a.AnimationId = rstr .. self.Information.Animations.Punch
	self.AttackAnimation = self.hum.Animator:LoadAnimation(_a)
	if self.Information.Animations.Death then
		local _a = Instance.new("Animation");
		_a.AnimationId = rstr .. self.Information.Animations.Death;
		self.DeathAnimation = self.hum.Animator:LoadAnimation(_a)
	else
		self.LieDownOnDeath = true
	end

	--self.ManualGoalReached = true;

	self.PathEvents = {
		path.Reached:Connect(function() --=> Fires when the zombie reaches the goal position
			self.GotStuck = false;

			--if not self.TargetPlayer then
			--	self.ManualGoalReached = true;
			--	return;
			--end
			--print("Path Reached");

			local closestOne = self:ClosestPlayer();
			if closestOne then
				self:SetWalkingPurpose(true)
				self:Attack();
			else
				self:SetWalkingPurpose(false); 
			end

			self.TimeoutSignal:Fire("w");
			self.Run(path, self.GoalPosition);
		end),

		path.Blocked:Connect(function() --=> Fires when something blocks the path to the goal position
			if self.GotStuck then
				self:SetWalkingPurpose(false);
			end
			--print("Path Blocked");

			self.TimeoutSignal:Fire("w");
			self.Run(path, self.GoalPosition);
		end),

		path.WaypointReached:Connect(function() --=> Fires when a single waypoint is reached (Can be fired before the goal position is completely reached (path.Reached))
			self.GotStuck = false;
			--print("Waypoint Reached");
			--Run(path, self.GoalPosition);
		end),

		path.Error:Connect(function(err: spath.ErrorType) --=> Fires when the goal is unreachable
			if err == "AgentStuck" then
				self.GotStuck = true;
				self:SetWalkingPurpose(false);
				self.TimeoutSignal:Fire("w");
				self.Run(path, self.GoalPosition);
			elseif err == "LimitReached" then
				task.delay(0.333, function()
					pcall(function()
						self.TimeoutSignal:Fire("w");
						self.Run(path, self.GoalPosition);
					end)
				end)
			end
			--warn(err);
		end),
	}


	self.DoEveryFrame = runSvc.Heartbeat:Connect(function(deltaTime)
		local ok, err = pcall(function()
			self.Timeout -= deltaTime;
			if self.Timeout <= 0 then
				self.Timeout = timeout
				self._TimeoutSignal:Fire();
			end
			
			
			local closestOne = self.TargetPlayer;
			if closestOne then
				local isInFront = self.hrp.CFrame:ToObjectSpace(closestOne.HumanoidRootPart.CFrame).Z < 0
				if isInFront then
					local unit = -(self.hrp.CFrame.Position - closestOne.HumanoidRootPart.Position).Unit
					self.Zombie.Torso.Neck.C0 = self.StartNeckCFrame * CFrame.lookAt(Vector3.new(0, 0, 0), unit) * CFrame.Angles(0, -math.rad(self.hrp.Orientation.Y), 0)
				end
			else
				self.Zombie.Torso.Neck.C0 = self.StartNeckCFrame * CFrame.Angles(-math.rad(30),0,0)
			end
		end)
		if not ok then
			if self.DoEveryFrame then
				self.DoEveryFrame:Disconnect()
				self.DoEveryFrame = nil
			end
		end
	end)


	self.OnDeath = self.hum.Died:Connect(function()
		if self.LieDownOnDeath then
			rr6(self.Zombie);
		else
			self.DeathAnimation:Play();
		end
		self:Kill();
	end)


	self.AttackPromise = promise.promisify(function()
		if self.Resting then return; end
		self.Resting = true;
		pcall(function()
			onAttack(self, self.TargetPlayer);
		end)
		task.wait(self.Information.AttackCooldown);
		return true;
	end)

	self.Janitor = janitor.new()


	self.Janitor:Add(self.DoEveryFrame, "Disconnect")
	self.Janitor:Add(self.OnDeath, "Disconnect");



	return self;
end



function zombieSvc:Revive()
	self.hrp.Anchored = false;
	self.GoalPosition = self.hrp.Position + (self.hrp.CFrame.LookVector * self.Reaction);
	self:SetWalkingPurpose(true);
	self.Run(self.Path, self.GoalPosition);
end

function zombieSvc:SetWalkingPurpose(purpose: boolean)
	if purpose then
		local closestOne, dist = self:ClosestPlayer();
		if closestOne then
			self.TargetPlayer = closestOne;
			if dist > self.Reaction then
				self.GoalPosition = self.hrp.Position + ((closestOne.HumanoidRootPart.Position - self.hrp.Position).Unit * self.Reaction)
			else
				self.GoalPosition = closestOne.HumanoidRootPart.Position;
			end
		else
			purpose = false;
		end
	end


	if not purpose then
		self.TargetPlayer = nil;
		--if self.ManualGoalReached then
		self.GoalPosition = self.GoalPosition or self:RandomPosition();
		--    self.ManualGoalReached = false;
		--else
		--self.GoalPosition = self:RandomPosition();
		--end
	end

	self.WalkingPurpose = purpose;
end



function zombieSvc:ClosestPlayer(): Model
	local plrs: {Player} = round:GetPlayers();
	local plr: Model = plrs[1] and plrs[1].Character or nil;

	local dist = MAX_DIST;

	for _,v: Player in pairs(plrs) do
		local hrp: Part = v.Character.HumanoidRootPart;
		local magnitude = (hrp.Position - self.hrp.Position).Magnitude
		local result = math.random(0,1)
		if ((result==0) and (magnitude < dist) or (magnitude <= dist)) then
			dist = magnitude;
			plr = v.Character;
		end
	end

	return plr, dist;
end


function zombieSvc:RandomPosition() --> If closest player not found
	local pos = self.hrp.Position + (self.hrp.CFrame.LookVector * math.random(2,10)) + Vector3.new(math.random(2,15),0,math.random(2,15));
	return pos;
end


function zombieSvc:Attack()
	if self.Resting then return; end
	if self.TargetPlayer then
		if (self.TargetPlayer.HumanoidRootPart.Position - self.hrp.Position).Magnitude <= self.Information.AttackDistance then
			self.AttackPromise():andThen(function()
				self.Resting = false;
			end)
		end 
	end
end


function zombieSvc:Kill()
	table.insert(zombieSvc.Corpses, self);
	if workspace.GameMap:FindFirstChild("Map") then
		self.Zombie.Parent = workspace.GameMap.Map;
	else
		--self.Zombie:Destroy();
	end
	
	self.Janitor:Destroy();
	for i,v: RBXScriptConnection in pairs(self.PathEvents or {}) do
		if typeof(v) == "RBXScriptConnection" then
			v:Disconnect();
		end
		self.PathEvents[i] = nil;
	end
	self.Path:Destroy();
	
	self.GarbageCollected = true -- this shouldnt be named like that but ye.
end


function zombieSvc:GarbageCollect()
	if not self.GarbageCollected then
		self.GarbageCollected = true;
		for i,v: RBXScriptConnection in pairs(self.PathEvents or {}) do
			if typeof(v) == "RBXScriptConnection" then
				v:Disconnect();
			end
			self.PathEvents[i] = nil;
		end
		self.Path:Destroy();
		self.Janitor:Destroy();
	end
	setmetatable(self, nil)
	for i,_ in pairs(self) do
		self[i] = nil;
	end
	self = nil;
end









function zombieSvc:RandomZombie(): string
	local map = round.ChosenMap;
	if not map then return nil; end
	local zombies = zombiesInfo[map]
	local probabilities = {}
	for i,v in pairs(zombies) do
		probabilities[i] = v.Rarity / 100;
	end

	local function pick()

		local sumaProbabilidades = 0
		for _, probabilidad in pairs(probabilities) do
			sumaProbabilidades = sumaProbabilidades + probabilidad
		end

		local numeroAleatorio = math.random()

		local acumulado = 0
		for token, probabilidad in pairs(probabilities) do
			acumulado = acumulado + probabilidad / sumaProbabilidades
			if numeroAleatorio <= acumulado then
				return token
			end
		end
	end

	return pick();
end



function zombieSvc.OnAttack(self: Zombie, player: Model)
	if self.GarbageCollected then
		return;
	end
	self.AttackAnimation:Play();
	task.delay(0.333, function()
		pcall(function()
			player.Humanoid:TakeDamage(self.Information.Damage);
		end)
	end)
end


function zombieSvc.OnRoundStarted(map: string)
	map = maps[map]
	if map.Mode == "ZombieHunt" then
		zombieSvc.InfectPromise = promise.new(function(resolve)
			local done = false;
			local conn = round.RoundEnded:Once(function()
				done = true;
			end)

			while task.wait() do
				if done then break; end
				if #zombieSvc.Zombies <= map.MaxZombies then
					task.wait(map.SpawnRate)
					for i = 1, math.random(1, map.MaxSpawn) do
						local zombie: Zombie
						local ok, err = pcall(function()
							zombie = zombieSvc.NewInfected(zombieSvc:RandomZombie(), 12, zombieSvc.OnAttack, 1, true)
						end)
						if not ok then
							continue;
						end
						if not zombie then
							continue;
						end
						if not zombie.Zombie then
							continue;
						end
						
						local spawn = workspace.Spawns.ZombieSpawns[map.Name]:GetChildren();
						zombie.Zombie:PivotTo(spawn[math.random(1, #spawn)].CFrame);
						
						zombie:Revive();
						table.insert(zombieSvc.Zombies, zombie);
					end
				else
					task.wait(1); --> dogshit?
				end 
			end

			resolve();

		end):andThen(function() --################# dogshit cleaning method?
			for i,v: Zombie in pairs(zombieSvc.Corpses) do
				--print(v);
				pcall(function()
					v:GarbageCollect();
				end)
				
				zombieSvc.Corpses[i] = nil;
				zombieSvc.Zombies[i] = nil;
			end
			for i,v: Zombie in pairs(zombieSvc.Zombies) do
				--print(v);
				pcall(function()
					v:GarbageCollect();
				end)
				zombieSvc.Zombies[i] = nil;
			end
			
			for _,v in pairs(workspace:GetChildren()) do
				local class = v:GetAttribute("Class");
				if (class == "Zombie") or (class == "Miniboss") then
					v:Destroy();
				end
			end
		end)
	end
end



function zombieSvc:KnitInit()

end

function zombieSvc:KnitStart()
	round = knit.GetService("RoundService");
	round.RoundStarted:Connect(zombieSvc.OnRoundStarted);
	print("ZombieProvider is ready")
end


return zombieSvc;