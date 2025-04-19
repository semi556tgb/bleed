-- features.lua

local Features = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Mouse = LocalPlayer:GetMouse()

local Aimbot = {
    Active = false,
    LockedTarget = nil,
    Smoothing = 0.15,
    FOV = 300,
    Highlight = Instance.new("Highlight")
}
Aimbot.Highlight.FillColor = Color3.fromRGB(255, 0, 0)
Aimbot.Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
Aimbot.Highlight.FillTransparency = 0.5
Aimbot.Highlight.OutlineTransparency = 0
Aimbot.Highlight.Parent = game:GetService("CoreGui")

function Features.GetClosestPlayer()
    local closest = nil
    local shortestDistance = Aimbot.FOV
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local pos = player.Character.HumanoidRootPart.Position
                local screenPos, onScreen = workspace.CurrentCamera:WorldToViewportPoint(pos)
                if onScreen then
                    local distance = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
                    if distance < shortestDistance then
                        closest = player
                        shortestDistance = distance
                    end
                end
            end
        end
    end
    return closest
end

function Features.RunAimbot(flags)
    RunService.Heartbeat:Connect(function()
        Aimbot.Active = (flags.Aimbot_Toggle and flags.Aimbot_Keybind) or (flags.BlatantAimbot_Toggle and flags.BlatantAimbot_Keybind)
    end)

    RunService.Stepped:Connect(function()
        if Aimbot.Active then
            if not Aimbot.LockedTarget or not Aimbot.LockedTarget.Character or not Aimbot.LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
                Aimbot.LockedTarget = Features.GetClosestPlayer()
            end

            if Aimbot.LockedTarget and Aimbot.LockedTarget.Character and Aimbot.LockedTarget.Character:FindFirstChild("HumanoidRootPart") then
                local aimPart = Aimbot.LockedTarget.Character.HumanoidRootPart.Position
                if flags.Prediction_Toggle then
                    local velocity = Aimbot.LockedTarget.Character.HumanoidRootPart.Velocity * flags.Prediction_Amount
                    aimPart = aimPart + velocity
                end

                local camera = workspace.CurrentCamera
                local direction = (aimPart - camera.CFrame.Position).Unit
                local smoothing = (flags.BlatantAimbot_Toggle and flags.BlatantAimbot_Keybind) and 1 or Aimbot.Smoothing
                local newCFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)
                camera.CFrame = camera.CFrame:Lerp(newCFrame, smoothing)
                Aimbot.Highlight.Adornee = Aimbot.LockedTarget.Character
            else
                Aimbot.Highlight.Adornee = nil
            end
        else
            Aimbot.LockedTarget = nil
            Aimbot.Highlight.Adornee = nil
        end
    end)
end

function Features.RunRapidFire(flags)
    local RapidFireLoop = nil

    RunService.Heartbeat:Connect(function()
        if flags.RapidFire_Toggle and not RapidFireLoop then
            RapidFireLoop = coroutine.create(function()
                while flags.RapidFire_Toggle do
                    local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                    if tool and tool:FindFirstChild("Activate") then
                        tool:Activate()
                    end
                    task.wait(flags.RapidFire_Delay)
                end
                RapidFireLoop = nil
            end)
            coroutine.resume(RapidFireLoop)
        end
    end)
end

return Features
