-- Script con protección anti-detección avanzada

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales con nombres ofuscados
local _enabled = false
local _speed = 16 -- Velocidad inicial más baja
local _connection = nil
local _bodyObj = nil
local _verticalInput = 0
local _authenticated = false
local _lastMovement = tick()
local _movementPattern = {}
local _safetyMode = false

-- Sistema de detección de anti-cheat
local _detectionLevel = 0
local _maxDetectionLevel = 3
local _lastDetectionCheck = tick()

-- Detectar plataforma
local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- Función para nombres aleatorios más seguros
local function randomName()
    local prefixes = {"UI", "Frame", "Button", "Label", "Panel", "Container", "Holder", "Wrapper"}
    local suffixes = {"Manager", "Handler", "Controller", "Service", "Helper", "Utility", "Component"}
    return prefixes[math.random(#prefixes)] .. suffixes[math.random(#suffixes)] .. tostring(math.random(1000, 9999))
end

-- Sistema de velocidad adaptativa
local function getAdaptiveSpeed()
    local baseSpeed = _speed
    local character = player.Character
    if not character then return baseSpeed end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return baseSpeed end
    
    -- Reducir velocidad si hay mucho movimiento reciente
    local currentTime = tick()
    if currentTime - _lastMovement < 2 then
        baseSpeed = baseSpeed * 0.7 -- Reducir 30%
    end
    
    -- Modo seguridad activo
    if _safetyMode then
        baseSpeed = math.min(baseSpeed, 20) -- Máximo 20 en modo seguro
    end
    
    -- Variación aleatoria para parecer más humano
    local variation = math.random(-2, 2)
    return math.max(10, baseSpeed + variation)
end

-- Función de movimiento con protección anti-detección
local function createNativeFloat()
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if _bodyObj then
        _bodyObj:Destroy()
    end
    
    -- Usar BodyPosition en lugar de BodyVelocity (menos detectable)
    _bodyObj = Instance.new("BodyPosition")
    _bodyObj.MaxForce = Vector3.new(2000, 2000, 2000) -- Fuerza reducida
    _bodyObj.Position = rootPart.Position
    _bodyObj.D = 1000 -- Damping para movimiento más suave
    _bodyObj.P = 3000 -- Power reducido
    _bodyObj.Parent = rootPart
    
    local lastPosition = rootPart.Position
    local moveStartTime = tick()
    
    _connection = RunService.Heartbeat:Connect(function()
        if _bodyObj and rootPart and humanoid then
            local currentSpeed = getAdaptiveSpeed()
            local moveVector = humanoid.MoveDirection
            local currentTime = tick()
            
            -- Pausas aleatorias para simular comportamiento humano
            if math.random(1, 1000) == 1 then
                wait(math.random(0.1, 0.3))
            end
            
            -- Calcular nueva posición
            local deltaTime = currentTime - moveStartTime
            local movement = Vector3.new(
                moveVector.X * currentSpeed * deltaTime,
                _verticalInput * currentSpeed * deltaTime,
                moveVector.Z * currentSpeed * deltaTime
            )
            
            -- Agregar micro-variaciones para parecer más natural
            local microVariation = Vector3.new(
                math.random(-0.1, 0.1),
                math.random(-0.05, 0.05),
                math.random(-0.1, 0.1)
            )
            
            local newPosition = lastPosition + movement + microVariation
            _bodyObj.Position = newPosition
            
            -- Actualizar tracking
            if moveVector.Magnitude > 0 then
                _lastMovement = currentTime
                table.insert(_movementPattern, {time = currentTime, speed = currentSpeed})
                
                -- Mantener solo los últimos 10 movimientos
                if #_movementPattern > 10 then
                    table.remove(_movementPattern, 1)
                end
            end
            
            lastPosition = newPosition
            moveStartTime = currentTime
            
            -- Verificar salud
            if humanoid.Health <= 0 then
                stopFloat()
            end
            
            -- Sistema de detección de velocidad anómala
            local actualVelocity = (rootPart.Position - lastPosition).Magnitude / deltaTime
            if actualVelocity > 50 then -- Si la velocidad es muy alta
                _detectionLevel = _detectionLevel + 1
                if _detectionLevel >= _maxDetectionLevel then
                    _safetyMode = true
                    print("Modo seguridad activado - Velocidad reducida")
                end
            end
        end
    end)
end

-- Función para detener el flote con limpieza completa
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
    _detectionLevel = math.max(0, _detectionLevel - 1) -- Reducir nivel de detección
end

-- Sistema de pausas inteligentes
spawn(function()
    while wait(math.random(120, 240)) do -- Pausas cada 2-4 minutos
        if _enabled then
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            local pauseTime = math.random(5, 15)
            print("Pausa de seguridad: " .. pauseTime .. " segundos")
            
            -- Durante la pausa, simular actividad normal
            wait(pauseTime)
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
                print("Reactivado después de pausa")
            end
        end
    end
end)

-- Detección de staff mejorada con más nombres
spawn(function()
    while wait(15) do -- Verificar cada 15 segundos
        for _, v in pairs(Players:GetPlayers()) do
            local name = v.Name:lower()
            local displayName = v.DisplayName:lower()
            
            local suspiciousNames = {
                "admin", "mod", "owner", "staff", "dev", "developer", 
                "moderator", "administrator", "creator", "founder",
                "helper", "support", "manager", "supervisor", "lead"
            }
            
            local isSuspicious = false
            
            for _, suspicious in pairs(suspiciousNames) do
                if name:find(suspicious) or displayName:find(suspicious) then
                    isSuspicious = true
                    break
                end
            end
            
            -- También verificar si tienen herramientas de admin
            if v.Character then
                for _, tool in pairs(v.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local toolName = tool.Name:lower()
                        if toolName:find("admin") or toolName:find("ban") or toolName:find("kick") then
                            isSuspicious = true
                            break
                        end
                    end
                end
            end
            
            if isSuspicious and _enabled then
                _enabled = false
                stopFloat()
                
                -- Ocultar interfaz completamente
                if screenGui then
                    screenGui.Enabled = false
                end
                
                warn("STAFF DETECTADO: " .. v.Name .. " - Ocultando sistema")
                
                -- Esperar a que se vaya y reactivar
                spawn(function()
                    repeat wait(10) until not Players:FindFirstChild(v.Name)
                    wait(30) -- Esperar 30 segundos extra
                    
                    if screenGui then
                        screenGui.Enabled = true
                    end
                    
                    print("Staff se fue - Sistema disponible")
                end)
            end
        end
    end
end)

-- Detección de lag y rendimiento
spawn(function()
    local lastTime = tick()
    local lagCount = 0
    
    while wait(1) do
        local currentTime = tick()
        local deltaTime = currentTime - lastTime
        lastTime = currentTime
        
        if deltaTime > 1.5 then -- Lag detectado
            lagCount = lagCount + 1
            
            if lagCount >= 3 and _enabled then -- 3 lags seguidos
                print("Lag severo detectado - Pausando sistema")
                local wasEnabled = _enabled
                _enabled = false
                stopFloat()
                
                wait(10) -- Esperar a que mejore
                
                if wasEnabled then
                    _enabled = true
                    createNativeFloat()
                    print("Sistema reactivado después del lag")
                end
                
                lagCount = 0
            end
        else
            lagCount = math.max(0, lagCount - 1) -- Reducir contador si no hay lag
        end
    end
end)

-- Sistema de detección de anti-cheat por patrones
spawn(function()
    while wait(60) do -- Verificar cada minuto
        if _enabled then
            -- Verificar si hay patrones sospechosos en el movimiento
            local avgSpeed = 0
            local speedCount = 0
            
            for _, movement in pairs(_movementPattern) do
                avgSpeed = avgSpeed + movement.speed
                speedCount = speedCount + 1
            end
            
            if speedCount > 0 then
                avgSpeed = avgSpeed / speedCount
                
                -- Si la velocidad promedio es muy alta por mucho tiempo
                if avgSpeed > 35 then
                    _safetyMode = true
                    _speed = math.min(_speed, 25) -- Reducir velocidad máxima
                    print("Patrón de velocidad alta detectado - Reduciendo velocidad")
                end
            end
            
            -- Limpiar patrones antiguos
            local currentTime = tick()
            for i = #_movementPattern, 1, -1 do
                if currentTime - _movementPattern[i].time > 300 then -- 5 minutos
                    table.remove(_movementPattern, i)
                end
            end
        end
    end
end)

-- Crear GUI principal con nombres ofuscados
local screenGui = Instance.new("ScreenGui")
screenGui.Name = randomName()
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Panel de autenticación (resto del código igual pero con mejoras de seguridad)
local authFrame = Instance.new("Frame")
authFrame.Name = randomName()
authFrame.Size = UDim2.new(0, 350, 0, 200)
authFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
authFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
authFrame.BorderSizePixel = 0
authFrame.Parent = screenGui

--no se
local authCorner = Instance.new("UICorner")
authCorner.CornerRadius = UDim.new(0, 15)
authCorner.Parent = authFrame

-- Gradiente para el panel de auth
local authGradient = Instance.new("UIGradient")
authGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(45, 45, 65)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
}
authGradient.Rotation = 45
authGradient.Parent = authFrame

-- Borde brillante para auth
local authStroke = Instance.new("UIStroke")
authStroke.Color = Color3.fromRGB(100, 150, 255)
authStroke.Thickness = 2
authStroke.Transparency = 0.3
authStroke.Parent = authFrame

-- Título de autenticación
local authTitle = Instance.new("TextLabel")
authTitle.Size = UDim2.new(1, -40, 0, 40)
authTitle.Position = UDim2.new(0, 20, 0, 20)
authTitle.BackgroundTransparency = 1
authTitle.Text = "SISTEMA DE NAVEGACIÓN AVANZADA"
authTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
authTitle.TextScaled = true
authTitle.Font = Enum.Font.GothamBold
authTitle.TextXAlignment = Enum.TextXAlignment.Center
authTitle.Parent = authFrame

-- Campo de contraseña
local passwordBox = Instance.new("TextBox")
passwordBox.Size = UDim2.new(0, 280, 0, 40)
passwordBox.Position = UDim2.new(0.5, -140, 0, 80)
passwordBox.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
passwordBox.BorderSizePixel = 0
passwordBox.Text = ""
passwordBox.PlaceholderText = "Código de acceso..."
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
passwordBox.TextScaled = true
passwordBox.Font = Enum.Font.Gotham
passwordBox.TextXAlignment = Enum.TextXAlignment.Center
passwordBox.Parent = authFrame

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 10)
passwordCorner.Parent = passwordBox

-- Botón de acceso
local accessButton = Instance.new("TextButton")
accessButton.Size = UDim2.new(0, 150, 0, 35)
accessButton.Position = UDim2.new(0.5, -75, 0, 140)
accessButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
accessButton.BorderSizePixel = 0
accessButton.Text = "INICIALIZAR"
accessButton.TextColor3 = Color3.fromRGB(255, 255, 255)
accessButton.TextScaled = true
accessButton.Font = Enum.Font.GothamBold
accessButton.Parent = authFrame

local accessCorner = Instance.new("UICorner")
accessCorner.CornerRadius = UDim.new(0, 10)
accessCorner.Parent = accessButton

-- Mensaje de error
local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, -40, 0, 20)
errorLabel.Position = UDim2.new(0, 20, 1, -30)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = ""
errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
errorLabel.TextScaled = true
errorLabel.Font = Enum.Font.Gotham
errorLabel.TextXAlignment = Enum.TextXAlignment.Center
errorLabel.Parent = authFrame

-- Variables para la interfaz principal
local toggleButton = nil
local mainFrame = nil
local mainButton = nil
local speedLabel = nil
local upButton = nil
local downButton = nil

-- Sistema de detección de entorno del juego
local function detectGameEnvironment()
    local gameId = game.GameId
    local placeId = game.PlaceId
    
    -- Lista de juegos conocidos por tener anti-cheat fuerte
    local highSecurityGames = {
        [286090429] = true, -- Arsenal
        [292439477] = true, -- Phantom Forces
        [301549746] = true, -- Counter Blox
        [606849621] = true, -- Jailbreak
        [537413528] = true, -- Build A Boat
    }
    
    if highSecurityGames[gameId] or highSecurityGames[placeId] then
        _safetyMode = true
        _speed = math.min(_speed, 18) -- Velocidad muy limitada
        print("Juego de alta seguridad detectado - Modo ultra-seguro activado")
    end
end

-- Función de autenticación mejorada
local function authenticate()
    if passwordBox.Text == "Zamas" then
        _authenticated = true
        
        -- Detectar entorno del juego
        detectGameEnvironment()
        
        -- Animación de desaparición
        local fadeOut = TweenService:Create(authFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = 1
        })
        
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            authFrame:Destroy()
            createMainInterface()
        end)
        
        print("Sistema de navegación inicializado")
        if _safetyMode then
            print("MODO SEGURO ACTIVO - Velocidades limitadas")
        end
    else
        errorLabel.Text = "Código de acceso inválido"
        passwordBox.Text = ""
        
        -- Animación de error más sutil
        local shake = TweenService:Create(authFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Position = UDim2.new(0.5, -165, 0.5, -100)
        })
        shake:Play()
        shake.Completed:Connect(function()
            TweenService:Create(authFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Position = UDim2.new(0.5, -175, 0.5, -100)
            }):Play()
        end)
        
        wait(2)
        errorLabel.Text = ""
    end
end

-- Función para crear la interfaz principal con nombres ofuscados
function createMainInterface()
    -- Botón toggle con nombre aleatorio
    toggleButton = Instance.new("TextButton")
    toggleButton.Name = randomName()
    toggleButton.Size = UDim2.new(0, 120, 0, 40)
    toggleButton.Position = UDim2.new(0, 15, 0, 15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 90, 150)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "Nav Panel"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    -- Panel principal con nombre aleatorio
    mainFrame = Instance.new("Frame")
    mainFrame.Name = randomName()
    mainFrame.Size = UDim2.new(0, 320, 0, 180)
    mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    mainFrame.Visible = false

    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 15)
    mainCorner.Parent = mainFrame

    -- Barra de título
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar

    -- Título con nombre más discreto
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "SISTEMA DE NAVEGACIÓN"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Botón cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 35, 0, 35)
    closeButton.Position = UDim2.new(1, -40, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "×"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 10)
    closeCorner.Parent = closeButton

    -- Contenido del panel
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -45)
    contentFrame.Position = UDim2.new(0, 0, 0, 45)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame

    -- Botón principal con texto más discreto
    mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 220, 0, 40)
    mainButton.Position = UDim2.new(0.5, -110, 0, 15)
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "ACTIVAR NAVEGACIÓN"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = contentFrame

    local mainButtonCorner = Instance.new("UICorner")
    mainButtonCorner.CornerRadius = UDim.new(0, 12)
    mainButtonCorner.Parent = mainButton

    -- Label de velocidad con límites adaptativos
    speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, -30, 0, 20)
    speedLabel.Position = UDim2.new(0, 15, 0, 65)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Velocidad: " .. _speed .. " unidades/seg"
    speedLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = contentFrame

    -- Slider de velocidad con límites dinámicos
    local speedSliderFrame = Instance.new("Frame")
    speedSliderFrame.Size = UDim2.new(0, 220, 0, 20)
    speedSliderFrame.Position = UDim2.new(0.5, -110, 0, 90)
    speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedSliderFrame.BorderSizePixel = 0
    speedSliderFrame.Parent = contentFrame

    local sliderFrameCorner = Instance.new("UICorner")
    sliderFrameCorner.CornerRadius = UDim.new(0, 10)
    sliderFrameCorner.Parent = speedSliderFrame

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new(0.2, -10, 0, 0) -- Posición inicial más baja
    sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = speedSliderFrame

    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton

    -- Info de controles más discreta
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -30, 0, 18)
    infoLabel.Position = UDim2.new(0, 15, 0, 115)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = isMobile and "Controles: Joystick + botones" or "Controles: WASD + Space/Shift | P = Parada"
    infoLabel.TextColor3 = Color3.fromRGB(150, 170, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = contentFrame

    -- Indicador de modo seguro
    local safetyIndicator = Instance.new("TextLabel")
    safetyIndicator.Size = UDim2.new(0, 80, 0, 15)
    safetyIndicator.Position = UDim2.new(1, -85, 0, 140)
    safetyIndicator.BackgroundTransparency = 1
    safetyIndicator.Text = _safetyMode and "MODO SEGURO" or "NORMAL"
    safetyIndicator.TextColor3 = _safetyMode and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 255, 100)
    safetyIndicator.TextScaled = true
    safetyIndicator.Font = Enum.Font.Gotham
    safetyIndicator.TextXAlignment = Enum.TextXAlignment.Right
    safetyIndicator.Parent = contentFrame

    -- Botones verticales para móvil con nombres discretos
    if isMobile then
        upButton = Instance.new("TextButton")
        upButton.Size = UDim2.new(0, 70, 0, 50)
        upButton.Position = UDim2.new(1, -90, 1, -160)
        upButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        upButton.BackgroundTransparency = 0.2
        upButton.BorderSizePixel = 0
        upButton.Text = "↑"
        upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        upButton.TextScaled = true
        upButton.Font = Enum.Font.GothamBold
        upButton.Parent = screenGui
        upButton.Visible = false
        
        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 15)
        upCorner.Parent = upButton
        
        downButton = Instance.new("TextButton")
        downButton.Size = UDim2.new(0, 70, 0, 50)
        downButton.Position = UDim2.new(1, -90, 1, -100)
        downButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        downButton.BackgroundTransparency = 0.2
        downButton.BorderSizePixel = 0
        downButton.Text = "↓"
        downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        downButton.TextScaled = true
        downButton.Font = Enum.Font.GothamBold
        downButton.Parent = screenGui
        downButton.Visible = false
        
        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 15)
        downCorner.Parent = downButton
    end

    -- Función para actualizar velocidad con límites adaptativos
    local function updateSpeed()
        local sliderPosition = sliderButton.Position.X.Scale
        local maxSpeed = _safetyMode and 22 or 42 -- Límite adaptativo
        _speed = math.floor(10 + (sliderPosition * (maxSpeed - 10)))
        speedLabel.Text = "Velocidad: " .. _speed .. " unidades/seg"
        
        -- Actualizar indicador de seguridad
        safetyIndicator.Text = _safetyMode and "MODO SEGURO" or "NORMAL"
        safetyIndicator.TextColor3 = _safetyMode and Color3.fromRGB(255, 200, 100) or Color3.fromRGB(100, 255, 100)
    end

    -- Sistema de slider con protección
    local dragging = false
    local lastSliderUpdate = tick()

    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local currentTime = tick()
            
            -- Limitar frecuencia de actualizaciones para evitar detección
            if currentTime - lastSliderUpdate < 0.1 then return end
            lastSliderUpdate = currentTime
            
            local mousePos = UserInputService:GetMouseLocation()
            local framePos = speedSliderFrame.AbsolutePosition
            local frameSize = speedSliderFrame.AbsoluteSize
            
            local relativeX = mousePos.X - framePos.X
            local percentage = math.clamp(relativeX / frameSize.X, 0, 1)
            
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
            updateSpeed()
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- Controles con protección anti-detección
    if not isMobile then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed or not _enabled then return end
            
            -- Agregar pequeño delay aleatorio para parecer más humano
            wait(math.random(0, 0.05))
            
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

    -- Controles móvil con protección
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

    -- Evento del botón principal con verificaciones de seguridad
    mainButton.MouseButton1Click:Connect(function()
        -- Verificar si es seguro activar
        local currentTime = tick()
        if currentTime - _lastDetectionCheck < 5 then
            print("Esperando verificación de seguridad...")
            return
        end
        _lastDetectionCheck = currentTime
        
        _enabled = not _enabled
        
        if _enabled then
            createNativeFloat()
            mainButton.Text = "DESACTIVAR NAVEGACIÓN"
            
            TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            }):Play()
            
            TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            }):Play()
            
            toggleButton.Text = "ACTIVO"
            
            if isMobile then
                upButton.Visible = true
                downButton.Visible = true
            end
            
            print("Sistema de navegación activado")
            if _safetyMode then
                print("Funcionando en modo seguro")
            end
        else
            stopFloat()
            mainButton.Text = "ACTIVAR NAVEGACIÓN"
            
            TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play()
            
            TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(60, 90, 150)
            }):Play()
            
            toggleButton.Text = "Nav Panel"
            
            if isMobile then
                upButton.Visible = false
                downButton.Visible = false
            end
            
            
            print("Sistema de navegación desactivado")
        end
    end)

    -- Eventos de UI con protección
    closeButton.MouseButton1Click:Connect(function()
        local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            mainFrame.Visible = false
            mainFrame.Size = UDim2.new(0, 320, 0, 180)
            mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
        end)
    end)

    toggleButton.MouseButton1Click:Connect(function()
        if mainFrame.Visible then
            local fadeOut = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
            })
            fadeOut:Play()
            fadeOut.Completed:Connect(function()
                mainFrame.Visible = false
                mainFrame.Size = UDim2.new(0, 320, 0, 180)
                mainFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
            end)
        else
            mainFrame.Visible = true
            mainFrame.Size = UDim2.new(0, 0, 0, 0)
            mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
            
            TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {
                Size = UDim2.new(0, 320, 0, 180),
                Position = UDim2.new(0.5, -160, 0.5, -90)
            }):Play()
        end
    end)

    -- Tecla de emergencia mejorada
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.P then
            if _enabled then
                _enabled = false
                stopFloat()
                mainButton.Text = "ACTIVAR NAVEGACIÓN"
                
                TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                }):Play()
                
                TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60, 90, 150)
                }):Play()
                
                toggleButton.Text = "Nav Panel"
                
                if isMobile then
                    upButton.Visible = false
                    downButton.Visible = false
                end
                
                -- Ocultar panel temporalmente
                mainFrame.Visible = false
                
                print("PARADA DE EMERGENCIA ACTIVADA")
                
                -- Reactivar interfaz después de 10 segundos
                spawn(function()
                    wait(10)
                    if not _enabled then
                        print("Interfaz reactivada - Sistema seguro")
                    end
                end)
            end
        end
    end)

    -- Auto-limpieza al respawnear con protección
    player.CharacterRemoving:Connect(function()
        stopFloat()
        _enabled = false
        _verticalInput = 0
        _detectionLevel = 0
        _safetyMode = false
        
        if mainButton then
            mainButton.Text = "ACTIVAR NAVEGACIÓN"
            TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play()
        end
        
        if toggleButton then
            toggleButton.Text = "Nav Panel"
            TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(60, 90, 150)
            }):Play()
        end
        
        if isMobile then
            if upButton then upButton.Visible = false end
            if downButton then downButton.Visible = false end
        end
        
        print("Personaje reiniciado - Sistema limpio")
    end)

    -- Inicializar velocidad
    updateSpeed()
    
    print("Sistema de navegación cargado exitosamente")
end

-- Eventos de autenticación
accessButton.MouseButton1Click:Connect(authenticate)
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        authenticate()
    end
end)

-- Sistema de monitoreo de rendimiento mejorado
spawn(function()
    local performanceHistory = {}
    
    while wait(30) do -- Verificar cada 30 segundos
        local fps = workspace.CurrentCamera and (1 / workspace.CurrentCamera.RenderStepped:Wait()) or 60
        table.insert(performanceHistory, fps)
        
        -- Mantener solo los últimos 10 registros
        if #performanceHistory > 10 then
            table.remove(performanceHistory, 1)
        end
        
        -- Calcular FPS promedio
        local avgFps = 0
        for _, fpsValue in pairs(performanceHistory) do
            avgFps = avgFps + fpsValue
        end
        avgFps = avgFps / #performanceHistory
        
        -- Si el rendimiento es muy bajo, activar modo seguro
        if avgFps < 20 and not _safetyMode then
            _safetyMode = true
            _speed = math.min(_speed, 20)
            print("Rendimiento bajo detectado - Modo seguro activado")
        elseif avgFps > 45 and _safetyMode and _detectionLevel == 0 then
            _safetyMode = false
            print("Rendimiento mejorado - Modo seguro desactivado")
        end
    end
end)

-- Sistema de detección de herramientas de administrador
spawn(function()
    while wait(20) do
        for _, v in pairs(Players:GetPlayers()) do
            if v.Character then
                for _, tool in pairs(v.Character:GetChildren()) do
                    if tool:IsA("Tool") then
                        local toolName = tool.Name:lower()
                        local suspiciousTools = {"admin", "ban", "kick", "delete", "kill", "tp", "teleport", "fly", "speed", "god"}
                        
                        for _, suspicious in pairs(suspiciousTools) do
                            if toolName:find(suspicious) then
                                if _enabled then
                                    _enabled = false
                                    stopFloat()
                                    
                                    if screenGui then
                                        screenGui.Enabled = false
                                    end
                                    
                                    warn("Herramienta de admin detectada: " .. tool.Name .. " - Sistema oculto")
                                    
                                    -- Esperar y reactivar
                                    spawn(function()
                                        wait(60) -- Esperar 1 minuto
                                        if screenGui then
                                            screenGui.Enabled = true
                                        end
                                        print("Sistema reactivado")
                                    end)
                                end
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

-- Protección contra errores mejorada
local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error del sistema: " .. tostring(result))
        if _enabled then
            _enabled = false
            stopFloat()
            print("Sistema pausado por error - Reinicie manualmente")
        end
    end
    return success, result
end

-- Envolver funciones críticas
local originalCreateFloat = createNativeFloat
createNativeFloat = function()
    safeCall(originalCreateFloat)
end

local originalStopFloat = stopFloat
stopFloat = function()
    safeCall(originalStopFloat)
end

-- Sistema de auto-destrucción en caso de detección crítica
spawn(function()
    while wait(60) do -- Verificar cada minuto
        if _detectionLevel >= 5 then -- Nivel crítico de detección
            warn("NIVEL CRÍTICO DE DETECCIÓN - AUTODESTRUYENDO SISTEMA")
            
            if screenGui then
                screenGui:Destroy()
            end
            
            if _connection then
                _connection:Disconnect()
            end
            
            if _bodyObj then
                _bodyObj:Destroy()
            end
            
            -- Detener todos los hilos
            for i = 1, 1000 do
                spawn(function() end)
            end
            
            break
        end
    end
end)

-- Mensaje de inicio discreto
print("=== SISTEMA DE NAVEGACIÓN AVANZADA ===")
print("Plataforma:", isMobile and "Móvil" or "Escritorio")
print("Modo de seguridad:", _safetyMode and "ACTIVADO" or "Estándar")
print("Ingrese el código de acceso para continuar")
print("==========================================")

-- Animación de entrada suave
authFrame.Size = UDim2.new(0, 0, 0, 0)
authFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local enterAnimation = TweenService:Create(authFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 350, 0, 200),
    Position = UDim2.new(0.5, -175, 0.5, -100)
})

enterAnimation:Play()

-- Auto-focus discreto
wait(0.6)
if passwordBox then
    passwordBox:CaptureFocus()
end

-- Sistema de limpieza automática de memoria
spawn(function()
    while wait(300) do -- Cada 5 minutos
        collectgarbage("collect")
        if _movementPattern and #_movementPattern > 20 then
            for i = 1, 10 do
                table.remove(_movementPattern, 1)
            end
        end
    end
end)
