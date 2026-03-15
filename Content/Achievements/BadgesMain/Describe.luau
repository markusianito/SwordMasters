--> Compile.lua


local BUTT_ONS = require(game.ReplicatedStorage.StandardLibraries.Quests).Assets.Buttons


local frame = script.Parent.Parent:WaitForChild("MainFrame"):WaitForChild("ScrollingFrame");
local str = workspace:GetAttribute("robloxstr")

local completedColor = Color3.fromRGB(0, 255, 42)

local badgesComm = game.ReplicatedStorage.RemoteEvents.BadgesCallback
local mark = script.Parent.Parent:WaitForChild("ButtonED"):WaitForChild("Exclamationmark");
local connections:{string: RBXScriptConnection} = {}
local cooldowns:{string: boolean} = {}



local describe = {}


function describe:Complete(frame: Frame, complete: boolean)
	if complete then
		frame.Main.Progress1.TextColor3 = completedColor;
		frame.Main.Task1.TextColor3 = completedColor;


		frame.Main.ClaimButton.Image = str..BUTT_ONS.Claim;
		connections[frame.Name] = frame.Main.ClaimButton.Activated:Connect(function()
			if not cooldowns[frame.Name] then
				cooldowns[frame.Name] = true;
				
				local data, claims, success = badgesComm:InvokeServer("consult", frame.Name);
				warn(data, claims, success)
				describe:Describe(data, claims)
				task.delay(0.2, function()
					describe:Describe(badgesComm:InvokeServer("consult", frame.Name))
				end)
				
				task.wait(5);
				
				cooldowns[frame.Name] = nil;
			end
		end)
	else
		frame.Main.Progress1.TextColor3 = frame.Main.Progress1:GetAttribute("txtcol")
		frame.Main.Task1.TextColor3 = frame.Main.Task1:GetAttribute("txtcol")

		if connections[frame.Name] then
			connections[frame.Name]:Disconnect()
			connections[frame.Name] = nil;
		end
		cooldowns[frame.Name] = nil;
	end



	for _,v in pairs(script.Parent:GetDescendants()) do
		if v:IsA("ImageButton") then
			if v.Image:match(BUTT_ONS.Claim) then
				mark.Visible = true;
				return;
			else
				mark.Visible = false;
			end
		end
	end
end


function describe:Describe(data: killData, claims: claimData)
	--warn(data)
	for _,v:Frame in pairs(frame:GetChildren()) do
		if not v:IsA("Frame") then continue end
		local t = v:GetAttribute("type")
		local label = v.Main.Progress1;
		if t == "Player" then
			label.Text = label:GetAttribute("txt"):format(math.clamp(data.Player, -1, label:GetAttribute("goal")))
			if data.Player >= label:GetAttribute("goal") then
				describe:Complete(v, true);
				if claims then
					if claims[v.Name] then
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claimed;
					else
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claim;
					end
				end
			else
				describe:Complete(v, false);
			end
		elseif t == "Zombie" then
			label.Text = label:GetAttribute("txt"):format(math.clamp(data.Zombie + data.Miniboss, -1, label:GetAttribute("goal")))
			if (data.Zombie + data.Miniboss) >= label:GetAttribute("goal") then
				describe:Complete(v, true);
				if claims then
					if claims[v.Name] then
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claimed;
					else
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claim;
					end
				end
			else
				describe:Complete(v, false);
			end
		elseif t == "Boss" then
			label.Text = label:GetAttribute("txt"):format(math.clamp(data.Bossfight, -1, label:GetAttribute("goal")))
			if data.Bossfight >= label:GetAttribute("goal") then
				describe:Complete(v, true);
				if claims then
					if claims[v.Name] then
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claimed;
					else
						v.Main.ClaimButton.Image = str..BUTT_ONS.Claim;
					end
				end
			else
				describe:Complete(v, false);
			end
		end
	end
end

return describe