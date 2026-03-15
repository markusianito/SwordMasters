--disable
-->> CodesMain.lua - Server
--> Main codes server program for SM;

local STRLEN = 32;

local codeSvc = require(game.ServerStorage.Modules.Services.CodeService);
local notify = game.ReplicatedStorage.ClientEvents.BoughtThing;
local get = game.ReplicatedStorage.Codes.Redeem;

get.OnServerInvoke = function(plr:Player, txt: string)
	if type(txt) ~= "string" then return false, "Invalid code!" end;
	if string.len(txt) > STRLEN then return false, "Invalid code!" end;
	
	txt = string.match(string.upper(txt),"%w+");
	
	if txt then
		local succ, massage = codeSvc:RedeemAsync(plr, txt);
		if succ then
			return succ
		else
			notify:FireClient(plr, "Failed", {AinStr = massage, Object =""})
			return false;
		end
	end
end