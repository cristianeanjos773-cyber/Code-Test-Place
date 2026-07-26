--!strict 

--[[
    This script exists to make the RootModules be able to commnuicated when its self table has died
    Before it existed, RootPlants caused circular dependancy by asking OPVZObjectDataService, which calls
    the OOPObjectFactory which calls the Support, tank and shooter classes which
    CALL THE ROOTClass
    Now this script solves it by externalizing the dead signal and succesfully
    PVZOBjectDataService disconnecting its OOP from the table. 
    This script will work as a mediator, with this, the root plant doesnt need to know the root class ever existed
    Both of them will send signals and this script will manage them 
]]  

local PVZFolder = script.Parent
local Services = PVZFolder.Services
local CombatService = require(Services.CombatService)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local libs = ReplicatedStorageFolder.libs
local ServerSignals = require(libs.ServerSignals)
local PVZOBjectDataService = require(script.Parent.Services.PVZObjectDataService)

local function OnObjectDied(OOPObjectKey: {}) 
    PVZOBjectDataService.DisconnectOOP(OOPObjectKey)
end 

local DamageRequest = CombatService.ValidateAttackRequest

local function OnObjectDamaged(OOPObjectKey: {}) 
    DamageRequest(OOPObjectKey)    
end 

ServerSignals.OOPObjectDied:Connect(function(OOPObjectKey) 
    OnObjectDied(OOPObjectKey) 
end)
 
ServerSignals.OOPAttackRequest:Connect(function(OOPObjectKey) 
    OnObjectDamaged(OOPObjectKey)
end)