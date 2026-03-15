--disable
-->> Main.lua - Server
--> Token speed program by Marcos

local MULTIPLIER = 2;
local TIME = 6;
local TEXT = "x2 Speed";
local ICON = 18540891267


local p = script.Parent;

local ain;
ain = p.Touched:Connect(function(plr: Humanoid)
	plr = plr.Parent:FindFirstChild("Humanoid");
	if plr then
		if plr.Parent:HasTag("Token") then return; end
		plr.Parent:AddTag("Token")
		ain:Disconnect();
		p.Images:Destroy();
		p.Transparency = 1;
		for _,v in pairs(p:GetChildren()) do
			if v:IsA("BasePart") then
				v.Transparency = 1;
			end
		end
		
		
		for _,v:ParticleEmitter in pairs(p.FX.Attachment:GetChildren()) do
			v:Emit(v:GetAttribute("EmitCount"))
		end
		script.Parent.Sound:Play();
		
		game.ReplicatedStorage.ClientEvents.TokenFire:FireClient( game.Players[plr.Parent.Name], "Speed",TIME, TEXT, workspace:GetAttribute("robloxstr") .. ICON, Color3.fromRGB(0, 187, 255))

		local nya = plr.Parent:GetAttribute("MoreSpeed");
		plr.Parent:SetAttribute("MoreSpeed", MULTIPLIER);
		
		task.wait(TIME);

		plr.Parent:SetAttribute("MoreSpeed", nya);
		plr.Parent:RemoveTag("Token")
		
		
		task.wait(2);
		p:Destroy();
	end
end)