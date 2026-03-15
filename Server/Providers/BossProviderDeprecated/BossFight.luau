
local knit = require(game.ReplicatedStorage.Packages.Knit);


local boss = knit.CreateService({Name = "BossFight"})
boss.__index = boss

---Variables
local ServerStorage       = game:GetService("ServerStorage")
local ReplicatedStorage   = game:GetService("ReplicatedStorage")
local Boss 				  = script.Parent.BossClone["Mountain Guardian"]
local MapFolder 	   	  = workspace.GameMap

---Modules
local BossStatus  		  = require(script.Parent.BossBody)
local Round				  
local Attack 			  = require(script.Parent.AttackMoves)
local MapEdit 		  = require(script.Parent.MapEdit)
--local Player		      = require(game.ServerStorage.Modules.Players)
local Zone 				  = require(script.Parent.Zone)
local S 				  = require(game.ServerScriptService.Settings);
---Tables

local AnimationsID = {
	["Idle"] 		= "rbxassetid://"..S.BossSettings.Animations.Idle,
	["Walk"] 		= "rbxassetid://"..S.BossSettings.Animations.Walk,
	["Death"] 		= "rbxassetid://"..S.BossSettings.Animations.Death,
	["Spawn"] 	 	= "rbxassetid://"..S.BossSettings.Animations.Spawn,
	["GroundKick1"] = "rbxassetid://"..S.BossSettings.Animations.GroundKick1,
	["GroundKick2"] = "rbxassetid://"..S.BossSettings.Animations.GroundKick2,
	["GroundKick3"] = "rbxassetid://"..S.BossSettings.Animations.GroundKick3,
	["LaserIdle"] 	= "rbxassetid://"..S.BossSettings.Animations.LaserIdle,
	["Spike"] 	 	= "rbxassetid://"..S.BossSettings.Animations.Spike,
	["Tired"] 	 	= "rbxassetid://"..S.BossSettings.Animations.Tired,
	["MEGAKICK"]	= "rbxassetid://"..S.BossSettings.Animations.MegaKick,
	["BreakIn"]   	= "rbxassetid://"..S.BossSettings.Animations.BreakIn,
	["BreakOut"]   	= "rbxassetid://"..S.BossSettings.Animations.BreakOut,
	["KickPlayers"] = "rbxassetid://"..S.BossSettings.Animations.KickPlayers
}
--15510237925


export type AnimationName1 = "Death" | "Idle" | "Spawn" | "GroundKick" | "Laser"| "Spike" | "Tired"

export type Cooldowns = "Attack" | "Action" | "Break"

function boss.new(char)

	local self = {}

	self.Boss 	  	 	 = char or Boss:Clone()
	self.Animation 	     = Instance.new("Animation")
	self.Map		     = MapFolder
	self.OldMove 	     = 0
	self.NumberOfAttack  = 0
	self.TreeDestroyed   = false
	self.Cooldown	 	 = {Attack = 5 , Action = 5 , Break = 5}
	self.Targets 		 = {}

	return setmetatable(self,boss)
end

 
function boss:SpawnBoss()
	local HitBoxZone = Zone.new(self.Boss["Left Leg"].HitBox)
	local humanoid = self.Boss.Humanoid

	humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)


	humanoid.MaxHealth = (1000) + ((#Round:GetPlayers() - 1) * 425)
	humanoid.Health = humanoid.MaxHealth

	_G.Pause = true

	MapFolder.Map.Map["Boss Spawn"]:WaitForChild("Zone"):Destroy()
	BossStatus.HideCharacterParts(self.Boss,true)

	self.Boss:PivotTo(MapFolder:WaitForChild("Map").Map["Boss Spawn"]["Boss spawn part"].CFrame * CFrame.new(0,10,0))

	self.Boss.Parent = workspace

	task.delay(0.8,function()
		BossStatus.HideCharacterParts(self.Boss,false)
	end)

	local animSpawn:AnimationTrack = self:LoadAnimation1("Spawn")

	animSpawn:GetMarkerReachedSignal("Landing"):Connect(function()
		MapEdit:EnableParticleEmitter(MapFolder.Map.Map.slim,true)
		task.delay(1,function()
			MapEdit:EnableParticleEmitter(MapFolder.Map.Map.slim,false)
		end)
	end)

	animSpawn:Play()
	animSpawn.Stopped:Wait()
	

	_G.Pause = false

	self.Boss.Scripts.Main.Enabled = true

	for _,v in pairs(Round:GetPlayers())  do
		ReplicatedStorage.RemoteEvents.AllPlayersEvent.BossHP:FireClient(v,humanoid.Health,self.Boss.Name,humanoid.MaxHealth, true)
	end

	local connection 

	connection = humanoid.HealthChanged:Connect(function(heal)
		for _,v in pairs(Round:GetPlayers())  do
			if heal > 0 then
				ReplicatedStorage.RemoteEvents.AllPlayersEvent.BossHP:FireAllClients(humanoid.Health,   self.Boss.Name,humanoid.MaxHealth)
			end
		end

		if heal <= 0  then
		for _,v in pairs(Round:GetPlayers())  do
			ReplicatedStorage.RemoteEvents.AllPlayersEvent.BossHP:FireAllClients(0,   self.Boss.Name,humanoid.MaxHealth)
		end
			local Boss1 = BossStatus.GetBoss()
			--if not Boss1:IsDied() then

			--end
			Boss1:Freeze()
			Boss1:ChangeDeathStatus(true)
			Boss1:ChangeDamageStatus(false)
			coroutine.resume(coroutine.create(function()
				self:PlayAnimation("Death",true)
			end))

			connection:Disconnect()
			--_G.RewardTB:ChangeGlobalKey("Kill Boss")
			--_G.RewardTB:ChangeGlobalKey("Survived")
			_G.Pause = true

			--wait(7)

			--Round:RestRound(Round:CheckMode())


		end
	end)


	HitBoxZone.playerEntered:Connect(function(player)
		table.insert(self.Targets,player.Character)
		if  self:CooldownIsRunning("Action") then
			repeat
				task.wait(1)

			until self:CooldownIsFinished("Action")
		end
		self:RandomAction(3)
		
	end)

	HitBoxZone.playerExited:Connect(function(player)
		table.remove(self.Targets,table.find(self.Targets,player.Character))
		
	end)

end


--Make function thats make random attack for boss
function boss:Attack()
	if self.NumberOfAttack <= S.BossSettings.ManyNumberOfAttacksBeforeBreak then
		local Boss1 = BossStatus.GetBoss()
		if Boss1 then
			if not Boss1:IsAttacking() or not Boss1:IsDied() then

				Boss1:ChangeAttackStatus(true)
				--Boss1:EnableForceField()
				Boss1:ChangeBossStateTo("Attacking")
				local RandomNumber = math.random(1,3)
				if self.OldMove == RandomNumber then 
					repeat
						RandomNumber = math.random(1,3)
					until self.OldMove ~= RandomNumber
					--print("we choosed new Move no old move now")
					self.OldMove = RandomNumber 
					self:ChooseRandomMove(RandomNumber,Boss1)
				else 
					self.OldMove = RandomNumber 
					self:ChooseRandomMove(RandomNumber,Boss1)
				end



			end
		end
	end	
end


--Make Boss death function
function boss:PlayAnimation(AnimationName:AnimationName1,IsLooped)

	self.Animation.AnimationId =  AnimationsID[AnimationName]
	local AnimationTrack:AnimationTrack = self.Boss.Humanoid.Animator:LoadAnimation(self.Animation)
	AnimationTrack:Play()
	AnimationTrack.Looped = IsLooped
	if IsLooped  then

		return AnimationTrack
	else
		AnimationTrack.Stopped:Wait()
		return AnimationTrack
	end	
end

function boss:LoadAnimation1(AnimationName:AnimationName1)
	self.Animation.AnimationId =  AnimationsID[AnimationName]
	local AnimationTrack:AnimationTrack = self.Boss.Humanoid.Animator:LoadAnimation(self.Animation)

	return AnimationTrack
end


--Change Status
function boss:Death()
	self.Boss:SetAttribute("IsDead", true)
	self:PlayAnimation("Death",false)
end


--Make boss chase close player
function boss:ChasePlayer()
	local Boss1 = BossStatus.GetBoss()
	if not Boss1 then return end

	if not self.Boss:GetAttribute("Death") and not Boss1:IsAttacking()then
		if not Boss1:IsInBreak() then


			if not Boss1:IsTakingAction() then


				local ClosestPlayer = nil
				local Distance = math.huge

				for _, Player1 in pairs(game.Players:GetPlayers()) do

					if Player1.Character and Player1.Character:FindFirstChild("HumanoidRootPart")   then				
						local Magnitude = (self.Boss.HumanoidRootPart.Position - Player1.Character.HumanoidRootPart.Position).Magnitude

						if Magnitude < Distance then

							Distance = Magnitude
							ClosestPlayer = Player1
						end
					end
				end
				if not ClosestPlayer then return end
				
				self.Boss.Humanoid:MoveTo(ClosestPlayer.Character.HumanoidRootPart.Position)


			end
		end
	end	
end

--Make boss system that will make boss attack every 5 seconds
function boss:BossSystem()

	coroutine.resume(coroutine.create(function()
		while task.wait(0.2) do

			if BossStatus.GetBoss():IsDied() then break end
			if not BossStatus.GetBoss():IsInBreak() then 
				if not BossStatus.GetBoss():IsTakingAction()  then
					for _,v in pairs(MapFolder.Map.Destroyables:GetChildren())do

						if v.PrimaryPart then
							if (v.PrimaryPart.Position- self.Boss.PrimaryPart.Position).Magnitude <= S.BossSettings.DistanceBetweenTreeAndBossToKickIt --[[55--]] then
								MapEdit.New():VelocityTrees(v,self.Boss)
							end
						end

					end
				end
			end



		end
	end))
	coroutine.resume(coroutine.create(function()
		while task.wait(math.random(7,10)) --[[wait(math.random(9,15))--]] do
			if BossStatus.GetBoss():IsDied() then break end
			if not BossStatus.GetBoss():IsInBreak() then 
				if BossStatus.GetBoss():IsTakingAction()  then
					--print("Boss is doing random action now we put attack move on hold until finish")
					repeat
						task.wait(1)

					until not BossStatus.GetBoss():IsTakingAction() 
					--print("Boss can do attack move now")
				end
				if  self:CooldownIsRunning("Action") then
					repeat
						task.wait(1)

					until self:CooldownIsFinished("Action")
				end
				if self:CooldownIsRunning("Break") then
					repeat
						wait(4)

					until self:CooldownIsFinished("Break")
				end
				self:Attack()
			end


		end
	end))
	coroutine.resume(coroutine.create(function()
		while task.wait(6) --[[wait(math.random(9,15))--]] do
			if BossStatus.GetBoss():IsDied() then break end
			if not BossStatus.GetBoss():IsInBreak() then 
				if not BossStatus.GetBoss():IsAttacking() then
					if not self:CooldownIsRunning("Break") then
						if not BossStatus.GetBoss():IsTakingAction()  then
							self:RandomAction()
						end


					end

				end
			end



		end
	end))
end


function boss:ChooseRandomMove(RandomNumber,Boss1)

	--print(RandomNumber)
	if self.NumberOfAttack < S.BossSettings.ManyNumberOfAttacksBeforeBreak then 
		self.NumberOfAttack += 1
		if RandomNumber == 1 then

			Boss1:Freeze()
			local NumberOfAttack = S.BossSettings.AttackMoveSettings.GroundKick.NumberOfAttackGroundKick
			local Move = Attack.new()
			local GetPhysics = MapEdit.New()

			local PosAttackPoint =Move:GetLegPosition()
			local EventAnim = self:LoadAnimation1("GroundKick"..NumberOfAttack)

			EventAnim:GetMarkerReachedSignal("Kick"..NumberOfAttack):Connect(function()

				Move:GroundKickMove(PosAttackPoint)

			end)
			GetPhysics:DisableCanCollideTrees(Round.GetMap().Destroyables)
			EventAnim:Play()
			EventAnim.Stopped:Wait()

			Boss1:Unfreeze()
			Boss1:ChangeBossStateTo("Idle")
			Boss1:DisableForceField()
			Boss1:ChangeAttackStatus(false)
			GetPhysics:EnableCanCollideTrees(Round.GetMap().Destroyables)
			spawn(function()
				self:StartCoolDown("Attack",5)
			end)


		elseif RandomNumber == 2 then
			local Newmove = Attack.new()
			local GetPhysics = MapEdit.New()
			Boss1:SetSpeed(30)
			Boss1:MoveTo(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].Position)
			Boss1:RotateBoss()
			spawn(function()
				task.wait(2)
				Boss1:Teleport(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].CFrame * CFrame.new(0,40,0))

			end)
			task.wait(0.3)	
			GetPhysics:DisableCanCollideTrees(Round.GetMap().Destroyables)
			MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim2,true)
			MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim3,true)
			task.delay( S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToDisableParticleEmitter,function()
				MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim2,false)
				MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim3,false)	
			end)
			Newmove:PlatFormMove()



			local animation = self:PlayAnimation("LaserIdle",true)

			task.wait(S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToStartSpawnLaser)	 
			Newmove:LaserMove()
			task.wait(S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToRotateLaser)	
			Newmove:LaserRotate()
			task.wait(19)
			MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim2,true)
			MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim3,true)
			task.delay(S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToDisableParticleEmitter,function()
				MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim2,false)
				MapEdit:EnableParticleEmitter(Round.GetMap().Map.slim3,false)	
			end)
			Newmove:PlatformEnd()
			task.wait(4)

			animation:Stop()
			GetPhysics:EnableCanCollideTrees(Round.GetMap().Destroyables)

			Boss1:SetSpeed(11)
			Boss1:ChangeBossStateTo("Idle")
			Boss1:DisableForceField()
			Boss1:ChangeAttackStatus(false)
			--print("Laser")
			task.spawn(function()
				self:StartCoolDown("Attack",5)
			end)



		else 

			--print("Spikes")
			Boss1:SetSpeed(30)
			Boss1:MoveTo(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].Position)
			Boss1:Freeze()
			task.spawn(function()
				task.wait(2)
				Boss1:Teleport(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].CFrame* CFrame.new(0,40,0))

			end)
			local anim = self:PlayAnimation("Spike",true)
			for i = 1 , S.BossSettings.AttackMoveSettings.Spike.NumberOfSpikeToSpawn do
				task.wait(S.BossSettings.AttackMoveSettings.Spike.WaitTimeBetweenSpawn)
				Attack:SpawnZoneSpikes(i)
			end

			Attack:SpawnSpikes()
			task.wait(S.BossSettings.AttackMoveSettings.Spike.TimeBetweenSpawnAndRestSpike)
			Attack:ResetSpikes()
			task.wait(1.1)
			anim:Stop()
			--print("Finished")

			Boss1:Unfreeze()	
			Boss1:SetSpeed(11)
			Boss1:ChangeBossStateTo("Idle")
			Boss1:DisableForceField()
			Boss1:ChangeAttackStatus(false)
			--print("Spike")
			task.spawn(function()
				self:StartCoolDown("Attack",5)
			end)


		end


		if self.NumberOfAttack >= S.BossSettings.ManyNumberOfAttacksBeforeBreak  then
			if  self:CooldownIsRunning("Attack") then
				repeat
					task.wait(3)

				until self:CooldownIsFinished("Attack")
			end

			self.NumberOfAttack = 0
			Boss1:ChangeBreakStatus(true)

			Boss1:SetSpeed(30)
			Boss1:MoveTo(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].Position)
			Boss1:RotateBoss()
			Boss1:Freeze()
			task.spawn(function()
				task.wait(2)
				Boss1:Teleport(Round.GetMap().Map["Boss Spawn"]["Boss spawn part"].CFrame * CFrame.new(0,40,0))
				
			end)
			
			local oldposition = Round.GetMap().Map["Boss Spawn"].block.Position


			Round.GetMap().Map["Boss Spawn"].block.Position = Round.GetMap().Map["Boss Spawn"].block.Position * Vector3.new(0,-30,0)
			Boss1:Freeze()
			Boss1:ChangeBossStateTo("Break")
			local anim = self:PlayAnimation("BreakIn",true)
			
			game.ServerStorage.EventsGame.DamageMultiplier.Value = 2
			task.delay(S.BossSettings.TimeBetweenBreakinAndBreakOut,function()
				if not Boss1:IsDied()then
					--print("Boss finished break ")
					anim:Stop()
					self:PlayAnimation("BreakOut", false)
					game.ServerStorage.EventsGame.DamageMultiplier.Value = 1

					MapEdit:VelocityPlayers(Boss1:GetBossMap())
					--task.delay(1,function()
					--	for i,v in pairs(Round:GetPlayers())do
					--		ReplicatedStorage.RemoteEvents.AllPlayersEvent.DisableControls:FireClient(v.Value)
					--	end
					--end)


					Boss1:SetSpeed(11)
					Boss1:ChangeBossStateTo("Idle")
					Boss1:ChangeBreakStatus(false)
					Boss1:Unfreeze()
					task.delay(3,function()
						Round.GetMap().Map["Boss Spawn"].block.Position = oldposition	

					end)
					task.spawn(function()
						self:StartCoolDown("Break",5)
					end)
				end
				



			end)
		end
	end
end

function boss:RandomAction(num)
	if self.NumberOfAttack >= S.BossSettings.ManyNumberOfAttacksBeforeBreak or BossStatus.GetBoss():IsInBreak() then	return	end
	local RandomAction = num or math.random(1,2)

	if RandomAction == 1  then
		if not self.TreeDestroyed then
			self.TreeDestroyed = true

			local Boss1 = BossStatus.GetBoss()
			Boss1:ChangeBossStateTo("Attacking")
			Boss1:ChangeActionStatus(true)
			Boss1:Freeze()
			local EventAnim = self:LoadAnimation1("MEGAKICK")

			EventAnim:GetMarkerReachedSignal("ChargedLeg"):Connect(function()
				MapEdit:EnableParticleEmitter(self.Boss["Left Leg"],true)
			end)

			EventAnim:GetMarkerReachedSignal("MEGAKICK"):Connect(function()
				local oldCFrame = self.Boss.HumanoidRootPart.CFrame
				MapEdit:EnableParticleEmitter(self.Boss["Left Leg"],false)

				-- Player.CamShakePlayers("Start",1)
				if ____ then
					
				end
				for _,v in pairs(MapFolder.Map.Destroyables:GetChildren())do


					MapEdit.New():ActionVelocityTree(v,Boss1:GetBossMap())

				end
				self.Boss.HumanoidRootPart.CFrame = oldCFrame

			end)

			EventAnim:Play()
			EventAnim.Stopped:Wait()
			Boss1:Unfreeze()
			Boss1:ChangeBossStateTo("Idle")
			Boss1:DisableForceField()
			Boss1:ChangeActionStatus(false)
			task.spawn(function()
				self:StartCoolDown("Action",5)
			end)



		end
	end
	if RandomAction == 3 then
		if  #self.Targets >= 1 then
			--if self:CooldownIsFinished("Action") then
			if not BossStatus.GetBoss():IsDied() then
				if not BossStatus.GetBoss():IsAttacking()then
					
				
		
					if not BossStatus.GetBoss():IsInBreak() then 

						local Boss1 = BossStatus.GetBoss()
						Boss1:ChangeBossStateTo("Attacking")
						Boss1:ChangeActionStatus(true)
						Boss1:Freeze()
						local EventAnim = self:LoadAnimation1("KickPlayers")

						EventAnim:GetMarkerReachedSignal("PlayerYEET"):Connect(function()

							MapEdit:VelocityPlayers(Boss1:GetBossMap(),self.Targets)

						end)

						EventAnim:Play()
						EventAnim.Stopped:Wait()
						Boss1:Unfreeze()
						Boss1:ChangeBossStateTo("Idle")
						Boss1:DisableForceField()
						Boss1:ChangeActionStatus(false)
						task.spawn(function()
							self:StartCoolDown("Action",3)
						end)
					end
				end
			end
			--end
		end

	end
end

function boss:StartCoolDown(Name:Cooldowns,Value)

	if self.Cooldown[Name]  then
		--print("Cooldown Started for "..Name)
		self.Cooldown[Name] = Value
		repeat
			wait(1)
			self.Cooldown[Name] -= 1 
		until self.Cooldown[Name] <= 0

		--print("Cooldown Finished for "..Name)
	end
end

function boss:GetCooldown(Name:Cooldowns)
	return self.Cooldown[Name]
end

function boss:CooldownIsFinished(Name:Cooldowns)
	--print(self.Cooldown[Name])
	--print(self.Cooldown[Name] <= 0 and self.Cooldown[Name] < 5)
	return self.Cooldown[Name] <= 0 

end

function boss:CooldownIsRunning(Name)
	return self.Cooldown[Name] < 5
end

function boss:DebugAttack(num)
	local Boss1 = BossStatus.GetBoss()
	Boss1:ChangeAttackStatus(true)
	--Boss1:EnableForceField()
	Boss1:ChangeBossStateTo("Attacking")
	boss.new(Boss1:GetBossMap()):ChooseRandomMove(num,Boss1)
end

function boss:KnitStart()
	Round = knit.GetService("RoundService")
	warn("BossFightModule is deprectated, consider deleting and rewriting it ASAP.");
	print("BossFightModule (legacy version) started")
end



return boss
