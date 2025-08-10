-- Script con UI corregida - Sistema de autenticación y mejoras visuales

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Variables principales
local _enabled = false
local _speed = 25
local _connection = nil
local _bodyObj = nil
local _verticalInput = 0
local _authenticated = false

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

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = randomName()
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Panel de autenticación
local authFrame = Instance.new("Frame")
authFrame.Name = "AuthFrame"
authFrame.Size = UDim2.new(0, 350, 0, 200)
authFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
authFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
authFrame.BorderSizePixel = 0
authFrame.Parent = screenGui

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
authTitle.Text = "FLOAT HELPER - ACCESO RESTRINGIDO"
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
passwordBox.PlaceholderText = "Ingrese la contraseña..."
passwordBox.TextColor3 = Color3.fromRGB(255, 255, 255)
passwordBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
passwordBox.TextScaled = true
passwordBox.Font = Enum.Font.Gotham
passwordBox.TextXAlignment = Enum.TextXAlignment.Center
passwordBox.Parent = authFrame

local passwordCorner = Instance.new("UICorner")
passwordCorner.CornerRadius = UDim.new(0, 10)
passwordCorner.Parent = passwordBox

local passwordStroke = Instance.new("UIStroke")
passwordStroke.Color = Color3.fromRGB(80, 120, 200)
passwordStroke.Thickness = 1
passwordStroke.Transparency = 0.5
passwordStroke.Parent = passwordBox

-- Botón de acceso
local accessButton = Instance.new("TextButton")
accessButton.Size = UDim2.new(0, 150, 0, 35)
accessButton.Position = UDim2.new(0.5, -75, 0, 140)
accessButton.BackgroundColor3 = Color3.fromRGB(50, 150, 100)
accessButton.BorderSizePixel = 0
accessButton.Text = "ACCEDER"
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

-- Función de autenticación
local function authenticate()
    if passwordBox.Text == "Zamas" then
        _authenticated = true
        
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
        
        print("Acceso concedido - Bienvenido al Float Helper")
    else
        errorLabel.Text = "Contraseña incorrecta"
        passwordBox.Text = ""
        
        -- Animación de error
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

-- Función para crear la interfaz principal
function createMainInterface()
    -- Botón toggle mejorado
    toggleButton = Instance.new("TextButton")
    toggleButton.Name = "ToggleButton"
    toggleButton.Size = UDim2.new(0, 120, 0, 40)
    toggleButton.Position = UDim2.new(0, 15, 0, 15)
    toggleButton.BackgroundColor3 = Color3.fromRGB(60, 90, 150)
    toggleButton.BorderSizePixel = 0
    toggleButton.Text = "Float Panel"
    toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    toggleButton.TextScaled = true
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.Parent = screenGui

    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 12)
    toggleCorner.Parent = toggleButton

    local toggleGradient = Instance.new("UIGradient")
    toggleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 110, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 90, 150))
    }
    toggleGradient.Rotation = 45
    toggleGradient.Parent = toggleButton

    -- Panel principal mejorado
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

    -- Gradiente principal
    local mainGradient = Instance.new("UIGradient")
    mainGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 20, 30))
    }
    mainGradient.Rotation = 135
    mainGradient.Parent = mainFrame

    -- Borde brillante
    local mainStroke = Instance.new("UIStroke")
    mainStroke.Color = Color3.fromRGB(100, 150, 255)
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4
    mainStroke.Parent = mainFrame

    -- Barra de título mejorada
    local titleBar = Instance.new("Frame")
    titleBar.Size = UDim2.new(1, 0, 0, 45)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = titleBar

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 60, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 60))
    }
    titleGradient.Rotation = 90
    titleGradient.Parent = titleBar

    -- Título
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "FLOAT HELPER PRO"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleBar

    -- Botón cerrar mejorado
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

    -- Botón principal mejorado
    mainButton = Instance.new("TextButton")
    mainButton.Size = UDim2.new(0, 220, 0, 40)
    mainButton.Position = UDim2.new(0.5, -110, 0, 15)
    mainButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
    mainButton.BorderSizePixel = 0
    mainButton.Text = "ACTIVAR FLOAT"
    mainButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    mainButton.TextScaled = true
    mainButton.Font = Enum.Font.GothamBold
    mainButton.Parent = contentFrame

    local mainButtonCorner = Instance.new("UICorner")
    mainButtonCorner.CornerRadius = UDim.new(0, 12)
    mainButtonCorner.Parent = mainButton

    local mainButtonGradient = Instance.new("UIGradient")
    mainButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 170, 70)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 150, 50))
    }
    mainButtonGradient.Rotation = 45
    mainButtonGradient.Parent = mainButton

    -- Label de velocidad
    speedLabel = Instance.new("TextLabel")
    speedLabel.Size = UDim2.new(1, -30, 0, 20)
    speedLabel.Position = UDim2.new(0, 15, 0, 65)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Velocidad: " .. _speed .. " studs/seg"
    speedLabel.TextColor3 = Color3.fromRGB(200, 220, 255)
    speedLabel.TextScaled = true
    speedLabel.Font = Enum.Font.Gotham
    speedLabel.TextXAlignment = Enum.TextXAlignment.Left
    speedLabel.Parent = contentFrame

    -- Slider de velocidad mejorado
    local speedSliderFrame = Instance.new("Frame")
    speedSliderFrame.Size = UDim2.new(0, 220, 0, 20)
    speedSliderFrame.Position = UDim2.new(0.5, -110, 0, 90)
    speedSliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    speedSliderFrame.BorderSizePixel = 0
    speedSliderFrame.Parent = contentFrame

    local sliderFrameCorner = Instance.new("UICorner")
    sliderFrameCorner.CornerRadius = UDim.new(0, 10)
    sliderFrameCorner.Parent = speedSliderFrame

    local sliderFrameStroke = Instance.new("UIStroke")
    sliderFrameStroke.Color = Color3.fromRGB(80, 120, 200)
    sliderFrameStroke.Thickness = 1
    sliderFrameStroke.Transparency = 0.6
    sliderFrameStroke.Parent = speedSliderFrame

    local sliderButton = Instance.new("TextButton")
    sliderButton.Size = UDim2.new(0, 20, 1, 0)
    sliderButton.Position = UDim2.new(0.375, -10, 0, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    sliderButton.BorderSizePixel = 0
    sliderButton.Text = ""
    sliderButton.Parent = speedSliderFrame

    local sliderButtonCorner = Instance.new("UICorner")
    sliderButtonCorner.CornerRadius = UDim.new(0, 10)
    sliderButtonCorner.Parent = sliderButton

    local sliderButtonGradient = Instance.new("UIGradient")
    sliderButtonGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 220, 120)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 100))
    }
    sliderButtonGradient.Rotation = 45
    sliderButtonGradient.Parent = sliderButton

    -- Info de controles
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -30, 0, 18)
    infoLabel.Position = UDim2.new(0, 15, 0, 115)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = isMobile and "Controles: Joystick + botones verticales" or "Controles: WASD + Space/Shift | P = Emergencia"
    infoLabel.TextColor3 = Color3.fromRGB(150, 170, 200)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Gotham
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.Parent = contentFrame

    -- Botones verticales para móvil mejorados
    if isMobile then
        upButton = Instance.new("TextButton")
        upButton.Size = UDim2.new(0, 70, 0, 50)
        upButton.Position = UDim2.new(1, -90, 1, -160)
        upButton.BackgroundColor3 = Color3.fromRGB(50, 100, 200)
        upButton.BackgroundTransparency = 0.1
        upButton.BorderSizePixel = 0
        upButton.Text = "SUBIR"
        upButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        upButton.TextScaled = true
        upButton.Font = Enum.Font.GothamBold
        upButton.Parent = screenGui
        upButton.Visible = false
        
        local upCorner = Instance.new("UICorner")
        upCorner.CornerRadius = UDim.new(0, 15)
        upCorner.Parent = upButton

        local upGradient = Instance.new("UIGradient")
        upGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 120, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 200))
        }
        upGradient.Rotation = 45
        upGradient.Parent = upButton
        
        downButton = Instance.new("TextButton")
        downButton.Size = UDim2.new(0, 70, 0, 50)
        downButton.Position = UDim2.new(1, -90, 1, -100)
        downButton.BackgroundColor3 = Color3.fromRGB(200, 100, 50)
        downButton.BackgroundTransparency = 0.1
        downButton.BorderSizePixel = 0
        downButton.Text = "BAJAR"
        downButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        downButton.TextScaled = true
        downButton.Font = Enum.Font.GothamBold
        downButton.Parent = screenGui
        downButton.Visible = false
        
        local downCorner = Instance.new("UICorner")
        downCorner.CornerRadius = UDim.new(0, 15)
        downCorner.Parent = downButton

        local downGradient = Instance.new("UIGradient")
        downGradient.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 120, 70)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 50))
        }
        downGradient.Rotation = 45
        downGradient.Parent = downButton
    end

    -- Función para actualizar velocidad (limitada a 42)
    local function updateSpeed()
        local sliderPosition = sliderButton.Position.X.Scale
        _speed = math.floor(10 + (sliderPosition * 32)) -- Rango de 10 a 42
        speedLabel.Text = "Velocidad: " .. _speed .. " studs/seg"
    end

    -- Sistema de slider mejorado
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
            
            sliderButton.Position = UDim2.new(percentage, -10, 0, 0)
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

    -- Evento del botón principal con animaciones
    mainButton.MouseButton1Click:Connect(function()
        _enabled = not _enabled
        
        if _enabled then
            createNativeFloat()
            mainButton.Text = "DESACTIVAR FLOAT"
            
            -- Animación de activación
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
            
            print("Float activado - Velocidad: " .. _speed .. " studs/seg")
        else
            stopFloat()
            mainButton.Text = "ACTIVAR FLOAT"
            
            -- Animación de desactivación
            TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play()
            
            TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(60, 90, 150)
            }):Play()
            
            toggleButton.Text = "Float Panel"
            
            if isMobile then
                upButton.Visible = false
                downButton.Visible = false
            end
            
            print("Float desactivado")
        end
    end)

    -- Eventos de UI con animaciones
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
        print("Panel cerrado")
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

    -- Tecla de emergencia (P para desactivar rápido)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        if input.KeyCode == Enum.KeyCode.P then
            if _enabled then
                _enabled = false
                stopFloat()
                mainButton.Text = "ACTIVAR FLOAT"
                
                TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(50, 150, 50)
                }):Play()
                
                TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                    BackgroundColor3 = Color3.fromRGB(60, 90, 150)
                }):Play()
                
                toggleButton.Text = "Float Panel"
                
                if isMobile then
                    upButton.Visible = false
                    downButton.Visible = false
                end
                
                mainFrame.Visible = false
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
            mainButton.Text = "ACTIVAR FLOAT"
            TweenService:Create(mainButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(50, 150, 50)
            }):Play()
        end
        
        if toggleButton then
            toggleButton.Text = "Float Panel"
            TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundColor3 = Color3.fromRGB(60, 90, 150)
            }):Play()
        end
        
        if isMobile then
            if upButton then upButton.Visible = false end
            if downButton then downButton.Visible = false end
        end
        
        print("Character respawned - Float reset")
    end)

    -- Inicializar velocidad
    updateSpeed()
    
    print("Interfaz principal cargada exitosamente")
end

-- Eventos de autenticación
accessButton.MouseButton1Click:Connect(authenticate)
passwordBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        authenticate()
    end
end)

-- Sistema de seguridad básico mejorado
spawn(function()
    while wait(math.random(180, 300)) do -- Pausa cada 3-5 minutos
        if _enabled then
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            print("Pausa automática de seguridad...")
            wait(math.random(8, 15)) -- Pausa de 8-15 segundos
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
                print("Float reactivado automáticamente")
            end
        end
    end
end)

-- Detección básica de staff mejorada
spawn(function()
    while wait(30) do
        for _, v in pairs(Players:GetPlayers()) do
            local name = v.Name:lower()
            local displayName = v.DisplayName:lower()
            
            local suspiciousNames = {"admin", "mod", "owner", "staff", "dev", "developer"}
            local isSuspicious = false
            
            for _, suspicious in pairs(suspiciousNames) do
                if name:find(suspicious) or displayName:find(suspicious) then
                    isSuspicious = true
                    break
                end
            end
            
            if isSuspicious and _enabled then
                _enabled = false
                stopFloat()
                
                -- Ocultar completamente la interfaz
                if screenGui then
                    for _, child in pairs(screenGui:GetChildren()) do
                        if child.Name ~= "AuthFrame" then
                            child.Visible = false
                        end
                    end
                end
                
                warn("STAFF DETECTADO: " .. v.Name .. " - Sistema desactivado automáticamente")
                
                -- Reactivar después de que se vaya el staff
                spawn(function()
                    repeat wait(5) until not Players:FindFirstChild(v.Name)
                    wait(10) -- Esperar 10 segundos adicionales
                    
                    if screenGui then
                        for _, child in pairs(screenGui:GetChildren()) do
                            if child.Name ~= "AuthFrame" then
                                child.Visible = true
                            end
                        end
                    end
                    
                    print("Staff se fue - Sistema reactivado")
                end)
            end
        end
    end
end)

-- Sistema de detección de lag/rendimiento
spawn(function()
    local lastTime = tick()
    while wait(1) do
        local currentTime = tick()
        local deltaTime = currentTime - lastTime
        lastTime = currentTime
        
        -- Si hay lag severo (más de 2 segundos de delay)
        if deltaTime > 2 and _enabled then
            print("Lag detectado - Pausando float temporalmente")
            local wasEnabled = _enabled
            _enabled = false
            stopFloat()
            
            wait(5) -- Esperar a que mejore el rendimiento
            
            if wasEnabled then
                _enabled = true
                createNativeFloat()
                print("Float reactivado después del lag")
            end
        end
    end
end)

-- Protección contra errores
local function safeCall(func, ...)
    local success, result = pcall(func, ...)
    if not success then
        warn("Error en Float Helper: " .. tostring(result))
        if _enabled then
            _enabled = false
            stopFloat()
            print("Float desactivado por error de seguridad")
        end
    end
    return success, result
end

-- Envolver funciones críticas en protección
local originalCreateFloat = createNativeFloat
createNativeFloat = function()
    safeCall(originalCreateFloat)
end

local originalStopFloat = stopFloat
stopFloat = function()
    safeCall(originalStopFloat)
end

-- Mensaje de inicio
print("=== FLOAT HELPER PRO - SISTEMA DE AUTENTICACIÓN ===")
print("Plataforma:", isMobile and "Móvil" or "PC")
print("Velocidad máxima: 42 studs/seg")
print("Ingrese la contraseña para acceder al sistema")
print("================================================")

-- Animación de entrada para el panel de autenticación
authFrame.Size = UDim2.new(0, 0, 0, 0)
authFrame.Position = UDim2.new(0.5, 0, 0.5, 0)

local enterAnimation = TweenService:Create(authFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 350, 0, 200),
    Position = UDim2.new(0.5, -175, 0.5, -100)
})

enterAnimation:Play()

-- Efecto de brillo en el borde del panel de autenticación
spawn(function()
    while authFrame.Parent do
        for i = 0, 1, 0.02 do
            if authFrame.Parent then
                authStroke.Transparency = 0.3 + (math.sin(i * math.pi * 2) * 0.2)
                wait(0.05)
            end
        end
    end
end)

-- Auto-focus en el campo de contraseña
wait(0.6)
if passwordBox then
    passwordBox:CaptureFocus()
end
