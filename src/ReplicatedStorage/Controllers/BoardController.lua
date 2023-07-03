-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packacges
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

--// Knit Services
local BoardService = nil

local BoardController = Knit.CreateController {
    Name = "BoardController" 
}

function BoardController:KnitStart()
    print(self.Name .. " Started")
    BoardService = Knit.GetService("BoardService")
    self:RegisterWorldPieceClicks(workspace:WaitForChild("Match"))
end

function BoardController:KnitInit()
    print(self.Name .. " Initialized")
end

function BoardController:RegisterWorldPieceClicks(WorldBoard)
    for _, Piece : BasePart in ipairs(WorldBoard.Pieces:GetChildren()) do
        local ClickDetector : ClickDetector = Piece:FindFirstChild("ClickDetector")

        ClickDetector.MouseClick:Connect(function(_)
            self:UnHighlightWorldPieceLegalMoves(WorldBoard)

            local SplitWorldName = Piece.Name:split("")

            local WorldPieceFileIndex = tonumber(SplitWorldName[1])
            local WorldPieceRankIndex = tonumber(SplitWorldName[2])

            BoardService:GetLegalMoves(WorldPieceFileIndex, WorldPieceRankIndex):andThen(function(PossibleMoves)
                local LegalMoves = PossibleMoves
                self:HighlightWorldPieceLegalMoves(WorldBoard, LegalMoves)
            end):catch(warn)
        end)
    end
end

function BoardController:HighlightUILegalMoves()
end

function BoardController:HighlightWorldPieceLegalMoves(WorldBoard : Folder, LegalMoves)
    local Squares = WorldBoard.Squares
    --warn(LegalMoves)
    for _, LegalMove in ipairs(LegalMoves) do
        local LegalSquare = Squares:FindFirstChild(tostring(LegalMove[1]) .. tostring(LegalMove[2]))
        LegalSquare.Color = Color3.fromHex("#3aa573")
        LegalSquare.Material = Enum.Material.Neon
    end
end

function BoardController:UnHighlightWorldPieceLegalMoves(WorldBoard : Folder)
    local Squares = WorldBoard.Squares
    local CurrentSquare = nil :: BasePart
    for RankIndex = 1, 8 do
        for FileIndex = 1, 8 do
            if ((RankIndex + FileIndex) % 2 == 1) then
                CurrentSquare = Squares[tostring(FileIndex)..tostring(RankIndex)]
                CurrentSquare.BrickColor = BrickColor.White()
                CurrentSquare.Material = Enum.Material.SmoothPlastic
            else
                CurrentSquare = Squares[tostring(FileIndex)..tostring(RankIndex)]
                CurrentSquare.BrickColor = BrickColor.Black()
                CurrentSquare.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end

return BoardController
