local RunService=game:GetService("RunService")
local UserInputService=game:GetService("UserInputService")

local StatesOfDevice = {
	["isServer"]=RunService:IsServer(),
	["isClient"]=RunService:IsClient(),
	["isStudio"]=RunService:IsStudio(),
	["isMobile"]=not UserInputService.KeyboardEnabled,	
}

return StatesOfDevice
