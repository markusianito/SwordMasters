local Light = {}

function Light.new(MapName)
	
	local self = {}
	self.Map   = MapName
	self.Folder = game.ServerStorage.Players
	
	
	return setmetatable(self,Light)	
end


function Light:SetUp(o)
	if o == nil  then
		if Light.Properties[self.Map] then
			for i,v in pairs(self.Folder:GetChildren()) do
				if v:IsA("ObjectValue")  then

					game.ReplicatedStorage.RemoteEvents.LightingEvents.SetUp:FireClient( v.Value,self.Map,Light.Properties[self.Map])
					
				end

			end
		end
		else
		game.ReplicatedStorage.RemoteEvents.LightingEvents.SetUp:FireClient(o ,self.Map,Light.Properties[self.Map])
	end
	
	
	
end







return Light
