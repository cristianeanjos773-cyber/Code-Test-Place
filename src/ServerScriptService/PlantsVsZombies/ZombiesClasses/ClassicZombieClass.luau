local ZombieClasses = script.Parent
local RootZombiesClass = require(ZombieClasses.RootZombiesClass)

local ClassicZombieClass = {}
setmetatable(ClassicZombieClass, {__index = RootZombiesClass})
ClassicZombieClass.__index = ClassicZombieClass



return ClassicZombieClass 