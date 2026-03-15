local sss = game:GetService("ServerScriptService")
local f = sss.Providers.BossProviderDeprecated
local BossFightModule = require(f.BossFight)
local BossBody = require(f.BossBody)

if workspace.GameMap.Map:GetAttribute("Mode") == "Bossfight"  then
	local NewBoss = BossFightModule.new(script.Parent.Parent)
	script.Parent.Parent:SetAttribute("GetDamage", true)
	coroutine.resume(coroutine.create(function()
		while task.wait(0.3) do
			if not BossBody.GetBoss():IsDied() then
				NewBoss:ChasePlayer()
			end
		end
	end))
	NewBoss:BossSystem()

end


