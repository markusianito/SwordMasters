--[[######################################################################################################################################																																
 _______    ___      .______    __   _______   ___________    ____	  _______      ___      .___  ___.  _______     _______. 
|   ____|  /   \     |   _  \  |  | |       \ |   ____\   \  /   /	 /  _____|    /   \     |   \/   | |   ____|   /       |  
|  |__    /  ^  \    |  |_)  | |  | |  .--.  ||  |__   \   \/   / 	|  |  __     /  ^  \    |  \  /  | |  |__     |   (----` 
|   __|  /  /_\  \   |   _  <  |  | |  |  |  ||   __|   \      /  	|  | |_ |   /  /_\  \   |  |\/|  | |   __|     \   \ 
|  |    /  _____  \  |  |_)  | |  | |  '--'  ||  |____   \    /   	|  |__| |  /  _____  \  |  |  |  | |  |____.----)   |  
|__|   /__/     \__\ |______/  |__| |_______/ |_______|   \__/       \______| /__/     \__\ |__|  |__| |_______|_______/                                                               
                                                                                                                                                                                            	 
MIT License

Copyright © 2024 FabiDev Games

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.     

____    ____  __       ___       ___  
\   \  /   / /_ |     / _ \     |__ \ 
 \   \/   /   | |    | | | |       ) |
  \      /    | |    | | | |      / / 
   \    /     | |  __| |_| |  __ / /_ 
    \__/      |_| (__)\___/  (__)____|

 _______   ______     ______  __    __  .___  ___.  _______ .__   __. .___________.    ___   .___________. __    ______   .__   __. 
|       \ /  __  \   /      ||  |  |  | |   \/   | |   ____||  \ |  | |           |   /   \  |           ||  |  /  __  \  |  \ |  | 
|  .--.  |  |  |  | |  ,----'|  |  |  | |  \  /  | |  |__   |   \|  | `---|  |----`  /  ^  \ `---|  |----`|  | |  |  |  | |   \|  | 
|  |  |  |  |  |  | |  |     |  |  |  | |  |\/|  | |   __|  |  . `  |     |  |      /  /_\  \    |  |     |  | |  |  |  | |  . `  | 
|  '--'  |  `--'  | |  `----.|  `--'  | |  |  |  | |  |____ |  |\   |	  |  |     /  _____  \   |  |     |  | |  `--'  | |  |\   |  
|_______/ \______/   \______| \______/  |__|  |__| |_______||__| \__|	  |__|    /__/     \__\  |__|     |__|  \______/  |__| \__|        
                                                                     
	Greetings, user! Using this module is actually very simple!
	
	To start :
	-> To test the ai, apply it on a rig!
	
	local AIModule = \path to module\   			(eg : require(game.ReplicatedStorage["Artificial Intelligence"].AttackingNPC))
	local Rig 	   = \path to rig\ 					(eg : workspace.Rig)
	local NPC      = AIModule.new(workspace.Rig)
	
	-> The code above uses the default settings.
	-> Now, if you want custom settings to your new NPC you can use this :
	
	local NpcSettings = {
		walkSpeed 						=  16,											|		--WALK SPEED of the NPC
		health 							=  100,											|		--HEALTH of the NPC												
		sightRadius 					=  100,											|		--HOW FAR can the NPC SEE
		combatDistance 					=  5,											|		--HOW CLOSE the NPC must be to ATTACK
		canSeeThruTag				    =  "SEE_THRU_AI",  								|		--The NPC will SEE THRU objects TAGGED with this
		useEyeSight						=  false,										|		--Give the NPC the ABILTY TO USE FOV (HUMAN VISION)
		damageRate 						=  2,											|		--COOLDOWN before the NPC can HIT AGAIN
		damage 							=  10,											|		--DAMAGE the npc can deal
		canJump 						=  true,										|		--Give the NPC the ABILITY TO JUMP
		canClimb 						=  true,										|		--Give the NPC the ABILITY TO CLIMB
		destroyAfterDeath 				=  true,										|		--DESTROY the NPC AFTER DEATH
		timeToDestroyAfterDeath 		=  2,											|		--TIME BEFORE the NPC IS DESTROYED after death
		attackFunction = function(_enemyCharacter : Model, _walkingToPosition : Vector3)|       --WHAT will THE NPC do WHEN HE ATTACKS
			print("Attack!")															|
		end,																			|
		animations = {																	|		--ANIMATION IDS
			climb 		=  180436334,													|
			fall 		=  180436148,													|
			idle1		=  180435571,													|
			idle2 		=  180435792,													|
			jump 		=  125750702,													|
			run			=  180426354,													|
			sit 		=  178130996,													|
			toolnone 	=  182393478,													|
			walk 		=  180426354,													|
		}
	}
	
	###########
	
	_enemyCharacter -> Is the current enemy that the AI is locked onto, stored as a character
	_walkingToPosition - > Is the current position that the AI is walking to, stored as a vector3
	
	NPC.OnDeath.Event:Connect(function(...)
		print("Rig just died! :d")
	end)
	
	-> The function above calls when the rig died, for a simplier connection.
	###########
	
	-> These are all the current settings that can be customized.
	-> You're not obligated to change them all.
	-> For example you can change only the walk speed of the npc , leaving the other settings default :
	
	local NpcSettings = {
		walkSpeed =  24,
	}
	-> After you're done customizing your settings , to call it simply :
	
	local NPC = AIModule.new(workspace.Rig, NpcSettings)
	
	-> That's it! Enjoy!
--[[######################################################################################################################################]]
--[[
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local CollectionService = game:GetService("CollectionService")
local PathfindingService = game:GetService("PathfindingService")
local TweenService = game:GetService("TweenService")

local Promise = require(script.Packages.Promise)

functionBank = {
	["isRig"] = function(rig)
		if not rig:IsA("Model") then return false end
		if not rig:FindFirstChild("HumanoidRootPart") then return false end
		for _, v in pairs(rig:GetChildren()) do
			if v.Name == "Humanoid"  then return true end
		end
		return false
	end;

	["getCharacters"] = function()
		local chars = { }
		for _, plr in pairs(Players:GetPlayers()) do
			table.insert(chars, plr.Character)
		end
		return chars
	end;

	["getDistance"] = function(part1, part2)
		return (part1.Position - part2.Position).magnitude
	end;

	["getCloserDistance"] = function(partTable, part, players)
		local minDist, index = math.huge, -1
		if players then
			for i, v in pairs(partTable) do
				local dist = functionBank.getDistance(v.HumanoidRootPart, part)
				if dist <= minDist then
					minDist = dist
					index = i
				end
			end
			return minDist, index
		end
		for i, v in pairs(partTable) do
			local dist = functionBank.getDistance(v, part)
			if dist <= minDist then
				minDist = dist
				index = i
			end
		end
		return minDist, index
	end;

	["isRigDead"] = function(rig)
		if rig.Humanoid.Health <= 0 then
			return true
		end
		return false
	end;

	["isInSight"] = function(part1 : other, part2 : enemyHead, settings)
		if not settings.useEyeSight then
			return true
		else
			local direction = part1.Position - part2.Position

			local rigLook = part2.CFrame.LookVector

			local dotProduct = direction.Unit:Dot(rigLook)

			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = {
				CollectionService:GetTagged(settings.canSeeThruTag)
			}
			local canSee = true

			local raycastResult = Workspace:Raycast(part2.Position, direction, params)
			if raycastResult and raycastResult.Instance then
				if raycastResult.Instance:IsDescendantOf(part1.Parent) then
					canSee = true
				else
					canSee = false
				end
			end
			if dotProduct > 0.5 and canSee then
				return true
			end
			return false
		end
	end;

	["getVectorDistanceBetweenTwoPoints"] = function(vector1, vector2)
		return math.sqrt(math.pow((vector1.X-vector2.X),2) + math.pow((vector1.Y-vector2.Y),2) + math.pow((vector1.Z-vector2.Z),2))
	end;
}

local AI = {}
AI.__index = AI

function AI.new(rig : Rig, _settings : Table)
	if not _settings then _settings = {animations = {}} else assert(typeof(_settings) == "table", "TYPE OF SETTINGS IS NOT A TABLE!") end
	if not _settings.animations then _settings.animations = { } end
	
	local self = setmetatable({}, AI)
	self.OnDeath = Instance.new("BindableEvent")
	self.OnDeath.Name = string.format("%s Died Connection", rig:GetFullName())
	self.OnDeath.Parent = script.Bin
	self.settings = {
		walkSpeed = _settings.walkSpeed or 16,
		health = _settings.health or 100,
		sightRadius = _settings.sightRadius or 100,
		combatDistance = _settings.combatDistance or 5,
		canSeeThruTag = _settings.canSeeThruTag or "SEE_THRU_AI",  
		useEyeSight = _settings.useEyeSight or false,
		damageRate = _settings.damageRate or 2,
		damage = _settings.damage or 10,
		canJump = _settings.canJump or true,
		canClimb = _settings.canClimb or true,
		destroyAfterDeath = _settings.destroyAfterDeath or true,
		timeToDestroyAfterDeath = _settings.timeToDestroyAfterDeath or 2,
		attackFunction = _settings.attackFunction or function(_enemyCharacter : Model, _walkingToPosition : Vector3)
			warn("Make sure to change the attack function setting!")
		end,
		animations = {
			climb = _settings.animations.climb or 180436334,
			fall = _settings.animations.fall or 180436148,
			idle1 = _settings.animations.idle1 or 180435571,
			idle2 = _settings.animations.idle2 or 180435792,
			jump = _settings.animations.jump or 125750702,
			run = _settings.animations.run or 180426354,
			sit = _settings.animations.sit or 178130996,
			toolnone = _settings.animations.toolnone or 182393478,
			walk = _settings.animations.walk or 180426354,
		}
	}
	
	
	
	self.rig = rig
	self.humanoidRootPart = rig:WaitForChild("HumanoidRootPart")
	self.humanoid = rig:WaitForChild("Humanoid")
	self.humanoid.WalkSpeed = self.settings.walkSpeed
	self.humanoid.MaxHealth = self.settings.health
	self.humanoid.Health = self.settings.health
	self.isInState = false
	self.isRigDestroying = false
	self.isRigDead = false
	self.canWalk = true
	self.walkToPositionValue = Instance.new("Vector3Value")
	self.moveto = Vector3.zero;
	self:setupAnims()
	
	self.EnemyNotFoundHandler = RunService.Stepped:Connect(function()
		if not self.foundEnemy then
			--print("enemy not found");
			local hrp:Part = self.humanoidRootPart
			local val = self.walkToPositionValue.Value;
			self.walkToPositionValue.Value = Vector3.new(
				val.X + math.random(-100,100),
				hrp.Position.Y,
				val.Z + math.random(-100,100)
			)
			self.humanoid:Move(self.walkToPositionValue.Value);
		end
	end)
	
	return self
end

function AI:setupAnims()
	local anims = script:WaitForChild("Animate"):Clone()
	anims.climb.ClimbAnim.AnimationId = "rbxassetid://"..self.settings.animations.climb
	anims.fall.FallAnim.AnimationId = "rbxassetid://"..self.settings.animations.fall
	anims.idle.Animation1.AnimationId = "rbxassetid://"..self.settings.animations.idle1 
	anims.idle.Animation2.AnimationId = "rbxassetid://"..self.settings.animations.idle2 
	anims.jump.JumpAnim.AnimationId = "rbxassetid://"..self.settings.animations.jump
	anims.run.RunAnim.AnimationId ="rbxassetid://".. self.settings.animations.run
	anims.sit.SitAnim.AnimationId = "rbxassetid://"..self.settings.animations.sit 
	anims.toolnone.ToolNoneAnim.AnimationId = "rbxassetid://"..self.settings.animations.toolnone
	anims.walk.WalkAnim.AnimationId = "rbxassetid://"..self.settings.animations.walk
	
	anims.Parent = self.rig
end

function AI:Start(checkEnemies : boolean)
	task.spawn(function()
		local function Died()
			self.OnDeath:Fire()
			self.isRigDead = true
			if self.settings.destroyAfterDeath then
				task.wait(self.settings.timeToDestroyAfterDeath)
				self:CleanUp()
			end
		end

		local function Destroying()
			self:CleanUp()
		end

		self.DestroyingConnection = self.rig.Destroying:Connect(Destroying)
		self.RigDiedConnection =  self.humanoid.Died:Connect(Died)
		self:checkForEnemiesLoop()
		self:walkToLoop()
	end)
end

function AI:attack()
	if self.attacking == true or self.isRigDestroying == true or self.isRigDead == true then return end
	self.attacking = true
	self.attackPromise = Promise.new(function(resolve, reject, onCancel)
		self:walkToLoop(true)
		self.settings.attackFunction(self.currentEnemy, self.walkToPositionValue.Value)
		task.wait(self.settings.damageRate)
		self.attacking = false
		self:walkToLoop()
	end)
end

function AI:checkStates()
	if self.isInState == true then return false end
	self.isInState = true;
	self.canWalk = true
	local distance =  functionBank.getDistance(self.currentEnemy.HumanoidRootPart, self.humanoidRootPart)
	if distance <= self.settings.combatDistance then
		self:attack()
	end
	self.canWalk = true
	self.isInState = false
end


-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------- ERROR FROM HERE:


function AI:walkToLoop(stop : boolean)
	if stop then
		self.isWalking = false
		return
	end
	self.isWalking = true
	local debounce = false
	local path = PathfindingService:CreatePath({
		AgentHeight = 6,
		AgentRadius = 3,
		AgentCanJump = self.settings.canJump, 
		AgentCanClimb = self.settings.canClimb,
		Costs = {
			Water = 100,
			DangerZone = math.huge
		},
	})
	local waypoints
	local nextWaypointIndex
	local reachedConnection
	local blockedConnection
	
	local function followPath(destination)

		local success, errorMessage = pcall(function()
			path:ComputeAsync(self.rig.PrimaryPart.Position, destination)
		end)
		if not self.humanoid then return end
		self.humanoid.WalkSpeed = self.settings.walkSpeed
		if success and path.Status == Enum.PathStatus.Success then
			waypoints = path:GetWaypoints()

			blockedConnection = path.Blocked:Connect(function(blockedWaypointIndex)
				if blockedWaypointIndex >= nextWaypointIndex then
					if blockedConnection then
						blockedConnection:Disconnect()
					end
					followPath(destination)
					blockedConnection = nil;
				end
			end)
			
			
			if not reachedConnection then
				reachedConnection = self.humanoid.MoveToFinished:Connect(function()
					if nextWaypointIndex < #waypoints then
						nextWaypointIndex += 1
						self.moveto = waypoints[nextWaypointIndex].Position
						self.humanoid:MoveTo(self.moveto)
						
						reachedConnection:Disconnect();
						reachedConnection = nil;
					end
				end)
			end
			nextWaypointIndex = 2
			self.humanoid:MoveTo(waypoints[nextWaypointIndex].Position);
		else
			--warn("Path not computed!", errorMessage)
		end
	end
	
	
	local succ, err = pcall(function()
		local p:Part = self.humanoidRootPart
		p:SetNetworkOwner(nil)
	end)
	
	if not succ then
		warn("fabi_npc_ai line 391", err);
		
	end
	
	
	while task.wait() do
		if  self.isRigDestroying == true or self.isRigDead == true then break end
		if self.isRigDestroying == false then
			followPath(self.walkToPositionValue.Value)
		end
		
	end
end

----------------------------------------------------------------------------------------------------- UNTIL HERE.
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------




function AI:checkRadius(get : boolean)
	local enemies = { }
	for _, v in pairs(functionBank.getCharacters()) do
		if functionBank.getDistance(v.HumanoidRootPart, self.humanoidRootPart) <= self.settings.sightRadius then
			if (Players:GetPlayerFromCharacter(v)) and functionBank.isInSight(v.Head, self.rig.Head, self.settings) then
				table.insert(enemies, v)
			end
		end
	end
	if get then
		return enemies
	end
end

function AI:checkForEnemiesLoop(stop : boolean)
	if stop then
		if self.checkForEnemiesFunction then
			self.checkForEnemiesFunction:Disconnect()
		end
		self.isCheckingForEnemies = false
		return
	end
	self.isCheckingForEnemies = true
	local debounce = false
	local function HeartBeat(dt)
		if debounce == true or self.isCheckingForEnemies == false or self.isRigDestroying == true or self.isRigDead == true then return end
		debounce = true
		local enemies = self:checkRadius(true)
		if #enemies > 0 then
			local targetDistance, index = functionBank.getCloserDistance(enemies, self.humanoidRootPart, true)
			if targetDistance < math.huge and index > 0 then
				if not functionBank.isRigDead(enemies[index]) then
					self.foundEnemy = true
					self.currentEnemy = enemies[index]
					
					if self.currentEnemy.Humanoid.MoveDirection.Magnitude > 0 then
						self.walkToPositionValue.Value = self.currentEnemy.HumanoidRootPart.Position + (self.currentEnemy.HumanoidRootPart.CFrame.LookVector * (math.random(69,81) / 10))
					else
						self.walkToPositionValue.Value = self.currentEnemy.HumanoidRootPart.Position
					end
					self:checkStates()
					if self.isDashing == false then
						self.humanoidRootPart.CFrame = CFrame.lookAt(self.humanoidRootPart.Position, enemies[index].PrimaryPart.Position, self.humanoidRootPart.CFrame.UpVector)
					end
				else
					self.foundEnemy = false
				end
			else
				self.foundEnemy = false
			end
		else
			self.foundEnemy = false
		end
		debounce = false
	end
	self.checkForEnemiesFunction = RunService.Stepped:Connect(HeartBeat)
end

function AI:CleanUp()
	self.isRigDestroying = true
	self:checkForEnemiesLoop(true)
	self:walkToLoop(true)
	self.walkToPositionValue:Destroy()
	self.OnDeath:Destroy()
	if self.attackPromise then
		self.attackPromise:cancel()
	end
	if self.RigDiedConnection then
		self.RigDiedConnection:Disconnect()
	end
	if self.DestroyingConnection then
		self.DestroyingConnection:Disconnect()
	end
	if self.EnemyNotFoundHandler then
		self.EnemyNotFoundHandler:Disconnect()
	end
	self.EnemyNotFoundHandler = nil;
	pcall(function()
		if self.rig then
			self.rig:Destroy()
		end
	end)
	
	setmetatable(self, nil)
	table.clear(self)
	self = nil;
end

return AI]]

