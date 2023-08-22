-- amazingcdub

--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Pawn
local King = {}
King.__index = King

function King.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("K", Color, FileIndex, RankIndex), King)
    self.NumberOfMoves = 0
    self.InCheck = false
    return self
end

function King:GetPseudoPossibleMoves(InternalBoard)
    local PseudoPossibleMoves = {}

    for RankOffset = -1, 1 do
        for FileOffset = -1, 1 do
            if ((self.RankIndex + RankOffset <= 0) or (self.FileIndex + FileOffset >= 9) or (self.FileIndex + FileOffset <= 0) or (self.RankIndex + RankOffset >= 9)) then continue end
            if (InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset] ~= 0 and InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset].Color == self.Color) then continue end
            PseudoPossibleMoves[#PseudoPossibleMoves + 1] = {self.FileIndex + FileOffset, self.RankIndex + RankOffset}
        end
    end

    return PseudoPossibleMoves
end

local function _removeIllegalMoves(OpponentPiecePossibleMoves, PossibleMoves)
    for _, OpponentPiecePossibleMove in ipairs(OpponentPiecePossibleMoves) do
        for KingPossibleIndex, KingPossibleMove in ipairs(PossibleMoves) do
            if (OpponentPiecePossibleMove[1] == KingPossibleMove[1] and OpponentPiecePossibleMove[2] == KingPossibleMove[2]) then
                table.remove(PossibleMoves, KingPossibleIndex)
            end
        end
    end
end

function King:GetPossibleMoves(InternalBoard)
    local PossibleMoves = self:GetPseudoPossibleMoves(InternalBoard)
    
    for RankIndex = 1, 8 do
       for FileIndex = 1, 8 do
            local Piece = InternalBoard[RankIndex][FileIndex]
            local OpponentPiecePossibleMoves = nil

            if (Piece == 0 or self.Color == Piece.Color) then continue end

            if (Piece.Type == "K") then
                OpponentPiecePossibleMoves = Piece:GetPseudoPossibleMoves(InternalBoard)
                _removeIllegalMoves(OpponentPiecePossibleMoves, PossibleMoves)
                continue
            end

            if (Piece.Type == "P") then
                OpponentPiecePossibleMoves = Piece:GetCapturingThreats(self.Color)
                _removeIllegalMoves(OpponentPiecePossibleMoves, PossibleMoves)
                continue
            end
            
            if (Piece.Type == "K" or Piece.Type == "P") then continue end

            OpponentPiecePossibleMoves = Piece:GetPossibleMoves(InternalBoard)
            _removeIllegalMoves(OpponentPiecePossibleMoves, PossibleMoves)
        end
    end

    return PossibleMoves
end

return King
