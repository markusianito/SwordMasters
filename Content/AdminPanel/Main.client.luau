--disable
-->> Main.lua - Client
--> Main program for Admin Panel
-- Scripted by Bordii :D
-- "Enhanced" by Marcos


local ui = script.Parent
local player = game.Players.LocalPlayer

if player.UserId == 1432388259 or player.UserId == 821967424 or player.UserId == 484071824 or player.UserId == 427694352 then 

	script.Parent.Enabled = true;

	local playerStats = require(ui:WaitForChild("PlayerStatsFrame"):WaitForChild("Main"))()
	
	local loadedStr = [[\n
#################################
#							   #
#	Sword Masters Admin Panel  #
#	Scripted by: Marcos Saenz  #
#	Successfully Loaded.	   #
#							   #
#################################
]]

	warn(loadedStr)

end



-- 1432388259 = Bordii
-- 821967424 = Marcos
-- 484071824 = Boogieboy
-- 427694352 = Tris