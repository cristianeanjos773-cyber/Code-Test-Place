local DataTemplate = require(script.Parent.DataTemplate)

local DataModuleManager = {}
DataModuleManager.Profile = {}

function DataModuleManager.ManageCoins(player: Player, amount: number)
    
    local leaderstats = player:FindFirstChild("leaderstats") :: Folder
    local Coins: IntValue = leaderstats.Coins
    local profile = DataModuleManager.Profile[player]
    
    if not player or not amount or not profile then return end
    
    profile.Data.Coins = math.clamp(profile.Data.Coins + amount, 0, 1000000) 
    Coins.Value = profile.Data.Coins
    
end

function DataModuleManager.ManageLevel(player: Player, amount: number)
    
    local leaderstats = player:FindFirstChild("leaderstats") :: Folder
    local Level: IntValue = leaderstats.Level
    local profile = DataModuleManager.Profile[player]

    if not player or not amount or not profile then return end 
    
    profile.Data.Level = math.clamp(profile.Data.Level + amount , 0, 1000000)
    Level.Value = profile.Data.Level
    
end

return DataModuleManager