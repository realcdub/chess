-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local PieceUtil = require(ReplicatedStorage.Shared.Packages.PieceUtil)

--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Pawn
local Queen = {}
Queen.__index = Queen

function Queen.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("Q", Color, FileIndex, RankIndex), Queen)
    return self
end

function Queen:GetPossibleMoves(InternalBoard)
    local DistanceToTheLeft = PieceUtil:GetDistanceToTheLeft(self.FileIndex)
    local DistanceToTheRight = PieceUtil:GetDistanceToTheRight(self.FileIndex)
    local DistanceToTheTop = PieceUtil:GetDistanceToTop(self.RankIndex)
    local DistanceToTheBottom = PieceUtil:GetDistanceToBottom(self.RankIndex)

    -- Top Corner
    local Top = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheTop, 0, 1)
    -- Bottom Corner
    local Bottom = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheBottom, 0, -1)
    -- Right Corner
    local Left = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheRight, 1, 0)
    -- Left Corner
    local Right = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], DistanceToTheLeft, -1, 0)
    -- Top Right Corner
    local TopRight = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheRight, DistanceToTheTop), 1, 1)
    -- Bottom Right Corner
    local BottomRight = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheRight, DistanceToTheBottom), 1, -1)
    -- Top Left Corner
    local TopLeft = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheLeft, DistanceToTheTop), -1, 1)
    -- Bottom Left Corner
    local BottomLeft = PieceUtil:GetOrthogonalOrDiagonalMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], math.min(DistanceToTheLeft, DistanceToTheBottom), -1, -1)

    local PossibleMoves = nil
    PossibleMoves = PieceUtil:CombineLegalMoves({Top, TopRight, TopLeft, Bottom, BottomRight, BottomLeft, Left, Right})

    return PossibleMoves
end

return Queen
