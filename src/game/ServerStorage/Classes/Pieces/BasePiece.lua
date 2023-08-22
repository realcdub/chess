-- amazingcdub

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

return BasePiece
