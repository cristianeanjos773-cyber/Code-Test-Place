local RootZombiesClass = {}

export type RootZombie = typeof(setmetatable({} :: {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["BiteDamage"]: number, 
    ["BiteCooldown"]: number,    
    ["ModelName"]: string, 
    ["Class"]: string,  
    },  
    RootZombiesClass
))

RootZombiesClass.__index = RootZombiesClass 

function RootZombiesClass.new(StatsTable: {[string]: string | number}): RootZombie
    
    if not StatsTable or typeof(StatsTable) ~= "table" then
        warn(`Stats table doesnt exist or is not a table, check the statstable argument, typeof: {StatsTable}`)
        return 
    end

    local self = setmetatable({}, RootZombiesClass) :: RootZombie 

    for PropertyName, PropertyValue in StatsTable do 
        self[PropertyName] = PropertyValue 
    end 

    print(self, StatsTable)
    return self :: RootZombie 

end 

return RootZombiesClass