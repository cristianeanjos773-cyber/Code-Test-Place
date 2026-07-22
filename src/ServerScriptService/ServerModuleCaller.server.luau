local RS = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorageFolder = RS.ReplicatedStorage
local libs = ReplicatedStorageFolder.libs

local ModuleLoader = require(libs.ModuleLoader)

local ModuleScriptArray = {}

local function InitializeServerModules()

    for _, ModuleScript in ServerScriptService:GetDescendants() do 
        if ModuleScript:IsA("ModuleScript") then 
            print(`[GuiModuleInitializer]: Found ModuleScript: {ModuleScript.Name}`) 
            table.insert(ModuleScriptArray, ModuleScript) 
        end
    end

    ModuleLoader.Load(ModuleScriptArray) 
end


InitializeServerModules()