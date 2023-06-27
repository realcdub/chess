local BasePiece = {}
BasePiece.__index = BasePiece

function BasePiece.new(Type, Color)
    local self = setmetatable({
        Type = Type :: string,
        Color = Color :: string
    }, BasePiece)
    return self
end

function BasePiece:Destroy()
end

return BasePiece
