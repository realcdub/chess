local BasePiece = {}
BasePiece.__index = BasePiece

function BasePiece.new(Type : string, Color : string, FileIndex : number, RankIndex : number)
    local self = setmetatable({
        Type = Type,
        Color = Color,
        FileIndex = FileIndex,
        RankIndex = RankIndex
    }, BasePiece)
    return self
end

function BasePiece:GetDistanceToTop()
    return 8 - self.RankIndex
end

function BasePiece:GetDistanceToBottom()
    return math.abs(1 - self.RankIndex)
end

function BasePiece:GetDistanceToTheRight()
    return 8 - self.FileIndex
end

function BasePiece:GetDistanceToTheLeft()
    return math.abs(1 - self.FileIndex)
end

function BasePiece:GetPossibleMoves()
    return {}
end

function BasePiece:Destroy()
end

return BasePiece
