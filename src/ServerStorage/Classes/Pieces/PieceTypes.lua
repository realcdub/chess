local PieceTypes = {
    ["P"] = "Pawn",
    ["N"] = "Knight",
    ["B"] = "Bishop",
    ["R"] = "Rook",
    ["Q"] = "Queen",
    ["K"] = "King",
}

function PieceTypes:FindPieceByType(Character : string)
    for CharacterType, PieceName in pairs(PieceTypes) do
       if (Character == CharacterType) then
        return PieceName
       end
    end
    warn("Did not find piece!")
    return nil
end
