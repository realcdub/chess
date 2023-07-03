-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local PieceUtil = require(ReplicatedStorage.Shared.Packages.PieceUtil)

--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Knight
local Knight = {}
Knight.__index = Knight

function Knight.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("N", Color, FileIndex, RankIndex), Knight)
    return self
end

local function _getKnightMoves(InternalBoard, Piece, FileOffset : number, RankOffset : number)
    local KnightMoves = {}

    if ((Piece.RankIndex + RankOffset <= 0) or (Piece.FileIndex + FileOffset >= 9) or (Piece.FileIndex + FileOffset <= 0) or (Piece.RankIndex + RankOffset >= 9)) then return {} end
    if (InternalBoard[Piece.RankIndex + RankOffset][Piece.FileIndex + FileOffset] ~= 0 and InternalBoard[Piece.RankIndex + RankOffset][Piece.FileIndex + FileOffset].Color == Piece.Color) then return {} end
    KnightMoves[#KnightMoves + 1] = {Piece.FileIndex + FileOffset, Piece.RankIndex + RankOffset}
    
    return KnightMoves
end

function Knight:GetPossibleMoves(InternalBoard)
    local TopLeft = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], -1, 2)
    local TopMidLeft = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], -2, 1)
    local BottomMidLeft = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], -2, -1)
    local BottomLeft = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], -1, -2)
    local BottomRight = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], 1, -2)
    local BottomMidRight = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], 2, -1)
    local TopMidRight = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], 2, 1)
    local TopRight = _getKnightMoves(InternalBoard, InternalBoard[self.RankIndex][self.FileIndex], 1, 2)

    local PossibleMoves = PieceUtil:CombineLegalMoves({TopLeft, TopMidLeft, BottomMidLeft, BottomLeft, BottomRight, BottomMidRight, TopMidRight, TopRight})
    return PossibleMoves
end

return Knight