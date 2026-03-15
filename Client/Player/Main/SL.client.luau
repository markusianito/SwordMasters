--disable
-->> SL.lua - Client
--> Shiftlock mgr


local KEY = Enum.KeyCode.LeftControl;



local forceSL = require(game.ReplicatedStorage.Packages:WaitForChild("Net")):RemoteEvent("Shiftlock")
local sl = game.ReplicatedStorage.ClientEvents.Shiftlock;
local InputService=game:GetService("UserInputService")
local plr = game.Players.LocalPlayer;
local char = plr.Character or plr.CharacterAdded:Wait();
local hum:Humanoid = char:WaitForChild("Humanoid");

local plrModule = require(plr:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")).new()

local SL = function(enabled)
	plrModule:ForceLock(enabled);
	hum.CameraOffset = Vector3.new(enabled and 1.75 or 0, 0, 0)
	InputService.MouseIconEnabled = not enabled
end


local override = false;

sl.Event:Connect(function(enabled)
	if override then return end
	SL(enabled)
end)

forceSL.OnClientEvent:Connect(function(enabled, f)
	override = f;
	SL(enabled);
end)


local called = false;

InputService.InputBegan:Connect(function(i, gpe)
	if gpe then return end
	if i.KeyCode == KEY then
		called = not called
		sl:Fire(called);
	end
end)


--[[
while task.wait() do
	if InputService:IsKeyDown(KEY) then
		if not called then
			called = true;
			sl:Fire(true);
		end
	else
		if called then
			called = false;
			sl:Fire(false);
		end
	end
end]]