local ids = {
	1432388259,
	1402768244,
	4491774587
}

local reset = require(workspace.Reset);

for _,v in pairs(ids) do
	reset:ResetLevel(v):ResetRedeemedCodes(v):ResetInventoryWCoins(v):ResetQuestInfo(v)
end