--// Services
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--// Packages
local Knit = require(ReplicatedStorage.Shared.Packages.Knit)

--// Player Components
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

--// Variables
local CurrentCamera = workspace.CurrentCamera

local InviteController = Knit.CreateController { Name = "InviteController" }

local Highlight = script.Highlight
local HighlightedCharacter = nil

local function _determineIfDescendantOfCharacter(Part)
    if (Part.Parent == workspace) then return false end
    if not (Part.Parent:FindFirstChild("Humanoid")) then
        _determineIfDescendantOfCharacter(Part.Parent)
    end
    return true
end

local function _recursivelyFindCharacter(Part)
    if not (Part.Parent:FindFirstChild("Humanoid")) then
        _recursivelyFindCharacter(Part.Parent)
    end
    return Part.Parent
end

local function _highlightHoveringCharacter()
    local MousePosition = UserInputService:GetMouseLocation()
    -- Raycast toward mouse position
    local ClippingRaycast = CurrentCamera:ViewportPointToRay(MousePosition.X, MousePosition.Y)

    local RaycastParameters = RaycastParams.new()
    RaycastParameters.FilterType = Enum.RaycastFilterType.Exclude
    -- Filter out the character and towers position being updated by mouse
    RaycastParameters.FilterDescendantsInstances = {Character:GetDescendants()}

    local RaycastResult = workspace:Raycast(ClippingRaycast.Origin, ClippingRaycast.Direction * 1000, RaycastParameters)

    if (RaycastResult) then
        local HighlightedObject = RaycastResult.Instance
        if (_determineIfDescendantOfCharacter(HighlightedObject)) then
            HighlightedObject = _recursivelyFindCharacter(HighlightedObject)
            if (HighlightedObject) then
                if (HighlightedObject.Parent:FindFirstChild("Highlight")) then return end
                Highlight.Parent = HighlightedObject.Parent
                HighlightedCharacter = HighlightedObject.Parent
            end
        else
            if (HighlightedCharacter) then
                Highlight = HighlightedCharacter:FindFirstChild("Highlight")
                Highlight.Parent = script
                HighlightedCharacter = nil
            end
        end
    end
end

function InviteController:KnitStart()
    local updateHighlightedCharacterConnection : RBXScriptConnection? = nil; updateHighlightedCharacterConnection = RunService.RenderStepped:Connect(function(_)
        _highlightHoveringCharacter()
    end)

    ContextActionService:BindActionAtPriority("ClickCharacter", function(actionName, inputState, inputObject)
        if (inputState == Enum.UserInputState.Begin) then
            if (HighlightedCharacter) then
                if (Players:GetPlayerFromCharacter(HighlightedCharacter)) then 
                    print(Players:GetPlayerFromCharacter(HighlightedCharacter).Name)
                else
                    print(HighlightedCharacter.Name)
                end
            end
        end
    end, false, 1, Enum.UserInputType.MouseButton1)
end

function InviteController:KnitInit()
    
end


return InviteController
