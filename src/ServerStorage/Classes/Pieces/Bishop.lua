--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local PieceUtil = require(ReplicatedStorage.Shared.Packages.PieceUtil)

--// Classes
local BasePiece = require(script.Parent.BasePiece)

--// Variables

-- Pawn
local Bishop = {}
Bishop.__index = Bishop

function Bishop.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("B", Color, FileIndex, RankIndex), Bishop)
    return self
end

function Bishop:GetPossibleMoves(InternalBoard)
    local DistanceToTheLeft = math.abs(1 - self.FileIndex)
    local DistanceToTheRight = 8 - self.FileIndex
    local DistanceToTheTop = 8 - self.RankIndex
    local DistanceToTheBottom = math.abs(1 - self.RankIndex)

    -- Top Right Corner
    local TopRight = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheRight, DistanceToTheTop), 1, 1)
    -- Bottom Right Corner
    local BottomRight = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheRight, DistanceToTheBottom), 1, -1)
    -- Top Left Corner
    local TopLeft = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheLeft, DistanceToTheTop), -1, 1)
    -- Bottom Left Corner
    local BottomLeft = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheLeft, DistanceToTheBottom), -1, -1)

    local PossibleMoves = nil
    PossibleMoves = PieceUtil:CombineLegalMoves({TopRight, BottomRight, TopLeft, BottomLeft})

    return PossibleMoves
end

return Bishop
