--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

local WorldPieceService = Knit.CreateService {
    Name = "PieceService",
    Client = {},
}

function WorldPieceService:MoveWorldPiece(WorldPiece : BasePart, TargetSquareCFrame : CFrame)
    local MoveInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, 0, false, 0)
    local MoveProperties = {CFrame = TargetSquareCFrame + Vector3.new(0, WorldPiece.Size / 2, 0)}
    local MoveTween = TweenService:Create(WorldPiece, MoveInfo, MoveProperties)
    MoveTween:Play()
end

return WorldPieceService
