local Debris = game:GetService("Debris")
--local StarterGUIscripts = script.Parent

type SetUpProperties = {
    ["SoundId"]: string?, 
    ["PlaybackSpeed"]: number?,
    ["Name"]: string?,
    ["Parent"]: Instance?, 
}


local SFXService = {}

function SFXService.SetUPSFXProperties(SoundInstance: Sound, SetUpPropeties: SetUpProperties) 
    
    task.spawn(function()
    
        for Properties, Values in SetUpPropeties do 
            warn("PRINTING ASKED PROPERTIES", Properties, " : ", Values)
           
            if not SoundInstance[Properties] then
                continue
            end 
            
            SoundInstance[Properties] = Values 
    
        end 
    
    end)

end 

function SFXService.SpawnSFX(SetUpPropeties: SetUpProperties) 
    local SoundInstance = Instance.new("Sound")
    SFXService.SetUPSFXProperties(SoundInstance, SetUpPropeties)
    SoundInstance.Parent = SetUpPropeties["Parent"]
    return SoundInstance
end 

return SFXService 