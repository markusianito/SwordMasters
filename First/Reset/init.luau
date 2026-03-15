local psvc = require(game.ServerScriptService.Datastore.DataManger.ProfileService);
local ds = game:GetService("DataStoreService");
local lvl = ds:GetDataStore("Levels");
local codeExp = ds:GetDataStore("RedeemedCodes");
local questDs = ds:GetDataStore("QuestData");
local kills   = ds:GetDataStore("Kills")
local badgesDB= ds:GetDataStore("BadgesDatabase");

local module = {}


function module:ResetInventoryWCoins(accId)
	psvc.GetProfileStore("PlayerData",
	{	PlayerStats = {Coins = 0} ;
	Inventory = {Skins = {"Default"},Swords = {"Default Sword"},Abilities={"Dash"},EquippedSkin = "Default",EquippedSword = "Default Sword",
	EquippedAbilities={"Dash"}};
	Settings = {MusicVolume = 100, SFXVolume = 100}
		}):WipeProfileAsync("Player_"..accId)
	return self;
end



function module:ResetLevel(accId)
	lvl:SetAsync("Level_"..accId, 1);
	lvl:SetAsync("XP_"..accId, 0);
	warn("ResetLevel: Done!")
	return self;
end

function module:ResetRedeemedCodes(accId)
	codeExp:RemoveAsync("codes_"..accId);
	warn("ResetRedeemedCodes: Done!")
	return self;
end

function module:ResetQuestInfo(accId)
	questDs:RemoveAsync("quests_"..accId);
	questDs:RemoveAsync("questing_"..accId);
	questDs:RemoveAsync("lastUpdate_"..accId);
	warn("ResetQuestInfo: Done!")
	return self;
end

function module:ResetStats(accId)
	kills:RemoveAsync(tostring(accId))
	warn("ResetKills: Done!")
	return self;
end

function module:ResetBadges(accId)
	badgesDB:RemoveAsync("badges_"..tostring(accId))
	warn("ResetBadges: Done!")
	return self;
end
local ds = game:GetService("DataStoreService");
local lvl = ds:GetDataStore("Levels");
local codeExp = ds:GetDataStore("RedeemedCodes");
local questDs = ds:GetDataStore("QuestData");
local kills   = ds:GetDataStore("Kills")
local badgesDB= ds:GetDataStore("BadgesDatabase");

local t = {lvl, codeExp, questDs, kills, badgesDB}

function clearData(datastore)

	local listSuccess, pages = pcall(function()
		return datastore:ListKeysAsync()
	end)
	if listSuccess then
		local keys = {}
		local pagenum = 0
		while true do
			local items = pages:GetCurrentPage()

			for key, info in pairs(items) do
				table.insert(keys, info.KeyName)
			end
			if pages.IsFinished then break end
			local s,e = pcall(pages.AdvanceToNextPageAsync, pages)
			if s then
				pagenum+=1
			else
				print("An error occurred, abort!")
				break
			end
			task.wait(1)
		end

		for _, key in pairs(keys) do
			local s, verpages = pcall(function()
				return datastore:ListVersionsAsync(key, nil, nil, DateTime.now().UnixTimestampMillis - 2592000000)
			end)
			if s then
				while true do
					local items = verpages:GetCurrentPage()

					for dkey, info in pairs(items) do
						local realCreationTime = info.CreatedTime / 1000
						if not info.IsDeleted and realCreationTime < os.time()-2592000 then
							print(key, datastore:GetAsync(key))
							warn("The key above will be deleted.")
							datastore:RemoveVersionAsync(key, info.Version)
						end
					end
					if verpages.IsFinished then break end
					verpages:AdvanceToNextPageAsync()
				end
				task.wait(2)
			else
				if verpages:lower():match("later") then
					print("Trying again in 15 seconds")
					task.wait(15)
				end
			end
		end
	else
		print(pages)
	end
end


for i,v in pairs(t) do
	clearData(v)
end






return module