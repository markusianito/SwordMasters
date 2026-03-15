

repeat task.wait() until script.Parent:IsA("Model")
local char = script.Parent
local hrp: Part = char:WaitForChild("HumanoidRootPart")
local R6 = require(script.Parent:WaitForChild("R6"))
local plr = game:GetService("Players"):GetPlayerFromCharacter(char)
local hum = char:WaitForChild("Humanoid")
local autoLoads = game:GetService("Players").CharacterAutoLoads

local function setNetworkOwner()
	for i, bp in pairs(char:GetChildren()) do
		if bp:IsA("BasePart") and bp:CanSetNetworkOwnership() then
			bp:SetNetworkOwner(plr)
		end
	end
end

hum.Died:Connect(function()
	if hum.RigType == Enum.HumanoidRigType.R6 then
		setNetworkOwner()
		R6(char)
		char.Torso:ApplyImpulse(char.Torso.CFrame.LookVector * 90)
		char["Left Leg"]:ApplyImpulse(char.Torso.CFrame.LookVector * -60)
		char["Right Leg"]:ApplyImpulse(char.Torso.CFrame.LookVector * -60)
		if autoLoads then
			task.delay(3, function()
				plr:LoadCharacter()
			end)
		end
	else
	end
end)