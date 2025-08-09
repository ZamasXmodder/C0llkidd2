-- Script para Steal a Brainrot - Flote Manual Controlable
-- Control con teclas (PC) y joystick virtual (móvil)

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
local currentDirection = Vector3.new(0, 0, 0)

-- Detectar plataforma
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BrainrotFloatGUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Panel principal
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainPanel"
mainFrame.Size = UDim2.new(0, 320, 0, isMobile and 280 or 220)
mainFrame.Position = UDim2.new(0.5, -160, 0.5, isMobile and -140 or -110)
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
titleLabel.Text = "Brainrot Float Manual v2.0"
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
floatButton.Position = UDim2.new(0.5, -100, 0, 40)
floatButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
floatButton.BorderSizePixel = 0
floatButton.Text = "Activar Flote Manual"
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
speedLabel.Position = UDim2.new(0, 0, 0, 90)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. floatSpeed
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Slider de velocidad (arreglado)
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Name = "SpeedSliderFrame"
speedSliderFrame.Size = UDim2.new(0, 200, 0, 20)
speedSliderFrame.Position = UDim2.new(0.5, -100, 0, 120)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = mainFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 10)
sliderFrameCorner.Parent = speedSliderFrame

local sliderButton = Instance.new("Frame")
sliderButton.Name = "SliderButton"
sliderButton.Size = UDim2.new(0, 20, 1, 0)
sliderButton.Position = UDim2.new(0.5, -10, 0, 0) -- Posición inicial en el centro
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = speedSliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 10)
sliderButtonCorner.Parent = sliderButton

-- Controles info
local controlsLabel = Instance.new("TextLabel")
controlsLabel.Name = "ControlsLabel"
controlsLabel.Size = UDim2.new(1, 0, 0, 30)
controlsLabel.Position = UDim2.new(0, 0, 0, 150)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = isMobile and "Usa el joystick para controlar" or "WASD: Mover | Space: Subir | Shift: Bajar"
controlsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
controlsLabel.TextScaled = true
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.Parent = mainFrame

-- Joystick virtual para móvil
local joystickFrame = nil
local joystickKnob = nil

if isMobile then
    joystickFrame = Instance.new("Frame")
    joystickFrame.Name = "JoystickFrame"
    joystickFrame.Size = UDim2.new(0, 100, 0, 100)
    joystickFrame.Position = UDim2.new(0, 20, 1, -120)
    joystickFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    joystickFrame.BackgroundTransparency = 0.3
    joystickFrame.BorderSizePixel = 0
    joystickFrame.Parent = screenGui
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = joystickFrame
    
    joystickKnob = Instance.new("Frame")
    joystickKnob.Name = "JoystickKnob"
    joystickKnob.Size = UDim2.new(0, 30, 0, 30)
    joystickKnob.Position = UDim2.new(0.5, -15, 0.5, -15)
    joystickKnob.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    joystickKnob.BorderSizePixel = 0
    joystickKnob.Parent = joystickFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0.5, 0)
    knobCorner.Parent = joystickKnob
    
    -- Botones de subir/bajar para móvil
    local upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(0, 60, 0, 40)
    upButton.Position = UDim2.new(1, -80, 1, -120)
    upButton.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
    upButton.BorderSizePixel = 0
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextScaled = true
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = screenGui
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton
    
    local downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(0, 60, 0, 40)
    downButton.Position = UDim2.new(1, -80, 1, -70)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
    downButton.BorderSizePixel = 0
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextScaled = true
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = screenGui
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton
end

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

-- Función de flote manual
local function createManualFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Crear BodyVelocity para control manual
    if bodyVelocity then
        bodyVelocity:Destroy()
    end
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Conexión para mantener el movimiento
    floatConnection = RunService.Heartbeat:Connect(function()
        if bodyVelocity and rootPart then
            bodyVelocity.Velocity = currentDirection * floatSpeed
            
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
    
    currentDirection = Vector3.new(0, 0, 0)
end

-- Función para actualizar la velocidad del slider
local function updateSliderSpeed()
    local sliderPosition = sliderButton.Position.X.Scale
    local percentage = sliderPosition
    
    floatSpeed = math.floor(5 + (percentage * 45)) -- Rango de 5 a 50
    speedLabel.Text = "Velocidad: " .. floatSpeed
end

-- Sistema de slider arreglado
local dragging = false

speedSliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        
        local function updateSlider()
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = speedSliderFrame.AbsolutePosition
            local frameSize = speedSliderFrame.AbsoluteSize
            
            local relativeX = mousePos.X - framePos.X
            local percentage = math.clamp(relativeX / frameSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
            updateSliderSpeed()
        end
        
        updateSlider()
        
        local connection
        connection = UserInputService.InputChanged:Connect(function(input2)
            if input2.UserInputType == Enum.UserInputType.MouseMovement or input2.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    updateSlider()
                end
            end
        end)
        
        local endConnection
        endConnection = UserInputService.InputEnded:Connect(function(input2)
            UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                connection:Disconnect()
                endConnection:Disconnect()
            end
        end)
    end
end)

-- Controles para PC
local keysPressed = {}

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not floatEnabled then return end
        
        keysPressed[input.KeyCode] = true
        updateMovement()
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        keysPressed[input.KeyCode] = false
        updateMovement()
    end)
end

function updateMovement()
    if not floatEnabled then return end
    
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Movimiento horizontal
    if keysPressed[Enum.KeyCode.W] then
        moveVector = moveVector + Vector3.new(0, 0, -1)
    end
    if keysPressed[Enum.KeyCode.S] then
        moveVector = moveVector + Vector3.new(0, 0, 1)
    end
    if keysPressed[Enum.KeyCode.A] then
        moveVector = moveVector + Vector3.new(-1, 0, 0)
    end
    if keysPressed[Enum.KeyCode.D] then
        moveVector = moveVector + Vector3.new(1, 0, 0)
    end
    
    -- Movimiento vertical
    if keysPressed[Enum.KeyCode.Space] then
        moveVector = moveVector + Vector3.new(0, 1, 0)
    end
    if keysPressed[Enum.KeyCode.LeftShift] then
        moveVector = moveVector + Vector3.new(0, -1, 0)
    end
    
    currentDirection = moveVector.Unit
    if moveVector.Magnitude == 0 then
        currentDirection = Vector3.new(0, 0, 0)
    end
end

-- Controles para móvil (joystick)
if isMobile then
    local joystickDragging = false
    local joystickCenter = Vector2.new(50, 50)
    
    joystickFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if joystickDragging and input.UserInputType == Enum.UserInputType.Touch and floatEnabled then
            local touchPos = input.Position
            local framePos = joystickFrame.AbsolutePosition
            local frameSize = joystickFrame.AbsoluteSize
            
            local relativePos = Vector2.new(
                touchPos.X - framePos.X - frameSize.X/2,
                touchPos.Y - framePos.Y - frameSize.Y/2
            )
            
            local distance = relativePos.Magnitude
            local maxDistance = frameSize.X/2 - 15
            
            if distance > maxDistance then
                relativePos = relativePos.Unit * maxDistance
            end
            
            joystickKnob.Position = UDim2.new(0.5, relativePos.X, 0.5, relativePos.Y)
            
            -- Convertir a dirección de movimiento
            local normalizedX = relativePos.X / maxDistance
            local normalizedY = relativePos.Y / maxDistance
            
            currentDirection = Vector3.new(normalizedX, 0, normalizedY)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickDragging = false
            joystickKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
            if floatEnabled then
                currentDirection = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    -- Botones de subir/bajar para móvil
    upButton.MouseButton1Down:Connect(function()
        if floatEnabled then
            currentDirection = currentDirection + Vector3.new(0, 1, 0)
        end
    end)
    
    upButton.MouseButton1Up:Connect(function()
        if floatEnabled then
            currentDirection = currentDirection - Vector3.new(0, 1, 0)
        end
    end)
    
    downButton.MouseButton1Down:Connect(function()
        if floatEnabled then
            currentDirection = currentDirection + Vector3.new(0, -1, 0)
        end
    end)
    
    downButton.MouseButton1Up:Connect(function()
        if floatEnabled then
            currentDirection = currentDirection - Vector3.new(0, -1, 0)
        end
    end)
end

-- Evento del botón de flote
floatButton.MouseButton1Click:Connect(function()
    floatEnabled = not floatEnabled
    
    if floatEnabled then
        createManualFloat()
        floatButton.Text = "Desactivar Flote"
        floatButton.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
        
        -- Mostrar controles móviles
        if isMobile then
            joystickFrame.Visible = true
            upButton.Visible = true
            downButton.Visible = true
        end
    else
        stopFloat()
        floatButton.Text = "Activar Flote Manual"
        floatButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        -- Ocultar controles móviles
        if isMobile then
            joystickFrame.Visible = false
            upButton.Visible = false
            downButton.Visible = false
        end
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
sliderButton.Position = UDim2.new(0.5, -10, 0, 0)
updateSliderSpeed()

-- Ocultar controles móviles inicialmente
if isMobile then
    joystickFrame.Visible = false
    upButton.Visible = false
    downButton.Visible = false
end

-- Limpiar al respawnear
player.CharacterRemoving:Connect(function()
    stopFloat()
    floatEnabled = false
    if floatButton then
        floatButton.Text = "Activar Flote Manual"
        floatButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
end)

-- Ocultar panel inicialmente
mainFrame.Visible = false

print("Brainrot Float Manual Script cargado exitosamente!")
print("Controles PC: WASD para mover, Space para subir, Shift para bajar")
print("Controles Móvil: Joystick para mover, botones ↑↓ para subir/bajar")
