local DataModuleManager = require(script.Parent.DataModuleManager)

local function PutValuesInPlr(plr)

    local leaderstats = Instance.new("Folder")
    local Coins = Instance.new("IntValue")
    local Level = Instance.new("IntValue")

    leaderstats.Name = "leaderstats"    
    leaderstats.Parent = plr
    Level.Value = DataModuleManager.Profile[plr].Data.Level
    Level.Name = "Level"
    Level.Parent = leaderstats
    Coins.Name = "Coins"
    Coins.Value = DataModuleManager.Profile[plr].Data.Coins
    Coins.Parent = leaderstats

end

return PutValuesInPlr