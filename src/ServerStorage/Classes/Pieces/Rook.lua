--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local PieceUtil = require(ReplicatedStorage.Shared.Packages.PieceUtil)

--// Classes
local BasePiece = require(script.Parent.BasePiece)

--// Variables

-- Pawn
local Rook = {}
Rook.__index = Rook

function Rook.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("R", Color, FileIndex, RankIndex), Rook)
    return self
end

function Rook:GetPossibleMoves(InternalBoard)
    local DistanceToTheLeft = math.abs(1 - self.FileIndex)
    local DistanceToTheRight = 8 - self.FileIndex
    local DistanceToTheTop = 8 - self.RankIndex
    local DistanceToTheBottom = math.abs(1 - self.RankIndex)

    -- Top Corner
    local Top = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheTop, 0, 1)
    -- Bottom Corner
    local Bottom = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheBottom, 0, -1)
    -- Right Corner
    local Left = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheRight, 1, 0)
    -- Left Corner
    local Right = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheLeft, -1, 0)

    local PossibleMoves = nil
    PossibleMoves = PieceUtil:CombineLegalMoves({Top, Bottom, Left, Right})

    return PossibleMoves
end

return Rook
