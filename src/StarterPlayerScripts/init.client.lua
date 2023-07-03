-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

for _, Controller in pairs(ReplicatedStorage.Shared.Controllers:GetDescendants()) do
    if (Controller.Name:match("Controller$")) then
        print(Controller.Name .. " Loaded")
        require(Controller)
    end
end

Knit.Start():andThen(function()
    warn("Client Started")
end):catch(warn)