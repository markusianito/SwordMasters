-->> CodeService.lua - Server
--> Codes mgr for SM
--> Functions w/ "Async" in their names, will yield

-- Códigos ANSI para colores


local STRLEN = 32;

local plrs = game:GetService("Players")
local defCds = require(game:GetService("ServerStorage").DefaultCodes);

local bin = game:GetService("ReplicatedStorage").Packages;
local knit = require(bin.Knit);
local net = require(bin.Net);
local data = require(bin.Data);data:Init()

local currentCodes = data.new("Codes", "Valid") -- :Get(code) --> table? {Name = string, Valid = boolean, Reward = {XP = number?, Coins = number, any = string}}


local notify = net:RemoteEvent("MessagesStars")
local redeem = net:RemoteFunction("RedeemCode");

local coinSvc
local dataSvc
local cds = knit.CreateService({Name = "CodeService"});


function cds:IsValidCodeAsync(code)
	local valid:{};
	local succ, errorr = pcall(function()
		valid = currentCodes:Get(code):Await();
	end)
	
	if defCds[code] then
		code = defCds[code];
	else
		if succ then
			if valid then
				return valid;
			end
		else
			return false;
		end
	end
	
	return code;
end


function cds:TryGet(plr)
	local data = dataSvc:GrabDataAsync(plr, 10);
	return data.Data
end


function cds:TrySet(plr, val, is)
	local data = cds:TryGet(plr);
	data.RedeemedCodes[val] = not not is;
end


function cds:CanRedeemAsync(plr, code)
	local data = self:TryGet(plr);

	if not data then
		return false, "Could not fetch"
	end
	data = data.RedeemedCodes
	
	return (data[code]~=true)
end



function Notify(plr, reward): ()
	notify:FireClient(plr, "NewItem", {AinStr = "You received", Object = reward})
end

function cds:RedeemAsync(plr, code)
	local codeName = code;
	code = self:IsValidCodeAsync(code);
	if code then
		local state = self:CanRedeemAsync(plr, code)
		if state then
			
			if code.Name == codeName then
				
				local data = self:TryGet(plr);
				if not data then
					return false, "Could not fetch"
				end 
				if data.RedeemedCodes[codeName] then
					return false, "This code has already been redeemed!";
				end
				
				data.RedeemedCodes[codeName] = true;
				
				
				
				if code.Reward.Coins then
					coinSvc:PayPlayer(plr, code.Reward.Coins);
					Notify(plr, `{code.Reward.Coins} Coins`)
					
				elseif code.Reward.XP then
					task.spawn(function()
						coinSvc:TeachPlayer(plr, code.Reward.XP);
					end)
					Notify(plr, `{code.Reward.XP} XP`)
					
				elseif code.Reward.Good then
					if plr.Inventory:FindFirstDescendant(code.Reward.Good) then
						return false, "You already own this item"
					end
					
					Notify(plr, code.Reward.Good.Name)
					local good:Instance, tipo:string = code.Reward.Good, code.Reward.Good:GetAttribute("ItemType");
					
					local item = Instance.new("StringValue");
					item.Name = good.Name;
					item.Parent = plr.Inventory[tipo=="Ability" and "Abilities" or tipo.."s"];
					--if tipo ~= "Ability" then
						-- game.ReplicatedStorage.RemoteEvents.DataEvents.NewItem:FireClient(plr,good.Name,tipo);
					--end
				else
					Notify(plr, "Nothing");
					return true, "No valid reward for this code, but reedemed aswell";
				end

				return true, "Code redeemed!";
				
			end
		else
			return false, "This code has already been redeemed!";
		end
	else
		return false, "Invalid code!";
	end
end

function cds:KnitStart()
	coinSvc = knit.GetService("EconomyService")
	dataSvc = knit.GetService("DataService");
	print("CodeService started")
	

	redeem.OnServerInvoke = function(plr:Player, txt: string)
		if type(txt) ~= "string" then return false, "Invalid code!" end;
		if string.len(txt) > STRLEN then return false, "Invalid code!" end;

		txt = string.match(string.upper(txt),"%w+");

		if txt then
			local succ, massage = cds:RedeemAsync(plr, txt);
			if succ then
				return succ
			else
				notify:FireClient(plr, "Failed", {AinStr = massage, Object =""})
				return false;
			end
		end
	end
end

return cds;