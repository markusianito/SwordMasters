local Map = {}
Map.__index = Map


local Attack = require(script.Parent.AttackMoves)


function Map.New()
	local self = {}
	return setmetatable(self,Map)
end

function Map:DisableCanCollideTrees(Fold:Folder)

	for _,v:BasePart in pairs(Fold:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = false
		end
	end

end

function Map:EnableCanCollideTrees(Fold:Folder)

	for _,v:BasePart in pairs(Fold:GetDescendants()) do
		if v:IsA("BasePart") then
			v.CanCollide = true
		end
	end

end

function Map:VelocityTrees(v,Boss)

	if not v:GetAttribute("Dest") then
		for _,m:Part in pairs(v:GetChildren())do

			local bv:LinearVelocity = Instance.new("LinearVelocity")
			local Attachment = Instance.new("Attachment")
			Attachment.Parent = m
			bv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
			m.Anchored = false
			bv.Attachment0 = Attachment
			bv.MaxForce = math.huge
			bv.VectorVelocity = Boss.PrimaryPart.CFrame.LookVector * 60

			bv.Parent = m
			--bv.P = 200000


			if m.Name == "Main"  then
				if m:FindFirstChild(m.Name) then
					m[m.Name]:Destroy()
				end
			end
			v:SetAttribute("Dest",true)
			--m.Transparency = 1

		end
		task.wait(2)		
		for _,m:Part in pairs(v:GetChildren())do
			m.CanCollide = false
			if m:FindFirstChild("LinearVelocity")then
				m.LinearVelocity:Destroy()
			end
		end
		task.wait(2)	
		v:Destroy()
	end
end


function Map:ActionVelocityTree(v,Boss)

	if not v:GetAttribute("Dest") then
		for _,m:Part in pairs(v:GetChildren())do

			local bv = Instance.new("LinearVelocity")
			local Attachment = Instance.new("Attachment")
			Attachment.Parent = m
			bv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
			m.Anchored = false
			bv.Attachment0 = Attachment
			Boss["Left Leg"].Center.CFrame = CFrame.lookAt(Boss["Left Leg"].Center.Position,m.Position)
			bv.MaxForce = math.huge
			bv.VectorVelocity = Boss["Left Leg"].Center.CFrame.LookVector * 60
			bv.Parent = m
			--bv.P = 2000000

			if m.Name == "Main"  then
				if m:FindFirstChild(m.Name) then
					m[m.Name]:Destroy()
				end
			end
			v:SetAttribute("Dest",true)
			--m.Transparency = 1
			spawn(function()
				task.wait(1)
				m.CanCollide = false
			end)
			--m.CanCollide = false
		end

		spawn(function()
			task.wait(2)		
			for _,m:Part in pairs(v:GetChildren())do

				if m:FindFirstChild("LinearVelocity")then
					m.LinearVelocity:Destroy()

				end
			end
			task.wait(1)	
			v:Destroy()
		end)

	end

	for _,l in pairs(workspace.GameMap.Map:GetDescendants()) do
		if l:GetAttribute("DestoryableSpikes") and not l:IsA("Model") then


			Attack:TweenModel(l,{CFrame = l.CFrame * CFrame.new(0,-9,0)},1.4)
			spawn(function()
				task.wait(1.8)
				l:Destroy()
			end)

		end
	end
end

--function velocity players character if this players are 40 studs near boss
function Map:VelocityPlayers(Boss,Tables)
	local oldposition = Attack:GetLegPosition()
	if Tables == nil  then



		for _,v in pairs(game.Players:GetChildren()) do
			if v.Character and (v.Character.HumanoidRootPart.Position - Boss.PrimaryPart.Position).Magnitude < 110 then

				--local g = Vector3.new(0,-workspace.Gravity,0)
			
				--local maxHeight = 30



				local character = v.Character
				if character then

					local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
					
					Attack:ChangeDirctionLeg(HumanoidRootPart)
					--local v0 = ( (Attack:GetLegPosition().LookVector * -Vector3.new(10, 0, 0)) - HumanoidRootPart.Position - 0.5 * g * FlightTime * FlightTime) / FlightTime

					--v0 = Vector3.new(v0.X, maxHeight, v0.Z) * 1.5


					local dir = (HumanoidRootPart.CFrame.Position - Attack:GetLegPosition().Position).Unit * 2

					local bv:LinearVelocity = Instance.new("LinearVelocity")
					bv.Parent = HumanoidRootPart
					local Attachment = Instance.new("Attachment")
					Attachment.Parent = HumanoidRootPart
					bv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
					HumanoidRootPart.Anchored = false
					bv.Attachment0 = Attachment
					bv.MaxForce =  math.huge
					bv.VectorVelocity = (dir+Vector3.new(0,1,0)).Unit * 70

					task.spawn(function()
						task.wait(1)

						bv:Destroy()
						Attachment:Destroy()
					end)




					--HumanoidRootPart.CFrame = CFrame.new(v0)

				end

			end
		end
		Attack:ChangeDirctionLeg(nil,oldposition)
		else
		for _,v in pairs(Tables) do
		
			

				
		

				local character = v
				if character then
					
					local HumanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				--	local g = Vector3.new(0, -workspace.Gravity, 0)
					Attack:ChangeDirctionLeg(HumanoidRootPart)
					--local v0 = ( (Attack:GetLegPosition().LookVector * -Vector3.new(10, 0, 0)) - HumanoidRootPart.Position - 0.5 * g * FlightTime * FlightTime) / FlightTime

					--v0 = Vector3.new(v0.X, maxHeight, v0.Z) * 1.5
					local dir = (HumanoidRootPart.CFrame.Position - Attack:GetLegPosition().Position).Unit

					local bv:LinearVelocity = Instance.new("LinearVelocity")
					bv.Parent = HumanoidRootPart
					local Attachment = Instance.new("Attachment")
					Attachment.Parent = HumanoidRootPart
					bv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
					HumanoidRootPart.Anchored = false
					bv.Attachment0 = Attachment
					bv.MaxForce =  math.huge
					bv.VectorVelocity = (dir+Vector3.new(0,1,0)).Unit * 70
					local rot = Instance.new("BodyAngularVelocity")
					rot.Parent = HumanoidRootPart
					rot.AngularVelocity = Vector3.new(1,2,1) * math.pi *5
					rot.MaxTorque = Vector3.new(2,5,2) *math.huge
					rot.P = 3000
					character:FindFirstChild("Humanoid"):TakeDamage(10)

					spawn(function()
						task.wait(1)

						bv:Destroy()
						Attachment:Destroy()
						rot:Destroy()
					end)

				--	HumanoidRootPart.CFrame = CFrame.new(v0)

				end

			
		end
		Attack:ChangeDirctionLeg(nil,oldposition)
	end
end


function Map:EnableParticleEmitter(folder:Folder,boolean)

	for _,v in pairs(folder:GetDescendants())do
		if v:IsA("ParticleEmitter") then
			v.Enabled = boolean
		end
	end

end

return Map
