--// GUI con botón Anti-Hit (10s)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Variables
local antiHitActive = false
local bodyVelocity
local connection

-- Crear GUI
local gui = Instance.new("ScreenGui")
pcall(function() gui.Parent = game:GetService("CoreGui") end)
if not gui.Parent then
    gui.Parent = player:WaitForChild("PlayerGui")
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 180, 0, 80)
frame.Position = UDim2.new(0.5, -90, 0.8, 0)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -20, 0, 40)
button.Position = UDim2.new(0, 10, 0.5, -20)
button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
button.TextColor3 = Color3.fromRGB(255, 255, 255)
button.Font = Enum.Font.GothamBold
button.TextSize = 18
button.Text = "Activar Anti-Hit"
button.Parent = frame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = button

-- Función Anti-Hit
local function activateAntiHit()
    if antiHitActive then return end
    antiHitActive = true
    button.Text = "Anti-Hit ON"

    -- Crear BodyVelocity para anular knockback
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart

    -- Mantener estado
    connection = RunService.Heartbeat:Connect(function()
        if antiHitActive and bodyVelocity then
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        end
    end)

    -- Apagar a los 10s
    task.delay(10, function()
        if antiHitActive then
            antiHitActive = false
            button.Text = "Activar Anti-Hit"
            if connection then connection:Disconnect() end
            if bodyVelocity then bodyVelocity:Destroy() end
            bodyVelocity = nil
        end
    end)
end

-- Conexión del botón
button.MouseButton1Click:Connect(activateAntiHit)

-- Reset al respawn
player.CharacterAdded:Connect(function(newChar)
    character = newChar
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    antiHitActive = false
    if connection then connection:Disconnect() end
    if bodyVelocity then bodyVelocity:Destroy() end
    button.Text = "Activar Anti-Hit"
end)

print("[SCRIPT CARGADO] Usa el botón en pantalla para activar Anti-Hit (10s)")
