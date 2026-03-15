-->> Admins - Library
--> Admin ID list for SwordMasters

local plrs = game:GetService("Players");
local get = plrs.GetNameFromUserIdAsync;

local IDs = {
	Bordii    =			1432388259;
	Marcos	  =			821967424;
	Tris	  =			427694352;
	Jass      =			2053150378;
	Gamersnederlands =	1487409077;
}


local T = {}
for _,v in pairs(IDs) do
	T[v] = true;
end

return T