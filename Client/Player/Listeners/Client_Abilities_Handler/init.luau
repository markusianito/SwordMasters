local knit =require(game.ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Knit"):WaitForChild("KnitClient"))
local Client_Abilities_Handler = knit.CreateController({Name = "ClientAbilitiesHandlerLegacy"})

--TODO Server Handling :
	--Equipping
	--Using
--TODO Client:
	-- are u sure message
	-- znaczek ze juz ma to cos takie koleczko

-- shared values initialization --


function Client_Abilities_Handler:KnitStart()
	local round = knit.GetService("RoundService");
	
	local char = knit.Player.Character or knit.Player.CharacterAdded:Wait();
	
	shared.EquippedAbilities={}
	shared.IsRoundRunning=false
	shared.IsInRound=false
	----
	local StatesOfDevice=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("Libraries"):WaitForChild("StatesOfDevice"))
	local ReplicatedSettings=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("ReplicatedSettings"))

	-- Init AbilitySlots Activation Keys Text --
	local abilitySlot=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AbilitySlot")
	for i=1,#abilitySlot:GetChildren() do
		local slot=abilitySlot:WaitForChild("Slot"..tostring(i))
		if StatesOfDevice.isMobile then
			slot.Key.Text="Tap"
		else
			slot.Key.Text=ReplicatedSettings.Abilities.ActivatingKeys["Slot"..tostring(i)].Name
		end
	end

	task.spawn(function() require(script.Use):Init() end)
	task.spawn(function() require(script.Shop):Init() end)
	task.spawn(function() require(script.Equip) end)
	task.spawn(function() require(script.Display) end)
	task.spawn(function() require(script.Inventory) end)

	local RoundStartEvent=round.RoundStarted
	local RoundEndEvent=round.RoundEnded

	char:WaitForChild("Humanoid").Died:Connect(function()
		shared.IsInRound=false
	end)

	RoundEndEvent:Connect(function()
		shared.IsRoundRunning=false
	end)

	RoundStartEvent:Connect(function()
		task.wait(0.666666666);
		shared.IsRoundRunning=true
		shared.IsInRound=true
	end)
	-- Initializing equipped abilities

	local plr=game:GetService("Players").LocalPlayer
	local function getEquippedAbility()
		while #plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities"):GetChildren()==0 do
			task.wait()
		end
		for i,v in pairs(plr:WaitForChild("Inventory"):WaitForChild("EquippedAbilities"):GetChildren()) do
			--print("equipped ability: "..v.Name)
			return v.Name
		end
	end

	game:GetService("Players").LocalPlayer:WaitForChild("Inventory"):WaitForChild("EquippedAbilities").ChildAdded:Connect(function()
		shared.EquippedAbilities={getEquippedAbility()}
	end)
	shared.EquippedAbilities={getEquippedAbility()}
	
	
	
	print("Client_Abilities_Handler (legacy version) started.")
end



return Client_Abilities_Handler