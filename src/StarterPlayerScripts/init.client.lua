--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Utility
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

Knit.AddControllers(ReplicatedStorage.Shared.Controllers)

Knit.Start():andThen(function()
    warn("Client Started")
end):catch(warn)