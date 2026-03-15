--[[
	4/4/2021.
	Made by SolarDev (@noober2359) on Roblox.
	For use with JuankStudios (Better compatibility with Blocks Simulator).
	This will not be shared FOR ANY REASON
	Originally this module is in Spanish, so this version in English is for more comfort
	Blocks :)
	Created 1/20/2022, Developed 23/5/2021
	
	Att: SolarDev
]]--

local plrSvc = game:GetService("Players");
local Get = {}
function Get.UserId(name:string)
	return plrSvc:GetUserIdFromNameAsync(name);
end

local function Check(value,datatype,enum)
	if type(value) ~= datatype then
		return error("\nUnable to use "..type(value)" as "..datatype..". Use "..datatype.." instead".." \nAt value #"..tostring(enum))
	end
end


local x,y,z = Enum.Axis.Y,Enum.Axis.Y,Enum.Axis.Z

local Skystrike = {}
Skystrike.__index = Skystrike

function Skystrike.New(inst:Instance)
	if not inst then return error("Expected . not : on calling 'New', or Instance == nil") end
	if not inst.ClassName then return error("Expected Instance on calling 'New'") end

	local self =	{};
	self.Instance =	inst;

	for i,v in pairs(Skystrike.Enum.Modifiers) do
		self.Instance:SetAttribute(v,Skystrike.Enum.PermissionLevel.Allowed)
	end
	self.Instance:SetAttribute("PlayerOwnership",0)
	return self
end

Skystrike.Enum = {
	Modifiers = {
		["CanHandle"] = "CanHandle", --- can handle children
		["Paintable"] = "Paintble", --- can be recolored
		["Deletable"] = "Deletable", --- can be destroyed
		["Modificable"] = "Modificable", --- can change properties
		["SuperModificable"] = "SuperModificable", -- can change special properties
		["Movable"] = "Movable", --- can be moved
		["Rotable"] = "Rotable", --- can be rotated
		["Scalable"] = "Scalable", --- can be scaled
		["CanHandleConstraints"] = "CanHandleConstraints", --- the name says it
	},
	SubModifiers = {
		--- child = subInstance, not a person lol
		["Public"] = "Public"; --- valid child
		["Private"] = "Private"; --- protected child
		["Internal"] = "Internal" --- builtin or required child
	},
	PermissionLevel = {
		["Allowed"] = true, --- yes
		["Restringed"] = false --- no
	}
}

function Skystrike.Surfaces(am:number)
	Check(am,"number",1)
	return {
		[Enum.NormalId.Top] = {Scale=Vector3.new(0,am,0),Position=Vector3.new(0,am,0)},
		[Enum.NormalId.Bottom] = {Scale=Vector3.new(0,am,0),Position=Vector3.new(0,-am,0)},
		[Enum.NormalId.Right] = {Scale=Vector3.new(am,0,0),Position=Vector3.new(am,0,0)},
		[Enum.NormalId.Left] = {Scale=Vector3.new(am,0,0),Position=Vector3.new(-am,0,0)},
		[Enum.NormalId.Front] = {Scale=Vector3.new(0,0,am),Position=Vector3.new(0,0,am)},
		[Enum.NormalId.Back] = {Scale=Vector3.new(0,0,am),Position=Vector3.new(0,0,-am)},
	}
end

function Skystrike:Scale(Surface:Enum.NormalId,Increment:number,IgnoreCollisions:boolean,CenterOfMass:boolean)
	local Part = self.Instance



	Check(Part,"userdata",1)Check(Surface,"userdata",2)Check(Increment,"number",3)
	Check(IgnoreCollisions,"boolean",4)
	Check(CenterOfMass,"boolean",5)

	local MaxStuds = Increment

	local prop = (not IgnoreCollisions) and 'Position' or 'CFrame'
	Part.Size = Part.Size + Skystrike.Surfaces(Increment)[Surface].Scale*MaxStuds
	if CenterOfMass then
		Part[prop] = Part[prop] + Skystrike.Surfaces(Increment)[Surface].Position*(MaxStuds/2)
	end
	return Part.Size, Part[prop]
end

function Skystrike.SmoothRot(Part:BasePart,Radians:number,EnumAxis:Enum.Axis)


	Check(Part,"userdata",1)Check(Radians,"number",2)
	if not EnumAxis == Enum.Axis.Y or not EnumAxis == Enum.Axis.X or not EnumAxis == Enum.Axis.Z then
		return error("\nUnable to use "..type(EnumAxis).." as Axis Use Enum.Axis.X (or .Y or .Z) instead".." \nAt value #3")
	end



	if EnumAxis == x then
		Part.CFrame = Part.Orientation*CFrame.Angles(math.pi/Radians,0,0)
		return Part.CFrame


	elseif EnumAxis == y then
		Part.CFrame = Part.Orientation*CFrame.Angles(0,math.pi/Radians,0)
		return Part.CFrame


	elseif EnumAxis == z then
		Part.CFrame = Part.Orientation*CFrame.Angles(0,0,math.pi/Radians)
		return Part.CFrame


	end
end

function Skystrike:Move(Surface:Enum.NormalId,Increment:number,IgnoreCollisions:boolean)
	local Part = self.Instance


	Check(Part,"userdata",1)Check(Surface,"userdata",2)
	Check(Increment,"number",3)Check(IgnoreCollisions,"boolean",4)

	local MaxStuds = Increment

	local prop = (not IgnoreCollisions) and 'Position' or 'CFrame'
	Part[prop] += Skystrike.Surfaces(Increment)[Surface].Position*(MaxStuds/2)
	return Part[prop]
end

function Skystrike:Rotate(EnumAxis:Enum.Axis,Increment:number,IgnoreCollisions:boolean)
	local Part = self.Instance


	Check(Part,"userdata",1)Check(Increment,"number",3)Check(IgnoreCollisions,"boolean",4)
	if not EnumAxis == Enum.Axis.Y or not EnumAxis == Enum.Axis.X or not EnumAxis == Enum.Axis.Z then
		return error("\nUnable to use "..type(EnumAxis).." as Axis Use Enum.Axis.X (or .Y or .Z) instead".." \nAt value #3")
	end


	local prop = (not IgnoreCollisions) and 'Orientation'

	if EnumAxis == x then
		Part[prop] += Vector3.new(Increment,0,0)
		return Part[prop]


	elseif EnumAxis == y then
		Part[prop] += Vector3.new(0,Increment,0)
		return Part[prop]


	elseif EnumAxis == z then
		Part[prop] += Vector3.new(Increment,0,0)
		return Part[prop]


	end
end

--[[ Unused because of limitations

function Skystrike.Graph(Parent:Instance,Color:Color3,Size:Vector3,Material:Enum.Material)

	local function Y1(x)
	
	end
	
	local function Y2(x)
	
	end

	local function CreatePart()
		local Part = Instance.new("Part")
		Part.Parent = Parent
		Part.Size = Size
		Part.Anchored = true
		Part.Color = Color
		Part.Material = Material
		return Part
	end

	local x = -2

	repeat
		x += 0.02
		local PartY1 = CreatePart()
		local PartY2 = CreatePart()
		PartY1.Position = Vector3.new(x, Y1(x), 0)
		PartY2.Position = Vector3.new(x, Y2(x), 0)
		task.wait()
	until x >= 2
end
]]--

function Skystrike:GotoMemory()
	local Part = self.Instance
	Part.CanCollide = false
	Part.Transparency = 1
end

function Skystrike:Color(Color:Color3)
	local Part = self.Instance
	Part.Color = Color
end

function Skystrike:GotoOrigin()
	local Part = self.Instance
	Part.Position = Vector3.new(0,0,0)
end

function Skystrike:Smaller()
	local Part = self.Instance
	Part.Size = Vector3.new(0,0,0)
end

function Skystrike:ReturnValidChildren()
	local inst = self.Instance
	local count = 1
	local tab = {}
	if inst:GetAttribute("CanHandle") then
		for i,v in ipairs(inst:GetChildren()) do
			if v:GetAttribute("ValidChildren") then
				table.insert(tab,count,v)
				count += 1
			end
		end
	end
	if #tab > 0 then
		return tab
	else
		return {}
	end
end

function Skystrike:SetPlayerOwnership(plr:Player)
	if self then 
		if not self.Instance then
			error("Expected : not . on calling 'SetPlayerOwnership'")
		end
		if not type(self.Instance) == "userdata" then
			error("Expected instance on calling 'SetPlayerOwnership'")
		end
	end

	if not plr then
		self.Instance:SetAttribute("PlayerOwnership",821967424)
		print("Setted the Ownership of instance "..self.Instance.Name.." to Game Owner (SolarDev)")
	else
		self.Instance:SetAttribute("PlayerOwnership",Get.UserId(plr.Name))
		print("Setted the Ownership of instance "..self.Instance.Name.." to "..tostring(plr))
	end

	return self.Instance
end

function Skystrike:DelPlayerOwnership()
	if self then 
		if not self.Instance then
			error("Expected : not . on calling 'DelPlayerOwnership'")
		end
		if not type(self.Instance) == "userdata" then
			error("Expected instance on calling 'DelPlayerOwnership'")
		end
	end

	self.Instance:SetAttribute("PlayerOwnership",0)
end

function Skystrike:GetPlayerOwnership()
	if self then 
		if not self.Instance then
			error("Expected : not . on calling 'GetPlayerOwnership'")
		end
		if not type(self.Instance) == "userdata" then
			error("Expected instance on calling 'GetPlayerOwnership'")
		end
	end

	return self.Instance:GetAttribute("PlayerOwnership")
end

function Skystrike:CheckPlayerOwnership(plr:Player)
	if self then 
		if not self.Instance then
			error("Expected : not . on calling 'CheckPlayerOwnership'")
		end
		if not type(self.Instance) == "userdata" then
			error("Expected instance on calling 'CheckPlayerOwnership'")
		end
	end

	return self.Instance:GetAttribute("PlayerOwnership") == (Get.UserId(plr.Name))
end

return Skystrike