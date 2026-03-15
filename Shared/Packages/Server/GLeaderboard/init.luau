--// Services
local DataStoreService = game:GetService("DataStoreService");

--// Classes
local ModuleScript = {}
local ClassVariable = {}

--// Services
function ModuleScript.new(PartInstance, LeaderstatsName, TotalItems, RefreshTime)
	
	local self = {}
	local newLeaderboard = {};
	newLeaderboard.__index = ClassVariable
	
	assert(PartInstance:IsA("Part"), "The 1st argument must be a Class of Part.");
	assert(type(LeaderstatsName) == "string", "The 2nd argument must be a type of string; got: " .. type(LeaderstatsName));
	assert(type(RefreshTime) == "number", "The 3rd argument must be a type of number; got: " .. type(RefreshTime))
	
	if PartInstance and LeaderstatsName then
		self.LeaderboardInstance = PartInstance;
		self.LeaderstatsName = tostring(LeaderstatsName);
		self.RefreshTime = tonumber(RefreshTime);
		self.TotalItems = tonumber(TotalItems);
		
		warn("Data successfully set, Global Leaderboard ready to use!")
		return setmetatable(self, newLeaderboard)
	end
	
end

function ClassVariable:UpdateData()
	-->> Errors messages.
	assert(self.LeaderboardInstance and self.LeaderstatsName and self.RefreshTime and self.TotalItems, "You must use ModuleScript.new() before using Leaderboard:UpdateData()")
	
	if self.LeaderboardInstance and self.LeaderstatsName then
		if game.Workspace:FindFirstChild(self.LeaderboardInstance.Name) then
			local SurfaceGui = self.LeaderboardInstance:WaitForChild("SurfaceGui");
			local List = SurfaceGui:WaitForChild("List");
			local Items = List:WaitForChild("Items");

			local OrderedDataStore = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_" .. self.LeaderstatsName)
			local Data = OrderedDataStore:GetSortedAsync(false, self.TotalItems, 1, 10e15);
			local TopPage = Data:GetCurrentPage()

			if #TopPage < 1 then
				Items.Visible = false
			else
				Items.Visible = true
			end

			for i, PlayerData in ipairs(TopPage) do
				local UserId = PlayerData.key;
				local Value = PlayerData.value;
				local Username = "[Not Available]";
				local Color = Color3.fromRGB(38, 50, 56)

				local Success2, ErrorMessage2 = pcall(function()
					Username = game.Players:GetNameFromUserIdAsync(tonumber(UserId))
				end)

				if i == 1 then
					Color = Color3.fromRGB(255, 215, 0)
				elseif i == 2 then
					Color = Color3.fromRGB(192, 192, 192)
				elseif i == 3 then
					Color = Color3.fromRGB(205, 127, 50)
				end

			end

			while wait(self.RefreshTime) do
				self:UpdateInternalData()
			end
		end
	end
end

function ClassVariable:UpdateInternalData()
	local DataStore = DataStoreService:GetOrderedDataStore("GlobalLeaderboard_" .. self.LeaderstatsName)
	local SurfaceGui = self.LeaderboardInstance:WaitForChild("SurfaceGui");
	local List = SurfaceGui:WaitForChild("List");
	local Items = List:WaitForChild("Items");

	for i, v in pairs(game.Players:GetPlayers()) do
		local Stats = v["leaderstats"]:WaitForChild(self.LeaderstatsName).Value
		if Stats then
			pcall(function()
				DataStore:UpdateAsync(v.UserId, function(Value)
					return tonumber(Stats)
				end)
			end)
		end
	end

	for i, v in pairs(Items:GetChildren()) do
		if v:IsA("ImageLabel") then
			v.Frame:TweenPosition(UDim2.new(-2, 0, 0, 0), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.4)
			wait(0.5)
		end
	end

	for i, v in pairs(Items:GetChildren()) do
		if v:IsA("ImageLabel") then
			v:Destroy()
		end
	end

	self:UpdateData()
end

return ModuleScript