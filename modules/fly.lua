-- (full fix)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

local fly = {}

-- Variables
fly.control = {f=0, b=0, l=0, r=0, u=0, d=0}
fly.flying = false
fly.speed = 40
fly.bv = nil
fly.bg = nil
fly.connection = nil

-- Fly dragging flag (di-update dari GUI)
fly.isSliderDragging = false

-- Get HRP & Humanoid
function fly.getHRP()
    local char = player.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

function fly.getHumanoid()
    local char = player.Character
    return char and char:FindFirstChildOfClass("Humanoid")
end

-- Enable Fly
function fly:Enable()
    local hrp = self.getHRP()
    if not hrp then return end
    self.flying = true

    -- BodyVelocity
    self.bv = Instance.new("BodyVelocity")
    self.bv.MaxForce = Vector3.new(9e9,9e9,9e9)
    self.bv.Velocity = Vector3.zero
    self.bv.Parent = hrp

    -- BodyGyro
    self.bg = Instance.new("BodyGyro")
    self.bg.MaxTorque = Vector3.new(9e9,9e9,9e9)
    self.bg.CFrame = hrp.CFrame
    self.bg.Parent = hrp

    -- RenderStepped movement
    if self.connection then
        self.connection:Disconnect()
    end

    self.connection = RunService.RenderStepped:Connect(function()
        if not self.flying then return end
        -- skip movement jika slider sedang di drag
        if self.isSliderDragging then return end

        local hum = self.getHumanoid()
        local joystick = hum and hum.MoveDirection or Vector3.zero

        local move = Vector3.new(
            self.control.l + self.control.r + joystick.X,
            self.control.u + self.control.d,
            self.control.f + self.control.b + joystick.Z
        )

        local camCF = cam.CFrame

        self.bv.Velocity =
            camCF.LookVector * move.Z * self.speed +
            camCF.RightVector * move.X * self.speed +
            Vector3.new(0, move.Y * self.speed, 0)

        self.bg.CFrame = camCF
    end)
end

-- Disable Fly
function fly:Disable()
    self.flying = false
    if self.connection then
        self.connection:Disconnect()
        self.connection = nil
    end
    if self.bv then
        self.bv:Destroy()
        self.bv = nil
    end
    if self.bg then
        self.bg:Destroy()
        self.bg = nil
    end
end

-- Set fly speed
function fly:setSpeed(value)
    self.speed = value
end

-- UserInput
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then fly.control.f = 1 end
    if input.KeyCode == Enum.KeyCode.S then fly.control.b = -1 end
    if input.KeyCode == Enum.KeyCode.A then fly.control.l = -1 end
    if input.KeyCode == Enum.KeyCode.D then fly.control.r = 1 end
    if input.KeyCode == Enum.KeyCode.Space then fly.control.u = 1 end
    if input.KeyCode == Enum.KeyCode.LeftShift then fly.control.d = -1 end
end)

UserInputService.InputEnded:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.W then fly.control.f = 0 end
    if input.KeyCode == Enum.KeyCode.S then fly.control.b = 0 end
    if input.KeyCode == Enum.KeyCode.A then fly.control.l = 0 end
    if input.KeyCode == Enum.KeyCode.D then fly.control.r = 0 end
    if input.KeyCode == Enum.KeyCode.Space then fly.control.u = 0 end
    if input.KeyCode == Enum.KeyCode.LeftShift then fly.control.d = 0 end
end)

return fly
