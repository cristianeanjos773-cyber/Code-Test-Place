--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedStorageFolder = ReplicatedStorage:WaitForChild("ReplicatedStorage")
local Remotes = ReplicatedStorageFolder:WaitForChild("Remotes")
local UpdateShooterAim = Remotes:WaitForChild("UpdateShooterAim") :: RemoteEvent

local VisualObjectsMovementsService = {}

function VisualObjectsMovementsService.ShooterMove() 
    warn("FSHOOTER MOVE FUNC CALLED!!")
    UpdateShooterAim.OnClientEvent:Connect(function(ShooterModel: Model, ClosestZombie: Model)
        print("SIGNAL RECEIVED!")
        local ShooterPosition = ShooterModel:GetPivot().Position
        local TargetPosition = ClosestZombie.PrimaryPart.Position 

        TargetPosition = Vector3.new(
            TargetPosition.X,
            ShooterPosition.Y,
            TargetPosition.Z
        )

        ShooterModel:PivotTo(CFrame.lookAt(ShooterPosition, TargetPosition))

    end)
end 

VisualObjectsMovementsService.ShooterMove()

return VisualObjectsMovementsService 