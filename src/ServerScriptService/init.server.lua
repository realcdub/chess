--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Utility
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

Knit.AddServices(ServerStorage.Server.Services)

Knit.Start():andThen(function()
    warn("Server Started")
end):catch(warn)