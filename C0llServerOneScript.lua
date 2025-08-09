-- Script Sigiloso usando controles originales del juego
-- Usa el joystick/controles nativos - Máxima compatibilidad

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local _enabled = false
local _speed = 8
local _connection = nil
local _bodyObj = nil
local _moveVector = Vector3.new(0, 0, 0)
local _verticalInput = 0

-- Detectar plataforma
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Función para nombres aleatorios
local function randomName()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    local name = ""
    for i = 1, math.random(8, 12) do
        local pos = math.random(1, #chars)
        name = name .. chars:sub(pos, pos)
    end
    return name
end

-- Crear GUI minimalista
local screenGui = Instance.new("ScreenGui")
screenGui.Name = randomName()
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Botón toggle discreto
local toggleButton = Instance.new("TextButton")
toggleButton.Name = randomName()
toggleButton.Size = UDim2.new(0, 70, 0, 25)
toggleButton.Position = UDim2.new(0, 10, 0, 50)
toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
toggleButton.BackgroundTransparency = 0.4
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Helper"
toggleButton.TextColor3 = Color3.fromRGB(200, 200, 200)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.Gotham
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 6)
toggleCorner.Parent = toggleButton

-- Panel de configuración
local configFrame = Instance.new("Frame")
configFrame.Name = randomName()
configFrame.Size = UDim2.new(0, 220, 0, 120)
configFrame.Position = UDim2.new(0.5, -110, 0.5, -60)
configFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
configFrame.BackgroundTransparency = 0.1
configFrame.BorderSizePixel = 0
configFrame.Active = true
configFrame.Draggable = true
configFrame.Parent = screenGui
configFrame.Visible = false

local configCorner = Instance.new("UICorner")
configCorner.CornerRadius = UDim.new(0, 8)
configCorner.Parent = configFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 25)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Movement Helper"
titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.Gotham
titleLabel.Parent = configFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleLabel

-- Botón cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 20, 0, 20)
closeButton.Position = UDim2.new(1, -22, 0, 2.5)
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

-- Botón principal
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 160, 0, 25)
mainButton.Position = UDim2.new(0.5, -80, 0, 35)
mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
mainButton.BorderSizePixel = 0
mainButton.Text = "Enable Float"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.Gotham
mainButton.Parent = configFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 6)
mainCorner.Parent = mainButton

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 15)
speedLabel.Position = UDim2.new(0, 0, 0, 65)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: " .. _speed
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = configFrame

-- Slider de velocidad
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0, 140, 0, 12)
speedSliderFrame.Position = UDim2.new(0.5, -70, 0, 85)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = configFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 6)
sliderFrameCorner.Parent = speedSliderFrame

local sliderButton = Instance.new("Frame")
sliderButton.Size = UDim2.new(0, 12, 1, 0)
sliderButton.Position = UDim2.new(0.4, -6, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = speedSliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 6)
sliderButtonCorner.Parent = sliderButton

-- Info de controles
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 15)
infoLabel.Position = UDim2.new(0, 0, 0, 102)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = isMobile and "Use original joystick + up/down buttons" or "Use WASD + Space/Shift normally"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = configFrame

-- Botones de control vertical para móvil (solo cuando está activo)
local upButton = nil
local downButton = nil

if isMobile then
    upButton = Instance.new("TextButton")
    upButton.Name = randomName()
    upButton.Size = UDim2.new(0, 50, 0, 35)
    upButton.Position = UDim2.new(1, -70, 1, -120)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 50, 100)
    upButton.BackgroundTransparency = 0.3
    upButton.BorderSizePixel = 0
    upButton.Text = "↑"
    upButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    upButton.TextScaled = true
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = screenGui
    upButton.Visible = false
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 8)
    upCorner.Parent = upButton
    
    downButton = Instance.new("TextButton")
    downButton.Name = randomName()
    downButton.Size = UDim2.new(0, 50, 0, 35)
    downButton.Position = UDim2.new(1, -70, 1, -80)
    downButton.BackgroundColor3 = Color3.fromRGB(100, 50, 50)
    downButton.BackgroundTransparency = 0.3
    downButton.BorderSizePixel = 0
    downButton.Text = "↓"
    downButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    downButton.TextScaled = true
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = screenGui
    downButton.Visible = false
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 8)
    downCorner.Parent = downButton
end

-- Función de movimiento usando controles originales
local function createNativeFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Crear BodyPosition para el flote
    if _bodyObj then
        _bodyObj:Destroy()
    end
    
    _bodyObj = Instance.new("BodyPosition")
    _bodyObj.MaxForce = Vector3.new(2000, 2000, 2000)
    _bodyObj.Position = rootPart.Position
    _bodyObj.D = 1200
    _bodyObj.P = 3000
    _bodyObj.Parent = rootPart
    
    -- Conexión que usa los controles nativos del juego
    _connection = RunService.Heartbeat:Connect(function(deltaTime)
        if _bodyObj and rootPart and humanoid then
            -- Obtener el vector de movimiento del humanoid (controles nativos)
            local moveVector = humanoid.MoveDirection
            
            -- Agregar componente vertical manual
            local finalVector = Vector3.new(
                moveVector.X,
                _verticalInput,
                moveVector.Z
            )
            
            -- Aplicar movimiento suave
            if finalVector.Magnitude > 0 then
                local targetPos = rootPart.Position + (finalVector * _speed * deltaTime)
                _bodyObj.Position = targetPos
            else
                _bodyObj.Position = rootPart.Position
            end
            
            if humanoid.Health <= 0 then
                stopFloat()
            end
        end
    end)
end

-- Función para detener el flote
local function stopFloat()
    if _connection then
        _connection:Disconnect()
        _connection = nil
    end
    
    if _bodyObj then
        _bodyObj:Destroy()
        _bodyObj = nil
    end
    
    _verticalInput = 0
end

-- Función para actualizar velocidad
local function updateSpeed()
    local sliderPosition = sliderButton.Position.X.Scale
    _speed = math.floor(3 + (sliderPosition * 12)) -- Rango de 3 a 15
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
            local percentage = math.clamp(relativeX / frameSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -6, 0, 0)
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

-- Controles verticales para PC (Space/Shift)
if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed or not _enabled then return end
        
        if input.KeyCode == Enum.KeyCode.Space then
            _verticalInput = 1
        elseif input.KeyCode == Enum.KeyCode.LeftShift then
            _verticalInput = -1
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.LeftShift then
            _verticalInput = 0
        end
    end)
end

-- Controles verticales para móvil
if isMobile then
    upButton.MouseButton1Down:Connect(function()
        if _enabled then
            _verticalInput = 1
        end
    end)
    
    upButton.MouseButton1Up:Connect(function()
        _verticalInput = 0
    end)
    
    downButton.MouseButton1Down:Connect(function()
        if _enabled then
            _verticalInput = -1
        end
    end)
    
    downButton.MouseButton1Up:Connect(function()
        _verticalInput = 0
    end)
end

-- Evento del botón principal
mainButton.MouseButton1Click:Connect(function()
    _enabled = not _enabled
    
    if _enabled then
        createNativeFloat()
        mainButton.Text = "Disable Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(100, 60, 60)
        toggleButton.Text = "ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
        
        -- Mostrar controles verticales en móvil
        if isMobile then
            upButton.Visible = true
            downButton.Visible = true
        end
    else
        stopFloat()
        mainButton.Text = "Enable Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
        toggleButton.Text = "Helper"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        
        -- Ocultar controles verticales en móvil
        if isMobile then
            upButton.Visible = false
            downButton.Visible = false
        end
    end
end)

-- Eventos de UI
closeButton.MouseButton1Click:Connect(function()
    configFrame.Visible = false
end)

toggleButton.MouseButton1Click:Connect(function()
    configFrame.Visible = not configFrame.Visible
end)

-- Inicializar
updateSpeed()

-- Auto-limpieza al respawnear
player.CharacterRemoving:Connect(function()
    stopFloat()
    _enabled = false
    _verticalInput = 0
    
    if mainButton then
        mainButton.Text = "Enable Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
    end
    
    if toggleButton then
        toggleButton.Text = "Helper"
        toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
    
    if isMobile then
        if upButton then upButton.Visible = false end
        if downButton then downButton.Visible = false end
    end
end)

-- Sistema de seguridad mejorado
spawn(function()
    while wait(math.random(45, 90)) do -- Pausa cada 45-90 segundos
        if _enabled then
            -- Pausa automática para simular comportamiento humano
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            wait(math.random(2, 5)) -- Pausa de 2-5 segundos
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
            end
        end
    end
end)

-- Detección básica de staff
spawn(function()
    while wait(10) do
        for _, v in pairs(Players:GetPlayers()) do
            local name = v.Name:lower()
            if name:find("admin") or name:find("mod") or name:find("owner") or name:find("staff") then
                if _enabled then
                    _enabled = false
                    stopFloat()
                    mainButton.Text = "Enable Float"
                    mainButton.BackgroundColor3 = Color3.fromRGB(60, 100, 60)
                    toggleButton.Text = "Helper"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
                    
                    if isMobile then
                        upButton.Visible = false
                        downButton.Visible = false
                    end
                    
                    configFrame.Visible = false
                    warn("Staff detectado - Helper desactivado automáticamente")
                end
            end
        end
    end
end)

-- Ocultar GUI inicialmente
configFrame.Visible = false

print("Native Controls Float Helper cargado")
print("Usa los controles originales del juego + botones verticales")
print("PC: WASD para mover, Space/Shift para subir/bajar")
print("Móvil: Joystick original + botones ↑↓")
