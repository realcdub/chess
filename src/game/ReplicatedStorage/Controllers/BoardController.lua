-- amazingcdub

--// Services
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

--// Knit Services
local BoardService = nil

--// Player Components
local CurrentCamera = workspace.CurrentCamera

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

local function _getGridTarget(x : number, y : number)
    local ClippingRay = CurrentCamera:ScreenPointToRay(x, y, 0)
    local selectRaycastResult : RaycastResult? = workspace:Raycast(ClippingRay.Origin, ClippingRay.Direction * 999)
    if (selectRaycastResult) then
        if (selectRaycastResult.Instance and (selectRaycastResult.Instance.Parent.Name == "Squares")) then
            return selectRaycastResult.Instance :: BasePart
        end
    end
end

function BoardController:RegisterWorldPieceClicks(WorldBoard : Folder)
    local CurrentPiece : BasePart? = nil
    local LegalMoves : {[any] : any}? = nil
    local OriginalSplitPieceName : string? = nil
    local JustMoved = false

    ContextActionService:BindActionAtPriority("SelectSquare", function(_, InputState, Input)
        if (InputState == Enum.UserInputState.Begin) then
            local SelectedSquare = _getGridTarget(Input.Position.X, Input.Position.Y)

            if (CurrentPiece ~= nil) then
                if (SelectedSquare and SelectedSquare.Name ~= CurrentPiece.Name) then
                    for _, LegalMove in ipairs(LegalMoves) do
                        if (SelectedSquare.Name == tostring(LegalMove[1]) .. tostring(LegalMove[2])) then
                            BoardService.MovePiece:Fire(CurrentPiece, SelectedSquare, OriginalSplitPieceName, WorldBoard)
                            self:UnHighlightWorldPieceLegalMoves(WorldBoard)
                            JustMoved = true
                            CurrentPiece = nil
                            break
                        end
                    end
                end
            end

            if (JustMoved == false) then
                if (SelectedSquare and WorldBoard.Pieces:FindFirstChild(SelectedSquare.Name)) then
                    CurrentPiece = WorldBoard.Pieces:FindFirstChild(SelectedSquare.Name)

                    OriginalSplitPieceName = SelectedSquare.Name:split("")

                    local WorldSquareFileIndex = tonumber(OriginalSplitPieceName[1])
                    local WorldSquareRankIndex = tonumber(OriginalSplitPieceName[2])

                    BoardService:GetLegalMoves(WorldSquareFileIndex, WorldSquareRankIndex):andThen(function(PossibleMoves)
                        LegalMoves = PossibleMoves
                        self:HighlightWorldPieceLegalMoves(WorldBoard, SelectedSquare, PossibleMoves)
                    end):catch(warn)
                end
            end

            JustMoved = false
        end

    end, false, 1, Enum.UserInputType.MouseButton1)
end

function BoardController:HighlightUILegalMoves()
end


function BoardController:HighlightWorldPieceLegalMoves(WorldBoard : Folder, CurrentSquare : BasePart, LegalMoves : {[any] : any})
    self:UnHighlightWorldPieceLegalMoves(WorldBoard)

    local Squares = WorldBoard.Squares
    CurrentSquare.Color = Color3.fromHex("#3aa573")
    CurrentSquare.Material = Enum.Material.SmoothPlastic

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
            -- Current square in iteration
            CurrentSquare = Squares[tostring(FileIndex)..tostring(RankIndex)]

            -- If square is black or white, move on to the next iteration
            if (CurrentSquare.BrickColor == BrickColor.White() or CurrentSquare.BrickColor == BrickColor.Black()) then continue end

            -- Set square colorss
            if ((RankIndex + FileIndex) % 2 == 1) then
                CurrentSquare.BrickColor = BrickColor.White()
                CurrentSquare.Material = Enum.Material.SmoothPlastic
            else
                CurrentSquare.BrickColor = BrickColor.Black()
                CurrentSquare.Material = Enum.Material.SmoothPlastic
            end
        end
    end
end

return BoardController
