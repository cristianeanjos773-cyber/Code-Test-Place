--[[
Purpose: Coonstruct OOP objects by receiving the object's name in the create functions
then looking at the classestoconstructors and deciding what class to construct
]]
local PlantsClasses = script.Parent.Parent.PlantsClasses

local ZombiesClasses = script.Parent.Parent.ZombiesClasses 
local PVZFlder = PlantsClasses.Parent
local PVZData = PVZFlder.PVZData

local PlantsData = require(PVZData.PlantsData)
local ZombiesData = require(PVZData.ZombiesData)

local ShooterClass = require(PlantsClasses.ShooterClass)
local SupportClass = require(PlantsClasses.SupportClass)
local TankClass = require(PlantsClasses.TankClass)

local ClassicZombiesClass = require(ZombiesClasses.ClassicZombieClass)

export type ShooterClass = ShooterClass.Shooter 
export type TankClass = TankClass.Tank
export type SupportClass = SupportClass.Support
export type ClassicZombie = ClassicZombiesClass.ClassicZombie 


local OOPObjectFactory = {}

OOPObjectFactory.ClassesToConstructors = {
    
    ["PlantConstructors"] = {
        ["Support"] = SupportClass.new,
        ["Shooter"] = ShooterClass.new,
        ["Tank"] = TankClass.new,  
    },
    
    ["ZombieConstructors"] = {
        ["ClassicZombie"] = ClassicZombiesClass.new        
    }

}

function OOPObjectFactory.CreatePlantObject(PlantName: string)
    local PlantStatus = PlantsData[PlantName]
    local PlantClassToConstruct = PlantsData[PlantName]["Class"]
    warn(PlantClassToConstruct)
    return OOPObjectFactory.ClassesToConstructors["PlantConstructors"][PlantClassToConstruct](PlantStatus) :: ShooterClass | TankClass | SupportClass
end


function OOPObjectFactory.CreateZombieObject(ZombieName: string)
    local ZombieStatus = ZombiesData[ZombieName]
    local ZombieClassToConstruct = ZombiesData[ZombieName]["Class"]
    return OOPObjectFactory.ClassesToConstructors["ZombieConstructors"][ZombieClassToConstruct](ZombieStatus) :: ClassicZombie 
end


return OOPObjectFactory 