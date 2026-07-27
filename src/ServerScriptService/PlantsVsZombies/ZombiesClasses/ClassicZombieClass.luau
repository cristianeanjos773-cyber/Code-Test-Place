--!strict 
local ZombieClasses = script.Parent
local RootZombiesClass = require(ZombieClasses.RootZombiesClass)
local ClassicZombieClass = {}
setmetatable(ClassicZombieClass, {__index = RootZombiesClass})
ClassicZombieClass.__index = ClassicZombieClass


type RootZombie = RootZombiesClass.RootZombie

export type ClassicZombie = typeof(setmetatable({} :: RootZombie & { 
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
    self:WalkToHouse()
end 

return ClassicZombieClass 