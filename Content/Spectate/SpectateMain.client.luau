--disable
-- TODO:revamp_this_system
-->> SpectateMain.lua - Client
--> Main spectate program for SM. made by marcos

task.wait(5);

local runSvc = game:GetService("RunService");
local bot = script.Parent:WaitForChild("Button");
local frm = script.Parent:WaitForChild("MainFrame");
local back, fwrd = frm:WaitForChild("BackSpectate"), frm:WaitForChild("ForwardSpectate");
local name = frm:WaitForChild("SpectateNickname");
local cam = workspace.CurrentCamera;
local plr = game.Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui");
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));

local lighting = knit.GetService("LightingProvider");
local round = knit.GetService("RoundService");

local getGui = function(name)
	return plrGui:WaitForChild(name);
end

local SPECTATING = false;

local guis = {
	getGui("Stamina");
	getGui("Shop");
	getGui("Settings");
	getGui("RobuxShop");
	getGui("Inventory");
	getGui("AbilitySlot");
	getGui("Sword");
	getGui("AbilitiesShop");
	getGui("Codes");
	getGui("Achievements")
}
local abguis = {
	getGui("Codes");
	getGui("Settings");
	getGui("Achievements");
	getGui("Quests");
	getGui("Inventory");
	getGui("RobuxShop");
	getGui("AbilitiesShop");
	getGui("Shop");
	getGui("Objective");
}

local warriors:{string} = {};
local connections:{RBXScriptConnection} = {};

local function arbitraryED(e)
	for _,v in pairs(abguis) do
		v.Enabled = e
	end
end

local function ED(e)
	SPECTATING = not e;
	for _,v in pairs(guis) do
		v.Enabled = e
	end
	if e then
		script.Parent.Parent.BossHP.Frame.Visible = not e
		return;
	end
	if workspace.GameMap:FindFirstChild("Map") then
		if workspace.GameMap.Map:GetAttribute("Mode") == "Bossfight" then
			
			script.Parent.Parent.BossHP.Frame.Visible = not e
		end
	end
end

local function Cleanup()
	cam.CameraSubject = plr.Character.Humanoid;
	for _,v:RBXScriptConnection in pairs(connections) do
		if typeof(v)=="RBXScriptConnection" then
			v:Disconnect();
			v = nil;
		end
	end
	table.clear(connections);
end

local function Sort()
	local t2 = {};
	local index = 1
	for _, v in ipairs(warriors) do
		t2[index] = v
		index += 1;
	end
	warriors = t2;
	t2 = nil;
	index = nil;
end

local index = 0;
local function Focus(i)
	--print(i);
	index = i<=#warriors and i or 1
	if index == 0 then
		cam.CameraType=Enum.CameraType.Custom
		cam.CameraSubject = plr.Character.Humanoid;
		frm.Visible = false;
		ED(true)
		Cleanup();
		return;
	end
	i = warriors[index] and warriors[index] or plr.Name
	cam.CameraType=Enum.CameraType.Custom
	cam.CameraSubject = workspace[i].Humanoid;
	name.Text = workspace[i].Name;
	if i == plr.Name then
		lighting:SetupLighting(lighting:Get("Lobby"))
	end
end

runSvc.Heartbeat:Connect(function() --> Main Heartbeat tasks for this program.

	--if plr.Character then
		if plr:GetAttribute("IsInRound" ) then
			bot.Visible = false	;
			frm.Visible = false	;
			return;
		else
			if (round.Running)  then
				bot.Visible = true	;
			else
				bot.Visible = false	;
			end
		end
	--end
	
	--if not SPECTATING then
	arbitraryED(not not not plr:GetAttribute("IsInRound"))
	--end
	if not round.Running then bot.Visible=false return; end
	for _,plr: Player in pairs(game:GetService("Players"):GetPlayers()) do
		local v = workspace:FindFirstChild(plr.Name);
		if v then
			if plr:GetAttribute("IsInRound") then
				if not table.find(warriors,v.Name) then
					table.insert(warriors, v.Name);
					Sort();
					connections[v.Name] = v.Humanoid.Died:Once(function()
						local i = table.find(warriors,v.Name);
						if i then
							table.remove(warriors,i);
							Sort();
							Focus(index);
						end
					end)
				end
			else
				local i = table.find(warriors, v.Name);
				if i then
					warriors[i] = nil;
					Sort();
					Focus(index)
				end
			end
		end
	end
end)

local executing=false;
local function Alternate()
	task.wait()
	if not executing then
		executing = true;
		ED(not frm.Visible)
		if frm.Visible then
			task.wait()
			if #warriors == 0 then
				name.Text = "no people in round"
				Focus(0);
			else
				local a = workspace:FindFirstChild("Map")
				if a then
					lighting:SetupLighting(a:GetAttribute("Name"))
					Focus(1)
				else
					lighting:SetupLighting(lighting:Get("Lobby"))
					Focus(0);
				end
			end;
		else
			if not plr:GetAttribute("IsInRound") then
				lighting:SetupLighting(lighting:Get("Lobby"))
			end
			cam.CameraSubject = plr.Character.Humanoid;
			warriors = {};
		end
		task.wait(0.1);
		executing = false;
	end
end

frm:GetPropertyChangedSignal("Visible"):Connect(Alternate);
bot:GetPropertyChangedSignal("Visible"):Connect(Alternate)
plr.CharacterAdded:Connect(Alternate)


back.MouseButton1Click:Connect(function()
	if #warriors == 0 then return; end
	index -= 1
	if index <= 0 then
		index = #warriors
	end
	Focus(index)
end)

fwrd.MouseButton1Click:Connect(function()
	if #warriors == 0 then return; end
	index += 1;
	if index > #warriors then
		index = 1;
	end
	Focus(index);
end)

--[][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][]
-->> ED.lua - Client
--> Enable/Disable gui manager portable by Marcos aka Juank
--> Outdated.

local is = false;
bot.MouseButton1Click:Connect(function()
	if not is then
		is = true;
		frm.Visible = not frm.Visible;
		task.wait(0.15);
		is = false;
	end
end)