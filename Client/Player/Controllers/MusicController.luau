-->> MusicController.luau
-- Handles background music, etc in Sword Masters
--> Scripted by Marcos


local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages
local knit = require(bin:WaitForChild("Knit"):WaitForChild("KnitClient"));
local plr = knit.Player
local char = plr.Character or plr.CharacterAdded:Wait();

local soundSvc = game:GetService("SoundService");
local runSvc = game:GetService("RunService");
local bost = soundSvc:WaitForChild("BackgroundOST");
local mute = plr:WaitForChild("PlayerGui"):WaitForChild("SoundsProgram"):WaitForChild("MuteButton");
local MUTED = workspace:GetAttribute("robloxstr") .. 108975765930887;
local PLAYING = workspace:GetAttribute("robloxstr") .. 132694754677036;


local isLobby = true;
local currentMap = "Lobby";
local changed = false;

local playing = "Lobby";

local MusicController = knit.CreateController({Name = "MusicController"});







function MusicController:KnitInit()

end

function MusicController:KnitStart()
	local round = knit.GetService("RoundService")

	local c = 0;
	repeat c += task.wait() until (#bost:GetChildren() >= 7) or (c > 10)

	if c > 10 then
		warn("Failed to load all background ost")
		plr:Kick("Failed to download assets, exit code 2");
		return;
	end



	local FadeOut = function(sound: Sound)
		local t = 0;
		local s = sound:GetAttribute("Volume");
		--task.spawn(function()
		while t < 1 do
			t += task.wait() * 2;
			sound.Volume = s * (1 - t);
		end
		--sound:Pause();
		--end)
	end

	local FadeIn = function(sound: Sound)
		local t = 0;
		local s = sound:GetAttribute("Volume");
		sound.Volume = 0;
		sound:Play();
		--task.spawn(function()
		while t < 1 do
			t += task.wait() * 2;
			sound.Volume = s * t;
		end
		--end)
	end



	runSvc.Heartbeat:Connect(function(dt)
		pcall(function()
			isLobby = not knit.Player.Character:GetAttribute("IsInRound")
		end)
		--warn(isLobby)
		if isLobby then
			if not changed then
				if playing ~= "Lobby" then
					FadeOut(bost[playing]);
				end
				FadeIn(bost.Lobby);

				playing = "Lobby";
				currentMap = "Lobby";

				changed = true;
				--warn("Lobby")
			end
		else
			if changed then
				FadeOut(bost.Lobby);
				changed = false;
			end
		end
	end)

	round.RoundStarted:Connect(function(map)
		local ok, err = pcall(function()
			FadeIn(bost[map])

			currentMap = map;
			playing = map;

			--warn(map);
		end)
		if err then
			warn(err);
		end

		changed = false;
	end)


	local k = 0.1
	mute.MouseButton1Click:Connect(function()
		local img;
		if mute.Image == PLAYING then
			img = MUTED;
			bost.Volume = 0;
		else
			img = PLAYING;
			bost.Volume = 0.5;
		end

		for i = 0,1,k do
			task.wait()
			mute.ImageTransparency = i;
		end
		mute.Image = img;

		for i = 1,0,-k do
			task.wait()
			mute.ImageTransparency = i;
		end
	end)


	mute.Image = MUTED;

	task.wait(1);

	mute.Image = PLAYING
end


return MusicController;