
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