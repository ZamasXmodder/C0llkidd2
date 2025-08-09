-- Script Sigiloso para Steal a Brainrot - Anti-Detección
-- Versión mejorada con múltiples capas de protección

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales con nombres ofuscados
local _enabled = false
local _speed = 8 -- Velocidad más baja para evitar detección
local _connection = nil
local _bodyObj = nil
local _direction = Vector3.new(0, 0, 0)
local _lastPos = nil
local _moveTime = 0

-- Detectar plataforma
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Función para crear nombres aleatorios (anti-detección)
local function randomName()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local name = ""
    for i = 1, math.random(8, 12) do
        local pos = math.random(1, #chars)
        name = name .. chars:sub(pos, pos)
    end
    return name
end

-- Crear GUI con nombres aleatorios
local screenGui = Instance.new("ScreenGui")
screenGui.Name = randomName()
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón toggle (más discreto)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = randomName()
toggleButton.Size = UDim2.new(0, 80, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BackgroundTransparency = 0.3
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Menu"
toggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Panel principal (más pequeño y discreto)
local mainFrame = Instance.new("Frame")
mainFrame.Name = randomName()
mainFrame.Size = UDim2.new(0, 250, 0, isMobile and 200 or 160)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, isMobile and -100 or -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Título discreto
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Movement Helper"
titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.Gotham
titleLabel.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Botón de cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -25, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

-- Botón principal (nombre discreto)
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 180, 0, 30)
mainButton.Position = UDim2.new(0.5, -90, 0, 35)
mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
mainButton.BorderSizePixel = 0
mainButton.Text = "Enable Helper"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.Gotham
mainButton.Parent = mainFrame

local mainCorner2 = Instance.new("UICorner")
mainCorner2.CornerRadius = UDim.new(0, 6)
mainCorner2.Parent = mainButton

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 75)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. _speed
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = mainFrame

-- Slider más discreto
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0, 160, 0, 15)
speedSliderFrame.Position = UDim2.new(0.5, -80, 0, 100)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = mainFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 8)
sliderFrameCorner.Parent = speedSliderFrame

local sliderButton = Instance.new("Frame")
sliderButton.Size = UDim2.new(0, 15, 1, 0)
sliderButton.Position = UDim2.new(0.3, -7.5, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = speedSliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 8)
sliderButtonCorner.Parent = sliderButton

-- Controles info
local controlsLabel = Instance.new("TextLabel")
controlsLabel.Size = UDim2.new(1, 0, 0, 25)
controlsLabel.Position = UDim2.new(0, 0, 0, 125)
controlsLabel.BackgroundTransparency = 1
controlsLabel.Text = isMobile and "Touch controls when active" or "WASD + Space/Shift when active"
controlsLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
controlsLabel.TextScaled = true
controlsLabel.Font = Enum.Font.Gotham
controlsLabel.Parent = mainFrame

-- Controles móviles (más discretos)
local joystickFrame = nil
local joystickKnob = nil
local upButton = nil
local downButton = nil

if isMobile then
    joystickFrame = Instance.new("Frame")
    joystickFrame.Size = UDim2.new(0, 80, 0, 80)
    joystickFrame.Position = UDim2.new(0, 15, 1, -100)
    joystickFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    joystickFrame.BackgroundTransparency = 0.5
    joystickFrame.BorderSizePixel = 0
    joystickFrame.Parent = screenGui
    joystickFrame.Visible = false
    
    local joystickCorner = Instance.new("UICorner")
    joystickCorner.CornerRadius = UDim.new(0.5, 0)
    joystickCorner.Parent = joystickFrame
    
    joystickKnob = Instance.new("Frame")
    joystickKnob.Size = UDim2.new(0, 25, 0, 25)
    joystickKnob.Position = UDim2.new(0.5, -12.5, 0.5, -12.5)
    joystickKnob.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
    joystickKnob.BorderSizePixel = 0
    joystickKnob.Parent = joystickFrame
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(0.5, 0)
    knobCorner.Parent = joystickKnob
    
    upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 40, 0, 30)
    upButton.Position = UDim2.new(1, -60, 1, -100)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    upButton.BackgroundTransparency = 0.3
    upButton.BorderSizePixel = 0
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    upButton.TextScaled = true
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = screenGui
    upButton.Visible = false
    
    downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 40, 0, 30)
    downButton.Position = UDim2.new(1, -60, 1, -65)
    downButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    downButton.BackgroundTransparency = 0.3
    downButton.BorderSizePixel = 0
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    downButton.TextScaled = true
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = screenGui
    downButton.Visible = false
end

-- Función de movimiento sigiloso (anti-detección)
local function createStealthMovement()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Usar BodyPosition en lugar de BodyVelocity (menos detectable)
    if _bodyObj then
        _bodyObj:Destroy()
    end
    
    _bodyObj = Instance.new("BodyPosition")
    _bodyObj.MaxForce = Vector3.new(2000, 2000, 2000) -- Fuerza más baja
    _bodyObj.Position = rootPart.Position
    _bodyObj.D = 1000 -- Damping para movimiento más natural
    _bodyObj.P = 3000 -- Power más bajo
    _bodyObj.Parent = rootPart
    
    _lastPos = rootPart.Position
    
    -- Conexión con movimiento más natural
    _connection = RunService.Heartbeat:Connect(function(deltaTime)
        if _bodyObj and rootPart then
            _moveTime = _moveTime + deltaTime
            
            -- Movimiento más suave y natural
            if _direction.Magnitude > 0 then
                local targetPos = _lastPos + (_direction * _speed * deltaTime)
                
                -- Agregar pequeñas variaciones para simular movimiento humano
                local variation = Vector3.new(
                    math.sin(_moveTime * 3) * 0.1,
                    math.cos(_moveTime * 2) * 0.05,
                    math.sin(_moveTime * 4) * 0.1
                )
                
                _bodyObj.Position = targetPos + variation
                _lastPos = targetPos
            else
                _bodyObj.Position = rootPart.Position
                _lastPos = rootPart.Position
            end
            
            if humanoid.Health <= 0 then
                stopMovement()
            end
        end
    end)
end

-- Función para detener movimiento
local function stopMovement()
    if _connection then
        _connection:Disconnect()
        _connection = nil
    end
    
    if _bodyObj then
        _bodyObj:Destroy()
        _bodyObj = nil
    end
    
    _direction = Vector3.new(0, 0, 0)
    _moveTime = 0
end

-- Función para actualizar velocidad
local function updateSpeed()
    local sliderPosition = sliderButton.Position.X.Scale
    _speed = math.floor(3 + (sliderPosition * 12)) -- Rango de 3 a 15 (más bajo)
    speedLabel.Text = "Speed: " .. _speed
end

-- Sistema de slider
local dragging = false

speedSliderFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        
        local function updateSlider()
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = speedSliderFrame.AbsolutePosition
            local frameSize = speedSliderFrame.AbsoluteSize
            
            local relativeX = mousePos.X - framePos.X
            local percentage = math.clamp(
                    relativeX / frameSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -7.5, 0, 0)
            updateSpeed()
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
            if input2.UserInputType == Enum.UserInputType.MouseButton1 or input2.UserInputType == Enum.UserInputType.Touch then
                dragging = false
                connection:Disconnect()
                endConnection:Disconnect()
            end
        end)
    end
end)

-- Controles para PC (con anti-detección)
local keysPressed = {}
local keyCheckDelay = 0

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not _enabled then return end
        
        -- Pequeño delay para evitar detección de input rápido
        wait(0.01)
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
    if not _enabled then return end
    
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Movimiento más suave
    if keysPressed[Enum.KeyCode.W] then
        moveVector = moveVector + Vector3.new(0, 0, -0.8) -- Reducido para ser más natural
    end
    if keysPressed[Enum.KeyCode.S] then
        moveVector = moveVector + Vector3.new(0, 0, 0.8)
    end
    if keysPressed[Enum.KeyCode.A] then
        moveVector = moveVector + Vector3.new(-0.8, 0, 0)
    end
    if keysPressed[Enum.KeyCode.D] then
        moveVector = moveVector + Vector3.new(0.8, 0, 0)
    end
    if keysPressed[Enum.KeyCode.Space] then
        moveVector = moveVector + Vector3.new(0, 0.6, 0) -- Movimiento vertical más lento
    end
    if keysPressed[Enum.KeyCode.LeftShift] then
        moveVector = moveVector + Vector3.new(0, -0.6, 0)
    end
    
    _direction = moveVector
end

-- Controles para móvil
if isMobile then
    local joystickDragging = false
    
    joystickFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickDragging = true
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if joystickDragging and input.UserInputType == Enum.UserInputType.Touch and _enabled then
            local touchPos = input.Position
            local framePos = joystickFrame.AbsolutePosition
            local frameSize = joystickFrame.AbsoluteSize
            
            local relativePos = Vector2.new(
                touchPos.X - framePos.X - frameSize.X/2,
                touchPos.Y - framePos.Y - frameSize.Y/2
            )
            
            local distance = relativePos.Magnitude
            local maxDistance = frameSize.X/2 - 12.5
            
            if distance > maxDistance then
                relativePos = relativePos.Unit * maxDistance
            end
            
            joystickKnob.Position = UDim2.new(0.5, relativePos.X, 0.5, relativePos.Y)
            
            local normalizedX = relativePos.X / maxDistance * 0.8
            local normalizedY = relativePos.Y / maxDistance * 0.8
            
            _direction = Vector3.new(normalizedX, 0, normalizedY)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            joystickDragging = false
            joystickKnob.Position = UDim2.new(0.5, 0, 0.5, 0)
            if _enabled then
                _direction = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    -- Botones verticales
    upButton.MouseButton1Down:Connect(function()
        if _enabled then
            _direction = _direction + Vector3.new(0, 0.6, 0)
        end
    end)
    
    upButton.MouseButton1Up:Connect(function()
        if _enabled then
            _direction = _direction - Vector3.new(0, 0.6, 0)
        end
    end)
    
    downButton.MouseButton1Down:Connect(function()
        if _enabled then
            _direction = _direction + Vector3.new(0, -0.6, 0)
        end
    end)
    
    downButton.MouseButton1Up:Connect(function()
        if _enabled then
            _direction = _direction - Vector3.new(0, -0.6, 0)
        end
    end)
end

-- Evento del botón principal
mainButton.MouseButton1Click:Connect(function()
    _enabled = not _enabled
    
    if _enabled then
        createStealthMovement()
        mainButton.Text = "Disable Helper"
        mainButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
        
        if isMobile then
            joystickFrame.Visible = true
            upButton.Visible = true
            downButton.Visible = true
        end
    else
        stopMovement()
        mainButton.Text = "Enable Helper"
        mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
        
        if isMobile then
            joystickFrame.Visible = false
            upButton.Visible = false
            downButton.Visible = false
        end
    end
end)

-- Eventos de UI
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    toggleButton.Text = "Menu"
    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
        toggleButton.Text = "Hide"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 40, 40)
    else
        toggleButton.Text = "Menu"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- Inicializar
updateSpeed()

-- Sistema de auto-limpieza mejorado
player.CharacterRemoving:Connect(function()
    stopMovement()
    _enabled = false
    if mainButton then
        mainButton.Text = "Enable Helper"
        mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    end
    
    if isMobile then
        if joystickFrame then joystickFrame.Visible = false end
        if upButton then upButton.Visible = false end
        if downButton then downButton.Visible = false end
    end
end)

-- Protección adicional contra detección
spawn(function()
    while wait(math.random(30, 60)) do -- Pausa aleatoria cada 30-60 segundos
        if _enabled then
            -- Pequeña pausa para simular comportamiento humano
            stopMovement()
            wait(math.random(1, 3))
            if _enabled then
                createStealthMovement()
            end
        end
    end
end)

-- Detección de moderadores/admins (básica)
spawn(function()
    while wait(5) do
        for _, v in pairs(Players:GetPlayers()) do
            if v.Name:lower():find("admin") or v.Name:lower():find("mod") or v.Name:lower():find("owner") then
                if _enabled then
                    _enabled = false
                    stopMovement()
                    mainButton.Text = "Enable Helper"
                    mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
                    
                    if isMobile then
                        joystickFrame.Visible = false
                        upButton.Visible = false
                        downButton.Visible = false
                    end
                    
                    warn("Posible staff detectado - Helper desactivado automáticamente")
                end
            end
        end
    end
end)

print("Stealth Movement Helper cargado")
print("Características anti-detección activadas")
print("Velocidades reducidas para mayor sigilo")
