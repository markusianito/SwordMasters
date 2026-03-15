local Buy = {}

local BuyEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Buy")
local ReplicatedSettings=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("ReplicatedSettings"))

local cooldown=0.3
local lastBuy=os.clock()

local isAsked=false

local plr=game:GetService("Players").LocalPlayer

local function onHumDied()
	
end

if plr.Character and plr.Character:FindFirstChild("Humanoid") then
	plr.Character.Humanoid.Died:Connect(onHumDied)
end

plr.CharacterAdded:Connect(function(char)
	if char:FindFirstChild("Humanoid") then
		char.Humanoid.Died:Connect(onHumDied)
	end
end)

Buy.BuyAbilityFromShop=function(abilityName:string)
	--defences
	if isAsked then return end
	if plr:WaitForChild("Inventory"):WaitForChild("Abilities"):FindFirstChild(abilityName) then return end
	
	if not table.find(ReplicatedSettings.ShopAbilities,abilityName) then return end
	if os.clock()-lastBuy<cooldown then warn("buying too fast, slow down") return end
	local decided=false
	local decision=false
	
	local connections={}
	
	local function disconnecConnections()
		for i,v in pairs(connections) do
			v:Disconnect()
		end
	end
	
	isAsked=true
	
	local HelpGui=plr:WaitForChild("PlayerGui"):WaitForChild("AbilitiesShop"):WaitForChild("MainFrame"):WaitForChild("Help")
	
	HelpGui.No.Visible=true
	HelpGui.Yes.Visible=true
	HelpGui.Ok.Visible=false
	
	table.insert(connections,HelpGui.No.Activated:Once(function()
		decision=false
		decided=true
		disconnecConnections()
		HelpGui.Visible=false
	end))

	table.insert(connections,HelpGui.Yes.Activated:Once(function()
		decision=true
		decided=true
		disconnecConnections()
		HelpGui.Visible=false
	end))
	
	HelpGui.Description.Text="Are You sure You want to buy "..abilityName.." ability?"
	HelpGui.Visible=true
	
	while not decided do
		task.wait()
	end

	if decision==true then
			local estatement_lealcanza = ReplicatedSettings.Abilities[abilityName].Price <= plr.PlayerStats.Coins.Value
			print("sending buy event")
			lastBuy=os.clock()
			BuyEvent:FireServer(abilityName)

			HelpGui.No.Visible=false
			HelpGui.Yes.Visible=false
			HelpGui.Ok.Visible=true

			wait(1)

			HelpGui.Ok.Activated:Once(function()
				HelpGui.Visible=false
				isAsked=false
			end)
			

		HelpGui.Description.Text=`{estatement_lealcanza and `You have bought the {abilityName} ability` or "You Dont Have Enough Coins"}`
		HelpGui.Visible=true
	else
		isAsked=false
	end
end

return Buy
