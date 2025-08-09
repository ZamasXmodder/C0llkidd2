-- Script con UI corregida - Sin superposiciones
-- Versión sin elementos que bloqueen la interfaz

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

-- Botón toggle (sin problemas de ZIndex)
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0, 90, 0, 35)
toggleButton.Position = UDim2.new(0, 10, 0, 10)
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Float Menu"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextScaled = true
toggleButton.Font = Enum.Font.GothamBold
toggleButton.Parent = screenGui

local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 8)
toggleCorner.Parent = toggleButton

-- Panel principal (SIN elementos superpuestos)
local mainFrame = Instance.new("Frame")
mainFrame.Name = randomName()
mainFrame.Size = UDim2.new(0, 280, 0, 160)
mainFrame.Position = UDim2.new(0.5, -140, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui
mainFrame.Visible = false

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- Barra de título (SIN superposición)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = titleBar

-- Título
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Float Helper - Rápido"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleBar

-- Botón cerrar (dentro de la barra de título)
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 2.5)
closeButton.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
closeButton.BorderSizePixel = 0
closeButton.Text = "×"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeButton

-- Contenido del panel (separado de la barra de título)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, 0, 1, -35)
contentFrame.Position = UDim2.new(0, 0, 0, 35)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- Botón principal
local mainButton = Instance.new("TextButton")
mainButton.Size = UDim2.new(0, 200, 0, 35)
mainButton.Position = UDim2.new(0.5, -100, 0, 10)
mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
mainButton.BorderSizePixel = 0
mainButton.Text = "🚀 Activar Float"
mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
mainButton.TextScaled = true
mainButton.Font = Enum.Font.GothamBold
mainButton.Parent = contentFrame

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainButton

-- Label de velocidad
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, -20, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 55)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Velocidad: " .. _speed .. " studs/seg"
speedLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
speedLabel.TextScaled = true
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = contentFrame

-- Slider de velocidad
local speedSliderFrame = Instance.new("Frame")
speedSliderFrame.Size = UDim2.new(0, 200, 0, 18)
speedSliderFrame.Position = UDim2.new(0.5, -100, 0, 80)
speedSliderFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedSliderFrame.BorderSizePixel = 0
speedSliderFrame.Parent = contentFrame

local sliderFrameCorner = Instance.new("UICorner")
sliderFrameCorner.CornerRadius = UDim.new(0, 9)
sliderFrameCorner.Parent = speedSliderFrame

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 18, 1, 0)
sliderButton.Position = UDim2.new(0.375, -9, 0, 0)
sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
sliderButton.BorderSizePixel = 0
sliderButton.Text = ""
sliderButton.Parent = speedSliderFrame

local sliderButtonCorner = Instance.new("UICorner")
sliderButtonCorner.CornerRadius = UDim.new(0, 9)
sliderButtonCorner.Parent = sliderButton

-- Info de controles
local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 0, 18)
infoLabel.Position = UDim2.new(0, 10, 0, 105)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = isMobile and "📱 Joystick original + botones ↑↓" or "⌨️ WASD + Space/Shift | P = Emergencia"
infoLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.Parent = contentFrame

-- Botones verticales para móvil (fuera del panel principal)
local upButton = nil
local downButton = nil

if isMobile then
    upButton = Instance.new("TextButton")
    upButton.Size = UDim2.new(0, 60, 0, 45)
    upButton.Position = UDim2.new(1, -80, 1, -140)
    upButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
    upButton.BackgroundTransparency = 0.2
    upButton.BorderSizePixel = 0
    upButton.Text = "↑\nSUBIR"
    upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    upButton.TextScaled = true
    upButton.Font = Enum.Font.GothamBold
    upButton.Parent = screenGui
    upButton.Visible = false
    
    local upCorner = Instance.new("UICorner")
    upCorner.CornerRadius = UDim.new(0, 12)
    upCorner.Parent = upButton
    
    downButton = Instance.new("TextButton")
    downButton.Size = UDim2.new(0, 60, 0, 45)
    downButton.Position = UDim2.new(1, -80, 1, -90)
    downButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
    downButton.BackgroundTransparency = 0.2
    downButton.BorderSizePixel = 0
    downButton.Text = "↓\nBAJAR"
    downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    downButton.TextScaled = true
    downButton.Font = Enum.Font.GothamBold
    downButton.Parent = screenGui
    downButton.Visible = false
    
    local downCorner = Instance.new("UICorner")
    downCorner.CornerRadius = UDim.new(0, 12)
    downCorner.Parent = downButton
end

-- Función de movimiento
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
            
            _bodyObj.Velocity = finalVelocity
            
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
    speedLabel.Text = "⚡ Velocidad: " .. _speed .. " studs/seg"
end

-- Sistema de slider (SIN problemas de input)
local dragging = false

sliderButton.MouseButton1Down:Connect(function()
    dragging = true
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = UserInputService:GetMouseLocation()
        local framePos = speedSliderFrame.AbsolutePosition
        local frameSize = speedSliderFrame.AbsoluteSize
        
        local relativeX = mousePos.X - framePos.X
        local percentage = math.clamp(relativeX / frameSize.X, 0, 1)
        
        sliderButton.Position = UDim2.new(percentage, -9, 0, 0)
        updateSpeed()
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
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
    
    upButton.TouchTap:Connect(function()
        if _enabled then
            _verticalInput = 1
            wait(0.1)
            _verticalInput = 0
        end
    end)
    
    downButton.MouseButton1Down:Connect(function()
        if _enabled then
            _verticalInput = -1
        end
    end)
    
    downButton.MouseButton1Up:Connect(function()
        _verticalInput = 0
    end)
    
    downButton.TouchTap:Connect(function()
        if _enabled then
            _verticalInput = -1
            wait(0.1)
            _verticalInput = 0
        end
    end)
end

-- Evento del botón principal
mainButton.MouseButton1Click:Connect(function()
    _enabled = not _enabled
    
    if _enabled then
        createNativeFloat()
        mainButton.Text = "🛑 Desactivar Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        toggleButton.Text = "ACTIVO"
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        
        if isMobile then
            upButton.Visible = true
            downButton.Visible = true
        end
        
        print("✅ Float activado - Velocidad: " .. _speed .. " studs/seg")
    else
        stopFloat()
        mainButton.Text = "🚀 Activar Float"
        mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        toggleButton.Text = "Float Menu"
        toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
        
        if isMobile then
            upButton.Visible = false
            downButton.Visible = false
        end
        
        print("❌ Float desactivado")
    end
end)

-- Eventos de UI
closeButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = false
    print("Panel cerrado")
end)

toggleButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    if mainFrame.Visible then
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
            mainButton.Text = "🚀 Activar Float"
            mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            toggleButton.Text = "Float Menu"
            toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
            
            if isMobile then
                upButton.Visible = false
                downButton.Visible = false
            end
            
            mainFrame.Visible = false
            print("🚨 EMERGENCIA: Float desactivado con tecla P")
        end
    end
end)

-- Auto-limpieza al respawnear
player.CharacterRemoving:Connect(function()
    stopFloat()
    _enabled = false
    _verticalInput = 0
    
    if mainButton then
        mainButton.Text = "🚀 Activar Float"
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
    
    print("🔄 Character respawned - Float reset")
end)

-- Sistema de seguridad básico
spawn(function()
    while wait(math.random(120, 240)) do -- Pausa cada 2-4 minutos
        if _enabled then
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            print("⏸️ Pausa automática de seguridad...")
            wait(math.random(5, 12)) -- Pausa de 5-12 segundos
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
                print("▶️ Float reactivado automáticamente")
            end
        end
    end
end)

-- Detección básica de staff
spawn(function()
    while wait(25) do
        for _, v in pairs(Players:GetPlayers()) do
            local name = v.Name:lower()
            if name:find("admin") or name:find("mod") or name:find("owner") or name:find("staff") then
                if _enabled then
                    _enabled = false
                    stopFloat()
                    mainButton.Text = "🚀 Activar Float"
                    mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                    toggleButton.Text = "Float Menu"
                    toggleButton.BackgroundColor3 = Color3.fromRGB(70, 120, 200)
                    
                    if isMobile then
                        upButton.Visible = false
                        downButton.Visible = false
                    end
                    
                    mainFrame.Visible = false
                    warn("🚨 STAFF DETECTADO: " .. v.Name .. " - Float desactivado automáticamente")
                end
            end
        end
    end
end)

-- Inicializar
updateSpeed()

-- Mensaje de carga exitosa
wait(0.5)
print("🎯 === FLOAT HELPER CARGADO EXITOSAMENTE ===")
print("📱 Plataforma:", isMobile and "Móvil" or "PC")
print("⚡ Velocidad inicial:", _speed, "studs/seg")
print("🎮 Controles PC: WASD + Space/Shift + P(emergencia)")
print("📱 Controles Móvil: Joystick original + botones ↑↓")
print("📊 Rango velocidad: 10-50 studs/seg")
print("🔧 UI corregida - Sin superposiciones")
print("===============================================")
