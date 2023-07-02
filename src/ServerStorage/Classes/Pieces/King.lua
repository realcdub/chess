--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Pawn
local King = {}
King.__index = King

function King.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("K", Color, FileIndex, RankIndex), King)
    return self
end

function King:GetPossibleMoves(InternalBoard)
    local PossibleMoves = {}

    for RankOffset = -1, 1 do
        for FileOffset = -1, 1 do
            if ((self.RankIndex + RankOffset <= 0) or (self.FileIndex + FileOffset >= 9) or (self.FileIndex + FileOffset <= 0) or (self.RankIndex + RankOffset >= 9)) then continue end
            if (InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset] ~= 0 and InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset].Color == self.Color) then continue end
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + FileOffset, self.RankIndex + RankOffset}
        end
    end

    return PossibleMoves
end

return King
