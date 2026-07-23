--!strict 
local PlantsClass = {}

PlantsClass.__index = PlantsClass 

export type RootPlant = typeof(setmetatable({} :: {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["Defense"]: number,
    ["SpawnCooldown"]: number,
    ["SunPrice"]: number,
    ["ModelName"]: string   
    },  
    PlantsClass
))

function PlantsClass.new(StatsTable: {[string]: string | number}): RootPlant  
    
    if not StatsTable or typeof(StatsTable) ~= "table" then
        warn(`Stats table doesnt exist or is not a table, check the statstable argument, typeof: {StatsTable}`)
        return 
    end
    local self = setmetatable({}, PlantsClass) :: RootPlant 

    for PropertyName, PropertyValue in StatsTable do 
        self[PropertyName] = PropertyValue 
    end 

    print(self, StatsTable)
    return self :: RootPlant 

end 

function PlantsClass:IsAlive(): boolean  
    local self = self :: RootPlant
    local SelfHP = self["HP"] 

    if SelfHP > 0 then 
        return true
    else
        return false 
    end 

end 

function PlantsClass:TakeDamage(Damage: number) 
    local self = self :: RootPlant
    local SelfHP = self["HP"] 
    
    local FinalDamageResult = math.max(Damage - self["Defense"], 0)
    local FinalSelfHP = SelfHP - FinalDamageResult
    
    self["HP"] = FinalSelfHP
    
    if self["HP"] <= 0 then
        self:PlantDie() 
    end

end

function PlantsClass:PlantDie() 

end 

function PlantsClass:HealPlant(HealAmount: number) 
    local self = self :: RootPlant
    self["HP"] = math.min(self["HP"] + HealAmount, self["MaxHP"])
end 

return PlantsClass 