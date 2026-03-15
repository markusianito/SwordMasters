--disable
-->> SineFloat.lua - Server
--> Makes an object float in a sine wave form
--> Includes: rotating.

--> Scripted by Marcos

repeat task.wait() until script:FindFirstAncestor("Workspace");

require(game.ReplicatedStorage.Collectables):SineFloat(script.Parent, 1);