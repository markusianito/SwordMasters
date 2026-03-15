--disable
local EventConnection = {}
local deb = {}
local frm = script.Parent

local function ApplyTransparency(frame, a)
	frame.BackgroundTransparency = math.clamp(a,frame:GetAttribute("BackgroundTransparency"),1)
	for _,v in pairs(frame:GetDescendants()) do
		if v:IsA("TextButton") or v:IsA("TextLabel") or v:IsA("TextBox") then
			v.TextTransparency = math.clamp(a,v:GetAttribute("TextTransparency"),1)
			v.BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
		elseif v:IsA("ImageButton") or v:IsA("ImageLabel") then
			v.ImageTransparency = math.clamp(a,v:GetAttribute("ImageTransparency"),1)
			v.BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
		elseif v:IsA("Frame") then
			v.BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1)
		elseif v:IsA("UIStroke") then
			v.Transparency = math.clamp(a,v:GetAttribute("Transparency"),1)
		elseif v:IsA("ScrollingFrame") then
			v.ScrollBarImageTransparency = math.clamp(a,v:GetAttribute("ScrollBarImageTransparency"),1)
			v.BackgroundTransparency = math.clamp(a,v:GetAttribute("BackgroundTransparency"),1);
		end
	end -- DISCORD?
end


local function FadeIn(frame: Frame)
	frame = frame or frm;
	task.spawn(function()
		frame.Visible = true;
		for i = 1, 0, -.2 do
			--tweenVar = i;
			task.wait();
			ApplyTransparency(frame, i);
		end

	end)
end

local function FadeOut(frame: Frame)
	frame = frame or frm;
	task.spawn(function()
		ApplyTransparency(frame, 1);
		frame.Visible = false;
	end)

end


local etc = require(script.Parent.Parent.Parent:WaitForChild("gui"):WaitForChild("etc"))
game.ReplicatedStorage.RemoteEvents.MapVoteEvents.MapVote.OnClientEvent:Connect(function(status,ChosenMapTable)
	
	if status then
		FadeIn();

		for _,ui in pairs(etc.AlternableUis) do
			if ui == script.Parent.Parent.Name then continue end;
			local frm = script.Parent.Parent.Parent[ui]:FindFirstChildOfClass("Frame")
			if frm then
				FadeOut(frm);
			end
		end
		
		for i,v in pairs(script.Parent:GetChildren())do
			if v:IsA("ImageLabel") then
				for l,m in pairs(ChosenMapTable) do
					
					script.Parent["MapImage"..l].Image = ChosenMapTable[l].ID
					
				end
			elseif v:IsA("TextButton")then
				for l,m in pairs(ChosenMapTable) do
					
					script.Parent["Map"..l.."Name"].Text = ChosenMapTable[l].Name
					script.Parent["VoteMap"..l]:SetAttribute("MapName",ChosenMapTable[l].Name)
					script.Parent["Map"..l.."Votes"]:SetAttribute("MapName",ChosenMapTable[l].Name)
					EventConnection = {}
					deb = {}
					EventConnection["VoteMap"..l] = script.Parent["VoteMap"..l].MouseButton1Down:Connect(function()
						if not deb["VoteMap"..l] then
							deb = {}
							deb["VoteMap"..l] = true
							local massage = game.ReplicatedStorage.RemoteEvents.MapVoteEvents.OnVote:InvokeServer(script.Parent["VoteMap"..l]:GetAttribute("MapName"))
							
						end
						
					end)
				end
			end
		end
	else
		FadeOut();
		EventConnection ={}
		for i,v in pairs(script.Parent:GetChildren())do
			if v:IsA("TextLabel") then
				if v:GetAttribute("MapName") then
					
					v.Text = "0"
					
				end
			end 
		end
	end
end)


game.ReplicatedStorage.RemoteEvents.MapVoteEvents.VoteNum.OnClientEvent:Connect(function(name,value)
	for i,v in pairs(script.Parent:GetChildren())do
		if v:IsA("TextLabel") then
			if v:GetAttribute("MapName") then
				if v:GetAttribute("MapName") == name then
					v.Text = value
				end
			end
		end 
		
	end
	
	
end)