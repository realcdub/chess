-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)
local PieceUtil = require(ReplicatedStorage.Shared.Packages.PieceUtil)

--// Classes
local Classes = ServerStorage.Server.Classes
local Match = require(Classes.Match.Match)
local MatchesContainer = require(Classes.Match.MatchesContainer)

--// Definitions
local PieceClasses = ServerStorage.Server.Classes.Pieces
local PieceTypes = require(PieceClasses.PieceTypes)
local BoardConfig = require(script.Parent:FindFirstChild("BoardConfig"))

--// Variables
local Assets = ReplicatedStorage.Shared.Assets

--// Constants
local MAX_PIECE_CLICK_ACTIVATION_DISTANCE = 10000
local DEFAULT_DARK_SQUARE_COLOR = Color3.fromRGB(0, 0, 0)
local DEFAULT_LIGHT_SQUARE_COLOR = Color3.fromRGB(255, 255, 255)

local BoardService = Knit.CreateService {
    Name = "BoardService",
    Client = {
        MovePiece = Knit.CreateSignal()
    },
}

function BoardService:KnitStart()
    print(self.Name .. " Started")
    local Match1 = Match.new(game:GetService("Players"):WaitForChild("amazingcdub"))
    table.insert(MatchesContainer.Matches, Match1)
    self:SetupWorldBoard(Match1.Board, Vector3.new(0, 5, 0))

    self.Client.MovePiece:Connect(function(Player, WorldPiece, TargetSquare, OriginalSplitWorldPieceName, WorldBoard)
        local PlayerMatch = MatchesContainer:FindMatchByPlayer(Player)

        local SplitTargetSquareName = TargetSquare.Name:split("")

        local OriginalRankIndex = tonumber(OriginalSplitWorldPieceName[2])
        local OriginalFileIndex = tonumber(OriginalSplitWorldPieceName[1])

        local TargetRankIndex = tonumber(SplitTargetSquareName[2])
        local TargetFileIndex = tonumber(SplitTargetSquareName[1])

        if (PlayerMatch.Board[TargetRankIndex][TargetFileIndex] ~= 0) then
            WorldBoard.Pieces[tostring(TargetFileIndex) .. tostring(TargetRankIndex)]:Destroy()
        end

        local InternalPiece = PlayerMatch.Board[OriginalRankIndex][OriginalFileIndex]
        InternalPiece.RankIndex = TargetRankIndex
        InternalPiece.FileIndex = TargetFileIndex

        PieceUtil:MoveWorldPiece(WorldPiece, TargetSquare.CFrame)
        WorldPiece.Name = TargetSquare.Name

        PlayerMatch.Board[OriginalRankIndex][OriginalFileIndex] = 0
        PlayerMatch.Board[TargetRankIndex][TargetFileIndex] = InternalPiece
    end)
end

function BoardService:KnitInit()
end

function BoardService.Client:GetLegalMoves(Player, FileIndex, RankIndex)
    local PlayerMatch = MatchesContainer:FindMatchByPlayer(Player)
    return PlayerMatch.Board[RankIndex][FileIndex]:GetPossibleMoves(PlayerMatch.Board)
end

function BoardService:_findAssetByPieceType(PieceType : string) : BasePart
    if (PieceType == 0) then return end
    local PieceName = PieceTypes:FindPieceByType(PieceType)

    if (PieceName ~= nil) then
        if (Assets:FindFirstChild(PieceName)) then
            return Assets:FindFirstChild(PieceName)
        end
    end
    warn("Did not find Asset. Piece might not exist!")
    return nil
end

function BoardService:SetupWorldBoard(InternalBoard, FirstSquareStartingPosition : Vector3)
    local WorldBoard = Instance.new("Folder")
    local Squares = Instance.new("Folder")
    local Pieces = Instance.new("Folder")

    WorldBoard.Name = "Match"
    WorldBoard.Parent = workspace

    Squares.Name = "Squares"
    Squares.Parent = WorldBoard

    Pieces.Name = "Pieces"
    Pieces.Parent = WorldBoard

    -- Iterate through the Match's Internal / Original 2D-Array for the chess board, created through Match Class constructor
    for RankIndex = 1, #InternalBoard, 1 do
        for FileIndex = 1, #InternalBoard[RankIndex], 1 do
            -- Create Board Square
            local CurrentSquare = Instance.new("Part")
            CurrentSquare.Name = tostring(FileIndex) .. tostring(RankIndex)
            CurrentSquare.Anchored = true
            CurrentSquare.Size = BoardConfig.World.SquareSize
            CurrentSquare.Material = BoardConfig.World.Material
        
            -- Create Outline
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
                -- Set position of every square, except a1, which is the guide square
                CurrentSquare.Position = FirstSquareStartingPosition + Vector3.new(CurrentSquare.Size.X * (RankIndex - 1), 0, CurrentSquare.Size.Z * (FileIndex - 1))
            end
            
            -- Determines square color
            if ((RankIndex + FileIndex) % 2 == 1) then
                CurrentSquare.BrickColor = BrickColor.White()
            else
                CurrentSquare.BrickColor = BrickColor.Black()
            end
            
            -- Put square into the game
            CurrentSquare.Parent = Squares
        
            -- Internal Piece (2D Array)
            local CurrentInternalPiece = InternalBoard[RankIndex][FileIndex]
            
            -- Empty square
            if (CurrentInternalPiece == 0) then continue  end
            -- Piece world asset
            local CurrentWorldPiece = self:_findAssetByPieceType(CurrentInternalPiece.Type)
            -- Continue if piece not found
            if (CurrentWorldPiece == nil) then continue end
        
            -- Set piece config
            local CurrentWorldPieceClone = CurrentWorldPiece:Clone()
            CurrentWorldPieceClone.CFrame = CurrentSquare.CFrame + Vector3.new(0, CurrentWorldPieceClone.Size.Y / 2, 0)
            CurrentWorldPieceClone.Name = tostring(FileIndex) .. tostring(RankIndex)
            CurrentWorldPieceClone.Anchored = true

            -- Set piece color accordingly
            if (CurrentInternalPiece.Color == "b") then
                CurrentWorldPieceClone.BrickColor = BrickColor.Black()
            else
                CurrentWorldPieceClone.BrickColor = BrickColor.White()
            end

            -- Put piece into the game
            CurrentWorldPieceClone.Parent = Pieces
        end
    end
end



return BoardService
