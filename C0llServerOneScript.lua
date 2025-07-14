-- Panel Simple para Steal a Brainrot - Speed & Jump

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotHacks"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 250, 0, 160)
mainFrame.Position = UDim2.new(0, 20, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "🧠 BRAINROT HACKS 🧠"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de Speed
local speedButton = Instance.new("TextButton")
speedButton.Name = "SpeedButton"
speedButton.Size = UDim2.new(0.85, 0, 0, 35)
speedButton.Position = UDim2.new(0.075, 0, 0.3, 0)
speedButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
speedButton.BorderSizePixel = 0
speedButton.Text = "🏃 SPEED: OFF"
speedButton.TextColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextScaled = true
speedButton.Font = Enum.Font.GothamBold
speedButton.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 6)
speedCorner.Parent = speedButton

-- Botón de Jump
local jumpButton = Instance.new("TextButton")
jumpButton.Name = "JumpButton"
jumpButton.Size = UDim2.new(0.85, 0, 0, 35)
jumpButton.Position = UDim2.new(0.075, 0, 0.6, 0)
jumpButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
jumpButton.BorderSizePixel = 0
jumpButton.Text = "🦘 JUMP: OFF"
jumpButton.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpButton.TextScaled = true
jumpButton.Font = Enum.Font.GothamBold
jumpButton.Parent = mainFrame

local jumpCorner = Instance.new("UICorner")
jumpCorner.CornerRadius = UDim.new(0, 6)
jumpCorner.Parent = jumpButton

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 80, 80)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 12)
closeCorner.Parent = closeButton

-- Variables de estado
local speedEnabled = false
local jumpEnabled = false
local originalWalkSpeed = 16
local originalJumpPower = 50

-- Función para obtener el humanoid
local function getHumanoid()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        return player.Character.Humanoid
    end
    return nil
end

-- Función de Speed
local function toggleSpeed()
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    speedEnabled = not speedEnabled
    
    if speedEnabled then
        originalWalkSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = 100 -- Velocidad rápida
        speedButton.Text = "🏃 SPEED: ON"
        speedButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    else
        humanoid.WalkSpeed = originalWalkSpeed
        speedButton.Text = "🏃 SPEED: OFF"
        speedButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    end
end

-- Función de Jump
local function toggleJump()
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    jumpEnabled = not jumpEnabled
    
    if jumpEnabled then
        originalJumpPower = humanoid.JumpPower
        humanoid.JumpPower = 120 -- Salto alto
        jumpButton.Text = "🦘 JUMP: ON"
        jumpButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    else
        humanoid.JumpPower = originalJumpPower
        jumpButton.Text = "🦘 JUMP: OFF"
        jumpButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
    end
end

-- Función para hacer el panel arrastrable
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = position
end

titleLabel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleLabel.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        if dragging then
            updateInput(input)
        end
    end
end)

-- Conectar eventos de los botones
speedButton.MouseButton1Click:Connect(toggleSpeed)
jumpButton.MouseButton1Click:Connect(toggleJump)
closeButton.MouseButton1Click:Connect(function()
    -- Restaurar valores originales antes de cerrar
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = originalWalkSpeed
        humanoid.JumpPower = originalJumpPower
    end
    screenGui:Destroy()
end)

-- Efectos hover
speedButton.MouseEnter:Connect(function()
    if not speedEnabled then
        speedButton.BackgroundColor3 = Color3.fromRGB(120, 170, 255)
    end
end)

speedButton.MouseLeave:Connect(function()
    if not speedEnabled then
        speedButton.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
    end
end)

jumpButton.MouseEnter:Connect(function()
    if not jumpEnabled then
        jumpButton.BackgroundColor3 = Color3.fromRGB(255, 170, 120)
    end
end)

jumpButton.MouseLeave:Connect(function()
    if not jumpEnabled then
        jumpButton.BackgroundColor3 = Color3.fromRGB(255, 150, 100)
    end
end)

-- Mantener los hacks activos cuando el personaje respawnea
player.CharacterAdded:Connect(function(character)
    wait(1) -- Esperar a que el personaje se cargue completamente
    
    if speedEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.WalkSpeed = 100
    end
    
    if jumpEnabled then
        local humanoid = character:WaitForChild("Humanoid")
        humanoid.JumpPower = 120
    end
end)

-- Animación de entrada
mainFrame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(
    mainFrame,
    TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    {Size = UDim2.new(0, 250, 0, 160)}
)
openTween:Play()

print("🧠 Brainrot Hacks Panel loaded! 🧠")
