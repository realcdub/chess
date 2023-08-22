--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)
local ProfileService = require(ServerStorage.Server.ServerPackages.ProfileService)

local DataService = Knit.CreateService {
    Name = "DataService",
    Client = {},
}

-- ProfileTemplate table is what empty profiles will default to.
-- Updating the template will not include missing template values
--   in existing player profiles!
local ProfileTemplate = {
    Rating = 1000
}

local ChessProfileStore = ProfileService.GetProfileStore(
	"ChessDataTest0",
	ProfileTemplate
)

local Profiles = {} -- [player] = profile

local function _playerAdded(player)
	local profile = ChessProfileStore:LoadProfileAsync("Player_" .. player.UserId)
	if profile ~= nil then
		profile:AddUserId(player.UserId) -- GDPR compliance
		profile:Reconcile() -- Fill in missing variables from ProfileTemplate (optional)
		profile:ListenToRelease(function()
			Profiles[player] = nil
			-- The profile could've been loaded on another Roblox server:
			player:Kick()
		end)
		if player:IsDescendantOf(Players) == true then
			Profiles[player] = profile
			print(profile.Data)
			-- A profile has been successfully loaded:
		else
			-- Player left before the profile loaded:
			profile:Release()
		end
	else
		-- The profile couldn't be loaded possibly due to other
		--   Roblox servers trying to load this profile at the same time:
		player:Kick()
	end
end

function DataService:KnitStart()
    ----- Initialize -----

    -- In case Players have joined the server earlier than this script ran:
    for _, player in ipairs(Players:GetPlayers()) do
        coroutine.wrap(_playerAdded)(player)
    end

    ----- Connections -----

    Players.PlayerAdded:Connect(_playerAdded)

    Players.PlayerRemoving:Connect(function(player)
        local profile = Profiles[player]
        if profile ~= nil then
            profile:Release()
        end
    end)
end

function DataService:UpdateRating(Profile, NewRating : number)
    if (Profile ~= nil) then
        Profile.Rating = NewRating
    end
end

function DataService:GetPlayerProfile(Player : Player)
    local profile = Profiles[Player]
	-- Yields until a Profile linked to a player is loaded or the player leaves
	while profile == nil and Player:IsDescendantOf(Players) == true do
		RunService.Heartbeat:Wait()
		profile = Profiles[Player]
	end
	
	return profile
end

return DataService
