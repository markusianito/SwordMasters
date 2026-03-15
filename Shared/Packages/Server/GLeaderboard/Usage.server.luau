--disable
 --// Services
local DataStore = game:GetService("DataStoreService"):GetDataStore("PointsDataStore")

--// Dependencies
local Leaderboard_Part = game.Workspace:WaitForChild("Leaderboard");
local SurfaceGui = Leaderboard_Part:WaitForChild("SurfaceGui");
local List = SurfaceGui:WaitForChild("List");
local Items = List:WaitForChild("Items");

--// Functions
game.Players.PlayerAdded:Connect(function(Player)
	local Leaderboard = require(script.Parent.GLeaderboard); --> DO NOT edit this, otherwise the leaderboard will not work.
	
	local Leaderstats = Instance.new("Folder");
	Leaderstats.Parent = Player
	Leaderstats.Name = "leaderstats"
	
	local Points = Instance.new("IntValue");
	Points.Parent = Leaderstats
	Points.Name = "Points"
	Points.Value = 0
	
	local UserKey = Player.UserId .. "-PointsData"
	local Data
	local Success, Error = pcall(function()
		Data = DataStore:GetAsync(UserKey)
	end)
	
	if Success then
		Points.Value = Data;
		print("Points successfully updated.")
	else
		print("Leaderstats error: " , Error)
	end
	
	local newLeaderboard = Leaderboard.new(Leaderboard_Part, "Points", 10, 10);
	newLeaderboard:UpdateData()
end)

game.Players.PlayerRemoving:Connect(function(Player)
	local UserKey = Player.UserId .. "-PointsData"
	local Success, Error = pcall(function()
		DataStore:SetAsync(UserKey, Player.leaderstats.Points.Value);
	end)
	
	if Success then
		print("Points successfully saved.")
	else
		print("Leaderstats error: " , Error)
	end
end)

game:BindToClose(function()
	for i, Player in pairs(game.Players:GetPlayers()) do
		local UserKey = Player.UserId .. "-PointsData"
		local Success, Error = pcall(function()
			DataStore:SetAsync(UserKey, Player.leaderstats.Points.Value);
		end)

		if Success then
			print("Points successfully saved.")
		else
			print("Leaderstats error: " , Error)
		end
	end
end)