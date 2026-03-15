	-->> Main.lua - Client
--> Main Quests program for SM

export type Quest = {
	Mission: {
		Eliminate: {
			Players: number|nil,
			Enemies: number|nil,
			Boss: number|nil
		}?,

		Win: {
			Round: {
				Mode: string|nil,
				Amount: number
			}
		}?
	},

	Reward: {
		Coins: number|nil,
		XP: number|nil
	}
}



export type QuestProgress = {
	Amount: number;
	Claimed: boolean
}

local quests = require(game.ReplicatedStorage.StandardLibraries.Quests);

local storage = game:GetService("ReplicatedStorage");
local net = require(storage.Packages.Net);


local data = net:RemoteFunction("QuestData")
local claim = net:RemoteEvent("ClaimQuest")
local timer = net:RemoteEvent("UpdateTimer");
local req = net:RemoteEvent("UpdateSignal");
local update = net:RemoteEvent("UpdateQuestInfo");

local frm = script.Parent:WaitForChild("MainFrame");
local q = {frm:WaitForChild("Quest1Frame"), frm:WaitForChild("Quest2Frame"), frm:WaitForChild("Quest3Frame")}
local cool = frm:WaitForChild("Cooldown");
local reroll = frm:WaitForChild("Reroll");
local seconds = script.Seconds;

local killStr = "Eliminate %d %s";
local winStr = "Win %d rounds"
local roundStr = "%s in %s Mode"


local claimConns = {}
local claimCooldown = {}

local goals = {}

local CompileData = function(quest, rarity:string, slotNum: number)
	local slot = q[tonumber(slotNum)];
	slot:WaitForChild("QuestRarity").Text = `{rarity} Quest:`;
	slot.QuestRarity.TextColor3 = quests.Colors[rarity];


	local str, str2 = "", slot:WaitForChild("Amount"):GetAttribute("txt");
	if quest.Mission.Eliminate then
		local players = quest.Mission.Eliminate.Players;
		local enemies = quest.Mission.Eliminate.Enemies;
		local boss = quest.Mission.Eliminate.Boss;
		
		if players then
			goals[slotNum] = players
			str = string.format(killStr, players, "Players");
			str2 = str2:format(script:GetAttribute(`Amount{slot:GetAttribute("Number")}`),players)
		elseif enemies then
			goals[slotNum] = enemies;
			str = string.format(killStr, enemies, "Enemies");
			str2 = str2:format(script:GetAttribute(`Amount{slot:GetAttribute("Number")}`),enemies)
		elseif boss then
			goals[slotNum] = boss;
			str = string.format(killStr, boss, "Boss");
			str2 = str2:format(script:GetAttribute(`Amount{slot:GetAttribute("Number")}`),boss)
		end
		
	elseif quest.Mission.Win then
		
		local round = quest.Mission.Win.Round;
		str = string.format(winStr, round.Amount);
		str2 = str2:format(script:GetAttribute(`Amount{slot:GetAttribute("Number")}`), round.Amount)
		goals[slotNum] = round.Amount;
		
		if round.Mode then
			str = string.format(roundStr, str, round.Mode):gsub("Survival", "Zombie Hunt")
		end
	end
	slot.QuestsDescription.Text = str;
	slot.Amount.Text = str2;
	
	if quest.Reward.XP then
		str = quest.Reward.XP .. " XP"
		slot.RewardAmount.TextColor3 = quests.Colors.XP
		
	elseif quest.Reward.Coins then
		str = quest.Reward.Coins .. " Coins"
		slot.RewardAmount.TextColor3 = quests.Colors.Coins
		
	end
	slot.RewardAmount.Text = str;
end



local function Describe(slotNum: Frame, val: QuestProgress)
	--warn(val);
	local slot = q[tonumber(slotNum)];
	local str = workspace:GetAttribute("robloxstr")
	slot:SetAttribute("Claimed", val.Claimed);
	
	local goal = goals[slotNum];
	val.Amount = math.clamp(val.Amount,0,goal)
	slot.Amount.Text = slot.Amount:GetAttribute("txt"):format(val.Amount, goal)
	script:SetAttribute("Amount"..slotNum, val.Amount);

	local canClaim, claimed = false, val.Claimed;
	if script:GetAttribute("Amount"..slotNum) >= goals[slotNum] then
		if slot:GetAttribute("Claimed") then
			claimed = true;
			canClaim = false;
			slot.ClaimButton.Image = str..quests.Assets.Buttons.Claimed
			slot.RewardAmount.TextColor3 = quests.Colors.QuestDone
			slot.Amount.TextColor3 = quests.Colors.QuestDone
			slot.QuestsDescription.TextColor3 = quests.Colors.QuestDone
		else
			canClaim = true;
			slot.ClaimButton.Image = str..quests.Assets.Buttons.Claim
			slot.RewardAmount.TextColor3 = quests.Colors.QuestDone
			slot.Amount.TextColor3 = quests.Colors.QuestDone
			slot.QuestsDescription.TextColor3 = quests.Colors.QuestDone
		end
	else
		slot.ClaimButton.Image = str..quests.Assets.Buttons.InProgress
		slot.Amount.TextColor3 = quests.Colors.QuestNormal
		slot.QuestsDescription.TextColor3 = quests.Colors.QuestNormal
	end

	if canClaim then
		claimConns[slot:GetAttribute("Number")] = slot.ClaimButton.Activated:Once(function()
			if not claimCooldown[slot:GetAttribute("Number")] then
				claimCooldown[slot:GetAttribute("Number")] = true;
				game.ReplicatedStorage.RemoteEvents.Quests.ClaimQuest:FireServer(slot:GetAttribute("Number"))
				task.wait(5);
				claimCooldown[slot:GetAttribute("Number")] = false;
			end
		end)
	else
		if claimConns[slot:GetAttribute("Number")] then
			claimConns[slot:GetAttribute("Number")]:Disconnect()
			claimConns[slot:GetAttribute("Number")] = nil
		end
	end
end

local Update = function(ts, prog)
	if not (ts and prog) then
		ts, prog = data:InvokeServer();
	end
	for i,v in pairs(ts) do
		CompileData(v, v["1"], i);
	end
	task.wait(0.222);
	for i:string,v:{Amount: number, Claimed: boolean} in pairs(prog) do
		Describe(i, v);
	end
end


req.OnClientEvent:Connect(Update);

update.OnClientEvent:Connect(function(mode, ...)
	if mode == "compile" then
		CompileData(...);
	elseif mode == "describe" then
		Describe(...);
	end
end)

pcall(Update) 



reroll.MouseButton1Click:Connect(function()
	if seconds.Value > 720 then
		game.MarketplaceService:PromptProductPurchase(game.Players.LocalPlayer, 1882399743)
	end	
end)

timer.OnClientEvent:Connect(function(timeStamp)
	script.Parent.TimeStamp.Value = timeStamp;
	cool.Text = timeStamp
end)