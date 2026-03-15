--disable
local CameraShaker = require(game.ReplicatedStorage.ModuleReplicated.CameraShaker)
local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame * shakeCf
end)


-- Explosion shake:
--wait(7)
--print("Done")

--
--wait(4)
--camShake:Shake(CameraShaker.Presets.Bump)



game.ReplicatedStorage.RemoteEvents.AllPlayersEvent.Camshake.OnClientEvent:Connect(function(deltatime,timee)
	

	camShake:Start()
	if deltatime == "Start" then
		
		camShake:StartShake(10, 10)
		wait(timee)
		print("Stooop Cam shake")
		camShake:Stop()		
	end
	
	
	
end)