--disable
local DataLoad = require(game.ReplicatedFirst.DataLoad)
local RS = game.ReplicatedStorage
local remote = RS.RemoteEvents.DailyShopEvents.DailyShop
local DailyshopFrame = script.Parent
local MainFrame = DailyshopFrame.Frame
local InfoFrame = DailyshopFrame.Frame.Info
local helpFrame = DailyshopFrame.Frame.Help
local SelectedItem = DailyshopFrame.Frame.Frame.SelectedItem

local Debounce = false
local Cooldown = false
local ShowGui = false
local HelpStatus 


function format_int(number)
	local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
	int = int:reverse():gsub("(%d%d%d)", "%1 ")
	return minus .. int:reverse():gsub("^ ,", "") .. fraction
end

function ConvertObjectToTable(object)
	
	local ob = {}
	ob["Price"] = object.Price.Value
	ob["Type"] = object.Type.Value
	ob["Rarity"] = object.Rarity.Value
	ob["Name"] = object.NameItem.Value
	ob["ID"] = object.ID.Value
	ob["Description"] = object.Description.Value
	ob["Position"] = object.Position.Value
	
	return ob
	
end

function SetupButtons(v)
	local frame = MainFrame.Frame[v.Type]["Random "..v.Type.." "..tostring(v.Position)]
	frame.Image = "rbxassetid://"..tostring(v["ID"])
	frame.Price.Text = format_int(v.Price )
	frame.NameOfItem.Value = v.Name
	if game.Players.LocalPlayer:WaitForChild("Iventory").Skins:FindFirstChild(v.Name) or game.Players.LocalPlayer:WaitForChild("Inventory").Swords:FindFirstChild(v.Name) then
		frame.Owned.Visible = true
	else
		frame.Owned.Visible = false
	end
	frame.MouseButton1Down:Connect(function()

		if  MainFrame.Frame.SelectedItem.Value  == frame.NameOfItem.Value then

			if not Debounce then
				MainFrame.Frame.SelectedItem.Value = ""
				Debounce = true
				InfoFrame:TweenPosition(UDim2.new(0.381, 0,0.225, 0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.5)
				task.wait(0.5)
				Debounce = false

			end
		else
			if not Debounce then
				InfoFrame.Frame["Item Image"].Image = "rbxassetid://"..v.ID
				InfoFrame.Frame.Description.Text = v.Description
				InfoFrame.Frame["Item name"].Text = v.Name
				InfoFrame.Frame.Rarity.Text = v.Rarity
				InfoFrame.Frame.Rarity.TextColor3 = DataLoad.RarityNameColors[v.Rarity].Color ---DataLoad.RarityNameColors[v.Rarity].Color
				InfoFrame.Frame.Rarity.UIStroke.Color = DataLoad.RarityBorders[v.Rarity]

				if game.Players.LocalPlayer:WaitForChild("Data").Skins:FindFirstChild(v.Name) or game.Players.LocalPlayer:WaitForChild("Data").Swords:FindFirstChild(v.Name)  then
					InfoFrame.Frame.Buy.Text = "Owned"
				else
					InfoFrame.Frame.Buy.Text = "Buy"
				end
				MainFrame.Frame.SelectedItem.Value = frame.NameOfItem.Value

				Debounce = true
				DailyshopFrame.Frame.Info:TweenPosition(UDim2.new(0.081, 0,0.235, 0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.5)
				task.wait(0.5)
				Debounce = false

			end

		end
	end)
end



remote.OnClientEvent:Connect(function(info)
	
	Cooldown = true
	MainFrame.Info:TweenPosition(UDim2.new(0.381, 0,0.225, 0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,0.5)
	for i,v in pairs(info.Skins) do
		
		SetupButtons(v)
	end
	for i,v in pairs(info.Sword) do
		
		SetupButtons(v)
	end
	task.wait(1.9)
	Cooldown = false
end)



task.wait(5)
for i,v in pairs(RS.DailyShop.Skin:GetChildren())do
	if #RS.DailyShop.Skin:GetChildren() ~= 0 then	
		SetupButtons(ConvertObjectToTable(v))
	end

end

for i,v in pairs(RS.DailyShop.Sword:GetChildren())do
	if #RS.DailyShop.Sword:GetChildren() ~= 0 then
		SetupButtons(ConvertObjectToTable(v))
	end
end


InfoFrame.Frame.Buy.MouseButton1Down:Connect(function()
	if InfoFrame.Frame.Buy.Text == "Owned" then return end
	if InfoFrame.Frame.Buy.Text == "Buy" then
		if not ShowGui  then
			ShowGui = true
			helpFrame.Visible = true
			helpFrame.No.Visible = true
			helpFrame.Yes.Visible = true
			helpFrame.Ok.Visible = false
			helpFrame.Description.Text = "Are You Sure You Want To Buy "..MainFrame.Frame.SelectedItem.Value.."?"
			HelpStatus = "Buy"
			
			repeat
				task.wait(0.5)
				InfoFrame.Frame.Buy.Text = InfoFrame.Frame.Buy.Text.." ."
				if string.len(InfoFrame.Frame.Buy.Text) >= 11  then
					InfoFrame.Frame.Buy.Text = "Buy"
				end
			until not ShowGui
			
			InfoFrame.Frame.Buy.Text = "Buy"
		end
	end
end)


helpFrame.No.MouseButton1Down:Connect(function()
	helpFrame.Visible = not helpFrame.Visible
	ShowGui = false
	HelpStatus = nil
end)

helpFrame.Yes.MouseButton1Down:Connect(function()
	local item = game.Players.LocalPlayer:WaitForChild("Inventory"):FindFirstChild("Skins"):FindFirstChild(SelectedItem.Value) or game.Players.LocalPlayer:WaitForChild("Data"):FindFirstChild("Swords"):FindFirstChild(SelectedItem.Value)
	if not item then
		local IsBought,Massage = RS.RemoteEvents.DailyShopEvents.Buy:InvokeServer(SelectedItem.Value)
		helpFrame.Visible = false
		
		if IsBought then
			ShowGui = false
			helpFrame.Description.Text = Massage
			helpFrame.No.Visible = false
			helpFrame.Yes.Visible = false
			helpFrame.Ok.Visible = true
			task.wait(0.5)
			helpFrame.Visible = true
			
			for i,v in pairs(DailyshopFrame.Frame.Frame:GetDescendants()) do
				if v:IsA("ImageButton") and v:FindFirstChild("NameOfItem")  then
					if v:FindFirstChild("NameOfItem").Value == SelectedItem.Value  then
						v.Owned.Visible = true
						InfoFrame.Frame.Buy.Text = "Owned"
					end 
				end
			end
			
		else
			helpFrame.Description.Text = Massage
			helpFrame.No.Visible = false
			helpFrame.Yes.Visible = false
			helpFrame.Ok.Visible = true
			task.wait(0.5)
			helpFrame.Visible = true
			
		end
	else
		print("You already Have it")
	end
	
	
end)


helpFrame.Ok.MouseButton1Down:Connect(function()
	helpFrame.Visible = not helpFrame.Visible
	ShowGui = false
end)


while task.wait(1)do
	if not Cooldown then
		DailyshopFrame.Frame.Frame.Countdown.Text = RS.DailyShop.TimeRest.Value
	else
		DailyshopFrame.Frame.Frame.Countdown.Text = "We are Updating Shop"
	end

end


--{0.355, 0},{0.164, 0}
--{0.166, 0},{0.164, 0}