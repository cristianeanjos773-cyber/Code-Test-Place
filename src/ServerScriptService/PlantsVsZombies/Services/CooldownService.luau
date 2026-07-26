--!strict 
local Players = game:GetService("Players")

export type CooldownObject =  string|Player|{}

export type CooldownData = {
    [string]: number 
}


local CooldownService = {}

CooldownService.ObjectsInCooldown = {} :: {[CooldownObject]: CooldownData}

setmetatable(CooldownService.ObjectsInCooldown, {__mode = "k"})


function CooldownService.IsCooldownOn(Object: CooldownObject, Action: string): boolean 
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] 
    warn(Object)
    if not ObjectInCooldown then 
        warn("You have probable forgotten to call .StartCooldown() first, no object in table foumd.")
        return false 
    end

    if not ObjectInCooldown[Action] then 
        ObjectInCooldown[Action] = 0
    end 

    local ObjectActionCooldown = ObjectInCooldown[Action] 
    warn(ObjectInCooldown, ObjectActionCooldown)
    local CurrentTime = os.clock()
    
    if ObjectActionCooldown and CurrentTime < ObjectActionCooldown then 
        return true
    else
        return false  
    end 

end 

function CooldownService.StartCooldown(Object: CooldownObject, Action: string, CooldownNumber: number)
    
    local ObjectFinalCooldown = os.clock() + CooldownNumber 
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] 
    
    if not ObjectInCooldown then 
        ObjectInCooldown = {}
        CooldownService.ObjectsInCooldown[Object] = ObjectInCooldown
    end

    ObjectInCooldown[Action] = ObjectFinalCooldown 

end

function CooldownService.GetRemainingCooldown(Object: CooldownObject, Action: string): number 
    local ObjectInCooldown = CooldownService.ObjectsInCooldown[Object] 

    if not ObjectInCooldown then 
        warn("You have probable forgotten to call .StartCooldown() first, no object in table foumd.")
        return 0
    end

    local CooldownEnd = ObjectInCooldown[Action]

    if not CooldownEnd then
        return 0 
    end 
    
    return math.max(CooldownEnd - os.clock(), 0)
end 

Players.PlayerAdded:Connect(function(Player: Player)
    CooldownService.ObjectsInCooldown[Player] = {} 
end)

return CooldownService