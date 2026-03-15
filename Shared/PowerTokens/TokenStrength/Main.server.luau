--disable
-->> Main.lua - Server
--> Token strength program by Marcos

local MULTIPLIER = 2;
local TIME = 6;
local TEXT = "x2 Strength";
local ICON = 18493867338



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
		
		game.ReplicatedStorage.ClientEvents.TokenFire:FireClient(game.Players[plr.Parent.Name], "Strength", TIME, TEXT, workspace:GetAttribute("robloxstr") .. ICON, Color3.fromRGB(255, 82, 82))

		local nya = plr.Parent:GetAttribute("MoreDamage");
		plr.Parent:SetAttribute("MoreDamage", MULTIPLIER);
		
		task.wait(TIME);

		plr.Parent:SetAttribute("MoreDamage", nya);
		plr.Parent:RemoveTag("Token")
		
		
		task.wait(2);
		p:Destroy();
	end
end)