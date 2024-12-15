local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Target = nil
local isCamLocked = false

UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.C then 
        isCamLocked = not isCamLocked
        if isCamLocked then
            -- Find nearest player to cursor
            local closestPlayer = nil
            local closestDistance = math.huge
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    local playerRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                    if playerRootPart then
                        local screenPoint, onScreen = Camera:WorldToScreenPoint(playerRootPart.Position)
                        local mousePos = UserInputService:GetMouseLocation()
                        local distance = (Vector2.new(screenPoint.X, screenPoint.Y) - mousePos).Magnitude
                        if distance < closestDistance and onScreen then
                            closestPlayer = player
                            closestDistance = distance
                        end
                    end
                end
            end
            Target = closestPlayer and closestPlayer.Character:FindFirstChild("HumanoidRootPart")
        end
    end
end)

RunService.RenderStepped:Connect(function()
    if isCamLocked and Target then
        Camera.CFrame = CFrame.new(Camera.CFrame.Position, Target.Position)
    end
end)