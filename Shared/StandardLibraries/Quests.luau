-->> Quests lib


local quests = {}

quests.Tiers = { --> Tier = probability
	Common = 40,
	Uncommon = 30,
	Rare = 20,
	Epic = 6,
	Legendary = 4
}



quests.Colors = {
	Common = Color3.fromRGB(222,222,222),
	Uncommon = Color3.fromRGB(63, 238, 24),
	Rare = Color3.fromRGB(0, 251, 255),
	Epic = Color3.fromRGB(183, 0, 255),
	Legendary = Color3.fromRGB(255, 191, 0),

	Coins = Color3.fromRGB(236, 201, 0),
	XP = Color3.fromRGB(19, 153, 236),


	QuestDone = Color3.fromRGB(98, 255, 74);
	QuestNormal = Color3.fromRGB(255, 255, 255);
}


quests.Assets = {
	Buttons = {
		InProgress = 18567635003;
		Claim = 18567620830;
		Claimed = 18567644717;
	}
}



quests.Quests = {
	Common = {
		{
			Mission = {
				Eliminate = {
					Players = 3
				}
			},
			Reward = {
				Coins = 150
			}
		},
		{
			Mission = {
				Eliminate = {
					Enemies = 20
				}
			},
			Reward = {
				Coins = 200
			}
		},
		{
			Mission = {
				Win = {
					Round = {
						Mode = nil,
						Amount = 3
					}
				}
			},
			Reward = {
				XP = 200
			}
		},
		{
			Mission = {
				Win = {
					Round = {
						Mode = "PVP",
						Amount = 1
					}
				}
			},
			Reward = {
				Coins = 100
			}
		},
		{
			Mission = {
				Eliminate = {
					Boss = 1
				}
			},
			Reward = {
				Coins = 100
			}
		},
	},



	Uncommon = {
		{
			Mission = {
				Eliminate = {
					Players = 10
				}
			},
			Reward = {
				Coins = 250
			}
		},
		{
			Mission = {
				Eliminate = {
					Enemies = 40
				}
			},
			Reward = {
				Coins = 250
			}
		},
		{
			Mission = {
				Win = {
					Round = {
						Mode = nil,
						Amount = 5
					}
				}
			},
			Reward = {
				XP = 250
			}
		},
		{
			Mission = {
				Win = {
					Round = {
						Mode = "Survival",
						Amount = 2
					}
				}
			},
			Reward = {
				XP = 300
			}
		},
	},





	Rare = {
		{
			Mission = {
				Eliminate = {
					Boss = 3
				}
			},
			Reward = {
				Coins = 300
			}
		},
		{
			Mission = {
				Win = {
					Round = {
						Mode = "PVP",
						Amount = 3
					}
				}
			},
			Reward = {
				XP = 400
			}
		},
		{
			Mission = {
				Eliminate = {
					Enemies = 100
				}
			},
			Reward = {
				Coins = 400
			}
		},
	},







	Epic = {
		{
			Mission = {
				Win = {
					Round = {
						Mode = nil,
						Amount = 10
					}
				}
			},
			Reward = {
				Coins = 750
			}
		},
		{
			Mission = {
				Eliminate = {
					Players = 35
				}
			},
			Reward = {
				XP = 900
			}
		},
	},





	Legendary = {
		{
			Mission = {
				Eliminate = {
					Enemies = 250
				}
			},
			Reward = {
				Coins = 1000
			}
		},
	}
}




return quests
