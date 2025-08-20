--// Anti-Hit con tecla F (10 segundos)
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

local antiHitActive = false
local bodyVelocity
local connection

local function toggleAntiHit()
    if antiHitActive then return end
    antiHitActive = true
    print("[ANTI-HIT] Activado por 10s")

    -- Crear BodyVelocity para eliminar knockback
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    -- Mantener efecto
    connection = RunService.Heartbeat:Connect(function()
        if antiHitActive and bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)

    -- Desactivar a los 10s
    task.delay(10, function()
        if antiHitActive then
            antiHitActive = false
            if connection then connection:Disconnect() end
            if bodyVelocity then bodyVelocity:Destroy() end
            bodyVelocity = nil
            print("[ANTI-HIT] Desactivado")
        end
    end)
end

-- Input de la tecla F
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.F then
        toggleAntiHit()
    end
end)

-- Reset al respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    antiHitActive = false
    if connection then connection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
end)

print("[SCRIPT CARGADO] Pulsa F para activar Anti-Hit (10s)")
