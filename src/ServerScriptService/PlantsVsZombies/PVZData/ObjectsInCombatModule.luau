local ObjectsInCombatModule = {}

ObjectsInCombatModule.ObjectsInCombat = {} -- whys this here instead of a directly and simply using the module table? because these cant be used as setmetatables. 
-- so we wouldnt be able to make this mode. 

setmetatable(ObjectsInCombatModule.ObjectsInCombat, {__mode = "kv"})


return ObjectsInCombatModule 