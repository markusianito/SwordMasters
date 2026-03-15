-->> Main.lua - Client
--> Main Program for PlayerStats Admin panel frame

--\\\\\\\\\\\\\\\\\\\\\\\\\\\\
--| Scripted by Marcos Saenz |
--////////////////////////////


export type UserInventory = {
	Swords: {string},
	Skins: {string},
	Abilities: {string}
}


export type InfoTable = {
	Name: string,
	XP: string,
	LastOnline: string,
	PlayerImage: string,
	
	Level: number,
	Coins: number,
	
	Inventory: UserInventory,
	
	Quests: table,
	QuestProgress: table,
	
	RedeemedCodes: {string},
	KillStats: {string: number},
	PunishmentHistory: {{Type: string, Reason: string}}
}



local events = game.ReplicatedStorage.RemoteEvents.Admin;
local ask = events.AskForStats;


local frame = script.Parent;
local inventory = frame:WaitForChild("Inventory");
local cmd = frame:WaitForChild("CommandEnter");
local cmdRun = frame:WaitForChild("ConfirmButton");
local idBox = frame:WaitForChild("ID");
local playerImg = frame:WaitForChild("Player");
local lvl = frame:WaitForChild("Level");
local lastOnline = frame:WaitForChild("LastOnline");
local name = frame:WaitForChild("Nickname");
local coins = frame:WaitForChild("Coins");
local xp = frame:WaitForChild("XP");




local module = {}
module.FunctionBank = {}



module.__call = function(t, ...) -->> Main
	
	idBox.FocusLost:Connect(function(enter, i)
		local info: InfoTable = module.GetInfoFromID(idBox)
		module:Describe(info);
	end)
	
	warn("Admin Panel: PlayerStats initialized.")
	return t;
end



function module.FunctionBank.ID(id)
	return ask:InvokeServer(id)
end

function module.FunctionBank.Name(str)
	name.Text = str;
end

function module.FunctionBank.Coins(num)
	coins.Text = coins:GetAttribute("txt"):format(num);
end

function module.FunctionBank.LastOnline(str)
	if str == "now" then
		
		lastOnline.TextColor3 = Color3.fromRGB(20, 255, 79)
		lastOnline.UIStroke.Color = Color3.fromRGB(10, 131, 40)
		
		lastOnline.Text = "Online";
		
	else
		
		lastOnline.TextColor3 = Color3.fromRGB(255, 255, 255)
		lastOnline.UIStroke.Color = Color3.fromRGB(66, 66, 66)

		lastOnline.Text = lastOnline:GetAttribute("txt"):format(str)
	end
end

function module.FunctionBank.PlayerImage(id)
	playerImg.Image = id -- "https://www.roblox.com/headshot-thumbnail/image?userId="..id.."&width=420&height=420&format=png";
end

function module.FunctionBank.Level(num)
	lvl.Text = lvl:GetAttribute("txt"):format(num);
end

function module.FunctionBank.XP(str: string|number)
	xp.Text = str -- at the moment
end

function module.FunctionBank.Inventory(t: UserInventory)
	-- TODO::SlotInScrollingFrameForEveryItem.
	
end




function module.GetInfoFromID(box:TextBox)
	local value = tonumber(box.Text)
	if value then
		if module.FunctionBank[box.Name] then
			return module.FunctionBank[box.Name](value);
		end
	else
		value = 0;
		box.Text = value
		return nil;
	end
end



function module:Describe(info: InfoTable)
	for i,v in pairs(info) do
		if module.FunctionBank[i] then
			module.FunctionBank[i](v);
		end
	end
end



return setmetatable({},module)
