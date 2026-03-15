--disable
function RestGui(gui)

	gui.Enabled =true
	task.wait(5)
	gui.Enabled = false
end

game.ReplicatedStorage.RemoteEvents.Round.GuiStatusRound.OnClientEvent:Connect(function(guiname,Status)
	
	task.wait(5)
	if typeof(Status) == "table" then

		for l,m in pairs(Status)do
			script.Parent[guiname].Frame.lab["Nickname"..tostring(l)].Text = m
			script.Parent[guiname].Frame.lab["Nickname"..tostring(l)].Visible = true
		end


		RestGui(script.Parent[guiname])
	else
		if Status ~= nil then
			if typeof(Status) == "string" then
				if guiname == "PVPWinnerGui" then
					script.Parent[guiname].Frame.WinnerPlayerNickname.Text = Status
					RestGui(script.Parent[guiname])
					
				end
			end
		else
			
			RestGui(script.Parent[guiname])
		end
	end

end)

game.ReplicatedStorage.ZHuntUI.OnClientEvent:Connect(function(key)
	if key == "win" then
		RestGui(script.Parent.ZombieHuntWinGui);
	elseif key == "lose" then
		RestGui(script.Parent.ZombieHuntLoseGui)
	end
end)