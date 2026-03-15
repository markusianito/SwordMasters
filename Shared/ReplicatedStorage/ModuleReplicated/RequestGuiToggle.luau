local tog = game.ReplicatedStorage.RemoteEvents.CustomEvents.GuiToggle;


local module = {}

function module:Enable(plr, gui, enabled)
	tog:FireClient(plr, gui, true)
end

function module:Disable(plr, gui, enabled)
	tog:FireClient(plr, gui, false)
end


function module:SetUpOnRegion(part, gui)
	local is = false;
	part.Touched:Connect(function(Hit)
		local plr = game.Players:GetPlayerFromCharacter(Hit:FindFirstAncestorOfClass("Model"))
		if plr then
			if not is then
				is = true;
				module:Enable(plr, gui);
				task.wait(0.333);
				is = false;
			end
		end
	end)
	
	
	part.TouchEnded:Connect(function(Hit)
		local plr = game.Players:GetPlayerFromCharacter(Hit:FindFirstAncestorOfClass("Model"))
		if plr then
			if is then return end;
			module:Disable(plr, gui);
		end
	end)
end

return module
