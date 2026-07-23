--!strict 
local Players = game:GetService("Players")

export type CooldownKey = {
    [string|Player|{}]: number
}

local CooldownService = {}

CooldownService.ObjectsInCooldown = {}

setmetatable(CooldownService.ObjectsInCooldown, {__mode = "k"})

function CooldownService.AddObjectInCooldownTable(Object: Player | string | {}, Action: string, CooldownNumber: number)
    
    warn(CooldownService.ObjectsInCooldown, Object, Action, CooldownNumber)
    
    if not CooldownService.ObjectsInCooldown[Object] then
        warn("fgsefwesfesfe")
        CooldownService.ObjectsInCooldown[Object] = {} 
    end

    if not CooldownNumber or typeof(CooldownNumber) ~= "number" then 
        warn(`[CooldownService]: check the cooldown number argument, the type:{CooldownNumber}`)
        return
    end

    
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey 
    --local ActionInCooldown = ObjectInCooldown[Action]

    if not ObjectInCooldown[Action] then 
        ObjectInCooldown[Action] = CooldownNumber or 0 
    end

end

function CooldownService.IsCooldownOn(Object: Player | string | {}, Action: string): boolean  
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey 

    if not ObjectInCooldown[Action] then 
        ObjectInCooldown[Action] = 0
    end 

    local ObjectActionCooldown = ObjectInCooldown[Action] :: number
    warn(ObjectActionCooldown)
    local CurrentTime = os.clock()
    
    if ObjectActionCooldown and CurrentTime < ObjectActionCooldown then 
        return true
    else
        return false  
    end 

end 

function CooldownService.StartCooldown(Object: string | Player | {}, Action: string, CooldownNumber: number)
    
    local ObjectFinalCooldown = os.clock() + CooldownNumber :: number
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey  
    
    if not ObjectInCooldown then 
        return
    end

    ObjectInCooldown[Action] = ObjectFinalCooldown 

end

Players.PlayerAdded:Connect(function(Player: Player)
    CooldownService.ObjectsInCooldown[Player] = {}
end)

return CooldownService