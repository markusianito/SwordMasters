
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remote = ReplicatedStorage.RemoteEvents.AllPlayersEvent
local BossHP = Remote.BossHP
local fayer = game.ReplicatedStorage.ClientEvents.BossHP;

local fire = function(num,bossname,Max, show)
	if show ~= nil then
		script.Parent.Frame.Visible = show
		script.Parent.Laser.Visible = show
		script.Parent.Spike.Visible = show
		script.Parent.Kick.Visible = show
	end
	if bossname then
		script.Parent.Frame.TextLabel.Text = bossname
	end
	script.Parent.Frame.TotalHP.Text =  tostring(math.floor(num)) .."/"..tostring(Max)
	script.Parent.Frame.Health:TweenSize(UDim2.new(num/Max,0,script.Parent.Frame.Health.Size.Y.Scale,0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,num/Max,true)

	if num <= 0  then
		script.Parent.Frame.Health:TweenSize(UDim2.new(num/Max,0,script.Parent.Frame.Health.Size.Y.Scale,0),Enum.EasingDirection.In,Enum.EasingStyle.Quad,num/Max, true)
		task.wait(7)
		script.Parent.Frame.Visible = false
		script.Parent.Laser.Visible = false
		script.Parent.Spike.Visible = false
		script.Parent.Kick.Visible = false
	end
end

fayer.Event:Connect(fire);

BossHP.OnClientEvent:Connect(function(...)
	fayer:Fire(...);
end)