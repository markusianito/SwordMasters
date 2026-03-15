local Display = {}

local DataLoad = require(game.ReplicatedFirst:WaitForChild("DataLoad"));
local ReplicatedSettings=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("ReplicatedSettings"))
local Libraries=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("Libraries"))
local abs = game.ReplicatedStorage.Abilities;

local plr=game:GetService("Players").LocalPlayer

local function getAbilitiesGui()
	return plr:WaitForChild("PlayerGui"):WaitForChild("AbilitiesShop")
end

local function getMainFrame()
	return getAbilitiesGui():WaitForChild("MainFrame")
end

local function getAbilityItemHolder()
	return getMainFrame():WaitForChild("AbilityItemHolder")
end

local function getExitButton()
	return getMainFrame():WaitForChild("Exit")
end

local function getCooldown()
	return getMainFrame():WaitForChild("Cooldown")
end

local connections={}

local Buy=require(script.Parent:WaitForChild("Buy"))

local currentAbilities={}
local latestUpdateTime=0

local function buyAbility(abilityName:string)
	Buy.BuyAbilityFromShop(abilityName)
end

local function checkOwning(abilityName)
	if plr:WaitForChild("Inventory"):WaitForChild("Abilities"):FindFirstChild(abilityName) then
		return true
	end
	return false
end

local guiLooks={
	Default=ReplicatedSettings.DefaultAbilitiesPriceGuiLook,
	Owning=ReplicatedSettings.OwnsAbilityDisplaySettings
}

local function changeTextLook(textButton:TextButton,typ:string)
	textButton.TextColor3=guiLooks[typ].TextColor
	textButton.TextStroke.Color=guiLooks[typ].TextStrokeColor
	textButton.TextStroke.Thickness=guiLooks[typ].TextStrokeThickness
	textButton.UIStroke.Color=guiLooks[typ].BorderStrokeColor
	textButton.UIStroke.Thickness=guiLooks[typ].BorderStrokeThickness
end

function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1 ")
	return minus .. int:reverse():gsub("^ ,", "") .. fraction
end

Display.UpdateOffer=function(abilityNames:{})
	latestUpdateTime=abilityNames.Time
	abilityNames = abilityNames.abilities
	for i,v in pairs(abilityNames) do
		if not table.find(ReplicatedSettings.ShopAbilities,v) then
			warn("tried to display in the shop ability that is not allowed tobe displayed in the shop in the Replicated_Settings")
			return
		end
	end
	
	currentAbilities=abilityNames;
	
	for i,v in pairs(abilityNames) do
		local abilitySlot=getAbilityItemHolder()["AbilitySlot"..tostring(i)]
		
		abilitySlot.AbilityImage.Image=workspace:GetAttribute("robloxstr") .. ReplicatedSettings.Abilities[v].ID
		abilitySlot.AbilityName.Text=v
		
		local rarity = ReplicatedSettings.Abilities[v].Rarity;
		abilitySlot.Rarity.Text=rarity
		abilitySlot.Price.Text=format_int(ReplicatedSettings.Abilities[v].Price)
		local a:TextLabel = abilitySlot.Rarity;
		a.TextColor3 = DataLoad.RarityNameColors[rarity]["Color"];
		a.TextStrokeColor3 = DataLoad.RarityNameColors[rarity]["Stroke"];
		
		-- shows owning ability
		if checkOwning(v) then
			abilitySlot.Owned.Visible=true
			changeTextLook(abilitySlot.Price,"Owning")
			abilitySlot.Price.Text="Owned"
		else
			abilitySlot.Owned.Visible=false
			changeTextLook(abilitySlot.Price,"Default")
		end
	end
end

local function getNextRefreshingHour(hour:number)
	if math.max(unpack(ReplicatedSettings.Abilities.RefreshingUTCTimes))<=hour then return ReplicatedSettings.Abilities.RefreshingUTCTimes[1] end
	for _,h in ipairs(ReplicatedSettings.Abilities.RefreshingUTCTimes) do
		if h>hour then return h end
	end
end

local getOffersInfoEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("GetOffersInfo")
getOffersInfoEvent.OnClientEvent:Connect(function(data)
	Display.UpdateOffer(data)
end)
plr:WaitForChild("Inventory"):WaitForChild("Abilities").ChildAdded:Connect(function()
	getOffersInfoEvent:FireServer()
end)

local function onCharAdded()
	for i,v in pairs(connections) do
		v:Disconnect()
	end

	table.insert(connections,getExitButton().Activated:Connect(function()
		getMainFrame().Visible=false
	end))

	for i=1,3 do
		table.insert(connections,getAbilityItemHolder():WaitForChild("AbilitySlot"..tostring(i)):WaitForChild("Price").Activated:Connect(function()
			buyAbility(currentAbilities[i])
		end))
	end

	-- asks for start info --
	getOffersInfoEvent:FireServer()
end

if plr.Character then onCharAdded() end
plr.CharacterAdded:Connect(onCharAdded)

local function toHMS(s)
	return string.format("%02i:%02i:%02i", s/60^2, s/60%60, s%60)
end

task.spawn(function()
	while wait(1) do
		local timeString = abs.TimeRest.Value;
		if timeString == "00:00:00" then
			getCooldown().Text="Refreshing..."
		else
			getCooldown().Text= timeString;
		end
	end
end)



return Display