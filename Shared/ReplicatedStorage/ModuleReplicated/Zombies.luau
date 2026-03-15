local ZombieStatModule = {}

function ZombieStatModule.CreateStats(Type, Health, Damage, Distance, HasMelee, HasShield, Shield, Rarity, Speed, DespawnTime, IdleAni, RunAni, JumpAni, PunchAni, SpawnAni, DeathAni)
	return {
		["Type"] = Type,
		["Health"] = Health,
		["Damage"] = Damage,
		["Distance"] = Distance,
		["HasMelee"] = HasMelee,
		["HasShield"] = HasShield,
		["Shield"] = Shield,
		["Rarity"] = Rarity,
		["Speed"] = Speed,
		["DespawnTime"] = DespawnTime,
		["Animations"] = {
			["Idle"] = IdleAni,	
			["Run"] = RunAni,	
			["Jump"] = JumpAni,	
			["Punch"] = PunchAni,	
			["Spawn"] = SpawnAni,	
			["Death"] = DeathAni
		},
	}
end

ZombieStatModule.List = {
	["Colosseum"] = {
		["Armored Zombie"] = 		ZombieStatModule.CreateStats("Standard", 75, 15, 25, false, false, 0, 20, 15, 5, 18112044033, 18539556117, 15615226718, 18539570508, 15663155774),
		["Attacker Zombie"] = 		ZombieStatModule.CreateStats("Standard", 40, 18, 25, true, false, 0, 30, 27, 5, 18112044033, 18111842642, 15615226718, 18112012203, 15663155774),
		["Victorious Zomdiator"] = 	ZombieStatModule.CreateStats("Miniboss", 450, 24, 25, false, true, 50, 5, 13, 7, 15618252694, 15618301591, 15615226718, 15618379637, nil, 15618830966),
		["Zombie Gladiator"] = 		ZombieStatModule.CreateStats("Standard", 30, 10, 25, false, false, 0, 45, 20, 5, 18112044033, 18553940474, 15615226718, 15615264651, 15663155774)
	},
	["Mystery Forest"] = {
		["Crystal Guard"] = 	ZombieStatModule.CreateStats("Miniboss", 250,  20, 25, true, true, 100, 5, 14, 7, 15618907226, 15696160672, 15615226718, 15635312553, nil, 15696071716),
		["Fast Zombie"] = 		ZombieStatModule.CreateStats("Standard", 20, 8, 25, false, false, 0, 30, 27, 5, 18112044033, 15618010827, 15615226718, 15615264651, 15663155774),
		["Slow Zombie"] = 		ZombieStatModule.CreateStats("Standard", 40, 12, 25, false, false, 0, 20, 16, 5, 18112044033, 15618194779, 15615226718, 15615264651, 15663155774),
		["Zombie"] = 			ZombieStatModule.CreateStats("Standard", 25, 8, 25, false, false, 0, 45, 19, 5, 18112044033, 18553940474, 15615226718, 15615264651, 15663155774)
	}
}

return ZombieStatModule