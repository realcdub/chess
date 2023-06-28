--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Utility
local String = require(ReplicatedStorage.Shared.Packages.String)

--// Classes
local Classes = ServerStorage.Server.Classes
local Pieces = Classes.Pieces
local Piece = require(Pieces.BasePiece)

--// Constants
local START_FEN = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBKR w KQkq - 0"

local function createBoard()
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

function Match.new()
    local self = setmetatable({
        Board = createBoard(),
        White = nil :: Player,
        Black = nil :: Player,
        Turn = nil :: string
    }, Match)

    self:_loadPositionFromFEN(START_FEN)

    return self
end

function Match:_loadPositionFromFEN(FEN : string)
    local rank = 1
    local file = 1

    local sections = FEN:split(" ")

    for character in sections[1]:gmatch(".") do
        if (character == "/") then
            file = 1
            rank += 1
        else
            if (type(tonumber(character)) == "number") then
                file += tonumber(character)
            else
                if (String:IsUpper(character)) then
                    self.Board[rank][file] = Piece.new(string.upper(character), "w")
                elseif (String:IsLower(character)) then
                    self.Board[rank][file] = Piece.new(string.upper(character), "b")
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
   self.Turn = nil
end

return Match
