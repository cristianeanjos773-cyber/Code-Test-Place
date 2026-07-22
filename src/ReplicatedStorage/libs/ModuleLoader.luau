local Cache = {}

-- Main Module:
local ModuleLoader = {}

function ModuleLoader.Get(Name: string)
    local Module = Cache[Name]

    if not Module then
        warn(`[ModuleLoader]: Module '{Name}' has not been loaded`)
    end

    return Module
end

function ModuleLoader.Load(List: {
    ModuleScript | Folder
})
    for _, V in List do
        if V:IsA("ModuleScript") then
            local Success, Module = pcall(require, V)

            if Success then
                Cache[V.Name] = Module

                if Module.Init then
                    task.defer(Module.Init, Module)
                end
                
            else
                warn(`[ModuleLoader]: Failed to load module '{V:GetFullName()}'`)
            end
        elseif V:IsA("Folder") then
            ModuleLoader.Load(V:GetChildren())
        end
    end
end

return ModuleLoader