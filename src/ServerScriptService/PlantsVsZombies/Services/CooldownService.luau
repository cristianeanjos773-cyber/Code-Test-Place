--!strict 
local Players = game:GetService("Players")
export type CooldownKey = {
    [string|Player]: number
}

local CooldownService = {}

CooldownService.ObjectsInCooldown = {}

setmetatable(CooldownService.ObjectsInCooldown, {__mode = "k"})

function CooldownService.AddObjectInCooldownTable(Object: Player | string, Action: string, CooldownNumber: number)
    warn(CooldownService.ObjectsInCooldown, Object, Action, CooldownNumber)
    
    if not CooldownService.ObjectsInCooldown[Object] then
        CooldownService.ObjectsInCooldown[Object] = {} 
    end

    if not CooldownNumber or typeof(CooldownNumber) ~= "number" then 
        warn(`[CooldownService]: check the cooldown number argument, the type:{CooldownNumber}`)
        return
    end

    
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey 
    local ActionInCooldown = ObjectInCooldown[Action]

    if not ObjectInCooldown[Action] then 
        ObjectInCooldown[Action] = CooldownNumber or 0 
    end 
    warn("AddObjectInCooldownTable", ObjectInCooldown, ActionInCooldown)
end

function CooldownService.IsCooldownOn(Object: Player | string, Action: string): boolean  
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey 

    warn("IsCooldownOnCall1", Object, Action)

    if not ObjectInCooldown[Action] then 
        ObjectInCooldown[Action] = 0
    end 

    local ObjectActionCooldown = ObjectInCooldown[Action] :: number
    warn(ObjectActionCooldown)
    local CurrentTime = os.clock()
    warn("Table of all", CooldownService.ObjectsInCooldown, "Action:", ObjectInCooldown[Action], "OBJINCOOLDOWN", ObjectInCooldown)
    
    if ObjectActionCooldown and CurrentTime < ObjectActionCooldown then 
        return true
    else
        return false  
    end 

end 

function CooldownService.StartCooldown(Object: string | Player, Action: string, CooldownNumber: number)
    local ObjectFinalCooldown = os.clock() + CooldownNumber :: number
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey  
    
    if not ObjectInCooldown then 
        warn("[CooldownService]: ObjectInCooldown doesnt exist")
        return
    end
 
    ObjectInCooldown[Action] = ObjectFinalCooldown 

end

Players.PlayerAdded:Connect(function(Player: Player)
    CooldownService.ObjectsInCooldown[Player] = {}
end)

return CooldownService