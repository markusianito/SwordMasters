--disable
local Tween = game:GetService("TweenService")

function TweenModel(model, goal, duration)
	local tweenInfo = TweenInfo.new(duration)
	local tween = Tween:Create(model, tweenInfo, goal)
	tween:Play()
end

function Start()
	task.wait(3)
	if game.Workspace.Map:FindFirstChild("MapRound") then return end
	game.Lighting:ClearAllChildren()
	local tablee = {
		["ClockTime"] = 11.135,
		["GeographicLatitude"] = -36.355

	}
	
	local Light = game.ReplicatedStorage.MapsLighting["LobbySky"]:Clone()
	Light.Parent = game.Lighting
	for i,v in pairs(Light:GetChildren()) do

		v.Parent = game.Lighting


	end
	Light:Destroy()
	for i,v in pairs(tablee) do
		TweenModel(game.Lighting,{[i] = v},3)
	end
	
end

Start()



game.ReplicatedStorage.RemoteEvents.LightingEvents.SetUp.OnClientEvent:Connect(function(mapname,tablee)
	--print(mapname)
	
	game.Lighting:ClearAllChildren()
	
	local Light = game.ReplicatedStorage.MapsLighting[mapname.."Sky"]:Clone()
	Light.Parent = game.Lighting
	for i,v in pairs(Light:GetChildren()) do
		
			v.Parent = game.Lighting
			
		
	end
	Light:Destroy()
	
	for i,v in pairs(tablee) do
		TweenModel(game.Lighting,{[i] = v},3)
	end
	if mapname == "Lobby"  then
		if game.ReplicatedStorage.CacheClient:FindFirstChild("Lobby") then
			--game.ReplicatedStorage.CacheClient:FindFirstChild("Lobby").Parent = game.Workspace
		end
		
		else
		--workspace.Lobby.Parent = game.ReplicatedStorage.CacheClient
	end
	
end)


game.Players.LocalPlayer.CharacterAdded:Connect(function()
	--print("LO")
	if not workspace.Map:FindFirstChild("MapRound") then
		if  game.ReplicatedStorage.CacheClient:FindFirstChild("Lobby") then
			--game.ReplicatedStorage.CacheClient:FindFirstChild("Lobby").Parent = game.Workspace
		end
		
	end
	
end)