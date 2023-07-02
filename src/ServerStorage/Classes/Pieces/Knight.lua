--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Knight
local Knight = {}
Knight.__index = Knight

function Knight.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("N", Color, FileIndex, RankIndex), Knight)
    return self
end

function Knight:GetPossibleMoves(InternalBoard)
    local PossibleMoves = {}

    for RankOffset = -2, 2 do
        for FileOffset = -2, 2 do
            if ((self.RankIndex + RankOffset <= 0) or (self.FileIndex + FileOffset >= 9) or (self.FileIndex + FileOffset <= 0) or (self.RankIndex + RankOffset >= 9)) then continue end
            if (InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset] ~= 0 and InternalBoard[self.RankIndex + RankOffset][self.FileIndex + FileOffset].Color == self.Color) then continue end
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + FileOffset, self.RankIndex + RankOffset}
        end
    end

    return PossibleMoves
end

return Knight
