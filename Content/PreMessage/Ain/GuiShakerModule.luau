
local module = {}

local RunService = game:GetService('RunService')
local TweenService = game:GetService('TweenService')

local ShakeOnceConnection = nil
local ShakeConnection2 = nil

function module:ShakeOnce(element, intensity, fadeOutTime, delayTime) -- Smoothing
	task.spawn(function()
		local Stopped = false
		local ReferenceIntensityValue = Instance.new('NumberValue', script)
		ReferenceIntensityValue.Value = intensity

		--// Basics \\--

		local OriginalPositionAttribute = element:SetAttribute("OriginalPosition", element.Position)
		local OriginalRotationAttribute = element:SetAttribute("OriginalRotation", element.Rotation)

		local OffsetConvert = 700
		local RotationConvert = intensity/1000
		
		--[[
		--]]

		ShakeOnceConnection = RunService.RenderStepped:Connect(function(dt)
			if Stopped == false then
				intensity = ReferenceIntensityValue.Value 
				local OriginalPosition = element:GetAttribute("OriginalPosition")

				element.Position = OriginalPosition + UDim2.new(
					math.random(-intensity, intensity)/OffsetConvert,
					0,
					math.random(-intensity, intensity)/OffsetConvert,
					0
				)

			end
		end)

		task.spawn(function()
			while task.wait() do
				if Stopped == false then
					element.Rotation = math.random(-intensity, intensity)/2
				end
			end
		end)

		task.wait(delayTime)

		local CalmTween = TweenService:Create(ReferenceIntensityValue, TweenInfo.new(fadeOutTime, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, false, 0), {Value = 0})
		CalmTween:Play()
		CalmTween.Completed:Wait()

		if ShakeOnceConnection ~= nil then
			ShakeOnceConnection:Disconnect()
			ShakeOnceConnection = nil
		end
		
		Stopped = true
		
		element.Position =  element:GetAttribute("OriginalPosition")
		element.Rotation = element:GetAttribute("OriginalRotation")
		task.wait()
		element:SetAttribute("OriginalPosition", nil)
		element:SetAttribute("OriginalRotation", nil)
		
		ReferenceIntensityValue:Destroy()
		ReferenceIntensityValue = nil;
	end)
	
end

function module:Shake(element, intensity, length)
	task.spawn(function()
		local Stopped = false

		--// Basics \\--

		local OriginalPositionAttribute = element:SetAttribute("OriginalPosition", element.Position)
		local OriginalRotationAttribute = element:SetAttribute("OriginalRotation", element.Rotation)

		local OffsetConvert = 700
		local RotationConvert = intensity/1000
		
		--[[
		--]]
		
		ShakeConnection2 = RunService.RenderStepped:Connect(function(dt)
			if Stopped == false then
				local OriginalPosition = element:GetAttribute("OriginalPosition")

				element.Position = OriginalPosition + UDim2.new(
					math.random(-intensity, intensity)/OffsetConvert,
					0,
					math.random(-intensity, intensity)/OffsetConvert,
					0
				)

			end
		end)

		task.spawn(function()
			while task.wait() do
				if Stopped == false then
					element.Rotation = math.random(-intensity, intensity)/2
				end
			end
		end)

		task.wait(length)
		if ShakeConnection2 ~= nil then
			ShakeConnection2:Disconnect()
			ShakeConnection2 = nil
		end
		Stopped = true
		intensity = 0
		
		element.Position =  element:GetAttribute("OriginalPosition")
		element.Rotation = element:GetAttribute("OriginalRotation")
		task.wait()
		element:SetAttribute("OriginalPosition", nil)
		element:SetAttribute("OriginalRotation", nil)
	end)
end

return module
