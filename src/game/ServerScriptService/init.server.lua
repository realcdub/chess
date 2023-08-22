-- amazingcdub

--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

for _, Service in pairs(ServerStorage.Server.Services:GetDescendants()) do
    if (Service.Name:match("Service$")) then
        print(Service.Name .. " Loaded")
        require(Service)
    end
end

Knit.Start():andThen(function()
    warn("Server Started")
end):catch(warn)