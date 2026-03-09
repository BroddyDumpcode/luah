local fly = {}

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

-- Variables
local control = {f=0,b=0,l=0,r=0,u=0,d=0}
local flying = false
local speed = 40
local bv, bg
local flyConnection
fly.flyDragging = false -- flag di-update dari GUI

-- Helper
local function getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function getHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Enable fly
function fly:Enable()
    local hrp = getHRP()
    if not hrp then return end
    flying = true

    -- Body movers
    bv = Instance.new("BodyVelocity")
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    bv.Velocity = Vector3.zero
    bv.Parent = hrp

    bg = Instance.new("BodyGyro")
    bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    bg.CFrame = hrp.CFrame
    bg.Parent = hrp

    -- Fly loop
    flyConnection = RunService.RenderStepped:Connect(function()
        if not flying or fly.flyDragging then return end -- skip saat slider digeser

        local hum = getHumanoid()
        local joystick = hum and hum.MoveDirection or Vector3.zero

        local move = Vector3.new(
            control.l + control.r + joystick.X,
            control.u + control.d,
            control.f + control.b + joystick.Z
        )

        local camCF = cam.CFrame

        bv.Velocity =
            camCF.LookVector * move.Z * speed +
            camCF.RightVector * move.X * speed +
            Vector3.new(0, move.Y * speed, 0)

        bg.CFrame = camCF
    end)
end

-- Disable fly
function fly:Disable()
    flying = false
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    if bv then bv:Destroy() end
    if bg then bg:Destroy() end
end

-- Set speed
function fly:setSpeed(v)
    speed = v
end

-- Movement keys
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then control.f = 1 end
    if input.KeyCode == Enum.KeyCode.S then control.b = -1 end
    if input.KeyCode == Enum.KeyCode.A then control.l = -1 end
    if input.KeyCode == Enum.KeyCode.D then control.r = 1 end
    if input.KeyCode == Enum.KeyCode.Space then control.u = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then control.d = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.W then control.f = 0 end
    if input.KeyCode == Enum.KeyCode.S then control.b = 0 end
    if input.KeyCode == Enum.KeyCode.A then control.l = 0 end
    if input.KeyCode == Enum.KeyCode.D then control.r = 0 end
    if input.KeyCode == Enum.KeyCode.Space then control.u = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then control.d = 0 end
end)

return fly
