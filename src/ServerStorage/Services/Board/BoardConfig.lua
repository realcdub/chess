local BoardConfig = {}

BoardConfig.World = {
    BoardSize = Vector3.new(),
    SquareSize = Vector3.new(10,1,10),
    Material = Enum.Material.SmoothPlastic,
}

BoardConfig.Interface = {
    BoardSize = UDim2.new(),
    SquareSize = UDim2.fromScale()
}

return BoardConfig