local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para el sistema de teleporte
local spawnPosition = nil
local isTeleporting = false

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotPanel"
screenGui.Parent = playerGui

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 150)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Esquinas redondeadas
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Brainrot Teleport"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Label de posición guardada
local positionLabel = Instance.new("TextLabel")
positionLabel.Size = UDim2.new(1, -20, 0, 25)
positionLabel.Position = UDim2.new(0, 10, 0, 35)
positionLabel.BackgroundTransparency = 1
positionLabel.Text = "Posición no guardada"
positionLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
positionLabel.TextScaled = true
positionLabel.Font = Enum.Font.Gotham
positionLabel.Parent = mainFrame

-- Botón para guardar posición
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(1, -20, 0, 30)
saveButton.Position = UDim2.new(0, 10, 0, 65)
saveButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
saveButton.Text = "Guardar Posición Actual"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextScaled = true
saveButton.Font = Enum.Font.Gotham
saveButton.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveButton

-- Botón de teleporte
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 105)
teleportButton.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
teleportButton.Text = "TELEPORT A SPAWN"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 4)
teleportCorner.Parent = teleportButton

-- Función para guardar posición inicial automáticamente
local function saveInitialPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Spawn: %.1f, %.1f, %.1f", spawnPosition.X, spawnPosition.Y, spawnPosition.Z)
        print("Posición de spawn guardada:", spawnPosition)
    end
end

-- Función de teleporte agresivo
local function aggressiveTeleport()
    if not spawnPosition or isTeleporting then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    isTeleporting = true
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- Método 1: Teleporte directo
    humanoidRootPart.CFrame = CFrame.new(spawnPosition)
    
    -- Método 2: Teleporte con offset hacia arriba para evitar colisiones
    wait(0.1)
    humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 5, 0))
    
    -- Método 3: Teleporte gradual
    for i = 1, 5 do
        wait(0.05)
        humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 2, 0))
    end
    
    -- Método 4: Resetear velocidad
    if humanoidRootPart:FindFirstChild("BodyVelocity") then
        humanoidRootPart.BodyVelocity:Destroy()
    end
    
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart
    
    wait(0.1)
    bodyVelocity:Destroy()
    
    -- Método 5: Teleporte final con confirmación
    for i = 1, 10 do
        wait(0.02)
        local distance = (humanoidRootPart.Position - spawnPosition).Magnitude
        if distance > 5 then
            humanoidRootPart.CFrame = CFrame.new(spawnPosition)
        else
            break
        end
    end
    
    isTeleporting = false
    print("Teleporte completado!")
end

-- Eventos de los botones
saveButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Guardado: %.1f, %.1f, %.1f", spawnPosition.X, spawnPosition.Y, spawnPosition.Z)
        
        -- Efecto visual
        local originalColor = saveButton.BackgroundColor3
        saveButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        wait(0.2)
        saveButton.BackgroundColor3 = originalColor
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    if spawnPosition then
        aggressiveTeleport()
        
        -- Efecto visual
        local originalColor = teleportButton.BackgroundColor3
        teleportButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        wait(0.3)
        teleportButton.BackgroundColor3 = originalColor
    else
        positionLabel.Text = "¡Primero guarda una posición!"
        wait(2)
        positionLabel.Text = "Posición no guardada"
    end
end)

-- Tecla rápida para teleporte (T)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T and spawnPosition then
        aggressiveTeleport()
    end
end)

-- Guardar posición inicial cuando el personaje aparece
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(1) -- Esperar un poco para asegurar que el spawn esté completo
    saveInitialPosition()
end)

-- Si el personaje ya existe, guardar la posición
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    saveInitialPosition()
end

print("Panel de Brainrot Teleport cargado! Presiona T para teleporte rápido")
