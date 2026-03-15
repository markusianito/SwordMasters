local Settings = {}

--=============>Round Section

Settings.Round = {
    NumberPlayersToStart     = 1,
    Intermission             = 30,
    TimeToStartVoteMap       = 15,
    WaitTimeToTeleport       = 3,
    WaitTimeBeforeStartRound = 5,
}
--=============>Map Section

Settings.BossSettings ={
    Animations = {
		Idle        = 16061978443,
        Walk        = 14931898537,
        Death       = 14931985159,
        Spawn       = 14931795418,
        GroundKick1 = 14931923590,
        GroundKick2 = 15170724360,
        GroundKick3 = 15170749235,
		LaserIdle   = 16061978443,
        Spike       = 14931940017,
        Tired       = 14941151550,
        MegaKick    = 15559388269,
        BreakIn     = 15563575296,
        BreakOut    = 15635589063,
        KickPlayers = 15619555355,
    },
    AttackMoveSettings = {
        GroundKick = {
            NumberOfAttackGroundKick = math.random(1,3) ,--boss will choose how many times do ground kick its choose random from 1 to 3 times
            GroundKickFinalSize      = Vector3.new(1200,0.1,1200), --end size of ground Kick
            WaitTimeToTweenSize      = 5,
            WaitTimeToRemoveMove     = 7,
            WaitTimeToTransparency   = 6

        },
        LaserAttack = {
            WaitTimeToDisableParticleEmitter = 2,
            CamShakePlayers                  = true,
            WaitTimeToStopCamShake           = 2.8,
            WaitTimeToTweenSizeOfPlatform    = 3,
            WaitTimeToStartSpawnLaser        = 3,
            WaitTimeToFinalSizeLaser         = 4,
            WaitTimeToRotateLaser            = 1,
            WaitTimeToStopRotateLaser        = 15,
            IncreaseSpeedEverySecond         = 0.0014,
            LaserDamage                      = 20,
            PlatformDamage                   = 10

         },
         Spike = {
           NumberOfSpikeToSpawn            = math.random(425,475),
           WaitTimeBetweenSpawn            = 0.001, 
           TimeBetweenPointAndSpikeToSpawn = 0.7,
           TweenTimeSpike                  = 0.4,
           TimeBetweenSpawnAndRestSpike    = 3
         }

    },
    ManyNumberOfAttacksBeforeBreak     = 3,
    MaxHealthBoss                      = nil, --If you made it nil So Boss health will equal to Number of players in round
    DistanceBetweenTreeAndBossToKickIt = 66, --Default 66 (Recommended),
    TimeBetweenBreakinAndBreakOut      = 10,
    DamageKickPlayers                  = 10
}

Settings.Abilities={
	["SpecialOffersChances"]={
		["Common"]=40,
		["Uncommon"]=20,
		["Rare"]=10,
		["Epic"]=10,
		["Legendary"]=10
	}
}

return Settings
