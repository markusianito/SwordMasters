-->> roundtroller.lua
--> Handles map vote, map caching, etc.
--> Scripted by Marcos;


local players = game:GetService("Players");
local player = players.LocalPlayer;
local storage = game:GetService("ReplicatedStorage");
local bin = storage:WaitForChild("Packages");
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local net = require(bin:WaitForChild("Net"));

local uied: RemoteEvent = net:RemoteEvent("UiEnableDisable")
local tekst: RemoteEvent = net:RemoteEvent("Intermission");
local vote: RemoteEvent = net:RemoteEvent("VoteMap");
local uimod: RemoteEvent = net:RemoteEvent("UiModify")


--> VOTE RELATED
local uiName = "VoteMap"
local ui = player:WaitForChild("PlayerGui"):WaitForChild(uiName):WaitForChild("MainFrame");
local intermission = player.PlayerGui:WaitForChild("Intermission");
local EventConnection = {}
local deb = {}

--> OBJECTIVE RELATED
local COMPLETED_TEXTCOLOR = Color3.fromRGB(35, 176, 52)
local obj = player.PlayerGui:WaitForChild("Objective");
local frame: Frame = obj:WaitForChild("MainFrame");
local count: Frame = frame:WaitForChild("ObjectiveCount")
local defcol, defstk = count.TextColor3, count:WaitForChild("UIStroke").Color;
local sPos = frame.Position;


local round = knit.CreateController({Name = "RoundController"});
round.ObjectiveGoal = 0;


local function Vote(gui: string, state: boolean, mapsTable: {})
	if gui == uiName then
		if state then
			for i,v in pairs(ui:GetChildren())do
				if v:IsA("ImageLabel") then
					for l,m in pairs(mapsTable) do
						ui["MapImage"..l].Image = workspace:GetAttribute("robloxstr") .. mapsTable[l].Image

					end
				elseif v:IsA("TextButton")then
					for l,m in pairs(mapsTable) do

						ui["Map"..l.."Name"].Text = mapsTable[l].Name
						ui["VoteMap"..l]:SetAttribute("MapName",mapsTable[l].Name)
						ui["Map"..l.."Votes"]:SetAttribute("MapName",mapsTable[l].Name)
						EventConnection = {}
						deb = {}
						EventConnection["VoteMap"..l] = ui["VoteMap"..l].MouseButton1Down:Connect(function()
							if not deb["VoteMap"..l] then
								deb = {}
								deb["VoteMap"..l] = true
								vote:FireServer(l)

							end

						end)
					end
				end
			end
		else
			for _,v:RBXScriptConnection in pairs(EventConnection) do
				v:Disconnect();
				v = nil;
			end
			EventConnection ={}
			for i,v in pairs(ui:GetChildren())do
				if v:IsA("TextLabel") then
					if v:GetAttribute("MapName") then
						v.Text = "0"
					end
				end 
			end
		end
	end
end


local function OnVoteEvent(amounts: {number})
	for i,v in pairs(amounts) do
		local t = ui:FindFirstChild("Map"..i.."Votes")
		if t then
			t.Text = v;
		end
	end
end



local function OnMassage(txt: string)
	intermission.Label.Text = txt;
end


function round:HideObjective()
	frame:TweenPosition(UDim2.new(0, sPos.X.Offset, sPos.Y.Scale, sPos.Y.Offset));
	frame:SetAttribute("Active", false);
end

function round:UpdateObjective(val, max, defaultext)
	val = math.clamp(tonumber(val),0, max or round.ObjectiveGoal or 999)
	count.Text = count:GetAttribute("txt"):format(tostring(val), tostring(max));
	local finished = val == max;

	if finished then
		count.TextColor3 = COMPLETED_TEXTCOLOR;
		count.Parent.ObjectiveDescription.TextColor3 = COMPLETED_TEXTCOLOR;
		
		count.UIStroke.Color = COMPLETED_TEXTCOLOR:Lerp(Color3.new(0,0,0), 0.2);
		count.Parent.ObjectiveDescription.UIStroke.Color = COMPLETED_TEXTCOLOR:Lerp(Color3.new(0,0,0), 0.2);
	end

	if defaultext then
		count.Parent.ObjectiveDescription.Text = defaultext;
	end
end

function round:ShowObjective(max, defaultext, amount)
	if frame:GetAttribute("Active") then
		return true;
	end
	round.ObjectiveGoal = max;

	round:UpdateObjective(amount, round.ObjectiveGoal, defaultext)

	count.TextColor3 = defcol
	count.Parent.ObjectiveDescription.TextColor3 = defcol

	count.UIStroke.Color = defstk
	count.Parent.ObjectiveDescription.UIStroke.Color = defstk
	
	frame:TweenPosition(sPos, Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 0.7)
	frame:SetAttribute("Active", true);
end


function round:KnitInit()
	frame:SetAttribute("Active", false);
end


function round:KnitStart()
	round:HideObjective();
	uied.OnClientEvent:Connect(Vote);
	tekst.OnClientEvent:Connect(OnMassage)
	vote.OnClientEvent:Connect(OnVoteEvent)

	uimod.OnClientEvent:Connect(function(ui: string, args: {})
		if ui == obj.Name then
			if args.State == true then -- if state is nil or not boolean, nothing will happen related to state.
				round:ShowObjective(args.Max, args.ObjectiveText, args.Amount or 0);
			elseif args.State == false then
				round:HideObjective();
			end

			if args.Amount then
				round:UpdateObjective(args.Amount, args.Max or round.ObjectiveGoal, args.ObjectiveText);
			end
		end
	end)
	
	
	
	print("RoundController is ready")
end





return round;