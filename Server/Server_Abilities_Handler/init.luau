local Server_Abilities_Handler = {}

local msgSvc = game:GetService("MessagingService");
local dataSvc = game:GetService("DataStoreService");
local timeSync=require(game.ServerStorage.Modules.TimeSync);
local Randomizer=require(script.Parent.Randomizer)
local ServerSettings=require(script.Parent.Settings)
local ReplicatedSettings=require(game.ReplicatedStorage.Classes.Abilities)
local getOffersInfoEvent=game:GetService("ReplicatedStorage"):WaitForChild("RemoteEvents"):WaitForChild("GetOffersInfo")

local absOffer = dataSvc:GetDataStore("AbilitiesOffer");

local function getAbilitiesFromRarity(rarity:string):{}
	local abilities={}
	for i,v in pairs(ReplicatedSettings) do
		if type(v)~="table" then continue end;
		if v.Rarity==nil then continue end
		if v.Rarity==rarity and table.find(ReplicatedSettings.AbilitiesInShop,i) then
			table.insert(abilities,i)
		end
	end
	return abilities
end

local function getRandomRarity():string
	local rar
	repeat
		rar = Randomizer.Pick(ServerSettings.Abilities.SpecialOffersChances)
	until rar ~= nil
	return rar
end

local function getRandomAbility():string
	local rarity=getRandomRarity()
	warn(rarity)
	local abilities=getAbilitiesFromRarity(rarity)
	warn(abilities)
	return abilities[math.random(1,#abilities)]
end

local offersFolder=script.CurrentAbilitiesOffer
local function refreshAbilitiesOffer(abilities)
	for i,v in pairs(abilities) do
		local nw=Instance.new("StringValue",offersFolder)
		nw.Name=v
		nw.Parent = offersFolder;
	end
end




local function getSpecialOffers() --TODO fix that
	local RandomAbilities={}
	for i=1,3 do
		while true do
			local randomAb=getRandomAbility()
			if not table.find(RandomAbilities,randomAb) then
				table.insert(RandomAbilities,randomAb)
				break
			end
		end
	end
	return RandomAbilities
end

local SaveData
local suck, err = pcall(function()
	SaveData = absOffer:GetAsync("SaveData");
end)

if not suck then
	warn("Cannot get abilities offer: ", err)warn("Trying once again...")
	
	local suc = pcall(function()
		SaveData = absOffer:GetAsync("SaveData");
	end)
	if suc then
		suck = true;
	end
end

if (SaveData == nil) and suck then
	SaveData = {Time = os.time(), abilities = getSpecialOffers()};
	absOffer:SetAsync("SaveData", SaveData);
end

msgSvc:SubscribeAsync("absOffer", function(any)
	SaveData = any.Data
	getOffersInfoEvent:FireAllClients(SaveData)
end)



---> This is called when someone joins the server. This user requests the ab offer data
getOffersInfoEvent.OnServerEvent:Connect(function(plr)
	getOffersInfoEvent:FireClient(plr,SaveData)
end)


require(script.Buy)
require(script.Equip)


local syncedtime    			     = require(game.ServerStorage.Modules.TimeSync)

local currentDay -- initialize our CurrentDay variable.

local hourOffset 			         = 0-- I stated earlier that I didn't need an offset, lol, but change this to your desired offset 
local offset 	                     = (60 * 60 * hourOffset)

local RE 							 = game.ReplicatedStorage.RemoteEvents



syncedtime.init()
---Cover Sec To Hours
local function toHMS(s)
	return string.format("%02i:%02i:%02i", s/60^2, s/60%60, s%60)
end

local irstTime = true;

while true do
	local day   	 	 = math.floor((syncedtime.time() + offset) / (3600)) * 4 -- flooring is EXTREMELY important here, because that means the number won't change unless it becomes an integer higher. This is the seed we're going to supply to our getAvailableItems function. This would output something like 18431. By dividing this by 24 hours and adding our offset, we know that if the number changes, THEN a day has passed since the epoch +  our own offset.
	local t   	         = (math.floor(syncedtime.time()) / 4) - offset -- Sets the time to your offset time (ex. 8 pm PST)
	local daypass        = (t) % (3600) -- Using % gives us the remainder, which in our case is how far into a day we are
	local timeleft 		 = (3600 * 4)  - (daypass * 4) -- Now we can easily calculate how much time is left by subtracting a day (86,400 seconds) by daypass
	local timeleftstring = toHMS(timeleft) -- This will format the time to HH:MM:SS (ex. 05:42:03)

	-- You can comment this out later, but test it with the printing to see if it works.
	game.ReplicatedStorage.Abilities.TimeRest.Value = timeleftstring
	--Obviously, you'd use "timeleftstring" to display a timer or something

	if day ~= currentDay then
		if irstTime then
			--warn("First time")
			currentDay = day;
			irstTime = false;
		else
			--warn"no first time"
			game.ReplicatedStorage.Abilities.Offers:ClearAllChildren()

			currentDay = day
			local day1 = day * 2.5
			---Setting Up Table for shop

			local anotherOffer;
			local isDiff = false;
			local suck, err = pcall(function()
				anotherOffer = absOffer:GetAsync("SaveData");
			end)
			if suck then
				for _,v in pairs(anotherOffer.abilities) do
					if not table.find(SaveData.abilities, v) then
						isDiff = true
					end
				end
			else
				warn(err);
			end
			if isDiff then
				SaveData = anotherOffer;
			else
				local offers = getSpecialOffers();

				SaveData = {Time = os.time(), abilities = offers}
				absOffer:SetAsync("SaveData", SaveData);
				msgSvc:PublishAsync("absOffer", SaveData);
			end


			task.wait(2)

			getOffersInfoEvent:FireAllClients(SaveData)
			refreshAbilitiesOffer(SaveData.abilities)
		end
	end
	task.wait(1)
end


return Server_Abilities_Handler