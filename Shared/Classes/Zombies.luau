-->> Zombies.luau
-- Zombies information
--> Scripted by Marcos

-- \
local Zombies = {
	Colosseum = {
		["Zombie Gladiator"] = {
			Type = "Standard";
			Rarity = 45;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 15615264651;
				Run = 18553940474;
				Spawn = 15663155774;
			};
			Health = 30;
			AttackCooldown = 2;
			Speed = 20;
			HasMelee = false;
			HasShield = false;
			Damage = 10;
		};
	
	
		["Attacker Zombie"] = {
			Type = "Standard";
			Rarity = 30;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 18112012203;
				Run = 18111842642;
				Spawn = 15663155774;
			};
			Health = 40;
			AttackCooldown = 2;
			Speed = 27;
			HasMelee = true;
			HasShield = false;
			Damage = 18;
		};
	
	
		["Victorious Zomdiator"] = {
			Type = "Miniboss";
			Rarity = 5;
			Shield = 50;
			AttackDistance = 25;
			Animations = {
				Idle = 15618252694;
				Jump = 15615226718;
				Death = 15618830966;
				Punch = 15618379637;
				Run = 15618301591;
			};
			Health = 450;
			AttackCooldown = 2;
			Speed = 13;
			HasMelee = false;
			HasShield = true;
			Damage = 24;
		};
	
		
		["Armored Zombie"] = {
			Type = "Standard";
			Rarity = 20;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 18539570508;
				Run = 18539556117;
				Spawn = 15663155774;
			};
			Health = 75;
			AttackCooldown = 2;
			Speed = 15;
			HasMelee = false;
			HasShield = false;
			Damage = 15;
		};
	};

	["Mystery Forest"] = {
		["Slow Zombie"] = {
			Type = "Standard";
			Rarity = 20;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 15615264651;
				Run = 15618194779;
				Spawn = 15663155774;
			};
			Health = 40;
			AttackCooldown = 2;
			Speed = 16;
			HasMelee = false;
			HasShield = false;
			Damage = 12;
		};
		["Crystal Guard"] = {
			Type = "Miniboss";
			Rarity = 5;
			Shield = 100;
			AttackDistance = 25;
			Animations = {
				Idle = 15618907226;
				Jump = 15615226718;
				Death = 15696071716;
				Punch = 15635312553;
				Run = 15696160672;
			};
			Health = 250;
			AttackCooldown = 2;
			Speed = 14;
			HasMelee = true;
			HasShield = true;
			Damage = 20;
		};
		["Fast Zombie"] = {
			Type = "Standard";
			Rarity = 30;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 15615264651;
				Run = 15618010827;
				Spawn = 15663155774;
			};
			Health = 20;
			AttackCooldown = 2;
			Speed = 27;
			HasMelee = false;
			HasShield = false;
			Damage = 8;
		};
		["Zombie"] = {
			Type = "Standard";
			Rarity = 45;
			Shield = 0;
			AttackDistance = 25;
			Animations = {
				Idle = 18112044033;
				Jump = 15615226718;
				Punch = 15615264651;
				Run = 18553940474;
				Spawn = 15663155774;
			};
			Health = 25;
			AttackCooldown = 2;
			Speed = 19;
			HasMelee = false;
			HasShield = false;
			Damage = 8;
		};
	}
};





return Zombies;