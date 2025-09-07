-- Script Underground Panel para Roblox
-- Este script crea un panel con opción Underground que te hace invisible bajo el mapa

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Variables para el estado underground
local isUnderground = false
local originalPosition = Vector3.new(0, 0, 0)
local undergroundConnection = nil
local originalParts = {}
local fakeParts = {}

-- Crear el GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "UndergroundPanel"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Frame principal del panel
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0, 50, 0, 50)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas para el frame principal
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Panel Underground"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

-- Esquinas redondeadas para el título
local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón Underground
local undergroundButton = Instance.new("TextButton")
undergroundButton.Name = "UndergroundButton"
undergroundButton.Size = UDim2.new(0.8, 0, 0, 50)
undergroundButton.Position = UDim2.new(0.1, 0, 0.4, 0)
undergroundButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
undergroundButton.BorderSizePixel = 0
undergroundButton.Text = "Underground: OFF"
undergroundButton.TextColor3 = Color3.fromRGB(255, 255, 255)
undergroundButton.TextScaled = true
undergroundButton.Font = Enum.Font.Gotham
undergroundButton.Parent = mainFrame

-- Esquinas redondeadas para el botón
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = undergroundButton

-- Indicador de estado
local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "Status"
statusLabel.Size = UDim2.new(0.8, 0, 0, 25)
statusLabel.Position = UDim2.new(0.1, 0, 0.75, 0)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Estado: Desactivado"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = mainFrame

-- Función para activar/desactivar underground
local function toggleUnderground()
    if not isUnderground then
        -- Activar underground - Método invisible sin mover el personaje
        isUnderground = true
        
        -- Hacer todas las partes completamente transparentes para otros jugadores
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                originalParts[part] = part.Transparency
                part.Transparency = 1 -- Completamente invisible
                
                -- Desactivar colisiones para que no puedan tocarte
                if part ~= humanoidRootPart then
                    part.CanCollide = false
                end
            end
        end
        
        -- Hacer invisible accesorios también
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle then
                    originalParts[handle] = handle.Transparency
                    handle.Transparency = 1
                    handle.CanCollide = false
                end
            end
        end
        
        -- Crear conexión para mantener invisibilidad
        undergroundConnection = RunService.Heartbeat:Connect(function()
            if character and character.Parent then
                -- Mantener invisibilidad constante
                for _, part in pairs(character:GetChildren()) do
                    if part:IsA("BasePart") then
                        part.Transparency = 1
                        if part ~= humanoidRootPart then
                            part.CanCollide = false
                        end
                    end
                end
                
                -- Mantener accesorios invisibles
                for _, accessory in pairs(character:GetChildren()) do
                    if accessory:IsA("Accessory") then
                        local handle = accessory:FindFirstChild("Handle")
                        if handle then
                            handle.Transparency = 1
                            handle.CanCollide = false
                        end
                    end
                end
            end
        end)
        
        -- Actualizar UI
        undergroundButton.Text = "Underground: ON"
        undergroundButton.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        statusLabel.Text = "Estado: Activado - Completamente invisible"
        statusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        
        -- Efecto de activación
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local tween = TweenService:Create(undergroundButton, tweenInfo, {Size = UDim2.new(0.85, 0, 0, 55)})
        tween:Play()
        tween.Completed:Connect(function()
            local tween2 = TweenService:Create(undergroundButton, tweenInfo, {Size = UDim2.new(0.8, 0, 0, 50)})
            tween2:Play()
        end)
        
    else
        -- Desactivar underground
        isUnderground = false
        
        if undergroundConnection then
            undergroundConnection:Disconnect()
            undergroundConnection = nil
        end
        
        -- Restaurar transparencias originales
        for part, originalTransparency in pairs(originalParts) do
            if part and part.Parent then
                part.Transparency = originalTransparency
                part.CanCollide = true
            end
        end
        originalParts = {}
        
        -- Restaurar visibilidad completa
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
                part.CanCollide = true
            end
        end
        
        -- Restaurar accesorios
        for _, accessory in pairs(character:GetChildren()) do
            if accessory:IsA("Accessory") then
                local handle = accessory:FindFirstChild("Handle")
                if handle then
                    handle.Transparency = 0
                    handle.CanCollide = true
                end
            end
        end
        
        -- Actualizar UI
        undergroundButton.Text = "Underground: OFF"
        undergroundButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        statusLabel.Text = "Estado: Desactivado"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Conectar el botón
undergroundButton.MouseButton1Click:Connect(toggleUnderground)

-- Efectos hover para el botón
undergroundButton.MouseEnter:Connect(function()
    if not isUnderground then
        undergroundButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end)

undergroundButton.MouseLeave:Connect(function()
    if not isUnderground then
        undergroundButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end)

-- Función para manejar cuando el personaje reaparece
local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Si estaba underground, desactivarlo temporalmente
    if isUnderground then
        isUnderground = false
        if undergroundConnection then
            undergroundConnection:Disconnect()
            undergroundConnection = nil
        end
        undergroundButton.Text = "Underground: OFF"
        undergroundButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        statusLabel.Text = "Estado: Desactivado - Personaje reiniciado"
        statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

-- Conectar evento de personaje añadido
player.CharacterAdded:Connect(onCharacterAdded)

-- Tecla de acceso rápido (F para toggle)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        toggleUnderground()
    end
end)

-- Mensaje de inicio
print("Panel Underground cargado correctamente!")
print("Presiona F o usa el botón para activar/desactivar Underground")
print("Método seguro para Steal a Brainrot - Sin autokill!")
print("Te vuelves completamente invisible sin cambiar tu posición")
