local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables para el sistema de teleporte
local spawnPosition = nil
local isTeleporting = false
local teleportConnection = nil
local forceConnection = nil

-- Crear la GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotPanel"
screenGui.Parent = playerGui

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 280, 0, 180)
mainFrame.Position = UDim2.new(0, 10, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
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
titleLabel.Text = "🔥 FORCE TELEPORT 🔥"
titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
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

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 20)
statusLabel.Position = UDim2.new(0, 10, 0, 60)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Inactivo"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Botón para guardar posición
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(1, -20, 0, 25)
saveButton.Position = UDim2.new(0, 10, 0, 85)
saveButton.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
saveButton.Text = "Guardar Posición"
saveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
saveButton.TextScaled = true
saveButton.Font = Enum.Font.Gotham
saveButton.Parent = mainFrame

local saveCorner = Instance.new("UICorner")
saveCorner.CornerRadius = UDim.new(0, 4)
saveCorner.Parent = saveButton

-- Botón de teleporte MEGA FORZADO
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(1, -20, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 115)
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
teleportButton.Text = "🚀 FORCE TELEPORT 🚀"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 4)
teleportCorner.Parent = teleportButton

-- Botón de parar teleporte
local stopButton = Instance.new("TextButton")
stopButton.Size = UDim2.new(1, -20, 0, 25)
stopButton.Position = UDim2.new(0, 10, 0, 150)
stopButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
stopButton.Text = "PARAR"
stopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stopButton.TextScaled = true
stopButton.Font = Enum.Font.Gotham
stopButton.Parent = mainFrame

local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 4)
stopCorner.Parent = stopButton

-- Función para guardar posición inicial automáticamente
local function saveInitialPosition()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Spawn: %.1f, %.1f, %.1f", spawnPosition.X, spawnPosition.Y, spawnPosition.Z)
        print("Posición de spawn guardada:", spawnPosition)
    end
end

-- Función para parar el teleporte forzado
local function stopForceTeleport()
    isTeleporting = false
    if teleportConnection then
        teleportConnection:Disconnect()
        teleportConnection = nil
    end
    if forceConnection then
        forceConnection:Disconnect()
        forceConnection = nil
    end
    statusLabel.Text = "Estado: Parado"
    statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    teleportButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
end

-- FUNCIÓN DE TELEPORTE MEGA AGRESIVO Y PERSISTENTE
local function ultraAggressiveTeleport()
    if not spawnPosition then 
        statusLabel.Text = "¡No hay posición guardada!"
        return 
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return end
    
    isTeleporting = true
    statusLabel.Text = "Estado: FORZANDO TELEPORTE"
    statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    teleportButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
    
    local humanoidRootPart = character.HumanoidRootPart
    local humanoid = character:FindFirstChild("Humanoid")
    
    -- FASE 1: Preparación anti-detección
    if humanoid then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
    
    -- Eliminar cualquier BodyMover existente
    for _, obj in pairs(humanoidRootPart:GetChildren()) do
        if obj:IsA("BodyPosition") or obj:IsA("BodyVelocity") or obj:IsA("BodyAngularVelocity") then
            obj:Destroy()
        end
    end
    
    -- FASE 2: Teleporte inicial múltiple
    for i = 1, 3 do
        humanoidRootPart.CFrame = CFrame.new(spawnPosition + Vector3.new(0, 5, 0))
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AngularVelocity = Vector3.new(0, 0, 0)
        wait(0.03)
    end
    
    -- FASE 3: Crear BodyPosition para mantener posición
    local bodyPosition = Instance.new("BodyPosition")
    bodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyPosition.Position = spawnPosition
    bodyPosition.D = 5000
    bodyPosition.P = 10000
    bodyPosition.Parent = humanoidRootPart
    
    -- FASE 4: Monitoreo constante y re-teleporte agresivo
    teleportConnection = RunService.Heartbeat:Connect(function()
        if not isTeleporting then return end
        
        local currentPos = humanoidRootPart.Position
        local distance = (currentPos - spawnPosition).Magnitude
        
        -- Si nos alejan más de 3 studs, FORZAR de vuelta
        if distance > 3 then
            humanoidRootPart.CFrame = CFrame.new(spawnPosition)
            humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            
            -- Actualizar BodyPosition
            if bodyPosition and bodyPosition.Parent then
                bodyPosition.Position = spawnPosition
            end
        end
    end)
    
    -- FASE 5: Fuerza adicional cada frame
    forceConnection = RunService.RenderStepped:Connect(function()
        if not isTeleporting then return end
        
        -- Resetear velocidad constantemente
        humanoidRootPart.Velocity = Vector3.new(0, 0, 0)
        humanoidRootPart.AngularVelocity = Vector3.new(0, 0, 0)
        
        -- Mantener estado de física
        if humanoid and humanoid.PlatformStand == false then
            humanoid.PlatformStand = true
        end
        
        -- Re-crear BodyPosition si se destruye
        if not humanoidRootPart:FindFirstChild("BodyPosition") then
            local newBodyPosition = Instance.new("BodyPosition")
            newBodyPosition.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            newBodyPosition.Position = spawnPosition
            newBodyPosition.D = 5000
            newBodyPosition.P = 10000
            newBodyPosition.Parent = humanoidRootPart
        end
    end)
    
    print("TELEPORTE ULTRA AGRESIVO ACTIVADO!")
end

-- Eventos de los botones
saveButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        spawnPosition = character.HumanoidRootPart.Position
        positionLabel.Text = string.format("Guardado: %.1f, %.1f, %.1f", spawnPosition.X, spawnPosition.Y, spawnPosition.Z)
        
        -- Efecto visual
        local originalColor = saveButton.BackgroundColor3
        saveButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wait(0.2)
        saveButton.BackgroundColor3 = originalColor
    end
end)

teleportButton.MouseButton1Click:Connect(function()
    if not isTeleporting then
        ultraAggressiveTeleport()
    end
end)

stopButton.MouseButton1Click:Connect(function()
    stopForceTeleport()
end)

-- Tecla rápida para teleporte (T) y parar (G)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.T and spawnPosition and not isTeleporting then
        ultraAggressiveTeleport()
    elseif input.KeyCode == Enum.KeyCode.G then
        stopForceTeleport()
    end
end)

-- Limpiar al morir
player.CharacterRemoving:Connect(function()
    stopForceTeleport()
end)

-- Guardar posición inicial cuando el personaje aparece
player.CharacterAdded:Connect(function(character)
    character:WaitForChild("HumanoidRootPart")
    wait(1)
    saveInitialPosition()
    stopForceTeleport() -- Parar cualquier teleporte anterior
end)

-- Si el personaje ya existe, guardar la posición
if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
    saveInitialPosition()
end

print("🔥 FORCE TELEPORT CARGADO! 🔥")
print("T = Activar teleporte forzado")
print("G = Parar teleporte")
