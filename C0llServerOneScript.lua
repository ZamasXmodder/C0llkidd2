-- Script con velocidades corregidas y botón toggle visible
-- Versión corregida con botón siempre visible

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local _enabled = false
local _speed = 25
local _connection = nil
local _bodyObj = nil
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

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = randomName()
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- CREAR BOTÓN TOGGLE PRIMERO Y ASEGURAR VISIBILIDAD
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton" -- Nombre fijo para debug
toggleButton.Size = UDim2.new(0, 80, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Float Menu"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui
toggleButton.Visible = true -- FORZAR VISIBILIDAD
toggleButton.ZIndex = 10 -- Asegurar que esté al frente

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Panel de configuración
local configFrame = Instance.new("Frame")
configFrame.Name = randomName()
configFrame.Size = UDim2.new(0, 240, 0, 130)
configFrame.Position = UDim2.new(0.5, -120, 0.5, -65)
configFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
configFrame.BackgroundTransparency = 0.1
configFrame.BorderSizePixel = 0
configFrame.Active = true
configFrame.Draggable = true
configFrame.Parent = screenGui
configFrame.Visible = false
configFrame.ZIndex = 5

local configCorner = Instance.new("UICorner")
configCorner.CornerRadius = UDim.new(0, 10)
configCorner.Parent = configFrame

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.BorderSizePixel = 0
titleLabel.Text = "Float Helper - Fast Edition"
titleLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = configFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = titleLabel

-- Botón cerrar
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -30, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleLabel

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeButton

-- Botón principal
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 180, 0, 30)
mainButton.Position = UDim2.new(0.5, -90, 0, 40)
mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
mainButton.BorderSizePixel = 0
mainButton.Text = "Activar Float"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.GothamBold
mainButton.Parent = configFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainButton

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 18)
speedLabel.Position = UDim2.new(0, 0, 0, 75)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Velocidad: " .. _speed .. " studs/seg"
speedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = configFrame

-- Slider de velocidad
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0, 160, 0, 15)
speedSliderFrame.Position = UDim2.new(0.5, -80, 0, 95)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = configFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 8)
sliderFrameCorner.Parent = speedSliderFrame

local sliderButton = Instance.new("Frame")
sliderButton.Size = UDim2.new(0, 15, 1, 0)
sliderButton.Position = UDim2.new(0.375, -7.5, 0, 0) -- Posición para velocidad 25
sliderButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
sliderButton.BorderSizePixel = 0
sliderButton.Parent = speedSliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 8)
sliderButtonCorner.Parent = sliderButton

-- Info de controles
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, 0, 0, 15)
infoLabel.Position = UDim2.new(0, 0, 0, 112)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = isMobile and "Joystick original + botones ↑↓" or "WASD + Space/Shift + Tecla P (emergencia)"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.Parent = configFrame

-- Botones verticales para móvil
local upButton = nil
local downButton = nil

if isMobile then
    upButton = Instance.new("TextButton")
    upButton.Name = "UpButton"
    upButton.Size = UDim2.new(0, 55, 0, 40)
    upButton.Position = UDim2.new(1, -75, 1, -130)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    upButton.BackgroundTransparency = 0.2
    upButton.BorderSizePixel = 0
    upButton.Text = "↑ SUBIR"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextScaled = true
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = screenGui
    upButton.Visible = false
    upButton.ZIndex = 8
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 10)
    upCorner.Parent = upButton
    
    downButton = Instance.new("TextButton")
    downButton.Name = "DownButton"
    downButton.Size = UDim2.new(0, 55, 0, 40)
    downButton.Position = UDim2.new(1, -75, 1, -85)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    downButton.BackgroundTransparency = 0.2
    downButton.BorderSizePixel = 0
    downButton.Text = "↓ BAJAR"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextScaled = true
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = screenGui
    downButton.Visible = false
    downButton.ZIndex = 8
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 10)
    downCorner.Parent = downButton
end

-- Función de movimiento con velocidades corregidas
local function createNativeFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if _bodyObj then
        _bodyObj:Destroy()
    end
    
    _bodyObj = Instance.new("BodyVelocity")
    _bodyObj.MaxForce = Vector3.new(4000, 4000, 4000)
    _bodyObj.Velocity = Vector3.new(0, 0, 0)
    _bodyObj.Parent = rootPart
    
    _connection = RunService.Heartbeat:Connect(function()
        if _bodyObj and rootPart and humanoid then
            local moveVector = humanoid.MoveDirection
            
            local finalVelocity = Vector3.new(
                moveVector.X * _speed,
                _verticalInput * _speed,
                moveVector.Z * _speed
            )
            
            _bodyObj.Velocity =
                finalVelocity
            
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
    _speed = math.floor(10 + (sliderPosition * 40)) -- Rango de 10 a 50
    speedLabel.Text = "Velocidad: " .. _speed .. " studs/seg"
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

-- Controles verticales para PC
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
        mainButton.Text = "Desactivar Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleButton.Text = "ACTIVO"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        if isMobile then
            upButton.Visible = true
            downButton.Visible = true
        end
        
        print("Float activado - Velocidad: " .. _speed)
    else
        stopFloat()
        mainButton.Text = "Activar Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "Float Menu"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        
        if isMobile then
            upButton.Visible = false
            downButton.Visible = false
        end
        
        print("Float desactivado")
    end
end)

-- Eventos de UI
closeButton.MouseButton1Click:Connect(function()
    configFrame.Visible = false
    print("Panel cerrado")
end)

toggleButton.MouseButton1Click:Connect(function()
    configFrame.Visible = not configFrame.Visible
    if configFrame.Visible then
        print("Panel abierto")
    else
        print("Panel cerrado")
    end
end)

-- Tecla de emergencia (P para desactivar rápido)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.P then
        if _enabled then
            _enabled = false
            stopFloat()
            mainButton.Text = "Activar Float"
            mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            toggleButton.Text = "Float Menu"
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
            
            if isMobile then
                upButton.Visible = false
                downButton.Visible = false
            end
            
            configFrame.Visible = false
            print("EMERGENCIA: Float desactivado con tecla P")
        end
    end
end)

-- Auto-limpieza al respawnear
player.CharacterRemoving:Connect(function()
    stopFloat()
    _enabled = false
    _verticalInput = 0
    
    if mainButton then
        mainButton.Text = "Activar Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    end
    
    if toggleButton then
        toggleButton.Text = "Float Menu"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
    end
    
    if isMobile then
        if upButton then upButton.Visible = false end
        if downButton then downButton.Visible = false end
    end
    
    print("Character respawned - Float reset")
end)

-- Sistema de seguridad básico
spawn(function()
    while wait(math.random(90, 180)) do -- Pausa cada 1.5-3 minutos
        if _enabled then
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            print("Pausa automática de seguridad...")
            wait(math.random(5, 10)) -- Pausa de 5-10 segundos
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
                print("Float reactivado automáticamente")
            end
        end
    end
end)

-- Detección básica de staff
spawn(function()
    while wait(20) do
        for _, v in pairs(Players:GetPlayers()) do
            local name = v.Name:lower()
            if name:find("admin") or name:find("mod") or name:find("owner") or name:find("staff") then
                if _enabled then
                    _enabled = false
                    stopFloat()
                    mainButton.Text = "Activar Float"
                    mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    toggleButton.Text = "Float Menu"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
                    
                    if isMobile then
                        upButton.Visible = false
                        downButton.Visible = false
                    end
                    
                    configFrame.Visible = false
                    warn("STAFF DETECTADO: " .. v.Name .. " - Float desactivado automáticamente")
                end
            end
        end
    end
end)

-- Inicializar
updateSpeed()

-- Debug: Verificar que el botón esté visible
wait(1)
print("=== FLOAT HELPER CARGADO ===")
print("Botón toggle visible:", toggleButton.Visible)
print("Botón toggle parent:", toggleButton.Parent.Name)
print("Velocidad inicial:", _speed, "studs/seg")
print("Plataforma:", isMobile and "Móvil" or "PC")
print("Controles PC: WASD + Space/Shift + P(emergencia)")
print("Controles Móvil: Joystick original + botones ↑↓")
print("Rango velocidad: 10-50 studs/seg")
print("=============================")

-- Hacer el botón más visible si no aparece
spawn(function()
    wait(2)
    if toggleButton and toggleButton.Parent then
        toggleButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100) -- Verde más brillante
        toggleButton.Size = UDim2.new(0, 90, 0, 35) -- Más grande
        toggleButton.Position = UDim2.new(0, 5, 0, 5) -- Esquina superior izquierda
        print("Botón reposicionado y redimensionado para mayor visibilidad")
    end
end)
