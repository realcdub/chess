--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Utility
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)
local String = require(ReplicatedStorage.Shared.Packages.Knit)

--// Classes
local Classes = ServerStorage.Server.Classes
local Match = require(Classes.Match)

--// Definitions
local PiecesDirectory = ServerStorage.Server.Classes.Pieces
local PieceTypes = PiecesDirectory.PieceTypes
local BoardConfig = require(script.Parent:FindFirstChild("BoardConfig"))

--// Variables
local Assets = ReplicatedStorage.Shared.Assets

local BoardService = Knit.CreateService {
    Name = "BoardService",
    Client = {},
}

function BoardService:KnitStart()
    print(self.Name .. " Started")
    local Match1 = Match.new()
    print(Match1.Board)
    self:SetupWorldBoard(Match1.Board, Vector3.new(0, 5, 0))
end

function BoardService:KnitInit()
end

function BoardService:SetupUIBoard(InternalBoard)
end

function BoardService:_findAssetByPieceType(PieceType : string) : BasePart
    if (PieceType == 0) then return end
    if (Assets:FindFirstChild(PieceTypes:FindPieceByType(PieceType) ~= nil)) then
        return Assets:FindFirstChild(PieceTypes:FindPieceByType(PieceType))
    end
    warn("Did not find Asset. Piece might not exist!")
    return nil
end

function BoardService:SetupWorldBoard(InternalBoard, FirstSquareStartingPosition : Vector3)
    -- Iterate through the Match's Internal / Original 2D-Array for the chess board, created through Match Class constructor
    for RankIndex, Rank in ipairs(InternalBoard) do
        for FileIndex, File in ipairs(InternalBoard[RankIndex]) do
            local CurrentSquare = Instance.new("Part")
            CurrentSquare.Name = tostring(FileIndex) .. tostring(RankIndex)
            CurrentSquare.Anchored = true
            CurrentSquare.Size = BoardConfig.World.SquareSize
            CurrentSquare.Material = BoardConfig.World.Material

            local Outline = Instance.new("SelectionBox")
            Outline.Adornee = CurrentSquare
            Outline.LineThickness = 0.0025
            Outline.Color3 = Color3.fromRGB(0, 0, 0)
            Outline.Parent = CurrentSquare
            
            -- Check for first square (a1)
            if (RankIndex == 1 and FileIndex == 1) then
                -- Set a1 square position
                CurrentSquare.Position = FirstSquareStartingPosition
            else
                -- Set position of every square, except a1
                CurrentSquare.Position = FirstSquareStartingPosition + Vector3.new(CurrentSquare.Size.X * (RankIndex - 1), 0, CurrentSquare.Size.Z * (FileIndex - 1))
            end

            -- Determines square color
            if ((RankIndex + FileIndex) % 2 == 1) then
                CurrentSquare.BrickColor = BrickColor.White()
            else
                CurrentSquare.BrickColor = BrickColor.Black()
            end

            CurrentSquare.Parent = workspace
        end
    end
end

function BoardService:GetPossibleMoves(Square, Piece, Board)
end

return BoardService
