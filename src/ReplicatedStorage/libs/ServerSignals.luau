local libs = script.Parent
local GoodSignal = require(libs.GoodSignalFramework)

local ServerSignals = {
    TankDamaged = GoodSignal.new(),
    OOPObjectDied = GoodSignal.new(), 
    OOPAttackRequest = GoodSignal.new(),
    OOPObjectKilledAnotherOOP = GoodSignal.new(),  
    OOPSpawned = GoodSignal.new(),
}

return ServerSignals 