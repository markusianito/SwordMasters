
local Attack = {}
Attack.__index = Attack
local Tween = game:GetService("TweenService")
local Boss = require(script.Parent.BossBody)
local Zone = require(script.Parent.Zone)
local S   = require(game.ServerScriptService.Settings)

--function tween model


function Attack.new(move)
	local self = {}
	self.Move = move

	return setmetatable(self,Attack)
end

function Attack:TweenModel(model, goal, duration,WaitUntilStop)
	local tweenInfo = TweenInfo.new(duration)
	local tween = Tween:Create(model, tweenInfo, goal)
	tween:Play()
	if WaitUntilStop then
		tween.Completed:Wait()
	end
end




-------LaserMove Attack
function Attack:PlatFormMove()
	if workspace.GameMap:FindFirstChild("Map") then
		local map:Folder = workspace.GameMap.Map
		-- tween laser platform'
		if S.BossSettings.AttackMoveSettings.LaserAttack.CamShakePlayers then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v:GetAttribute("IsInRound") then
					game.ReplicatedStorage.RemoteEvents.AllPlayersEvent.Camshake:FireClient(v,"Start",S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToStopCamShake)
				end
			end
		end
		
		for _,v in pairs(map.Map.BossPlatform:GetDescendants()) do
			if v:IsA("BasePart") then
				for _,m in pairs(map.Map.ClonePlatform:GetDescendants()) do
					if m:IsA("BasePart") then
						if v.Name == m.Name then	
							Attack:TweenModel(v,{CFrame = m.CFrame},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToTweenSizeOfPlatform)		
						end
					end
				end
			end
		end
		
	end


end

--function get platform to back position
function Attack:PlatformEnd()
	if workspace.GameMap.Map then
		
		local map:Folder = workspace.GameMap.Map
		if S.BossSettings.AttackMoveSettings.LaserAttack.CamShakePlayers then
			for _,v in pairs(game.Players:GetPlayers()) do
				if v:GetAttribute("IsInRound") then
					game.ReplicatedStorage.RemoteEvents.AllPlayersEvent.Camshake:FireClient(v,"Start",S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToStopCamShake)
				end
			end
		end
		for _,v in pairs(map.Map.BossPlatform:GetDescendants()) do
			if v:IsA("BasePart") then
				for _,m in pairs(map.Map.BackPlatform:GetDescendants()) do
					if m:IsA("BasePart") then
						if v.Name == m.Name then
							Attack:TweenModel(v,{CFrame = m.CFrame},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToTweenSizeOfPlatform)
						end
					end
				end
			end
		end
	end
end






--function tweenlaser part to size
function Attack:LaserMove()
	if not workspace.GameMap:FindFirstChild("Map") then return end
	local map:Folder = workspace.GameMap.Map
	-- tween laser platform'
	for _,v in pairs(map.Map.BossPlatform:GetDescendants()) do
		if v:IsA("BasePart") then
			for _,m in pairs(map.Map.ClonePlatform:GetDescendants()) do
				if m:IsA("BasePart") then
					if v.Name == m.Name and v.Name == "Laser1" or v.Name == "Laser2" then	
						Attack:TweenModel(v,{Size = m.Size},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToFinalSizeLaser)		
					end
				end
			end
		end
	end

end




--function rotate laser for 10 secs and increase speed every sec
function Attack:LaserRotate()
	if not workspace.GameMap:FindFirstChild("Map") then return end
	local map:Folder = workspace.GameMap.Map
	local laser1 = map.Map.BossPlatform.Lasers.Laser1
	local laser2 = map.Map.BossPlatform.Lasers.Laser2
	local laser1CFrame = laser1.CFrame
	local laser2CFrame = laser2.CFrame	
	_G.Time = S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToStopRotateLaser
	_G.partspeed = 0.02 -- speed of the spin
	local connection 

	Attack:EnableDamageForLaser()
	local AnimationRotate = coroutine.create(function()
		--repeat
		--	wait(0.00001)* 
		--	
		--until Time >= 15
		connection = game:GetService("RunService").Heartbeat:Connect(function(delta)
			Attack:TweenModel(laser1,{CFrame = laser1.CFrame * CFrame.Angles(0,_G.partspeed,0)},delta,false)
			Attack:TweenModel(laser2,{CFrame = laser2.CFrame * CFrame.Angles(0,_G.partspeed,0)},delta,true)
			--laser1.CFrame = laser1.CFrame * CFrame.Angles(0,partspeed,0) -- the spin of the part
			--laser2.CFrame = laser2.CFrame CFrame.Angles(0,partspeed,0)
			if _G.Time <= 1  then
				connection:Disconnect()
			end
		end)
	end)


	local IncreaseSpeed = coroutine.create(function()
		repeat
			task.wait(1)
			_G.Time-=1
			_G.partspeed +=S.BossSettings.AttackMoveSettings.LaserAttack.IncreaseSpeedEverySecond
		until _G.Time <= 1
	end)

	local slowdown = coroutine.create(function()
		task.wait(S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToStopRotateLaser-1)
		Attack:TweenModel(laser1,{CFrame = laser1CFrame},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToFinalSizeLaser)
		Attack:TweenModel(laser2,{CFrame = laser2CFrame},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToFinalSizeLaser)
		Attack:DisabledDamageForLaser()
		task.wait(S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToTweenSizeOfPlatform)
		Attack:TweenModel(laser1,{Size = Vector3.new(0,0,0)},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToFinalSizeLaser)
		Attack:TweenModel(laser2,{Size = Vector3.new(0,0,0)},S.BossSettings.AttackMoveSettings.LaserAttack.WaitTimeToFinalSizeLaser)

	end)

	coroutine.resume(AnimationRotate)
	coroutine.resume(IncreaseSpeed)
	coroutine.resume(slowdown)

end

function Attack:EnableDamageForLaser()
	local map:Folder = workspace.GameMap.Map
	map.Map.BossPlatform.Lasers.Event.Enabled = true

end

function Attack:DisabledDamageForLaser()
	if not workspace.GameMap:FindFirstChild("Map") then return end
	local getboss = Boss.GetBoss()
	if not getboss then	return end
	local map:Folder = workspace.GameMap.Map
	map.Map.BossPlatform.Lasers.Event.Enabled = false

end



---GroundKickMove 
function Attack:GetLegPosition()
	local boss = Boss.GetBoss():GetBossMap()
	local LegCframe = boss["Left Leg"].Part.CFrame
	return LegCframe
end

function Attack:ChangeDirctionLeg(Target,old)
	if old then
		local boss = Boss.GetBoss():GetBossMap()
		boss["Left Leg"].Part.CFrame = old
	end
	if Target  then
		local boss = Boss.GetBoss():GetBossMap()
		boss["Left Leg"].Part.CFrame = CFrame.lookAt(boss["Left Leg"].Part.Position , Target.Position)
	
	end
	
end 

function Attack:GroundKickMove(pos)
	local Wave = script.Parent.AttackAction["Ground kick"].Soundwave.Soundwave:Clone()
	Wave.Parent = workspace.GameMap.Map.Debris
	Wave.Event.Enabled = true
	Wave.CFrame = pos

	Attack:TweenModel(Wave,{Size = S.BossSettings.AttackMoveSettings.GroundKick.GroundKickFinalSize},S.BossSettings.AttackMoveSettings.GroundKick.WaitTimeToTweenSize)
	Attack:TweenModel(Wave,{Transparency = 1},S.BossSettings.AttackMoveSettings.GroundKick.WaitTimeToTransparency)
	game.Debris:AddItem(Wave,S.BossSettings.AttackMoveSettings.GroundKick.WaitTimeToRemoveMove)



end

--Spikes
function Attack:SpawnZoneSpikes()

	local container = workspace.GameMap.Map.Zones
	local zone = Zone.new(container)


	local intersectionVector
	repeat
		local randomVector, touchingParts = zone:getRandomPoint()
		local rayOrigin = randomVector + Vector3.new(0, 1, 0)
		local raycastParams = RaycastParams.new()
		raycastParams.FilterDescendantsInstances = touchingParts
		raycastParams.FilterType = Enum.RaycastFilterType.Include
		local raycastResult = workspace:Raycast(rayOrigin, Vector3.new(0, -5, 0), raycastParams)
		intersectionVector = (raycastResult and raycastResult.Position)
	until intersectionVector
	local clone = script.Parent.AttackAction.Spikes.Attackzone.Attackzone:Clone()
	clone.Name = #workspace.GameMap.Map.Debris.Zone:GetChildren().."Spike"
	clone.CFrame =  CFrame.new(intersectionVector + Vector3.new(0, -0.2, 0)) *  CFrame.Angles(0,math.rad(90),math.rad(90))

	clone.Spike.CFrame =  CFrame.new(intersectionVector + Vector3.new(0, -7, 0)) 


	clone.Parent = workspace.GameMap.Map.Debris.Zone
	clone.Touched:Connect(function(hit)
		if hit:GetAttribute("IsSpike") then
			hit:Destroy()

		end
		if hit:GetAttribute("DestoryableSpikes") then

			Attack:TweenModel(hit,{CFrame = hit.CFrame * CFrame.new(0,-9,0)},0.5)
			task.spawn(function()
				wait(0.7)
				hit:Destroy()
			end)

		end
	end)

	clone.Transparency = 0 


	local Debounce = {["Spike"] = {}}
	Debounce[clone.Name] = {}
	local connection = nil
	connection =  clone.Spike.Touched:Connect(function(hit)
		--i want to damage player

		if hit.Parent:FindFirstChild("Humanoid") and game.Players:FindFirstChild(hit.Parent.Name) then
			if Debounce[clone.Name][hit.Parent] == nil then
				Debounce[clone.Name][hit.Parent] = true
				hit.Parent.Humanoid:TakeDamage(30)

				task.spawn(function()
					task.wait(1)
					Debounce[clone.Name][hit.Parent] = nil
				end)	
			end
		end
		if hit:GetAttribute("DestoryableSpikes") then
			Attack:TweenModel(hit,{CFrame = hit.CFrame * CFrame.new(0,-9,0)},0.5)
			task.spawn(function()
				task.wait(0.7)
				connection:Disconnect()
				hit:Destroy()
			end)

		end

	end)
end

---Function task.spawn spikes
function Attack:SpawnSpikes()
	if not workspace.GameMap.Map then return end
	for _,v in pairs(workspace.GameMap.Map.Debris.Zone:GetChildren())do
		Attack:TweenModel(v,{Transparency = 1},0.2)
		task.spawn(function()
			task.wait(S.BossSettings.AttackMoveSettings.Spike.TimeBetweenPointAndSpikeToSpawn)
			Attack:TweenModel(v.Spike,{CFrame = v.Spike.CFrame * CFrame.new(0,12,0)},S.BossSettings.AttackMoveSettings.Spike.TweenTimeSpike)
		end)
	end

end

-- function get spikes back to orginial position
function Attack:ResetSpikes()
	if not workspace.GameMap.Map then return end
	for _,v in pairs(workspace.GameMap.Map.Debris.Zone:GetChildren())do
		Attack:TweenModel(v.Spike,{CFrame = v.Spike.CFrame * CFrame.new(0,-12,0)},S.BossSettings.AttackMoveSettings.Spike.TimeBetweenPointAndSpikeToSpawn)
	end
	task.wait(1.2)
	workspace.GameMap.Map.Debris.Zone:ClearAllChildren()

end	

return Attack