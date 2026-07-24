local libs = script.Parent
local GoodSignal = require(libs.GoodSignalFramework)

local ServerSignals = {
    TankDamaged = GoodSignal.new()
}

return ServerSignals 