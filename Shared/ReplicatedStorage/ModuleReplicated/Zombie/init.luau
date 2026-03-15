local Zombie = {}
Zombie.__index = Zombie

local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Round = require(ServerScriptService.Round.RoundMain.Round)
local AI = require(script.AI)

function changeVisibility(object, visibility)
	local Blacklist = {
		"HumanoidRootPart",
		"Head",
	}

	for i,v:BasePart in pairs(object:GetDescendants()) do
		for _, blacklistedObject in Blacklist do

			if v:IsA("BasePart") and v.Name ~= blacklistedObject then
				if visibility then
					v.Transparency = 0
				else
					v.Transparency = 1
				end
				object.HumanoidRootPart.Transparency = 1
				object.Head.Transparency = 1
			end
		end
	end
end

function initAnim(name: string, Animation: number, where)
	if not where:FindFirstChild("Animations") then
		local AnimsFolder = Instance.new("Folder")
		AnimsFolder.Name = "Animations"
		AnimsFolder.Parent = where
	end

	local anim = Instance.new("Animation")
	anim.Name = name
	anim.AnimationId = `rbxassetid://{Animation}`
	anim.Parent = where.Animations
end

function Zombie.new(ZombieName: string, Properties, SpawnRate)
	local self = {}

	self.ZombieName = ZombieName
	self.MapName = Round.GetMap():GetAttribute("MapName")
	self.MapZombies = Properties[self.MapName]
	self.Properties = Properties[self.MapName][self.ZombieName]
	self.SpawnRate = SpawnRate

	warn(self.Properties)
	--print(self.MapZombies)
	--print(self.ZombieName)
	self.isAlive = true
	self.CanAttack = false

	return setmetatable(self, Zombie)
end

function Zombie:Spawn()
	task.spawn(function()
		--print(self.MapName)
		--print(self.ZombieName)
		--print(self.Properties)
		--print(self.MapZombies)
		while task.wait(self.SpawnRate) do
			if self.isAlive then
				local ChosenZombie = self:PickZombie()
				print(ChosenZombie)
				self:AssignPropertiesAsync()
				local ZombieModel = ReplicatedStorage.Assets.Zombies:FindFirstChild(`{self.MapName} Zombies`):FindFirstChild(ChosenZombie)
				task.wait(1)
				self.clonedZombie = ZombieModel:Clone()
				local MapSpawns = workspace.Spawns[`{self.MapName}Spawns`].ZombieSpawns:GetChildren()
				self.clonedZombie:PivotTo(MapSpawns[math.random(1, #MapSpawns)].CFrame * CFrame.new(0, -1, 0))
				--changeVisibility(self.clonedZombie, false)
				self.clonedZombie.Parent = workspace
				if not self.CanAttack then
					--initAnim("Spawn", self.Properties.Animations.Spawn, self.clonedZombie)
					--local anim = self.clonedZombie.Humanoid:LoadAnimation(self.clonedZombie.Animations.Spawn)
					--anim:Play()
					--task.delay(0.5, function()
					--	changeVisibility(self.clonedZombie, true)
					--end)
					--anim.Ended:Wait()
					--print("Played")
					self.clonedZombie.AI.Enabled = true
					self.CanAttack = true
				else
					self.clonedZombie.AI.Enabled = true
				end

			else  end
		end

		return self.clonedZombie
	end)
end

function Zombie:PickZombie()
	local totalRarity = 0

	for i, zombie in self.MapZombies do
		totalRarity += zombie.Rarity
	end

	local RandomNumber = math.random(1, totalRarity)
	local currentRarity = 0

	for i, zombie in self.MapZombies do
		currentRarity += zombie.Rarity
		if RandomNumber <= currentRarity then
			return tostring(i)
		end
	end
end

function Zombie:AssignPropertiesAsync()
	local ZombieModel = ReplicatedStorage.Assets.Zombies:FindFirstChild(`{self.MapName} Zombies`):FindFirstChild(self.ZombieName)
	if not ZombieModel then return end

	local Humanoid = ZombieModel.Humanoid
	--local Animate = ZombieModel.Animate

	Humanoid.MaxHealth = self.Properties.Health
	Humanoid.Health = self.Properties.Health
	Humanoid.WalkSpeed = self.Properties.Speed
end

--function Zombie:Init()
--	local Target = self.AI:CheckPotenitalTargets(self.Properties.Distance)
--	if Target then
--		self.AI:FindPath(Target)
--	else
--		self.AI:Walk()
--	end
--end

function Zombie:Deconstruct()
	setmetatable(self, nil)
	table.clear(self)
	table.freeze(self)
end

return Zombie