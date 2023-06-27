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
local START_FEN = "rnbqkbnr/ppppppp1p/8/8/8/8/PPPPPPPP/RNBQKBKR w KQkq - 0"

local function isUpper(character : string) : boolean
    if (string.lower(character) ~= character) then return true end
    return false
end

local function isLower(character : string) : boolean
    if (string.upper(character) ~= character) then return true end
    return false
end

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
                    self.Board[rank][file] = character
                elseif (String:IsLower(character)) then
                    self.Board[rank][file] = character
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

return Match.new()
