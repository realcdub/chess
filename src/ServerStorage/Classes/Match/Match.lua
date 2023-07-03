-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Packages
local String = require(ReplicatedStorage.Shared.Packages.String)

--// Classes
local Classes = ServerStorage.Server.Classes
local Pieces = Classes.Pieces
local Pawn = require(Pieces.Pawn)
local Bishop = require(Pieces.Bishop)
local Knight = require(Pieces.Knight)
local Rook = require(Pieces.Rook)
local Queen = require(Pieces.Queen)
local King = require(Pieces.King)

--// Constants
--local START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0"
--local START_FEN = "nNnnkNNN/NnNNnnnN/NnnnnNNN/nnNnnnnN/NnnnnnNN/NnNNNNnn/NNNNNnNN/NNNnKnnn w - - 0 1"
local START_FEN = "r1b1k2r/pppp1ppp/2n2q1n/2b1p3/2B1P3/2NP1Q2/PPP1NPPP/R1B1K2R w KQkq - 0 1"

local function _createBoard()
    local board = {}
    for i = 1, 8 do
        board[i] = {}
        for j = 1, 8 do
            board[i][j] = 0
        end
    end
    return board
end

local Match = {}
Match.__index = Match

function Match.new(Opponent : Player)
    local self = setmetatable({
        Board = _createBoard(),
        White = Opponent,
        Black = nil :: Player,
    }, Match)

    self:_loadPositionFromFEN(START_FEN)

    return self
end

function Match:_loadPositionFromFEN(FEN : string)
    local rank = 8
    local file = 1

    local sections = FEN:split(" ")

    for character in sections[1]:gmatch(".") do
        -- Check for new rank
        if (character == "/") then
            file = 1
            rank -= 1
        else
            -- Check if there are spaces on board
            if (type(tonumber(character)) == "number") then
                file += tonumber(character)
            else
                -- Check if piece is white
                if (String:IsUpper(character)) then
                    if (character == "P") then
                        self.Board[rank][file] = Pawn.new("w", file, rank)
                    elseif (character == "B") then
                        self.Board[rank][file] = Bishop.new("w", file, rank)
                    elseif (character == "N") then
                        self.Board[rank][file] = Knight.new("w", file, rank)
                    elseif (character == "R") then
                        self.Board[rank][file] = Rook.new("w", file, rank)
                    elseif (character == "Q") then
                        self.Board[rank][file] = Queen.new("w", file, rank)
                    elseif (character == "K") then
                       self.Board[rank][file] = King.new("w", file, rank)
                    end
                -- Check if piece is black
                elseif (String:IsLower(character)) then
                    if (character == "p") then
                        self.Board[rank][file] = Pawn.new("b", file, rank)
                    elseif (character == "b") then
                        self.Board[rank][file] = Bishop.new("b", file, rank)
                    elseif (character == "n") then
                        self.Board[rank][file] = Knight.new("b", file, rank)
                    elseif (character == "r") then
                        self.Board[rank][file] = Rook.new("b", file, rank)
                    elseif (character == "q") then
                        self.Board[rank][file] = Queen.new("b", file, rank)
                    elseif (character == "k") then
                        self.Board[rank][file] = King.new("b", file, rank)
                    end
                end
                file += 1
            end
        end
    end
end

function Match:Destroy()
   table.clear(self.Board)
   self.White = nil
   self.Black = nil
end

return Match
