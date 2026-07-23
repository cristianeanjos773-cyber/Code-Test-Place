--!strict 
local Players = game:GetService("Players")

export type CooldownKey = {
    [string|Player|{}]: number
}

local CooldownService = {}

CooldownService.ObjectsInCooldown = {}

setmetatable(CooldownService.ObjectsInCooldown, {__mode = "k"})


function CooldownService.IsCooldownOn(Object: CooldownKey, Action: string): boolean  
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

function CooldownService.StartCooldown(Object: CooldownKey, Action: string, CooldownNumber: number)
    
    local ObjectFinalCooldown = os.clock() + CooldownNumber :: number
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] :: CooldownKey  
    
    if not ObjectInCooldown then 
        ObjectInCooldown = {}
        CooldownService.ObjectsInCooldown[Object] = ObjectInCooldown
    end

    ObjectInCooldown[Action] = ObjectFinalCooldown 

end


Players.PlayerAdded:Connect(function(Player: Player)
    CooldownService.ObjectsInCooldown[Player] = {} :: CooldownKey
end)

return CooldownService