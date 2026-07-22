--!strict 
local ServerStorage = game:GetService("ServerStorage")
local PVZPlayerDataService = {}

export type PlantsOwnerTable = {
    [Player]: {[string]: Model} 
}



export type PlayerCooldownKey = {
    [string]: number
}

PVZPlayerDataService.PlantsOwners = {} :: PlantsOwnerTable 

--[[TODO:
Today we should make a module exclusive for managing the player PVZ data instead of leaving in this module 
because of cyclic dependence
i should make functions, like a "PVZPlayerData.RemovePlrFromTable()" etc
]]

setmetatable(PVZPlayerDataService.PlantsOwners, {__mode =  "k"}) 


function PVZPlayerDataService.AddPlantInPlayer(Player: Player, PlantName: string) 
    local PlantModel = ServerStorage.PlantsModels:FindFirstChild(PlantName) :: Model

    if not PlantModel then 
        return 
    end

    if not PVZPlayerDataService.PlantsOwners[Player] then 
        PVZPlayerDataService.PlantsOwners[Player] = {}
    end
    
    local PlayerOwner = PVZPlayerDataService.PlantsOwners[Player]
    local PlantModelName = PlantModel.Name

    
    PlayerOwner[PlantModelName] = PlantModel 

end 

function PVZPlayerDataService.RemovePlantFromPlayer(Player: Player, PlantModel: Model) 
    local PlayerOwner = PVZPlayerDataService.PlantsOwners[Player]
    
    if not PlayerOwner or type(PlayerOwner) ~= "table" then 
        warn(`PvZPlayerDataService.RemovePlantFromPlayer(): PlayerOwner does not exist or is not type table {typeof(PlayerOwner)}`)
        return 
    end

    local PlantModelName = PlantModel.Name

    if PlayerOwner[PlantModelName] then
        PlayerOwner[PlantModelName]:Destroy() 
        PlayerOwner[PlantModelName] = nil 
    end

end 

 

return PVZPlayerDataService
