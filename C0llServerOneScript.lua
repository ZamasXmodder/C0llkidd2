-- Script para Steal a Brainrot - Función de Flote Incomún
-- Creado para evitar detección de parches

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local floatEnabled = false
local floatSpeed = 16
local floatConnection = nil
local bodyVelocity = nil

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFloatGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Esquinas redondeadas para el panel
local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Título del panel
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Brainrot Float v2.0"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeButton.BorderSizePixel = 0
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 5)
closeCorner.Parent = closeButton

-- Botón de flote
local floatButton = Instance.new("TextButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(0, 200, 0, 40)
floatButton.Position = UDim2.new(0.5, -100, 0, 50)
floatButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
floatButton.BorderSizePixel = 0
floatButton.Text = "Activar Flote Incomún"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.Gotham
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 8)
floatCorner.Parent = floatButton

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Name = "SpeedLabel"
speedLabel.Size = UDim2.new(1, 0, 0, 25)
speedLabel.Position = UDim2.new(0, 0, 0, 100)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad de Flote: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Slider de velocidad
local speedSlider = Instance.new("Frame")
speedSlider.Name = "SpeedSlider"
speedSlider.Size = UDim2.new(0, 200, 0, 20)
speedSlider.Position = UDim2.new(0.5, -100, 0, 130)
speedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSlider.BorderSizePixel = 0
speedSlider.Parent = mainFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 10)
sliderCorner.Parent = speedSlider

local sliderButton = Instance.new("TextButton")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0, 0, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = speedSlider

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 10)
sliderButtonCorner.Parent = sliderButton

-- Botón para abrir/cerrar panel
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Abrir Panel"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Función de flote incomún (evita detección)
local function createUncommonFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Crear BodyVelocity personalizado para flote incomún
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
    bodyVelocity.Velocity = Vector3.new(0, floatSpeed, 0)
    bodyVelocity.Parent = rootPart
    
    -- Conexión para mantener el flote con variaciones
    floatConnection = RunService.Heartbeat:Connect(function()
        if bodyVelocity and rootPart then
            -- Agregar variaciones aleatorias para evitar detección
            local variation = math.random(-2, 2) * 0.1
            bodyVelocity.Velocity = Vector3.new(0, floatSpeed + variation, 0)
            
            -- Simular física natural
            if humanoid.Health <= 0 then
                stopFloat()
            end
        end
    end)
end

-- Función para detener el flote
local function stopFloat()
    if floatConnection then
        floatConnection:Disconnect()
        floatConnection = nil
    end
    
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
end

-- Función para actualizar la velocidad del slider
local function updateSliderSpeed()
    local sliderPosition = sliderButton.Position.X.Offset
    local maxPosition = speedSlider.AbsoluteSize.X - sliderButton.AbsoluteSize.X
    local percentage = sliderPosition / maxPosition
    
    floatSpeed = math.floor(5 + (percentage * 45)) -- Rango de 5 a 50
    speedLabel.Text = "Velocidad de Flote: " .. floatSpeed
    
    -- Actualizar velocidad si está activo
    if floatEnabled and bodyVelocity then
        bodyVelocity.Velocity = Vector3.new(0, floatSpeed, 0)
    end
end

-- Eventos del slider
local dragging = false

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation()
        local sliderPos = speedSlider.AbsolutePosition
        local newX = mousePos.X - sliderPos.X - (sliderButton.AbsoluteSize.X / 2)
        
        newX = math.clamp(newX, 0, speedSlider.AbsoluteSize.X - sliderButton.AbsoluteSize.X)
        
        sliderButton.Position = UDim2.new(0, newX, 0, 0)
        updateSliderSpeed()
    end
end)

-- Evento del botón de flote
floatButton.MouseButton1Click:Connect(function()
    floatEnabled = not floatEnabled
    
    if floatEnabled then
        createUncommonFloat()
        floatButton.Text = "Desactivar Flote"
        floatButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
    else
        stopFloat()
        floatButton.Text = "Activar Flote Incomún"
        floatButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

-- Evento del botón de cerrar
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Text = "Abrir Panel"
end)

-- Evento del botón toggle
toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    toggleButton.Text = mainFrame.Visible and "Cerrar Panel" or "Abrir Panel"
end)

-- Inicializar slider en posición media
sliderButton.Position = UDim2.new(0, (speedSlider.AbsoluteSize.X - sliderButton.AbsoluteSize.X) / 2, 0, 0)
updateSliderSpeed()

-- Limpiar al respawnear
player.CharacterRemoving:Connect(function()
    stopFloat()
end)

-- Ocultar panel inicialmente
mainFrame.Visible = false

print("Brainrot Float Script cargado exitosamente!")
print("Usa el botón 'Abrir Panel' para acceder a las funciones")
