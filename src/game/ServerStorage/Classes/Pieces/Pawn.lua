-- amazingcdub

--// Classes
local BasePiece = require(script.Parent.BasePiece)

-- Pawn
local Pawn = {}
Pawn.__index = Pawn

function Pawn.new(Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable(BasePiece.new("P", Color, FileIndex, RankIndex), Pawn)
    return self
end

function Pawn:GetPossibleMoves(InternalBoard)
    local PossibleMoves = {}
    -- White Pawn Logic
    if (self.Color == "w") then
        -- Check 1 Square ahead
        if (InternalBoard[self.RankIndex + 1][self.FileIndex] == 0) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex, self.RankIndex + 1}
        end

        -- Check 2 Squares ahead
        if (self.RankIndex == 2 and InternalBoard[self.RankIndex + 2][self.FileIndex] == 0 and InternalBoard[self.RankIndex + 1][self.FileIndex] == 0) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex, self.RankIndex + 2}
        end

        -- Capturing
        if (self.RankIndex + 1 <= 8 and self.FileIndex + 1 <= 8 and InternalBoard[self.RankIndex + 1][self.FileIndex + 1] ~= 0 and InternalBoard[self.RankIndex + 1][self.FileIndex + 1].Color == "b") then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + 1, self.RankIndex + 1}
        end

        if (self.RankIndex + 1 <= 8 and self.FileIndex - 1 >= 1 and InternalBoard[self.RankIndex + 1][self.FileIndex - 1] ~= 0 and InternalBoard[self.RankIndex + 1][self.FileIndex - 1].Color == "b") then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex - 1, self.RankIndex + 1}
        end

        --[[
        -- En Passant
        if (self.RankIndex == 5 and InternalBoard[self.RankIndex][self.FileIndex + 1] ~= 0 and InternalBoard[self.RankIndex][self.FileIndex - 1].Color == "b" and InternalBoard[self.RankIndex][self.FileIndex - 1].Type == "P") then
            PossibleMoves[#PossibleMoves+1] = {self.FileIndex - 1, self.RankIndex + 1}
        end

        if (self.RankIndex == 5 and InternalBoard[self.RankIndex][self.FileIndex + 1] ~= 0 and InternalBoard[self.RankIndex][self.FileIndex + 1].Color == "b" and InternalBoard[self.RankIndex][self.FileIndex + 1].Type == "P" ) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + 1, self.RankIndex + 1}
        end
        -]]
    end

    -- Bloack Pawn Logic
    if (self.Color == "b") then
        -- Check 1 Square ahead
        if (InternalBoard[self.RankIndex - 1][self.FileIndex] == 0) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex, self.RankIndex - 1}
        end

        -- Check 2 Squares ahead
        if (self.RankIndex == 7 and InternalBoard[self.RankIndex - 2][self.FileIndex] == 0 and InternalBoard[self.RankIndex - 1][self.FileIndex] == 0) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex, self.RankIndex - 2}
        end

        -- Capturing
        if (self.RankIndex - 1 >= 1 and self.FileIndex + 1 <= 8 and InternalBoard[self.RankIndex - 1][self.FileIndex + 1] ~= 0 and InternalBoard[self.RankIndex - 1][self.FileIndex + 1].Color == "w") then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + 1, self.RankIndex - 1}
        end

        if (self.RankIndex - 1 >= 1 and self.FileIndex - 1 >= 1 and InternalBoard[self.RankIndex - 1][self.FileIndex - 1] ~= 0 and (InternalBoard[self.RankIndex - 1][self.FileIndex - 1].Color == "w")) then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex - 1, self.RankIndex - 1}
        end

        --[[
        -- En Passant
        if (self.RankIndex == 4 and InternalBoard[self.RankIndex][self.FileIndex - 1] ~= 0 and InternalBoard[self.RankIndex][self.FileIndex - 1].Color == "w" and InternalBoard[self.RankIndex][self.FileIndex - 1].Type == "P") then
            PossibleMoves[#PossibleMoves+1] = {self.FileIndex - 1, self.RankIndex + 1}
        end

        if (self.RankIndex == 4 and InternalBoard[self.RankIndex][self.FileIndex + 1] ~= 0 and InternalBoard[self.RankIndex][self.FileIndex + 1].Color == "w" and InternalBoard[self.RankIndex][self.FileIndex - 1].Type == "P") then
            PossibleMoves[#PossibleMoves + 1] = {self.FileIndex + 1, self.RankIndex + 1}
        end
        --]]
    end

    return PossibleMoves
end

function Pawn:GetCapturingThreats(KingColor : string)
    local CapturingMoves = {}

    if (KingColor == "b" and self.Color == "w") then
        -- Capturing
        if (self.RankIndex + 1 <= 8 and self.FileIndex + 1 <= 8) then
            CapturingMoves[#CapturingMoves + 1] = {self.FileIndex + 1, self.RankIndex + 1}
        end

        if (self.RankIndex + 1 <= 8 and self.FileIndex - 1 >= 1) then
            CapturingMoves[#CapturingMoves + 1] = {self.FileIndex - 1, self.RankIndex + 1}
        end
    end

    if (KingColor == "w" and self.Color == "b") then
        -- Capturing
        if (self.RankIndex - 1 >= 1 and self.FileIndex + 1 <= 8) then
            CapturingMoves[#CapturingMoves + 1] = {self.FileIndex + 1, self.RankIndex - 1}
        end

        if (self.RankIndex - 1 >= 1 and self.FileIndex - 1 >= 1) then
            CapturingMoves[#CapturingMoves + 1] = {self.FileIndex - 1, self.RankIndex - 1}
        end
    end

    print(CapturingMoves)
    return CapturingMoves
end

return Pawn
