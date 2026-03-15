local Boss = {}
Boss.__index = Boss

local MapFolder 	   	  = workspace.GameMap

--- function get boss from mapfolder
function Boss.GetBoss()
	local self = {}
	
	self.Boss = workspace:FindFirstChild("Mountain Guardian")
	--self.Boss = MapFolder:FindFirstChild("MapRound").Map.Boss:FindFirstChild("Mountain Guardian")
	return setmetatable(self,Boss)
	 
end	



function Boss:Freeze()
	self.Boss.HumanoidRootPart.Anchored = true
end



function Boss:Unfreeze()
	self.Boss.HumanoidRootPart.Anchored = false
end


--ForceField
function Boss:DisableForceField()
	if  self.Boss.HumanoidRootPart:FindFirstChild("ForceField") then
		self.Boss.HumanoidRootPart:FindFirstChild("ForceField"):Destroy()
	end
end

function Boss:EnableForceField()
	local ForceField = Instance.new("ForceField")
	ForceField.Parent = self.Boss.HumanoidRootPart
end

--Change Status boss
function Boss:ChangeBossStateTo(state)
	self.Boss:SetAttribute("State",state)
end

--function get boss state
function Boss:GetBossState()
	return self.Boss:GetAttribute("State")
end

function Boss:ChangeAttackStatus(bool)
	self.Boss:SetAttribute("IsAttacking",bool)
end

function Boss:ChangeDeathStatus(bool)
	
	self.Boss:SetAttribute("IsDead",bool)
end

--function change damage status
function Boss:ChangeDamageStatus(bool)
	self.Boss:SetAttribute("GetDamage",bool)
end

function Boss:ChangeActionStatus(bool)
	self.Boss:SetAttribute("RandomAction",bool)
end

function Boss:ChangeBreakStatus(bool)
	self.Boss:SetAttribute("InBreak",bool)
end

function Boss:IsAttacking()
	return self.Boss:GetAttribute("IsAttacking")
end

function Boss:IsInBreak()
	return self.Boss:GetAttribute("InBreak")
end
--check if boss died
function Boss:IsDied()
	if workspace.GameMap:FindFirstChild("MapRound") then
		if self.Boss then
			
			return self.Boss:GetAttribute("IsDead")
			else
			return true
		end
		
		else
		return true
	end
	
end

function Boss:IsTakeDamage()
	return self.Boss:GetAttribute("GetDamage")	
end

--function boss is taking action
function Boss:IsTakingAction()
	return self.Boss:GetAttribute("RandomAction")
end
--function moveto boss
function Boss:MoveTo(position)
	self.Boss.Humanoid:MoveTo(position)
	--check if move to stooped
	self.Boss.Humanoid.MoveToFinished:Wait()
end

function Boss:Teleport(Pos)
	local Model:Model =self.Boss
	Model:PivotTo(Pos)
end
--set Speed for bosss
function Boss:SetSpeed(speed)
	self.Boss.Humanoid.WalkSpeed = speed
end

--rotate boss 90 degree
function Boss:RotateBoss()
	self.Boss.HumanoidRootPart.CFrame = self.Boss.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(180),0)
end

function Boss.HideCharacterParts(object,visible)
	for _,v:BasePart in pairs(object:GetDescendants()) do
		if v:IsA("MeshPart") then
			if visible then
				v.Transparency = 1
				else
				v.Transparency = 0
			end
			
		end
		
	end
end





function Boss:GetBossMap()
	return self.Boss
end






return Boss

