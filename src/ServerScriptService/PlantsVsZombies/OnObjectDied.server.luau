--!strict 

--[[
    This script exists to make the RootModules be able to commnuicated when its self table has died
    Before it existed, RootPlants caused circular dependancy by asking OPVZObjectDataService, which calls
    the OOPObjectFactory which calls the Support, tank and shooter classes which
    CALL THE ROOTClass
    Now this script solves it by externalizing the dead signal and succesfully
    PVZOBjectDataService disconnecting its OOP from the table. 
]]  

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage.ReplicatedStorage
local libs = ReplicatedStorageFolder.libs
local ServerSignals = require(libs.ServerSignals)
local PVZOBjectDataService = require(script.Parent.Services.PVZObjectDataService)

local function OnObjectDied(OOPObjectKey: {}) 
    PVZOBjectDataService.DisconnectOOP(OOPObjectKey)
end 

ServerSignals.OOPObjectDied:Connect(function(OOPObjectKey) 
    OnObjectDied(OOPObjectKey) 
end)