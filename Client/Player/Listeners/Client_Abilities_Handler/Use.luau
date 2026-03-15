local Use = {}

local plr = game.Players.LocalPlayer;
local char = plr.Character or plr.CharacterAdded:Wait();
local hum:Humanoid = char:WaitForChild("Humanoid");
local mouse = plr:GetMouse();
local runSvc = game:GetService("RunService");
local InputService=game:GetService("UserInputService")
local Libraries=require(game.ReplicatedStorage.Client_Modules.Libraries)
local StatesOfDevice=Libraries.StatesOfDevice
local Display=require(script.Parent.Display)
local Replicated_Settings=require(game:GetService("ReplicatedStorage"):WaitForChild("Client_Modules"):WaitForChild("ReplicatedSettings"))
local bring=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Bring")
local cback=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Callback")
local stamed = game.ReplicatedStorage.ClientEvents.StaminaED;
local cfg = require(game.ReplicatedStorage.Abilities.AbilitiesCfg);



local AbilityClientFunctoins
local loaded;

local function dwait(ab: string)
	if cfg.Unlockable[ab] then
		task.wait(0.2);
		return true;
	end
	return false;
end

local fbSets = Replicated_Settings.Abilities.Fireball;


cback.OnClientInvoke = function(abilityName,...)
	if AbilityClientFunctoins[abilityName]==nil then print("no callback function to handle "..abilityName.." ability") return end
	return AbilityClientFunctoins[abilityName](...)
end

local usedAbilities={}
local clientData={}

local getch = function(isCel)
	local ready = false;
	local ded = false;
	local readyFunc = function()
		ready = true;
	end
	if isCel then
		InputService.TouchTap:Once(readyFunc)
	else
		mouse.Button1Down:Once(readyFunc)
	end
	
	hum.Died:Once(readyFunc);
	
	while not ready do
		task.wait();
		if char then
			if not not char:GetAttribute("DamageMultiplier") then
				ded = true;
				ready = true;
			end
		end
	end
	
	return not ded
end





local TheParams = RaycastParams.new() --->>>>>>  THE SIGN REFRENCE OMG :0
TheParams.FilterType = Enum.RaycastFilterType.Include;


local functoins = {
	["getch"] = getch;
}


local run = function(func, ...)
	local params = {...};
	local data = nil;
	local ain;
	
	local suck,err = pcall(function()
		local f = functoins[func]
		if f then
			data = f(table.unpack(params));
			ain = true;
		else
			warn("no function for "..func.." was found");
			ain = false;
		end
	end)
	if not suck then
		warn(err);
		return false, nil, err
	end
	return ain, data
end


AbilityClientFunctoins = {
	["Laser beam"] = function(func, ...)
		return run(func, ...);
	end,
	
	
	
	
	["Fireball"] = function( open)
		local ded = false;
		local dedF = hum.Died:Once(function()
			if clientData.Placeholder then
				clientData.Placeholder:Destroy();
			end
			if clientData.dot then
				clientData.dot:Destroy();
			end
			ded = true;
		end)
		
		TheParams.FilterDescendantsInstances = {workspace.GameMap.Map.Destroyables}
		
		local dots = workspace:FindFirstChild("Dots")
		if not dots then
			dots = Instance.new("Folder");
			dots.Name = "Dots";
			dots.Parent = workspace;
		end
		
		local char = plr.Character;
		local hrp:Part = char.HumanoidRootPart;
		local ball = char:FindFirstChild("Left Arm").Fireball
		local hum:Humanoid = char.Humanoid
		
		clientData.Placeholder = Instance.new("Part");
		local ph = clientData.Placeholder;
		ph.Color = Color3.fromRGB(37, 255, 128);
		ph.Material = Enum.Material.Neon;
		ph.Shape = Enum.PartType.Cylinder
		ph.Size = Vector3.new(1,3,3);
		ph.Anchored = true;
		ph.CanCollide = false;
		ph.Name = "placeholder_" .. plr.Name;
		ph.Parent = workspace;
		
		local rayparams = RaycastParams.new();
		rayparams.RespectCanCollide = true;
		rayparams.CollisionGroup = "Player";
		rayparams.FilterType = Enum.RaycastFilterType.Include;
		rayparams.FilterDescendantsInstances = {workspace}
		
		
		
		clientData.dot = Instance.new("Part");
		local dot = clientData.dot
		dot.CanCollide = false;
		dot.CanQuery = false;
		dot.Transparency = 1;
		dot.Anchored = true;
		dot.Name = " ";
		dot.Parent = workspace

		if ded then return {}, true; end
		
		repeat task.wait() until hum.FloorMaterial ~= Enum.Material.Air;
		
		if ded then return {}, true; end
		
		--local y = workspace.Map.MapRound:FindFirstChild("Floor") and workspace.Map.MapRound.Floor.Position.Y or hrp.Position.Y+-2.7
		
		
		if not StatesOfDevice.isMobile then

			clientData.AimConnection = runSvc.Heartbeat:Connect(function()
				local ray = workspace:Raycast(
					mouse.Origin.Position,
					mouse.Hit:ToWorldSpace(CFrame.new(0,0,-50)).Position - mouse.Origin.Position,
					rayparams
				)
				if ray then
					ph.CFrame = CFrame.new(
						math.clamp(
							ray.Position.X,
							hrp.Position.X-fbSets.MaxRadius,
							hrp.Position.X+fbSets.MaxRadius
						),
						--y,
						math.clamp(
							ray.Position.Y,
							hrp.Position.Y-fbSets.MaxRadius,
							hrp.Position.Y+fbSets.MaxRadius
						),
						math.clamp(
							ray.Position.Z,
							hrp.Position.Z-fbSets.MaxRadius,
							hrp.Position.Z+fbSets.MaxRadius
						)
					) * CFrame.Angles(0, 0, math.rad(90));


					dot.Position = Vector3.new(
						ph.Position.X,
						ph.Position.Y +3,
						ph.Position.Z
					)
				end
				local ray = workspace:Raycast(ball.Position, dot.Position - (ball.Position + Vector3.new(0,3,0)),TheParams);
				if ray then
					--ph.Color = Color3.fromRGB(255, 194, 51);
				else
					ph.Color = Color3.fromRGB(37, 255, 128);
				end
			end)
			if ded then return {}, true; end

			getch();

			if ded then return {}, true; end

			bring:FireServer(true);
			
			if clientData.AimConnection then
				clientData.AimConnection:Disconnect();
			end
			clientData.AimConnection = nil;

			hrp.CFrame = CFrame.lookAt(hrp.Position, dot.Position);
			hrp.Anchored = true;

			local dist = math.ceil((ball.Position - dot.Position).Magnitude)



			for i = 1,dist do
				if ded then return {}, true; end
				local p = Instance.new("Part");
				p.Anchored = true;
				p.CanCollide = false;
				p.Color = Color3.fromRGB(37, 255, 128);
				p.Material = Enum.Material.Neon;
				p.Size = Vector3.one;
				p.Transparency = (i%2==0) and 1 or 0.5;
				p.Shape = Enum.PartType.Ball;
				p.Name = "dot_"..tostring(i);
				p.Parent = dots;
			end

			local adjust = function(factor)
				for i,v in pairs(dots:GetChildren()) do
					i = tonumber(v.Name:sub(5))
					v.CFrame = ball.CFrame:Lerp(dot.CFrame, i / dist) + Vector3.new(0,factor * math.sin(math.pi * (i / dist)),0)
				end
			end

			adjust(6);

			local dy, maxY = mouse.Y, mouse.ViewSizeY

			clientData.AdjustConnection = runSvc.Heartbeat:Connect(function()

				local delta = math.clamp(
					math.abs(

						6 - ((mouse.Y - dy) / 9)

					), 0, 36
				)



				adjust(
					delta
				)
			end)

			local getched = true;
			local timeOut = 0

			clientData.UnGetchConnection = mouse.Button1Up:Connect(function()
				getched = false
			end)

			while getched do
				if ded then return {}, true; end
				timeOut += runSvc.Heartbeat:Wait();

				if timeOut >= 3 then
					getched = false;
				end
			end

			if clientData.UnGetchConnection then
				clientData.UnGetchConnection:Disconnect();
			end
			clientData.UnGetchConnection = nil;

			if clientData.AdjustConnection then
				clientData.AdjustConnection:Disconnect();
			end
			clientData.AdjustConnection = nil;

			if clientData.FilterConnection then
				clientData.FilterConnection:Disconnect();
				clientData.FilterConnection = nil
			end


			local positions = {};
			for i,v:Part in pairs(dots:GetChildren()) do
				positions[tonumber(v.Name:sub(5))] = v.Position;
			end

			hrp.Anchored = false;

			dots:ClearAllChildren();
			ph:Destroy();
			dot:Destroy();
			clientData.Placeholder = nil;
			clientData.dot = nil

			shared.lood = nil;

			return positions
			
		else --> IS MOBILE

			clientData.AimConnection = InputService.TouchMoved:Connect(function(_, gpe)
				if gpe then return end;
				local ray = workspace:Raycast(
					mouse.Origin.Position,
					mouse.Hit:ToWorldSpace(CFrame.new(0,0,-50)).Position - mouse.Origin.Position,
					rayparams
				)
				if ray then
					ph.CFrame = CFrame.new(
						math.clamp(
							ray.Position.X,
							hrp.Position.X-fbSets.MaxRadius,
							hrp.Position.X+fbSets.MaxRadius
						),

						math.clamp(
							ray.Position.Y,
							hrp.Position.Y-fbSets.MaxRadius,
							hrp.Position.Y+fbSets.MaxRadius
						),
						math.clamp(
							ray.Position.Z,
							hrp.Position.Z-fbSets.MaxRadius,
							hrp.Position.Z+fbSets.MaxRadius
						)
					) * CFrame.Angles(0, 0, math.rad(90));


					dot.Position = Vector3.new(
						ph.Position.X,
						ph.Position.Y +3,
						ph.Position.Z
					)
				end
				local ray = workspace:Raycast(ball.Position, dot.Position - (ball.Position + Vector3.new(0,3,0)),TheParams);
				if ray then
					--ph.Color = Color3.fromRGB(255, 194, 51);
				else
					ph.Color = Color3.fromRGB(37, 255, 128);
				end
			end)

			getch(true);

			bring:FireServer(true);
			if clientData.AimConnection then
				clientData.AimConnection:Disconnect();
			end
			clientData.AimConnection = nil;

			hrp.CFrame = CFrame.lookAt(hrp.Position, dot.Position);
			hrp.Anchored = true;

			local dist = math.ceil((ball.Position - dot.Position).Magnitude)



			for i = 1,dist do
				local p = Instance.new("Part");
				p.Anchored = true;
				p.CanCollide = false;
				p.Color = Color3.fromRGB(0, 0, 0);
				p.Material = Enum.Material.Neon;
				p.Size = Vector3.one;
				p.Transparency = (i%2==0) and 1 or 0.5;
				p.Shape = Enum.PartType.Ball;
				p.Name = "dot_"..tostring(i);
				p.Parent = dots;
			end

			local adjust = function(factor)
				for i,v in pairs(dots:GetChildren()) do
					i = tonumber(v.Name:sub(5))
					v.CFrame = ball.CFrame:Lerp(dot.CFrame, i / dist) + Vector3.new(0,factor * math.sin(math.pi * (i / dist)),0)
				end
			end

			adjust(6);

			local dy, maxY = mouse.Y, mouse.ViewSizeY

			clientData.AdjustConnection = InputService.TouchMoved:Connect(function()

				local delta = math.clamp(
					math.abs(

						6 - ((mouse.Y - dy) / 9)

					), 0, 36
				)



				adjust(
					delta
				)
			end)

			local getched = true;
			local timeOut = 0

			clientData.UnGetchConnection = InputService.TouchEnded:Connect(function()
				getched = false
			end)

			while getched do
				timeOut += runSvc.Heartbeat:Wait();

				if timeOut >= 3 then
					getched = false;
				end
			end

			if clientData.UnGetchConnection then
				clientData.UnGetchConnection:Disconnect();
			end
			clientData.UnGetchConnection = nil;

			if clientData.AdjustConnection then
				clientData.AdjustConnection:Disconnect();
			end
			clientData.AdjustConnection = nil;

			if clientData.FilterConnection then
				clientData.FilterConnection:Disconnect();
				clientData.FilterConnection = nil
			end


			local positions = {};
			for i,v:Part in pairs(dots:GetChildren()) do
				positions[tonumber(v.Name:sub(5))] = v.Position;
			end

			hrp.Anchored = false;

			dots:ClearAllChildren();
			ph:Destroy();
			dot:Destroy();
			clientData.Placeholder = nil;
			clientData.dot = nil

			shared.lood = nil;

			return positions
		end
	end
}



local disturb = script.Parent.Disturb
disturb.Event:Connect(function(key)
	if key then
		table.clear(usedAbilities);
	end
end)


Use.Init=function(self)
	local Load=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Load")
	local Loaded=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Loaded")
	local Unlock=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Unlock")
	local UseEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("Abilities"):WaitForChild("Use")
	
	local function checkKeyCodeSettingsConsistency(keyCode:Enum.KeyCode):boolean
		for i,v in pairs(Replicated_Settings.Abilities.ActivatingKeys) do
			if v==keyCode then return true end
		end
		return false
	end
	
	local function checkCooldownSettingsConsistency(abilityName:string):boolean
		if Replicated_Settings.Abilities[abilityName].Cooldown==nil then warn("replicated_settings issue -> abilities cooldown is not conistent (probably misspelled name or lack of some ability cooldown information)") return false end
		return true
	end
	
	local function getSlotNumberFromKeyCode(keyCode:Enum.KeyCode)
		for i,v in pairs(Replicated_Settings.Abilities.ActivatingKeys) do
			if v==keyCode then 
				local gsubedString,nothing=string.gsub(i,"Slot","")
				local slotNumber=tonumber(gsubedString)
				return slotNumber
			end
		end
		return nil
	end
	
	local function loadAbility(abilityName:string)
		--defences
		--print("defences")
		if abilityName==nil then print(abilityName) return end
		if not shared.IsRoundRunning then           return end
		if not shared.IsInRound then                return end

		--print("passed defences")
		stamed:Fire(false);

		
		if usedAbilities[abilityName] then
			if os.clock()-usedAbilities[abilityName]>=(Replicated_Settings.Abilities[abilityName].Cooldown + 0.1) then
				--warn("Exists")
				return Load:InvokeServer(abilityName);
			end
		else
			--warn"No exists"
			return Load:InvokeServer(abilityName);
		end
	end
	
	local function useAbility(abilityName:string)
		dwait(abilityName)
		--defences
		--print("defences")
		if abilityName==nil then print("abilityName") return end
		if not shared.IsRoundRunning then print("round not running") return end
		if not shared.IsInRound then print("is not in round") return end
		if not checkCooldownSettingsConsistency(abilityName) then print("inconsistent") return end


		if usedAbilities[abilityName]==nil then
			usedAbilities[abilityName]=os.clock()
			UseEvent:FireServer(abilityName)
			Display.UseAbility(abilityName)
		else
			if os.clock()-usedAbilities[abilityName]>=(Replicated_Settings.Abilities[abilityName].Cooldown + 0.1) then
				usedAbilities[abilityName]=os.clock()
				UseEvent:FireServer(abilityName)
				Display.UseAbility(abilityName)
			end
		end

		stamed:Fire(true);
	end
	
	Loaded.OnClientEvent:Connect(function(ab)
		if not ab then return end
		useAbility(ab);
	end)

	local Consistent = false;
	
	local function call(ab)
		Display.ReleaseActivationKey()
		if Consistent then
			useAbility(shared.EquippedAbilities[ab or 1])
			Consistent = false;
		end
	end
	shared.thing = "THINGA"
	shared.running = false;
	
	local ainBegan = function(input)
		input = input or {KeyCode = Enum.KeyCode.E};
		local abilityName = shared.EquippedAbilities[getSlotNumberFromKeyCode(input.KeyCode)];
		dwait(abilityName)
		shared.running = true;
		Display.HoldActivationKey()

		Consistent = true;
		
		--task.spawn(function()
			shared.lood = loadAbility(abilityName);
			if shared.lood then
				call(getSlotNumberFromKeyCode(input.KeyCode))
			end

			shared.lood = nil;
			shared.running = false;
		Display.ReleaseActivationKey();
		--end)
	end
	
	local ainEnded = function(input)
		task.wait(0.1);
		input = input or {KeyCode = Enum.KeyCode.E};
		local abilityName = shared.EquippedAbilities[getSlotNumberFromKeyCode(input.KeyCode)];
		dwait(abilityName)

		if not shared.running then
			Display.ReleaseActivationKey();
		end

		if shared.lood or Unlock:InvokeServer(shared.EquippedAbilities[1]) then
			call(getSlotNumberFromKeyCode(input.KeyCode));
		end

		shared.lood = nil;
	end
	
	
	if not StatesOfDevice.isMobile then -- IS PC
		InputService.InputBegan:Connect(function(input,gameProcessedEvent)
			if shared.running then return end;
			--defences
			--print("input began", input.KeyCode)
			if gameProcessedEvent then     return end
			if input.KeyCode==nil then     return end
			if not checkKeyCodeSettingsConsistency(input.KeyCode) then     return end
			
			ainBegan(input);
		end)
		
		InputService.InputEnded:Connect(function(input,gameProcessedEvent)
			--task.wait(.1);
			--if running then return end
			if gameProcessedEvent then     return end
			if input.KeyCode==nil then     return end
			if not checkKeyCodeSettingsConsistency(input.KeyCode) then     return end
			
			ainEnded(input);
		end)
	end
	
	hum.Died:Connect(function()
		shared.running = false;
		shared.lood = true;
		Display.ReleaseActivationKey();
	end)
	
	local AbilitySlot=game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("AbilitySlot")
	local abilityButton1:ImageButton=AbilitySlot:WaitForChild("Slot1")
	
	
	
	abilityButton1.MouseButton1Down:Connect(function()
		if shared.running then return end;
		ainBegan();
	end)

	abilityButton1.MouseButton1Up:Connect(function()
		--if running then return end;
		ainEnded();
	end)
	abilityButton1.MouseLeave:Connect(function()
		--if running then return end;
		ainEnded();
	end)
end

return Use
