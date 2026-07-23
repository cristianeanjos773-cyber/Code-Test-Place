-----------------------------------------------------Services
local players = game:GetService("Players")
local RunService = game:GetService("RunService")
-----------------------------------------------------References
local DataFolder = script.Parent
-----------------------------------------------------Modules
local ValueHandler = require(DataFolder:FindFirstChild("ValueHandler"))
local ProfileStore = require(DataFolder:FindFirstChild("ProfileStore"))
local DataTemplate = require(DataFolder:FindFirstChild("DataTemplate"))
local DataModuleManager = require(DataFolder:FindFirstChild("DataModuleManager"))
-----------------------------------------------------

local function InitialzeValues(player)
    ValueHandler(player)
end

local function GetStoreName()
    return RunService:IsStudio() and "is studio" or "test" 
end

local PlayerStore = ProfileStore.New(GetStoreName(), DataTemplate)

local function PlayerAdded(player: Player)
    
    local playerprofile = PlayerStore:StartSessionAsync("Player_" .. player.UserId, {
        Cancel = function()
            return player.Parent ~= players
        end,
    }
    )
    
    if playerprofile ~= nil then
        playerprofile:AddUserId(player.UserId)
        playerprofile:Reconcile()

        playerprofile.OnSessionEnd:Connect(function()
            DataModuleManager.Profile[player] = nil 
            player:Kick("Data failed... this usually gets solved automatically if you rejoin...")
        end)
    end
    
    if player.Parent == players then
        DataModuleManager.Profile[player] = playerprofile
        DataModuleManager.SendDataToClient(player)
        warn("ATTEMPTED TO CALL THAT DATA FUNCTION WHICH YOU NOW WHICH IS")
        InitialzeValues(player)
    else
        playerprofile:EndSession()
    end
    
end

local function PlayerLeft(player: Player)
    local PlayerProfile = DataModuleManager.Profile[player]
    
    if not PlayerProfile then return end
    
    PlayerProfile:EndSession()
    DataModuleManager.Profile[player] = nil 
    
end

for _, plrs in players:GetPlayers() do
    task.spawn(PlayerAdded, plrs)
end

players.PlayerAdded:Connect(PlayerAdded)
players.PlayerRemoving:Connect(PlayerLeft)    