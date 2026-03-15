-->> SwordProvider.lua
--> Script to handle swords in SM
--> Scripter by Marcos Saenz


export type Sword = {
	Animations: Folder,
	Sounds: Folder,
	Handle: BasePart,
	Name: string,
}


local tagSvc = game:GetService("CollectionService")
local storage = game:GetService("ReplicatedStorage");
local bin = storage.Packages;
local knit = require(bin.Knit);
local signal = require(bin.Signal);
local trove = require(bin.Trove)

local round-- = knit.GetService("RoundService");
local economy;
local data;


local sword = knit.CreateService({Name = "SwordProvider"});
sword.__index = sword;


function sword:GetSword(name: string): Tool
	return storage.Assets.Swords:FindFirstChild(name);
end


local function TakeDamage(swoos, modal)
	local hum:Humanoid = modal.Humanoid;
	if storage.Assets:FindFirstChild(modal.Name, true) then --> IS NPC
		swoos.Sounds.Hit:Play();
		hum:TakeDamage(swoos:GetAttribute("Damage"));

	elseif game:GetService("Players"):FindFirstChild(modal.Name) then -- IS PLAYER

		if (round.FriendlyFire) and (hum.Health > 0) then
			swoos.Sounds.Hit:Play();
			hum:TakeDamage(swoos:GetAttribute("Damage"));
		end
	else
		return;
	end
end


local function AssignSignal(self)
	self.KillSignal = signal.new();
	self.KillSignal:Once(function(plr: Player, mob: Model)
		local modal = mob:GetAttribute("Class");
		local coins = economy.CoinDeals[modal];
		local xp = economy.XPDeals[modal]
		
		
		if coins then
			economy:PayPlayer(plr, coins);
		end
		if xp then
			economy:TeachPlayer(plr, xp);
		end
		if xp or coins then
			round:AddSocialCredits(1);
		end
		data:AddStat(plr, modal, "Stats.Kills", 1);
	end)
end


function sword.new(plr: Player, swordName: string, lifetime: number, hitboxSize: Vector3, display: boolean)
	local hum: Humanoid = plr.Character.Humanoid;
	local swoos = sword:GetSword(swordName or plr.Inventory.EquippedSword.Value);
	if swoos then
		swoos = swoos:Clone()
		swoos.Parent = plr.Backpack;
		hum:EquipTool(swoos);
		
		
		task.delay(.1, function()
			hum:ChangeState(Enum.HumanoidStateType.Landed)
		end)
	else
		return;
	end

	local self = {};
	self.Player = plr;
	self.Sword = swoos;
	self.Trove = trove.new();
	self.KillSignal = signal.new();
	self.Animations = swoos.Animations:GetChildren();
	self.Enabled = true;
	self.Combo = 1;
	
	function self:CreateHitbox(size: Vector3,  lifetime: number,display: boolean)
		size = size or Vector3.new(2,3,2);
		local sword = self.Sword;
		local plr = self.Player;
		local hrp: Part = plr.Character.HumanoidRootPart;
		local hum: Humanoid = plr.Character.Humanoid;


		local newHitbox = storage.Assets.Standard.PlayerHitbox:Clone();
		newHitbox.Size = size
		newHitbox:SetAttribute("Emissor", plr.Name);


		if not display then
			newHitbox.Transparency = 1;
		end

		local Weld = newHitbox.WeldConstraint;
		Weld.Part0 = plr.Character.HumanoidRootPart
		Weld.Part1 = newHitbox
		Weld.Parent = newHitbox

		newHitbox.Position = hrp.Position + hrp.CFrame.LookVector * 1.5

		newHitbox.Parent = plr.Character;


		AssignSignal(self);




		local conn = newHitbox.Touched:Connect(function(Hit)
			local modal = Hit:FindFirstAncestorOfClass("Model") or Hit;
			if modal:FindFirstChild("Humanoid") and (modal.Name ~= plr.Name) and not newHitbox:GetAttribute("InCooldown") then
				TakeDamage(swoos, modal);
				task.spawn(function()
					task.wait();
					local h:Humanoid = modal:FindFirstChild("Humanoid")
					if h then
						if h.Health <= 0 and (not modal:HasTag("Modal")) then
							tagSvc:AddTag(modal, "Modal");
							self.KillSignal:Fire(plr, modal);
						end
					end
				end)
				newHitbox:Destroy()
			end
		end)

		coroutine.wrap(function()
			task.wait(lifetime);
			if conn then
				conn:Disconnect();
				conn = nil;
			end
			if newHitbox then
				newHitbox:Destroy();
			end
		end)()
	end
	
	
	function self:TakeAway()
		self.Trove:Destroy();
		if self.KillSignal then
			self.KillSignal:Destroy();
		end
		if self.Sword then
			self.Sword:Destroy();
		end
		if self.Animations then
			self.Animations = nil;
		end
	end

	self.ActivatedEvent = self.Trove:Connect(swoos.Activated, function()
		if plr:GetAttribute("Busy") then return end;
		if not hum then return; end
		if not self.Enabled then return; end

		swoos.Sounds.Swing:Play()
		self.Enabled = false
		self.Combo = self.Combo >= #self.Animations and 1 or self.Combo + 1

		pcall(function()
			task.delay(0.3, function()
				self:CreateHitbox(hitboxSize, lifetime, display)
			end)
			hum.Animator:LoadAnimation(self.Animations[self.Combo]):Play()
		end)


		task.wait(swoos:GetAttribute("Cooldown"))
		self.Enabled = true
	end)

	self.DedEvent = self.Trove:Connect(hum.Died, function()
		self:TakeAway();
	end)
	
	
	return self;

end



function sword:KnitInit()

end


function sword:KnitStart()
	round = knit.GetService("RoundService");
	economy = knit.GetService("EconomyService");
	data = knit.GetService("DataService");
	print("SwordProvider is ready.");
end;


return sword;