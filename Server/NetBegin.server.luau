-->> RemotePortsBegin.luau
-- Initializes all remote events and functions in sword masters.
--> Scripted by Marcos

--[[ developer notes:
client-side: refers to the function that executes when the server fires the event to a client (OnClientEvent)
server-side: refers to the function that executes when a client fires the event to the server (OnServerEvent)

]]

local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local net = require(bin.Net);

--[[ Shiftlock (SL)
Client-side:
	@Arguments: <boolean> force
	@Description:
	Forces shiftlock on the client. Making him unable to manually change his shiftlock state with Ctrl key
	@Example:
	```lua
	SL:FireClient(plr, true) --> Activates shiftlock on the client, forced.
	```
]]
local SL = net:RemoteEvent("Shiftlock")


--[[ MessagesStars (msgs)
Client-side:
	@Arguments:
	<"NewItem"|"Failed"|"Insufficient"> mode,
	<{AinStr: string, Object: string}> specs
	
	@Description:
	Shows a message to a player, in the bottom of his screen.
	Intented for bought-item notifications
	@Example:
	```lua
	SL:FireClient(plr, "NewItem", {AinStr = "Successfully purchased", Object = "Cookie"})
	```
]]
local msgs = net:RemoteEvent("MessagesStars")

--[[ DataMod (dmod)
Client-side:
	@Arguments:
	<string> mode,
	<any> data
	
	@Description:
	Makes a request to the player to update his saved data.
	
	@Example:
	```lua
	dataMod:FireClient(plr, "Reconcile");
	```
	
	
Server-side:
	@Arguments:
	<string> mode,
	<any> data
	
	@Description:
	Makes a request to the server to update a key from the player's data
	
	@Example:
	```lua
	dataMod:FireServer("Equip", "Fireball", "Ability");
	dataMod:FireServer("ChangeDisplayName", "DarkWarrior");
	```
]]
local dataMod = net:RemoteFunction("DataMod");


local uied = net:RemoteEvent("UiEnableDisable");
uied.OnServerEvent:Connect(function(plr, ...)
	uied:FireClient(plr, ...);
end)