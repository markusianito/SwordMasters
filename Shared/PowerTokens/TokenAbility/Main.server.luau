--disable
-->> Main.lua - Server
--> Token health program by Marcos

local HEALTH = 20


local p = script.Parent;

local ain;
ain = p.Touched:Connect(function(plr: Humanoid)
	plr = plr.Parent:FindFirstChild("Humanoid");
	if plr then
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
		
		--> Ain
		if not plr.Parent:GetAttribute("Busy") then
			game.ReplicatedStorage.ClientEvents.Annoy:FireClient(game.Players[plr.Parent.Name]);
		end
		
		
		
		
		task.wait(2);
		p:Destroy();
	end
end)