--!strict 
local ZombieClasses = script.Parent
local RootZombiesClass = require(ZombieClasses.RootZombiesClass)
local ClassicZombieClass = {}
setmetatable(ClassicZombieClass, {__index = RootZombiesClass})
ClassicZombieClass.__index = ClassicZombieClass


type RootZombie = RootZombiesClass.RootZombie

export type ClassicZombie = typeof(setmetatable({} :: RootZombie & {
    ["HP"]: number,
    ["MaxHP"]: number, 
    ["ModelName"]: string, 
    ["ModelInstance"]: Model, 
    ["Class"]: string,
    ["Initialize"]: () -> (),  
},
ClassicZombieClass 
))

function ClassicZombieClass.new(ClassicZombieStats: {}): ClassicZombie  
    local self = RootZombiesClass.new(ClassicZombieStats) :: ClassicZombie
    setmetatable(self, ClassicZombieClass)
    return self 
end

function ClassicZombieClass:Initialize() 
    local self = self :: ClassicZombie
    local ZombieModel = self["ModelInstance"]
    warn("Printing self properties:", self, ZombieModel)
    self:WalkToHouse(ZombieModel)
end 

return ClassicZombieClass 